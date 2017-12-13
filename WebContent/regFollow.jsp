<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="sun.misc.*"%>
<%@ page import="com.infbox.demo.*"%>
<%@ page import="com.infbox.sdk.*,com.infbox.demo.article.*"%>
<%
//这是用户关注帖子信息源的处理页面，这个页面由InfBox抓信服务器调用 
	request.setCharacterEncoding("utf-8");

	//"tId=" + tId+"&appid="+appId+"&param="+param+"&appsecret="+appSecret+"&token="+token+"&fwid="+fwId+"&action=add"; //URLEncoder.encode()方法  为字符串进行编码
	String tId=request.getParameter("tId");
	if(tId==null)  return ;		        		
	String param=request.getParameter("param");
	 System.out.println(param);
	String appsecret=request.getParameter("appsecret");	
	String appid=request.getParameter("appid");
	
	String fwid=request.getParameter("fwid");
	
	System.out.println("1 encrypt="+fwid);
	String action=request.getParameter("action");
	String token=request.getParameter("token");
	
	System.out.println("fwId="+fwid+",token="+token+",action="+action+",appid="+appid);
	//保存到数据库，然后返回所关注帖子的名称
	if(action.equalsIgnoreCase("add") ){
		//保存订阅到数据库
		if(param.equals("tiezi")){//param=tiezi代表是帖子的关注
			Article art=JHArticleUtil.getArticle(Integer.parseInt(tId));
			if(art==null){
				out.print("{\"error\":\"2\"}");
				return;
			}else{
				long i=DemoUtil.addFollow(fwid, param, tId,token);
				if(i>0)out.print("{\"title\":\""+art.title+"\"}");
				else out.print("{\"error\":\"3\"}");
				return;
			}
			
		}
		
		
	}else if(action.equalsIgnoreCase("del") ){
		//String parm = "tId=" + tId+"&appid="+appId+"&action=del"+"&appsecret="+appSecret+"&fwid="+fwId;
		Follow fw=DemoUtil.getFollow(fwid);
		if(fw==null){//记录不存在，已经删除了，告诉服务器已经删除,此处需要提供自己的身份，否则，服务器认为你没有权限删除
			out.print("{\"error\":\"4\",\"appid\":\""+InfBoxUtil.appId+"\",\"appsecret\":\""+InfBoxUtil.getAppSecret()+"\"}");
			return;
		}else {
			//delete record
			DemoUtil.deleteFollow(fw.id); 
			out.print("{\"token\":\""+fw.token+"\"}");
			return;
		}
		
		
		
	}
		
%>