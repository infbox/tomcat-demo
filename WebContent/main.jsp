<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*,com.infbox.demo.article.*" 
	pageEncoding="UTF-8"%>
<%
MyUser user =(MyUser) session.getAttribute("user");
String uid="";
if(user==null) {	
	uid=request.getParameter("uid");	
	if(uid==null){
		response.sendRedirect("infbox/login.jsp");
		return;
	}
	user =new MyUser();
	Object obj=DemoUtil.getUserCache(uid)	; 
	if(obj==null){
		response.sendRedirect("infbox/login.jsp");
		return;
	}else{
		user=(MyUser)obj;
		//用户信息保存到session里
		session.setAttribute("user", user);
		//DemoUtil.delUserCache(uid);
		
	} 
	
	
}


%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>抓信集成教程Demo</title>
		<link rel="stylesheet" href="css/style.css" />
		<script type="text/javascript" src="//lib.sinaapp.com/js/jquery/1.9.1/jquery-1.9.1.min.js"></script>			
		
    <script type='text/javascript'>
		function sendTestMsg(){
			$.post("sendInfBoxMsg.jsp", {
				id :1,type:'',title:'测试消息'
			}, function(e, f) {
				alert('发送成功');
				
			});
		}
		function sendTest2(){
			var openid = $("#openid").val();
			var vTitle = $("#title").val();
			$.post("sendInfBoxMsg.jsp", {
				id :1,type:'',title:vTitle,receiverId:openid
			}, function(e, f) {
				alert('发送成功');
				
			});
		}
    </script>

	</head>
	<body>
		<div class="header">
			<div class="header-conts">
				<div class="logo-box fl">
					<a href="main.jsp"><img class="fl" src="images/pic_logo.png"/ style="height:58px;margin-right:5px;"></a>
					抓信集成教程Demo
				</div>
				<!--logo-box end-->
				<div class="top-info fr">
					<ul>
						<% if(user==null) {%>
							<li><a href="#">你好，请&nbsp;</a><a href="javascript:login('${ctx }');">登录</a></li>
						<% } else{%>
						
							<li><a href="#">你好，${user.name }</a></li>
							<li class="last"><a href="logout.jsp">退出</a></li>
						<%} %>
						
						
					</ul>
				</div>
				<!--top-info end-->
			</div>
		</div>
		<!--header end-->
		<div class="conts cf">
			<div class="conts-topbar cf">
				<h1 class="fl"><a href="javascript:sendTestMsg();">点击此处，发送抓信测试消息！！！</a></h1>
				<div class="topbar-searchbox fr">
					<input class="fl" id="txt_search" type="text" name="" placeholder="输入搜索话题关键词" id=""/>
					<input class="fr" id="btn_search" type="button" id="" value="" />
				</div>
			</div>
			<!--conts-topbar end-->
			<div class="conts-leftbox list-leftbox fl">
				<div class="list-topbar cf">
					<ul class="fl">
						<li><a class="on" href="#">帖子列表</a></li>
						
					</ul>
					
				</div>
				<ul class="cf">
					<%
					ArrayList<Article> list=JHArticleUtil.getArticleList(1, 10);
					for(int i=0;i<list.size();i++){
						Article post=list.get(i);		
						MyUser u=DemoUtil.getUserById(post.userid);	
						if(u==null)continue;
						String timeStr=DemoUtil.getDateStr(post.getPostDate().getTime());
						
						%>
					
						<li>
							<div  class="icon-up fl"><img alt="" src="<%=post.getBgImg()%>" style="width:60px;height:60px;"></div>
							
							<div class="list-conts fr">
								<h2><a class="col-blue" href="post.jsp?id=<%=post.id%>"><%=post.title %></a></h2>
								<p>
									
								</p>
								<div class="article-user-info list-user-info cf">
									
									
										<img class="fl user-head" src="<%=u.headPic%>">
										<a class="article-user-name fl" href="#"><%=u.getName() %></a>
								
									<span class="col-gray fl">（0积分）</span>
									<span class="article-date col-gray fl">发表于<%=timeStr %></span>
									
									
								</div>
							</div>
						</li>
					<%} 
					if(list.size()==0){
						%>
						<li>暂时还没有数据，请先点击右侧按钮发表一篇新帖吧</li>
						<%
					}%>
				</ul>
				
			</div>
			<!--conts-leftbox end-->
			<div class="conts-rightbox fr">
			 	<a class="new-article" href="postArticle.jsp">发表新贴</a>
			 	<div class="bankuai-list">
			 		<span class="title">版块分类</span>
			 		<ul>
						
							<li><a href="">板块名称<span class="fr">2</span></a></li>
							<li><a href="">板块名称<span class="fr">2</span></a></li>
						
			 		</ul>
			 	</div>
			 	<div class="tab-list">
			 		<span class="title">热门标签</span>
			 		<div class="tab-box cf">
			 			<a href="#">手机</a>
			 			<a href="#">操作系统BUG</a>
			 			<a href="#">大数据</a>
			 			<a href="#">屏幕</a>
			 			<a href="#">生物学</a>
			 			<a href="#">操作系统BUG</a>
			 			<a href="#">手机</a>
			 			<a href="#">操作系统BUG</a>
			 			<a href="#">大数据</a>
			 			<a href="#">人机工程</a>
			 			<a href="#">大数据</a>
			 			<a href="#">操作系统BUG</a>
			 		</div>
			 	</div>
			 	<div class="user-list cf">
			 		<span class="title">活跃会员 <a href="#">换一批</a></span>
			 		<ul>
			 			<li>
			 				<a href="#"><img src="images/pic_head1.png" alt="" />abc5566</a>
			 			</li>
			 			<li>
			 				<a href="#"><img src="images/pic_head1.png" alt="" />abc5566</a>
			 			</li>
			 			<li>
			 				<a href="#"><img src="images/pic_head1.png" alt="" />abc5566</a>
			 			</li>
			 			<li>
			 				<a href="#"><img src="images/pic_head1.png" alt="" />abc5566</a>
			 			</li>
			 			<li>
			 				<a href="#"><img src="images/pic_head1.png" alt="" />abc5566</a>
			 			</li>
			 			<li>
			 				<a href="#"><img src="images/pic_head1.png" alt="" />abc5566</a>
			 			</li>
			 		</ul>
			 	</div>
			</div>
		</div>
		<!--conts end-->
	</body>
	<script type="text/javascript">
		
	</script>
</html>
