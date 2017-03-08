<%@ page contentType="text/html; charset=utf-8" language="java" %>
<div id="content_title">常见问题与解答</div>
<div id="content_body">
<hr>
<font color=green>Q</font>: 本平台允许提交哪些编程语言，相关的编译器的参数又是？<br>
<font color=red>A</font>: 本平台基于开源的Linux平台搭建。使用<a href="http://gcc.gnu.org">GNU GCC/G++</a>处理C/C++提交, <a href="http://www.freepascal.org">Free Pascal</a>编译Pascal，对于Java则使用<a href="http://java.sun.com/javase/downloads/index.jsp">Sun JDK 1.6</a>。相关编译器参数如下：<br>
C: <font color=blue>gcc foo.c -o foo -ansi -fno-asm -O2 -Wall -lm --static -DONLINE_JUDGE</font><br>
C++: <font color=blue>g++ foo.c -o foo -ansi -fno-asm -O2 -Wall -lm --static -DONLINE_JUDGE</font><br>
Free Pascal(FPC): <font color=blue>fpc -Sd -O2 -Op2 -dONLINE_JUDGE</font><br>
Java: <font color=blue>默认参数</font><br>
我们使用的平台以及编译器版本：<br>
<font color=blue>gcc/g++ 4.4.5 (Debian 4.4.4-8)</font><br>
<font color=blue>glibc 2.11.2</font><br>
<font color=blue>Free Pascal Compiler version 2.4.0 [2010/02/20] for i386</font><br>
<font color=blue>java version "1.6.0_21"</font><br>
<hr>
<font color=green>Q</font>: 系统是如何处理输入输出的？<br>
<font color=red>A</font>: 你的程序应该从标准输入（stdin）获取输入信息，并将结果写入标准输出（stdout）。比如在C语言中使用scanf/printf处理输入输出，C++语言也可以使用cin/cout。<br>
但是任何访问磁盘文件的行为是被禁止的，否则你会获得 <font color=green>Runtime Error</font> 错误。<br>
<a name="sample">这是采用C++语言编写的A+B示例程序：</a><br>
<pre>
<font color="20B000">#include &lt;iostream&gt;
using namespace std;

int main()
{
    int a,b;
    while(cin &gt;&gt; a &gt;&gt; b)
        cout &lt;&lt; a+b &lt;&lt; endl;
}
</font>
</pre>
这是采用C语言编写的A+B示例程序：<br>
<pre>
<font color="20B000">#include &lt;stdio.h&gt;

int main()
{
    int a,b;
    while(scanf("%d %d",&amp;a, &amp;b) != EOF)
        printf("%d\n",a+b);
    return 0;
}
</font>
</pre>
这是采用Free Pascal语言编写的A+B示例程序：<br>
<pre>
<font color="20B000">
program p1001(Input,Output); 
var 
  a,b:Integer; 
begin 
   while not eof(Input) do 
     begin 
       Readln(a,b); 
       Writeln(a+b); 
     end; 
end.
</font>
</pre>
这是采用Java语言编写的A+B示例程序：<br>
<pre>
<font color="20B000">
import java.util.Scanner;

public class Main {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		while (in.hasNextInt()) {
			int a = in.nextInt();
			int b = in.nextInt();
			System.out.println(a + b);
		}
	}
}
</font>
</pre>
这是采用Python语言编写的A+B示例程序：<br>
<pre>
<font color="20B000">
import sys
for line in sys.stdin:
    a = line.split()
    print int(a[0]) + int(a[1])
</font>
</pre>

这是采用PHP语言编写的A+B示例程序：<br>
<pre>
<font color="20B000">
&lt;?php
while (fscanf(STDIN, "%d%d", $a, $b) == 2) {
    print ($a + $b) . "\n";
}
</font>
</pre>

<hr>
<font color=green>Q</font>: 我已经通过了本地测试，但为什么还会得到 Compile Error 错误？<br>
<font color=red>A</font>: 我们采用的 GNU C 与平常使用的 MSVC 有许多语法上的区别，例如：<br>
<ul>
<li><font color=blue>main</font> 函数必须被定义为 <font color=blue>int</font> 类型，使用 <font color=blue>void main</font> 将会得到 Compile Error。<br> 
<li><font color=green>itoa</font> 不是一个标准的ANSI函数.<br>
<li><font color=green>__int64</font> 并不被本平台接受，你应该使用 <font color=blue>long long</font> 类型来处理64位整型。<br>
</ul>
<hr>
<font color=green>Q</font>: 对于系统返回的不同评判结果该如何理解？<br>
<font color=red>A</font>: 这里是一些评判结果的说明：<br>
<p>
<font color=blue>Queuing</font> : 你的代码正在等候区等待被评测，请稍安勿躁。<br>
<br>
<font color=blue>Accepted</font> : 恭喜，你的代码通过了系统测试。<br>
<br>
<font color=blue>Presentation Error</font> : 你的程序输出了正确的数据，但是输出格式不符合规定。通常是因为输出了多余的换行和空格，请仔细阅读题目要求并再次检查程序。<br>
<br>
<font color=blue>Wrong Answer</font> : 你的程序已经成功运行，但是输出了错误的数据。<br>
<br>
<font color=blue>Time Limit Exceeded</font> : 你的程序因为超过了题目限制的时间而未能输出全部结果。请检查使用的算法的复杂度，小心可能的死循环。<br>
<br>
<font color=blue>Memory Limit Exceeded</font> : 你的程序使用了超过题目限制的内存空间而未能输出全部结果。<br>
<br>
<font color=blue>Output Limit Exceeded</font>: 你的程序输出了过多的信息，通常本例由死循环引起。<br>
<br>
<font color=blue>Non-zero Exit Code</font>: 你的程序没有正确返回结束信号，对于C/C++，应当在main函数末尾加上“return 0”。<br>
<br>
<font color=blue>Compile Error</font> : 编译器未能成功编译你的程序。请点击本消息查看详细的出错信息。<br>
<br>
<font color=blue>Out Of Contest Time</font>: 你提交程序的时刻已经超过了比赛结束时间。<br>
<br>
<font color=blue>No such problem</font>: 未在题库中找到该题目，请联系管理员。<br>
<br>
<font color=blue>Segmentation Fault</font> : 通常情况下可能由以下原因引起：<br>
<ul>
<li>1、缓冲区溢出 --- 通常由于非法读写内存空间造成。<br> 
<li>2、栈溢出 --- 请记住本平台默认的栈大小为 8192K。<br>
</ul>
<br>
<font color=blue>Floating Point Error</font> : 你的程序中含有对一个数除以零的行为。<br>
<br>
<font color=blue>Runtime Error</font> : 见下方描述。<br>
<hr>
<font color=green>Q</font>: 我该如何提交Java程序？<br>
<font color=red>A</font>: 示例程序见上。你的程序应该声明一个主类 <font color=blue>public class Main</font> 并在其中声明方法 <font color=blue>public static void main(String[] args)</font> 作为程序入口。<br>
<hr>
<font color=green>Q</font>: 我可以使用Java提供的哪些包？<br>
<font color=red>A</font>: java.lang, java.io, java.nio, java.math, java.util, java.text 以及 java.net。你的程序不应该使用 try-catch 捕获任何异常，读写文件或使用Socket建立网络连接。换句话说，你不应该在程序中做任何与解题无关的事情。<br>
<hr>
<font color=green>Q</font>: Runtime Error的含义？<br>
<font color=red>A</font>: 如果你使用Java，请确保程序入口正确声明（见上述）。任何被禁止的操作以及上述缓冲区溢出、栈溢出均可导致本错误。<br>
<hr>

</div>
