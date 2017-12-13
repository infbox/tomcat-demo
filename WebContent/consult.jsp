<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
String option=request.getParameter("option"); 
String devId=request.getParameter("deviceId");
String ctId=request.getParameter("consultType");
if(ctId==null)ctId="";
System.out.println("option="+option+",ctId="+ctId);//'+;
 String sRetv="{}";  
 if( ctId.contains("8")){
	 if(option.contains("1") ){
		 sRetv="{\"cmd\":\"consult\",\"ctType\":\"9\",\"title\":\"请选择需要监测的实时数据\",\"content\":\"点击以下选项即可\",\"url\":\"http://www.infbox.com/demo1/consult.jsp\"}"; 
	 } else
	 if(option.contains("3")){
		 sRetv="{\"cmd\":\"live\",\"type\":\"video\",\"url\":\"http://www.infbox.com/gongxiu/device/liveVideo.jsp\"}"; 
	 } else 
	 if(option.contains("4") ){
		 sRetv="{\"cmd\":\"live\",\"type\":\"audio\",\"url\":\"http://www.infbox.com/gongxiu/device/liveAudio.jsp\"}"; 
	 }  else 
		 if(option.contains("2") ){
			 sRetv="{\"cmd\":\"live\",\"type\":\"location\",\"url\":\"http://www.infbox.com/gongxiu/device/liveAudio.jsp\"}"; 
		 }  
 }else if(ctId.contains("9")){
	 if(option.contains("1") ){
		 sRetv="{\"cmd\":\"live\",\"type\":\"data\",\"url\":\"http://www.infbox.com/gongxiu/device/liveData.jsp\"}"; 
	 } else
	 if(option.contains("2") ){
		 sRetv="{\"cmd\":\"live\",\"type\":\"data\",\"url\":\"http://www.infbox.com/gongxiu/device/liveData.jsp\"}";  
	 } else 
	 if(option.contains("3") ){
		 sRetv="{\"cmd\":\"live\",\"type\":\"data\",\"url\":\"http://www.infbox.com/gongxiu/device/liveData.jsp\"}"; 
	 }  
 }else{
	 //跟设备沟通的第一个页面
	 sRetv="{\"cmd\":\"consult\",\"ctType\":\"8\",\"title\":\"欢迎您，主人！\",\"content\":\"点击以下选项即可\",\"url\":\"http://www.infbox.com/demo1/consult.jsp\"}";
 }
 
 out.print(sRetv);
    
%>