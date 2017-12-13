<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.infbox.demo.article.*"%>
<%@ page import="java.io.*,org.bson.types.ObjectId"%>
<%@ page import="com.infbox.demo.*"%>
<%

	MyUser user = (MyUser) session.getAttribute("user");
 	if (user == null) {
 		out.println("error");
 		return;
 	}
	request.setCharacterEncoding("UTF-8");
		String recvId=request.getParameter("recvId");//接收者的id
		String friendName=request.getParameter("name");//接收者的姓名
		if (recvId==null) return;
		
		int recvID=Integer.parseInt(recvId);
		String msg=request.getParameter("msg");
		if (msg==null) return;		
		MiscUtil.debug("recvId="+recvId+",msg="+msg);	
		short type=1;
		int data=LiuyanUtil.addLiuyan(user.getId(), recvID, msg, type,user.getName(),friendName);  
		if(data>0)out.print("ok");
		else out.print("error");
%>
