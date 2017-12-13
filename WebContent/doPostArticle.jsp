<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.jspsmart.upload.SmartUpload"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*,com.infbox.demo.*"%>

<%@ page import="com.jspsmart.upload.File"%>
<%@ page import="com.jspsmart.upload.Files"%>
<%@ page import="java.awt.Image,java.awt.image.*"%>
<%@ page import="com.sun.image.codec.jpeg.*"%>

<%@ page import="com.infbox.demo.article.*,com.infbox.sdk.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>保存公众号草稿文章信息</title>
	</head>
	<body>
		<%
			request.setCharacterEncoding("UTF-8");			
			MyUser user =(MyUser) session.getAttribute("user");
			if(user==null)return;
			Article activity = null;
			String newsId = request.getParameter("newsId");
			String flag = request.getParameter("flag");
			String title = request.getParameter("title");	
			String author = request.getParameter("author");		
			String content = request.getParameter("content");		
			String bgimg = request.getParameter("logo");	;
		
			
			if(bgimg==null || bgimg.trim().length()<5)bgimg=InfBoxUtil.SITE_URL+"/images/pic_logo.png";
			content = content == null ? "" : content;
			content = content.replaceAll("<script>", "<sscript>").replaceAll("</script>", "</sscript>");
			
			if(title == null || title.length() == 0){
				out.print("<script language='javascript'>alert('您没有填写公众号文章主题，请重新填写');history.go(-1);</script>");
				return;
			}
			
			if(content == null || content.length() == 0){
				out.print("<script language='javascript'>alert('您没有填写公众号文章内容，请重新填写s');history.go(-1);</script>");
				return;
			}

			if(newsId != null && MiscUtil.isInteger(newsId)){//修改页面
				activity = JHArticleUtil.getArticle(Integer.parseInt(newsId));
		 	}else{
		 		activity = new Article();
		 	}
			if(author==null || author.trim().equals(""))author=user.getName();
			activity.setTitle(title);
			activity.postDate=new Date();
			activity.setAuthor(author);			
			activity.setContent(content);
			activity.setUserid(user.getId()); 
			activity.bgImg=bgimg;
			
			
			Boolean ok=JHArticleUtil.addArticle(activity);
			out.print("<script language='javascript'>alert('成功提交！');window.location.href='main.jsp';</script>");
			
			
			
		%>
	</body>
</html>