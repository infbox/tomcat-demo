<%@ page language="java" import="java.util.*,com.infbox.demo.article.*,com.infbox.sdk.*,com.infbox.demo.*" pageEncoding="utf-8"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String id=request.getParameter("id");
if(id==null){
	return;
}
int intId=Integer.parseInt(id); 
Article article=JHArticleUtil.getArticle(intId); 
MyUser user = (MyUser) session.getAttribute("user");
if(article.getState()<0){
	//说明文章被屏蔽了，只能管理员看到内容
	if(user!=null && user.getLevel()>1){
		article.content="服务器繁忙，无法获取内容，请稍后再试";
	}
}
JHArticleUtil.incCount(intId, JHArticleUtil.READ_COUNT);
MyUser author =DemoUtil.getUserById(article.userid);

String postDate=MiscUtil.date2Str(article.postDate, true);
%>

<!doctype html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<title><%=article.title %></title>
		<script src="js/ib_a_blank.js?v=8"></script>		
		<script src="<%=InfBoxUtil.SITE_URL%>/js/sweetalert2.min.js"></script>
		<link rel="stylesheet" href="<%=InfBoxUtil.SITE_URL%>/css/sweetalert2.min.css">
		<link rel="stylesheet" href="../../css/button.css">
		<!-- Include a polyfill for ES6 Promises (optional) for IE11 and Android browser -->
		<script src="<%=InfBoxUtil.SITE_URL%>/js/core.js"></script>		
		<script type="text/javascript" src="//cdn.bootcss.com/jquery/2.0.3/jquery.min.js"></script>
		<script src="js/templet.js?v=9"></script>		
		<script src="js/jngh.js?v=40"></script>				
		<link rel="stylesheet" href="css/jhArticle.css?v=9" />
		<link rel="stylesheet" type="text/css" href="css/naviBar.css?v=3" />
		<script type="text/javascript" src="../../ueditor/third-party/SyntaxHighlighter/shCore.js"></script> 
		<script type="text/javascript" src="../../ueditor/third-party/SyntaxHighlighter/fix1.js"></script>   
		 
		<link rel="stylesheet" href="../../ueditor/third-party/SyntaxHighlighter/shCoreDefault.css" type="text/css" />
		<link rel="stylesheet" href="../../ueditor/themes/iframe.css" type="text/css" />
		
	</head>
  
	<body id="activity-detail" class="zh_CN mm_appmsg not_in_mm">	
		<div id="head" class="header-nav" >			
			<span class="right right_menu_width">
				<a class="btn left" href="searchInput.jsp" target="_blank"><img src="img/icon_serach.png"/></a>
				<a class="btn right" href="myInfo.jsp" target="_blank"><img src="img/icon02.png"/></a>
			</span>
		</div>		
		
		<div id="appStart" class="header-nav" style="background-color:#4E4E4E;display:none;">
			<a class="back"><img src="http://www.infbox.com/img/logo.png" style="max-height:85px;" /></a>
				<p class="left" style="margin-left:20px;">抓信</p>
				<span class="right" style="height:32px;width:90px;">					
					<a href="http://a.app.qq.com/o/simple.jsp?pkgname=com.infbox.app" onclick="check()" id="appstoreURL"
					 style="margin-right:3px;float:right;width:90px;text-align:center;overflow:hidden;">
						<p  class="button red " style="color:white;" ><b>打开</b></p>
					</a>
				</span>
		</div>	
		<div id="js_article" class="rich_media body-margin-top">			
			<div class="rich_media_inner">
				<div id="page-content">
					<div id="img-content" class="rich_media_area_primary">
						<h2 class="rich_media_title" id="activity-name">
                        	<%=article.title %>
                   		</h2>
						<div class="rich_media_meta_list">
														
							<em id="post-date" class="rich_media_meta rich_media_meta_text"></em>
							<em class="rich_media_meta rich_media_meta_text"><%=postDate%></em>
							<a class="rich_media_meta rich_media_meta_link rich_media_meta_nickname" href="userInfo.jsp?id=<%=author.getId()%>" target="_blank" id="post-user"><%=author.getName()%></a>
						</div>
						
						<div class="rich_media_thumb_wrp" id="media">
                        	
                        </div>							
						<div class="rich_media_content " id="js_content">
							<%=article.content %>
						</div>
						<div class="ct_mpda_wrp" id="js_sponsor_ad_area" style="width:100%;background-color:#fff;">
							<center id="adv_area">
							<a href="http://www.mercedes-benz.com.cn/" target="_blank" ><img src="img/ad1.jpg" id="bottom_ad" style="height:150px;" /></a>
							</center>
							<p><br></p>
						</div>
						<div class="ct_mpda_wrp" >
							<div style="width:49%;float:left;margin-right:1%;"><a id="likeNumLink3" href="javascript:addPrase('<%=InfBoxUtil.SITE_URL%>',<%=article.id%>,'2')"  class='likeZan' style='float:right;'>赞<span class="praise_num" id="likeNum3"></span></a></div>
							<div style="width:49%;float:left;margin-left:1%;"><a href="<%=InfBoxUtil.SITE_URL%>/alipay/saveMoney.jsp?articleId=<%=article.id%>" class='likeZan' >打赏<span class="praise_num" id="bonusNum3"></span></a></div>
							</div>						
						<div class="ct_mpda_wrp" id="js_toobar3" style="margin-top:60px;margin-bottom:60px;">
							<div id="js_read_area3" class="media_tool_meta tips_global meta_primary" style="vertical-align:middle;" >
								<span id="readNum3" style="color:#607fa6;"></span>
								<a href="<%=InfBoxUtil.SITE_URL%>/mobile/lbs/index.jsp" target="_blank" style="margin-left:10px;"><i class=" icon_nearby_gray bgAsImg"></i>附近的人</a> 
								<a style="float:right;margin-right:10px;" href="tousu.jsp?id=<%=article.id%>" target="_blank">投诉</a>
							</div>
						</div>
					</div>
					<div style="width:100%;z-index:10000;position:fixed;bottom:0;height:34px;line-height:34px;background-color:#F4F5F7;" >
						<a  href='newsComment.jsp?id=<%=article.id%>' target='_blank'> <input  class='likeZan' id="myComment" style="min-width:100px;width:35%; height:28px;margin-top:3px;margin-left:13px;font-size:10px;" placeholder="点此发表评论"/></a>
						<a style="float:right;margin-right:10px;" href="javascript:shoucang('<%=InfBoxUtil.SITE_URL%>','<%=article.id%>','###Title###','###Author###','###Bgimg###','###url_path###');" ><img alt="收藏" src="img/icon_heart_gray.png" style="height:24px;margin-top:5px;" ></a>
						<span style="float:right;margin-right:15px;" id="comment3"><a  href='newsComment.jsp?id=<%=article.id%>' target='_blank' ><img alt="评论" src="img/icon04.png" style="height:24px;margin-top:5px;" ><div style="height:34px;line-height:34px;float:right;font-size:13px;" id="commentNum3"></div></a></span>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			$(function (){
				queryCounter('<%=InfBoxUtil.SITE_URL%>',<%=article.id%>,'###app_name###');				
				var topbarH = $(".header-nav").css("height");
				$("#js_article").css("margin-top",topbarH);				
				
				
			});
			setTimeout(function () {
				/*不可以用两个斜杠写注释，否则ios报错*/
				var pla=ismobile(1);
				var useIB=false;
				if(pla==0){
					if(typeof(infbox)=="undefined") useIB=false;
					else useIB=true;
					$("#appstoreURL").attr("href","https://itunes.apple.com/cn/app/qq/id1161342807");
				}else {
					if(typeof(infbox)=="object") useIB=true;
				}
				if(useIB){		    	   
			    	   $("#head").show();
			    	   $("#appStart").hide();
			       }else{
			    	   $("#head").hide();
			    	   $("#appStart").show();
			       }
		    }, 1000);
			 SyntaxHighlighter.all() //执行代码高亮  
			 $('.syntaxhighlighter').css("width","100px");
			 fixLineNum();
		</script>
		
	</body>
</html>