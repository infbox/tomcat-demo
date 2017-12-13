<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="com.infbox.demo.article.JHArticleUtil"  %>
<%
	String type = request.getParameter("type"); 	
	Integer pagecount = Integer.parseInt(request.getParameter("pagecount"));
	Integer userId = Integer.parseInt(request.getParameter("userid"));
	String result = JHArticleUtil.getArticlesByUser(userId,pagecount,10);  
	out.print(result);
%>