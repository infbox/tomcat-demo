<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.mongodb.BasicDBObject"%>
<%@ page import="java.io.*,org.bson.types.ObjectId"%>
<%@ page import="com.infbox.demo.article.*"%>
<%@ page import="com.infbox.demo.*,com.infbox.sdk.*"%>
	<%
		request.setCharacterEncoding("UTF-8");				
			String id = request.getParameter("id");
			MyUser me = (MyUser) session.getAttribute("user");		
			if(me==null){
				String bsUrl2="mobile/c/newsComment.jsp?id="+id;
				System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?fd_url="+bsUrl2+"&needId=1");
				response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
				return;
			}
			
			
			int intId=Integer.parseInt(id);

			com.infbox.demo.article.Article article=JHArticleUtil.getArticle(intId);
			
			String title = null;
			
			title = article.title;

			if (title == null)
		title = "互动评论";

		String dValue = null;
		ArrayList<Comment> pList=DemoUtil.getComments(intId);
	%>
		
<html>
<head>
<title><%=title%></title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="https://lib.sinaapp.com/js/jquery/1.8.3/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/jquery-mobile/1.4.5/jquery.mobile.min.js"></script>
<link href="https://cdn.bootcss.com/jquery-mobile/1.4.5/jquery.mobile.min.css" rel="stylesheet">
<link rel="stylesheet" href="./css/listview-grid.css">
<link rel="stylesheet" href="./css/kan.css?v=1.10">
<link rel="stylesheet" href="./css/app.min.css">
<link rel="stylesheet" href="./css/stayBtm.css?v=2">
<link rel="stylesheet" href="./css/main.css">
<link rel="stylesheet" href="./css/fixInput.css">
<link rel="stylesheet" type="text/css" href="css/sweetalert.css">
<link href="./css/reply2.css" rel="stylesheet" type="text/css"
	charset="utf-8">
<link href="./css/luck1.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="css/jinghList3.css?v=7" />
<script src="./js/sweetalert.min.js"></script>
<script src="./js/jngh.js?v=42"></script>
<script type="text/javascript">
$(document).ready(function(e){
    $(document).on("tap",".reply", function(e){ 
    	e.stopPropagation();//防止事件传播
    	if($("#popMenu").css("display")!="none"){
    		$("#popMenu").css("display","none");
    		return;
    	}
    	//alert("e.pageY="+e.pageY);
    	var top=0,left=0;
    	//top=$(this).scrollTop;
    	//alert("this.scroll="+top);
    	top=document.documentElement.scrollTop+e.clientY;
    	left=document.documentElement.scrollLeft+e.clientX;
    	
    	// $( "#popMenu" ).css("background-color","yellow");
    	 $("#popMenu").css("display","block");
    	 $("#popMenu").css("position","absolute");
    	// $("#popMenu a").css("font-weight",50);
    	 $("#popMenu").css("width","200px");
    	// alert('tap='+e.pageY);
    	 $("#popMenu").css("top",e.pageY-30 +'px');//pageY
    	 var x=e.pageX-50;
    	 var c_Width=$(document.body)[0].clientWidth;  
    	 if(x<0) x=10;
    	 else if((x+200)>c_Width) x=e.pageX-110;
    	 $("#popMenu").css("left",x +'px');
    	 $("#popMenu").css("z-index",99999);
    	
    	 $("#popDing").html("赞["+$(this).attr("ding")+"]");
    	 $("#popDing").attr("tieid",$(this).attr("tieid"));
    	 $("#popDing").attr("divid",$(this).attr("id"));
    	 $("#popDing").attr("ding",$(this).attr("ding"));
    	// cPopup.css({top:e.pageY - 40 +'px',display:'block',position:'absolute'});
      });  
    
    //查看用户信息
    $(document).on("tap",".author", function(e){ 
    	e.preventDefault();//防止a链接嵌套事件传给父级
    	  e.stopPropagation();//防止事件传播
    	  var authorid=$(this).attr("authorid");
    	//跳转显示用户信息
    	window.location.href='userInfo.jsp?id='+authorid;
      });  
    
    $(document.body).touchmove(function(){
    	$( "#popMenu" ).css({display:'none'});
	});
    
    });
  </script>
 
