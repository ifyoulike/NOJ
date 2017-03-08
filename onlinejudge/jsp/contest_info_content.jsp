<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="cn.edu.zju.acm.onlinejudge.bean.AbstractContest" %>
<%@ page import="cn.edu.zju.acm.onlinejudge.util.Utility" %>

<%
    boolean isProblemset =  "Problemsets".equals(request.getAttribute("region"));    
    String name = isProblemset ? "problemset" : "contest";
    String longName = isProblemset ? "Problem Set" : "Contest";
    
%>

        <logic:messagesPresent property="error">
        <div class="internalError">
            <html:errors property="error"/>
        </div>
        </logic:messagesPresent>
        <logic:messagesNotPresent property="error">
        <div id="content_title"><bean:write name="contest" property="title"/></div>
        <div id="content_body">
                     <%
                        AbstractContest contest = (AbstractContest) request.getAttribute("contest");
                     %>
                     <table class="contestInfoTable">
                        <tr>
                            <td class="contestInfo"> </td>
                        </tr>
                        <tr>
                          <td class="contestInfo">赛事简介:</td>
                          <td><bean:write name="contest" property="description"/></td>
                        </tr>
                        <%
                        if (contest.getStartTime() != null) {                          
                        %>
                        <tr>
                          <td class="contestInfo">开始时间:</td>
                          <td>
                          <a class="dateLink" target="_blank" href="<%=Utility.toTimeUrl(contest.getStartTime())%>"><font color=blue><%=Utility.toTimestampWithTimeZone(contest.getStartTime())%></font></a>
                          </td>
                        </tr>
                        <tr>
                          <td class="contestInfo">比赛时长:</td>
                          <td><%=Utility.toTextTime(contest.getLength() / 1000)%></td>
                        </tr>                        
                        <%
                        }
                        %>
                          

                        <tr>
                          <td class="contestInfo">比赛状态:</td>
                          <%
                          String contestStatus = "一直可用";
                          long current = System.currentTimeMillis();
                          if (contest.getStartTime() != null) {                          
                            
                            if (current < contest.getStartTime().getTime()) {
                               contestStatus = "尚未开始";
                            } else if (current > contest.getEndTime().getTime()) {
                                contestStatus = "已结束";
                            } else {
                                contestStatus = "正在进行";
                            }
                          }
                          %>
                          <td><%=contestStatus%></td>
                        </tr>
                        <%
                        if ("尚未开始".equals(contestStatus)) {
                        %>
                        <tr>
                          <td class="contestInfo">剩余时间:</td>
                          <td>
                            <%=Utility.toTextTime((contest.getStartTime().getTime() - current) / 1000)%>
                          </td>
                        </tr>
                        <%
                        }
                        %>
                        <tr>
                            <td class="contestInfo"> </td>
                        </tr>
                      </table>
        </div>
        </logic:messagesNotPresent>

