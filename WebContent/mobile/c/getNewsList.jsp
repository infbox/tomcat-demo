<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="com.infbox.demo.article.JHArticleUtil,com.infbox.util.*,com.infbox.demo.*,java.util.*,com.infbox.demo.article.*"  %>
<%
	String type = request.getParameter("type");	
	Integer pagecount = Integer.parseInt(request.getParameter("pagecount"));	
	String ss=JHArticleUtil.queryArticleList(pagecount,5); 
	out.print(ss); 
%>