<%@ page language="java" import="java.util.*,com.infbox.demo.article.*,com.infbox.sdk.*,com.infbox.demo.*" pageEncoding="utf-8"%>
<%
String myId=request.getParameter("userid");
if(myId==null){	
	return;
}

MyUser user=(MyUser) session.getAttribute("user");
if(user==null){
	String bsUrl2="mobile/c/myFans.jsp?userid="+myId;
	System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&fd_url="+bsUrl2+"&needId=1");
	response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	return;
}

int myUserId=Integer.parseInt(myId);
MiscUtil.debug("myId="+myUserId);
ArrayList<Friend> friends=DemoUtil.getFriendList(myUserId,2, null);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<link rel="stylesheet" href="../lbs/css/list2.css" />
		<link rel="stylesheet" href="css/headBar2.css" />
		<title>我的粉丝列表</title>
	</head>
	<body>
		<div class="prev">
			<a onclick="javascript:window.history.back();"><img class="go_back" src="img/icon_back.png"/></a>关注我的人
			<span>
				<img class="leftimg" src="img/icon06.png"/>|
				<img class="rightimg" src="img/icon02.png"  />
			</span>
		</div>
		<div class="main-top">
			<p>以下是关注我的人：</p>
		</div>
		<div class="main-foot">
		<%
		if(friends==null || friends.size()<1){
			%>
			<ul>
				<li>目前还没有人关注您！</li></ul>
			<%
		}else{
			out.println("<ul>");
			for(int k=0;k<friends.size();k++){
				Friend ff=friends.get(k);
				if(ff.pic==null || ff.pic.length()<5)ff.pic="img/pic02.png";
			%>
			<li>
					<img class="pic" src="<%=ff.pic%>"/>
					<div>
						<span class="left">
							<h2><%=ff.name %></h2>
							<p class="about">土豪！我们做朋友吧！</p>
							<p class="grade">
								<img src="img/icon07.png"/>
								<img src="img/icon07.png"/>
								<img src="img/icon08.png"/>
								<img src="img/icon09.png"/>
								<img src="img/icon09.png"/>
							</p>
						</span>
						<a href="userInfo.jsp?id=<%=ff.frdId%>">查看资料</a>
						<p class="dq"><img src="img/icon12.png"/>北京</p>
						<p class="sj"><img src="img/icon10.png"/>设奖<span>（150）</span></p>
						<p class="hy" onclick="javascript:alert('ok');"><img src="img/icon11.png"/>取消关注</p>
					</div>
				</li>
			<%}
			out.println("</ul>");
		}
		%>
			
				
				
			
		</div>
	</body>
</html>