<style id="collapsible-list-item-style-flat">
.ui-li-static.ui-collapsible>.ui-collapsible-heading {
	margin: 0;
}

.ui-li-static.ui-collapsible {
	padding: 0;
}

.ui-li-static.ui-collapsible>.ui-collapsible-heading>.ui-btn {
	border-top-width: 0;
}

.ui-li-static.ui-collapsible>.ui-collapsible-heading.ui-collapsible-heading-collapsed>.ui-btn,.ui-li-static.ui-collapsible>.ui-collapsible-content
	{
	border-bottom-width: 0;
}
.goTop{
position: fixed; top: 50px;padding-top:1px;
}
.goDown{
bottom:-1px;padding-bottom:1px;
}
</style>
<link rel="stylesheet" href="css/headBar2.css" />
</head>


		
		
		
<body style="overflow-y:scroll;" class="bodyer">
<div class="prev">
			
			<span>
				<img class="leftimg" src="img/icon06.png"/>|
				<img class="rightimg" src="img/icon02.png"  />
			</span>
		</div>
<div data-role="page" data-theme="a" id="demo-page" class="my-page body-margin-top" >
	


	<br/>		
	<div style="margin-bottom:5px;padding-left:10px;">
					<a href="javascript:window.location.href='article.jsp?id=<%=article.id%>';"><span style="font-size:1.3em;"><%=title%></span></a>
			</div>
	<div class="main">

		<div class="replies" id="hotReplies" style="display: block;">
					<div class="titleBar  titleBar-blue">
						<div class="text">
							<strong>用户评论</strong> 
						</div>
					</div>
					
					<div class="list">
					<%		
					if(pList.size()==0){
						%>
						<p>目前还没有评论，快来抢沙发吧！</p>
						<%
					}
					
					MyUser u=null;String timeStr=null;	
					for(int i=0;i<pList.size();i++){
						Comment comment=pList.get(i);		
						u=DemoUtil.getUserById(comment.author_id);						
					%>
					
						<div class="reply" id="hot-<%=comment.id%>" tieid="<%=comment.id%>" >
							<div class="inner  clearfix">
								<span class="author" authorid="<%=u.getId()%>"><span class="from"><%=u.getName() %></span>
								</span> <span class="postTime"><%=MiscUtil.date2Str(comment.addTime)%></span>
								<div class="body">									
									<p class="content"><%=comment.content %></p>
								</div>
							</div>

						</div>	
						
					<%} %>
					</div>
					
		</div>
	
	</div><!-- end of main content -->
		

		
	
<!-- footer begin -->
	<div data-role="footer" data-position="fixed" id="pFooter"
			data-theme="a">
			<div class="main" style=" display:flex;justify-content:center;align-items:center;height:34px;">
			
				<div style="position: relative; float: left; width: 80%;height:100%;">
					<input id="mycomment"  placeholder="点此发表评论" >
				</div>
				<% 
				String action="";
				if(me!=null)action="javascript:faComment()";
				else action="javascript:faComment()";
				%>
				<div style="position: relative; float: right; width: 20% height:32px;">
					<a type="button" href="javascript:void(0);" onclick="<%=action %>"
						class="ui-btn ui-btn-inline ui-icon-comment ui-btn-icon-right" >发表</a>


				</div>
			</div>
		</div>
	<div id="popMenu"  data-role="controlgroup" data-type="horizontal" data-theme="b" style="width:220px;display:none;">
						<a id="popDing" href="javascript:dingTie();" data-icon="grid" class="ui-btn ui-icon-heart ui-btn-icon-left" style="width:100px;">赞[19334]</a>
						<a id="popReply" onclick="javascript:huifuInput();" data-icon="grid" class="ui-btn ui-icon-edit ui-btn-icon-left" style="width:100px;">回复</a>				        							        
		</div>
</div><!-- end of page -->
<script>
			
	
	$(function () { 		
		$("[data-role='header'], [data-role='footer']").toolbar();		
		$('#mycomment').focus(function (){ 
			$('#pFooter').removeClass("stayBtm"); 
			$('#pFooter').addClass("goTop"); 
		}) ;
		
	});
	
	function faComment(){
		sendComment(<%=me.getId()%>,<%=id%>);		
	}
</script>
</body>
</html>
