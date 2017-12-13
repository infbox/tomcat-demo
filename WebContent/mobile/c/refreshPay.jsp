<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="sun.misc.*,com.infbox.sdk.*"%>
<%@ page import="java.util.*,com.infbox.demo.article.*,com.infbox.demo.*,com.infbox.pay.*"%>
<%@ page import="java.io.*,org.bson.types.ObjectId"%>
<%@ page session="true" %> 
<%		


MyUser user = (MyUser) session.getAttribute("user");
if (user == null) {
	out.println("error");
	return;
}
		
		request.setCharacterEncoding("UTF-8");
			String pId = request.getParameter("id");
			if(pId==null){
				out.println("error");
				return;
			}
			Boolean b=PayUtil.refreshStatus(Long.parseLong(pId)); 
			
			if(b){
				out.println("confirmed");				
			}else out.println("not_confirmed");
			
		
			
	%>