<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="cn.edu.zju.acm.onlinejudge.util.Features" %>
<%@ page import="cn.edu.zju.acm.onlinejudge.bean.UserProfile" %>
                <tr><td class="nav_header">
                <img src="<%=request.getContextPath()%>/image/arrow_sub2.gif"><div><a href="<%=request.getContextPath()%>">首页</a></div></img>
                </td></tr>
                <logic:present name="oj_user">
<% if (Features.editProfile()) {%>                
                <tr><td class="<%="EditProfile".equals(request.getAttribute("pageId")) ? "selected_item" : "item"%>">
                    <a href="<%=request.getContextPath()%>/editProfile.do">编辑资料</a>
                </td></tr>
<% } %>                
				<tr><td class="<%="ShowUserStatus".equals(request.getAttribute("pageId")) ? "selected_item" : "item"%>">
                        <a href="<%=request.getContextPath()%>/showUserStatus.do?userId=<%=((UserProfile)request.getSession().getAttribute("oj_user")).getId() %>">用户信息</a>
                </td></tr>
<%--                
                <tr><td class="<%="EditPreference".equals(request.getAttribute("pageId")) ? "selected_item" : "item"%>">
                        <a href="<%=request.getContextPath()%>/editPreference.do">Edit Preference</a>
                </td></tr>
--%>                
                </logic:present>
                <tr><td class="<%="FAQ".equals(request.getAttribute("pageId")) ? "selected_item" : "item"%>">
                        <a href="<%=request.getContextPath()%>/faq.do">常见问题</a>
                </td></tr>
<%--                
                <tr><td class="<%="About".equals(request.getAttribute("pageId")) ? "selected_item" : "item"%>">
                        <a href="<%=request.getContextPath()%>/about.do">About This Site</a>
                </td></tr>
                <tr><td class="<%="ContactUs".equals(request.getAttribute("pageId")) ? "selected_item" : "item"%>">
                        <a href="<%=request.getContextPath()%>/contactUs.do">Contact Us</a>
                </td></tr>
--%>
