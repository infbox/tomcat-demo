<%@ page language="java" import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*,com.infbox.demo.article.*" pageEncoding="UTF-8"%>

<%	
/*
	帖子详情
*/

	MyUser user =(MyUser) session.getAttribute("user");
	String uid=""; 
	if(user==null) {
		//未登录，先登陆
		response.sendRedirect("infbox/login.jsp");
		return;
	}
	String postId=request.getParameter("id");
	
	Article post=JHArticleUtil.getArticle(Integer.parseInt(postId));
	MyUser u=DemoUtil.getUserById(post.userid);
	String timeStr=DemoUtil.getTimeString(post.postDate.getTime());
	ArrayList<Comment> list=DemoUtil.getComments(post.id);
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title></title>
		<link rel="stylesheet" href="css/style.css?v=6" />
		<script type="text/javascript" src="//lib.sinaapp.com/js/jquery/1.9.1/jquery-1.9.1.min.js"></script>	
		<script type="text/javascript" src="ueditor/third-party/SyntaxHighlighter/shCore.js"></script>   
		<link rel="stylesheet" href="ueditor/third-party/SyntaxHighlighter/shCoreDefault.css" type="text/css" />
		<link rel="stylesheet" href="ueditor/themes/iframe.css" type="text/css" />
		<script type="text/javascript" src="ueditor/third-party/SyntaxHighlighter/fix1.js"></script>   
		
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
							<li><a href="#">你好，请&nbsp;</a><a href="infbox/login.jsp">登录</a></li>
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
				<h1 class="fl"><a href="main.jsp">重要通知：有奖征集问题活动开始啦！！！</a></h1>
				<div class="topbar-searchbox fr">
					<input class="fl" id="txt_search" type="text" name="" id="" placeholder="输入搜索话题关键词" />
					<input class="fr" id="btn_search" type="button" id="" value="" />
				</div>
			</div>
			<!--conts-topbar end-->
			<div class="conts-leftbox fl">
				<div class="article-conts">
					
					<div class="erweima2"><a href="javascript:showQrCode('<%=postId%>');"><img id="qrCodeImg" src="images/saoma.jpg" class="qr_small" title="使用抓信扫码，可以实时收到最新回帖通知"/></a></div>
					<div class="erweima1"><a href="javascript:showQrCode('<%=postId%>');">抓信<br/>关注</a></div>
					<h2><%=post.title %></h2>
					<div class="article-user-info cf">
						
						
							<img class="fl user-head" src="<%=u.headPic%>"/>
							<a class="article-user-name fl" href="#"><%=u.getName() %></a>
						
						<span class="col-gray fl">（0积分）</span>
						<span class="article-date col-gray fl">发表于<%=timeStr %> &nbsp;</span>
											
							<span class="article-state fl">活跃</span>						
					</div>
					<!--article-user-info end-->
					<div class="article-box cf">
						
						<div class="article " style="width:100%;">
							<%=post.content %>
						</div>
					</div>
					<!--article-box end-->
				</div>
				<!--article-conts end-->
				<%
				String header=null;
				if(list.size()==0) header="暂时还没有人评论哦！";
				else  header=list.size()+"条评论";
				%>
				<div class="article-comment-box">
					<div class="article-comment-bar cf">
						<h3 id="commentHeader" class="fl"><%=header %></h3>
						
					</div>
					<!--article-comment-bar end-->
					<ul id="followList" class="article-comment">
						<%
						for(int j=0;j<list.size();j++){
							Comment comment=list.get(j);		
							u=DemoUtil.getUserById(comment.author_id);	
							timeStr=DemoUtil.getTimeString(comment.addTime.getTime());
						
						%>
							<li>
								<div ></div>
								<div class="article-comment-right fl">
									<div class="article-comment-info cf">
										
										
											<img class="fl user-head" src="<%=u.headPic%>"/>
											<a class="article-user-name fl" href="#"><%=u.getName() %></a>
										
										<span class="col-gray fl">（0积分）</span>
										<span class="comment-date col-gray fl">发表于<%=timeStr %></span>
									</div>
									<p><%=comment.content %></p>
									
									
								</div>
							</li>
						<%} %>

					</ul>
				</div>
				<!--article-comment-box end-->
			
					<div class="my-comment">
						<h3>我的评论</h3>
						<textarea class="my-comment-txtbox" placeholder="你怎么看待这个问题？"></textarea>
						<div class="my-comment-info cf">		
								<img class="my-comment-info-head fl" src="<%=user.headPic %>" alt="" />
								<a class="article-user-name fl" href="#"><%=user.getName() %></a>						
							<span class="col-gray fl">（140积分）</span>
							<a class="my-comment-sbumit fr" onclick="reCard('${userSendCard.uuid }');" href="javascript:void(0);">提交评论</a>
						</div>
						<!--my-comment-info end-->
					</div>
			
				<!--my-comment end-->
			</div>
			<!--conts-leftbox end-->
			<div class="conts-rightbox fr">
			 	<a class="new-article" href="main.jsp">返回首页</a>
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
		var tieId = '<%=postId%>';
		var mainFollow = '<li>'
			+'<div></div>'
			+'<div class="article-comment-right fl">'
				+'<div class="article-comment-info cf">'
					+'<img class="fl user-head" src="${user.headPic}"/>'
					+'<a class="article-user-name fl" href="#">${user.name}</a>'
					+'<span class="col-gray fl">（140积分）</span>'
					+'<span class="comment-date col-gray fl">刚刚</span>'
				+'</div>'
				+'<p>$content$</p>'				
				
				+'</div>'
				+'</ul>'
			+'</div>'
		+'</li>';
		var otherFollow = '<li>'
			+'<p>$content$</p>'
			+'<div class="article-comment-info cf" style="font-size: 14px;">'
				+'<a class="article-user-name fl" href="#">'
				+'${user.name}'
				+'</a>'
				+'<span class="col-gray fl">（140积分）</span>'
				+'<span class="comment-date col-gray fl">刚刚</span>'
				+'<a class="col-blue" href="#">回复</a>'
			+'</div>'
		+'</li>';
		
		var commentTotal=<%=list.size()%>;
		function reCard(){
			var content = $(".my-comment").find("textarea").val();
			if(content==""){
				alert("请输入回复内容");
			}
			$.ajax({
				url:"addComment.jsp",
				data:{
					post_id:<%=postId%>,
					content:content
				},success:function(data){					
					$("#followList").append(mainFollow.replace("$content$",content));
					$(".my-comment").find("textarea").val("");
					commentTotal=commentTotal+1;
					$("#commentHeader").html(commentTotal+"条评论");
					
				}
			});
		}
		
	
		
		function showQrCode(postId){
			var className=$('#qrCodeImg').attr('class');
			if(className=='qr_small'){				
				$("#qrCodeImg").attr('src','qrcode?type=3&tid='+postId+'&param=tiezi');
				$("#qrCodeImg").attr('class','qr_big');
				$(".erweima2").css("margin_top","-30px");
				$(".erweima1").hide();
			}else{
				$("#qrCodeImg").attr('class','qr_small');
				$("#qrCodeImg").attr('src','images/saoma.jpg');
				$(".erweima1").show();
				$(".erweima2").css("margin_top","0px");
			}

		}
		 SyntaxHighlighter.all() //执行代码高亮  
		 $('.syntaxhighlighter').css("width","100px");
		 fixLineNum();
	</script>
</html>
