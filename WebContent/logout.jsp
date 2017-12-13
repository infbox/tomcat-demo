<%@ page language="java" import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*" pageEncoding="UTF-8"%>

<%	
	session.setAttribute("user", null);	
	response.sendRedirect("infbox/login.jsp");
%>