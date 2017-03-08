<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="cn.edu.zju.acm.onlinejudge.util.Features" %>
                <div class="welcome_msg"><img src="<%=request.getContextPath()%>/image/banner.png"/></div>
                <div class="login_info">
                    <logic:notPresent name="oj_user">
                        <a href="<%=request.getContextPath()%>/login.do">登陆</a> 
                        <% if (Features.register()) {%>
                        <a href="<%=request.getContextPath()%>/register.do">注册</a>
                        <% } %>                    	
                    </logic:notPresent>
                    <logic:present name="oj_user">
                        <span class="user_name"><bean:write name="oj_user" property="handle" /></span>
                        <a href="<%=request.getContextPath()%>/logout.do">退出</a>
                    </logic:present>
                </div>
