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
	
		String msg=request.getParameter("msg");
		if (msg==null) return;		
		MiscUtil.debug("memo="+msg);	
		short type=1;
		DemoUtil.setUserMemo( msg,user.getId());   
		user.memo=msg;
		out.print("ok");
		
%>
