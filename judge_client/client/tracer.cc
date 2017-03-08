/*
 * Copyright 2007 Xu, Chuan <xuchuan@gmail.com>
 *
 * This file is part of ZOJ.
 *
 * ZOJ is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * ZOJ is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with ZOJ. if not, see <http://www.gnu.org/licenses/>.
 */

#include "tracer.h"

#include <string>
#include <cstring>

using namespace std;

#include <fcntl.h>
#include <signal.h>
#include <sys/ptrace.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <unistd.h>

#include "enabled_syscall.h"
#include "logging.h"
#include "protocol.h"
#include "strutil.h"
#include "args.h"

DECLARE_ARG(string, root);

namespace {

void sigalrm_handler(int) {
}

int IgnoreSIGALRM() {
    struct sigaction act;
    act.sa_handler = sigalrm_handler;
    sigemptyset(&act.sa_mask);
    act.sa_flags = 0;
    sigaction(SIGALRM, &act, NULL);
    return 0;
}

int ReadStringFromTracedProcess(pid_t pid, unsigned long address, char* buffer, int max_length) {
    for (int i = 0; i < max_length; i += sizeof(long)) {
        long data = ptrace(PTRACE_PEEKDATA, pid, address + i, 0);
        if (data == -1) {
            LOG(SYSCALL_ERROR)<<"Fail to read address "<<address + i;
            return -1;
        }
        char* p = (char*) &data;
        for (int j = 0; j < sizeof(long); j++, p++) {
            if (*p && i + j < max_length) {
                if (isprint(*p)) {
                    buffer[i + j] = *p;
                } else {
                    LOG(ERROR)<<"Unrecoginized character 0x"<<hex<<(int)(*p);
                    return -1;
                }
            } else {
                buffer[i + j] = 0;
                return 0;
            }
        }
    }
    buffer[max_length] = 0;
    return 0;
}

bool AllowedFileAccess(const char* path) {
    static char path_buffer[FILENAME_MAX + 1];
    // this should be consistent with environment.cc
    string prob_root = ARG_root + "/prob";

    if (path[0] == '\0')
        return false;

    realpath(path, path_buffer);

    // the program is not allowed to access problem data
    if (strncmp(path_buffer, prob_root.c_str(), prob_root.size()) == 0) {
        LOG(INFO)<<"Accessing "<<path_buffer<<" is not allowed";
        return false;
    }
    return true;
}

}

int __to_install_sigalrm_handler = IgnoreSIGALRM();

/* return true to ignore further checking. */
bool Tracer::HandleSyscall(struct user_regs_struct& regs) {
    switch(regs.REG_SYSCALL) {
    case SYS_exit:
    case SYS_exit_group:
        DLOG<<"SYS_exit";
        OnExit();
        break;
    case SYS_execve:
        if (first_execve_) {
            DLOG<<"SYS_execve";
            first_execve_ = false;
            ptrace(PTRACE_SYSCALL, pid_, 0, 0);
            return true;
        }
        break;
    case SYS_brk:
        if (before_syscall_) {
            requested_brk_ = regs.REG_ARG0;
        } else {
            if (regs.REG_RET < requested_brk_) {
                DLOG<<"brk request "<<requested_brk_<<" return "<<regs.REG_RET;
                ptrace(PTRACE_KILL, pid_, 0, 0);
                memory_limit_exceeded_ = true;
                return true;
            }
        }
        break;
#if __WORDSIZE == 64
    case SYS_select:
#else
    case SYS__newselect:
#endif
        if (before_syscall_) {
            long address = regs.REG_ARG4;
            if (address == 0)
                break;

            size_t i;
            memset(path_, 0, sizeof(struct timeval));
            for (i = 0; i < sizeof(struct timeval); i += sizeof(long)) {
                long data = ptrace(PTRACE_PEEKDATA, pid_, address + i, 0);
                long* buf = (long*)&path_[i];
                *buf = data;
            }

            // we only allow "selects" that immediately returns
            struct timeval* t = (struct timeval*)&path_;
            if (t->tv_sec != 0 || t->tv_usec != 0)
                break;
        }
        ptrace(PTRACE_SYSCALL, pid_, 0, 0);
        return true;
    case SYS_kill:
        if (before_syscall_) {
            // allow self-kill 
            if (regs.REG_ARG0 != pid_ || (regs.REG_ARG1 != SIGKILL && regs.REG_ARG1 != SIGFPE))
                break;
        }
        ptrace(PTRACE_SYSCALL, pid_, 0, 0);
        return true;
    case SYS_open:
        if (before_syscall_) {
            if (ReadStringFromTracedProcess(pid_, regs.REG_ARG0, path_, sizeof(path_)) < 0) {
                break;
            }
            DLOG<<"SYS_open "<<path_<<" flag "<<hex<<regs.REG_ARG1;
            if (restricted_open_path_ && !AllowedFileAccess(path_)) {
                break;
            }
            regs.REG_ARG1 &= ~( O_WRONLY | O_RDWR | O_CREAT | O_APPEND);
            ptrace(PTRACE_SETREGS, pid_, 0, &regs);
        }
        ptrace(PTRACE_SYSCALL, pid_, 0, 0);
        return true;
    }
    return false;
}

