<%@page import="com.infbox.util.BASE64"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.mongodb.BasicDBObject"%>
<%@ page import="java.io.*,org.bson.types.ObjectId"%>
<%@ page import="com.infbox.demo.article.*"%>
<%@ page import="com.infbox.demo.*,com.infbox.sdk.*"%>
<%

MyUser me = (MyUser) session.getAttribute("user");


request.setCharacterEncoding("UTF-8"); 
String id = request.getParameter("id");
if(id==null || id.equals("undefined"))id="0";
int userId=Integer.parseInt(id);
if(me==null){
	String bsUrl2="mobile/c/userInfo.jsp?id="+id;
	System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&fd_url="+bsUrl2+"&needId=1");
	response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	return;
}

MyUser user=DemoUtil.getUserById(userId);
if(user==null){	
	out.print("找不到该用户资料");
	
	return;
}
//if(user.city==null)user.city="";

%>

<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<link rel="stylesheet" href="css/people.css" />
		<link rel="stylesheet" type="text/css" href="css/sweetalert.css">
		<title><%=user.getName() %>的信息</title>
		<script type="text/javascript" src="https://lib.sinaapp.com/js/jquery/1.8.3/jquery.min.js"></script>
		<script src="./js/sweetalert.min.js"></script>
		<script src="./js/jngh.js?v=25"></script>
		<style type="text/css">
		.goTop{
top:30px;padding-top:90px;position:absolute;width:98%;left:1%;
}
.goDown{
bottom:-1px;padding-bottom:1px;
}
		</style>
	</head>
	<body>
		<div class="prev">
			个人信息
			<span>
				<img class="leftimg" src="img/icon06.png"/>|
				<img class="rightimg" src="img/icon02.png" onclick="javascript:window.location.href='myInfo.jsp'" />
			</span>
		</div>
		<div class="main-foot">
			<ul>
			<%
				if(user==null){
					out.println("没找到该用户资料！");
				}else{
					if(user.headPic==null || "".equals(user.headPic)) user.headPic="img/pic02.png";
					if(user.memo==null || "".equals(user.memo)) user.memo="还没有设置签名";
			%>
				<li>
					<img class="pic" src="<%=user.headPic%>"/>
					<div>
						<span class="left">
							<h2><%=user.getName() %></h2>
							<p class="about"><%if(user.getLevel()==0){
									out.println("");
								}else{
									
									for(int i=0;i<user.getLevel()&&i<4;i++){
										out.println("<img src='img/icon03.png' style='vertical-align:middle;width:21px;height:21px;'/>");
									}
									out.println("已认证专家");
									
								}
							%></p>
							<%if(user.city!=null){ %>
							<p class="dq"><img src="img/icon12.png"/><%=user.getCity() %></p>
							<% }%>
						</span>
						<%
						Boolean isIdol=DemoUtil.isMyIdol(me.getId(), user.getId());
						if(isIdol){
							%>
							<a>已关注</a>
							<%
						}else{
						%>
						<a href="javascript:addFollow('<%=user.getId()%>',1)">加关注</a>
						<%} %>
					</div>
				</li>
				<%} %>
			</ul>
		</div>
		<%if(user!=null){ %>
		<div class="main-center">
			<input type="hidden" value='<%=user.getName()%>' id="liuyan_name">
			<ul>
				<li>
					<p><span><%=user.memo %></span></p>					
				</li>
				<li onclick="javascript:window.location.href='myIdols.jsp?userid=<%=user.getId()%>';">
					<p><span>Ta的关注(<%=user.idolCount %>)</span></p>
					<a href="">></a>						
				</li>
				<li onclick="javascript:window.location.href='myFans.jsp?userid=<%=user.getId()%>';">
					<p><span>Ta的粉丝(<%=user.fansCount %>)</span></p>
					<a href="">></a>						
				</li>				
				<li onclick="javascript:window.location.href='ArticleListByUser.jsp?userid=<%=user.getId()%>';">
					<p><span>Ta的文章</span></p>
					<a >></a>
				</li>
				<li onclick="javascript:window.location.href='ActivityCollectList.jsp?userId=<%=user.getId()%>';">
					<p><span>Ta的收藏</span></p>
					<a >></a>
				</li>
				<li class="message">
					<p> <img src="img/icon14.png"/>留言</p>
					<a href="">></a>
					<a class="btn" href="javascript:addLiuyan('<%=user.getId()%>');">发送</a>
				</li>
			</ul>
		</div>
		<div class="message-box">
			<textarea name="liuyan_str" id="liuyan_str" rows="" cols="" placeholder="请输入您想说的话！"></textarea>
			<span>0/500</span>
			<div class="up"></div>
		</div>
		<script>
			
	
	$(function () { 		
		
		$('#liuyan_str').focus(function (){ 
			
			$('.message-box').addClass("goTop"); 
		}) ;
		$('#liuyan_str').blur(function (){ 
			$('.message-box').removeClass("goTop"); 
			
		});
	}) ;
</script>
		<%} %>
		
	</body>
</html>
