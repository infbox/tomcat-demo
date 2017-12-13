<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="com.infbox.demo.article.JHArticleUtil"  %>
<%
	String articleId = request.getParameter("articleId");	
	String result = JHArticleUtil.getCounter(Integer.parseInt(articleId)); 
	out.print(result); 
%>