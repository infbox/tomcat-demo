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
		String frdId=request.getParameter("frdId");//接收者的id
		if (frdId==null) return;
		
		int iFrdId=Integer.parseInt(frdId);
		MyUser frd=DemoUtil.getUserById(iFrdId);
		String type=request.getParameter("type");
		if (type==null) return;		
		MiscUtil.debug("frdId="+frdId+",type="+type);	
		short sType=1;
		if(type!=null)sType=Short.parseShort(type);
		long data=DemoUtil.addFriend(user.getId(), iFrdId, frd.getName(), frd.getHeadPic(),user.getName(),user.headPic);  
		if(data>0){
			user.idolCount+=1;
			out.print("ok");}
		else out.print("error");
%>
