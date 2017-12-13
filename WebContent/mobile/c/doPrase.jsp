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
  	//将来要防止程序恶意点赞
	request.setCharacterEncoding("UTF-8");
		String aId=request.getParameter("aId");//接收者的id
		
		if (aId==null) return;
		int artID=Integer.parseInt(aId);
		String type=request.getParameter("type");
		if (type==null) return;		
		MiscUtil.debug("aId="+aId+",type="+type);	
		short sType=1;
		if(type!=null)sType=Short.parseShort(type);
		int data=JHArticleUtil.incCount(artID, sType);  
		if(data>0)out.print("ok");
		else out.print("error");
%>
