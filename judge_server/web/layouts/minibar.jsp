<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="cn.edu.zju.acm.onlinejudge.util.Features" %>
<%@ page import="cn.edu.zju.acm.onlinejudge.util.ConfigManager" %>

                <div id="menus">
                <a <logic:equal name="region" value="Home">class="selected"</logic:equal> href="<%=request.getContextPath()%>/">首页</a>
                <% if (Features.contest()) {%>
                <a <logic:equal name="region" value="Contests">class="selected"</logic:equal> href="<%=request.getContextPath()%>/showContests.do">比赛</a>
                <% } %>
                <% if (Features.problemset()) {%>
                <a <logic:equal name="region" value="Problems">class="selected"</logic:equal> href="<%=request.getContextPath()%>/showProblems.do?contestId=34">题库</a>
                <% } %>
                <logic:present name="oj_security">
                <logic:equal name="oj_security" property="hasCourses" value="true" scope="session">
                <a <logic:equal name="region" value="Courses">class="selected"</logic:equal>
                href="<%=request.getContextPath()%>/showCourses.do">Course</a>
                </logic:equal>
                <logic:equal name="oj_security" property="superAdmin" value="true" scope="session">
                <a <logic:equal name="region" value="Admin">class="selected"</logic:equal>
                href="<%=request.getContextPath()%>/showActionDashboard.do">权限狗</a>
                </logic:equal>
                </logic:present>
                </div>

