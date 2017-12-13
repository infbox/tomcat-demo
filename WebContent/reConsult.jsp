<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="sun.misc.*"%>
<%@ page import="com.infbox.demo.*,com.infbox.demo.article.*"%>
<%
//这是请示信息回复的处理页面
	request.setCharacterEncoding("utf-8");
	String encrypt=request.getParameter("encrypt");
	if(encrypt==null)  {
		out.print("{\"result\":\"error1\"}");
		 return ;
	}
	System.out.println("1 encrypt="+encrypt);
	
	String btn=request.getParameter("btn");
	String option=request.getParameter("option");
	String svrId=request.getParameter("id");
	String cmd=request.getParameter("cmd");
	String param=request.getParameter("param");
	String fromMobile=request.getParameter("fromMobile");
	String token=request.getParameter("token");
	
	System.out.println("btn="+btn+",option="+option+",svrId="+svrId+",fromMobile="+fromMobile+
				"token="+token+",cmd="+cmd+",param="+param);
	//如果是对投诉文章的处理，就关闭文章
	if(cmd!=null && "article".equalsIgnoreCase(cmd) && option.contains("1")){
		int articleId=Integer.parseInt(param);
		JHArticleUtil.screenArticle(articleId);
	}
	//处理反馈的请示，记录反馈数据
	DemoUtil.updateInfBoxConsult(svrId, token, option, btn);
	out.print("{\"result\":\"ok\"}");
	return;	
%>