static bool isUnsafeBehavior(pid_t pid, const struct user_regs_struct& regs) {
    if ((unsigned long long)regs.REG_SYSCALL >=
        sizeof(enabled_syscall) / sizeof(enabled_syscall[0])) {
        return true;
    }

    siginfo_t siginfo;
    memset(&siginfo, 0, sizeof(siginfo_t));
    ptrace(PTRACE_GETSIGINFO, pid, NULL, &siginfo);

    // SIGTRAP not triggered by ptrace? ex. "int 0x3"
    if (siginfo.si_pid != pid) {
        return true;
    }

#ifdef __x86_64
    long bytes = ptrace(PTRACE_PEEKTEXT, pid, regs.rip - 2, NULL);
    // "0f 05" is asm "syscall". It is the standard way to call a syscall in amd64.
    // It uses 64-bit syscall table.
    // "int 0x80" and "sysenter" use 32-bit syscall table. They should be banned.
    if ((bytes & 0xffff) != 0x050f) {
        return true;
    }
#endif

    return false;
}

void Tracer::Trace() {
    bool first_trap = true;
    while (waitpid(pid_, &status_, 0) > 0) {
        if (!WIFSTOPPED(status_)) {
            exited_ = true;
            break;
        }
        int sig = WSTOPSIG(status_);
        if (sig != SIGTRAP) {
            ptrace(PTRACE_SYSCALL, pid_, 0, sig);
            continue;
        }
        before_syscall_ = !before_syscall_;
        struct user_regs_struct regs;
        ptrace(PTRACE_GETREGS, pid_, 0, &regs);
        // 1st SIGTRAP is not caused by a syscall but PTRACE_TRACEME
        if (!first_trap && isUnsafeBehavior(pid_, regs)) {
            LOG(ERROR)<<"Unsafe behavior";
            ptrace(PTRACE_KILL, pid_, 0, 0);
            restricted_syscall_ = true;
            continue;
        }
        first_trap = false;
        if (HandleSyscall(regs))
            continue;
        if (regs.REG_SYSCALL < sizeof(enabled_syscall) / sizeof(enabled_syscall[0]) &&
            !enabled_syscall[regs.REG_SYSCALL]) {
            LOG(ERROR)<<"Restricted syscall "<<syscall_name[regs.REG_SYSCALL];
            ptrace(PTRACE_KILL, pid_, 0, 0);
            restricted_syscall_ = true;
        } else {
            ptrace(PTRACE_SYSCALL, pid_, 0, 0);
        }
    }
}

void Tracer::OnExit() {
}

