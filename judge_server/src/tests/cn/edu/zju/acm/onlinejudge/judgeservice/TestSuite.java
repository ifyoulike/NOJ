package cn.edu.zju.acm.onlinejudge.judgeservice;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses( {
	JudgeClientInstanceUnitTest.class,
	JudgeQueueUnitTest.class,
	JudgeClientUnitTest.class })
public class TestSuite {
}
