<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.infbox.demo.*"%>

<%
/*
处理任务反馈的页面逻辑
*/

	request.setCharacterEncoding("utf-8");
	String encrypt=request.getParameter("encrypt");
	if(encrypt==null) {
		out.print("{\"result\":\"error1\"}");
		 return ;
	}
	System.out.println("1 encrypt="+encrypt);
	Boolean retv=false;
	String cmd=request.getParameter("cmd");
	String svrId=request.getParameter("id");
	String token=request.getParameter("token");
	
	if(cmd.equals("setTaskState")){//改变任务状态
		String state=request.getParameter("state");
		retv=DemoUtil.updateInfBoxTask(svrId, token, Integer.parseInt(state));
		
	}else if(cmd.equals("CommentTask")){//点评任务
		String comment=request.getParameter("comment");
		String score=request.getParameter("score");
		retv=DemoUtil.commentInfBoxTask(svrId, token, comment, Float.parseFloat(score));
		
	}
	
	
	
	System.out.println("svrId="+svrId+
				"token="+token+",cmd="+cmd);
	out.print("{\"result\":\"ok\"}");
	return;	
%>