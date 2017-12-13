<%@page pageEncoding="UTF-8" import="java.util.Date,com.infbox.demo.*,com.infbox.sdk.*,com.infbox.demo.article.*" contentType="text/html; charset=utf-8"%>

<%
 	MyUser user=(MyUser)session.getAttribute("urse");
if(user==null){ 
	user=new MyUser();
				user.setName("测试员");
}
%> 
<!doctype html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<title></title>
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
		<link rel="stylesheet" href="../../ueditor/third-party/SyntaxHighlighter/shCoreDefault.css" type="text/css" />
		<link rel="stylesheet" href="ueditor/themes/iframe.css" type="text/css" />
		 <style>
        .mock12{height: 45px;margin:0 auto;max-height:45px;}
 		.mock12 img {max-height:45px;}	   
       </style>   
	</head>
  
	<body id="activity-detail" class="zh_CN mm_appmsg not_in_mm" style="max-width:640px;margin:0 auto;background-color:gray;">	
		<div id="head" class="header-nav mock12" >			
			
		</div>		
		
		
		<div id="js_article" class="rich_media body-margin-top">			
			<div class="rich_media_inner">
				<div id="page-content">
					<div id="img-content" class="rich_media_area_primary">
						<h2 class="rich_media_title" id="article_title">
                        	
                   		</h2>
						<div class="rich_media_meta_list">
														
							<em id="post-date" class="rich_media_meta rich_media_meta_text"></em>
							<em class="rich_media_meta rich_media_meta_text" id="today1">2017-01-01</em>
							<a class="rich_media_meta rich_media_meta_link rich_media_meta_nickname" href="userInfo.jsp?id=<%=user.getId()%>" target="_blank" id="post-user"><%=user.getName()%></a>
						</div>
						
						<div class="rich_media_thumb_wrp" id="media">
                        	
                        </div>							
						<div class="rich_media_content " id="js_content">
							
						</div>
						<div class="ct_mpda_wrp" id="js_sponsor_ad_area" style="width:100%;background-color:#fff;">
							<center id="adv_area">
							<a href="http://www.mercedes-benz.com.cn/" target="_blank" ><img src="img/ad1.jpg" id="bottom_ad" style="height:150px;" /></a>
							</center>
							<p><br></p>
						</div>
						<div class="ct_mpda_wrp" >
							<div style="width:49%;float:left;margin-right:1%;"><a id="likeNumLink3" href="javascript:void(0)"  class='likeZan' style='float:right;'>赞<span class="praise_num" id="likeNum3"></span></a></div>
							<div style="width:49%;float:left;margin-left:1%;"><a href="javascript:void(0)" class='likeZan' >打赏<span class="praise_num" id="bonusNum3"></span></a></div>
							</div>						
						<div class="ct_mpda_wrp" id="js_toobar3" style="margin-top:60px;margin-bottom:60px;" >
							<div id="js_read_area3" class="media_tool_meta tips_global meta_primary" style="vertical-align:middle;" >
								<span id="readNum3" style="color:#607fa6;"></span>
								<a href="#" target="_blank" style="margin-left:10px;"><i class=" icon_nearby_gray bgAsImg"></i>附近的人</a> 
								<a style="float:right;margin-right:10px;" href="#" target="_blank">投诉</a>
							</div>
						</div>
					</div>
					
				</div>
			</div>
		</div>
		<script type="text/javascript">
		<%if(user==null){
			out.print("alert('用户未登录，等会可能无法提交，请先保存好网页内容');");
		}%>
			$(function (){
							
				var topbarH = $(".header-nav").css("height");
				$("#js_article").css("margin-top",topbarH);				
				
				
			});
			
			
			var tit=sessionStorage.getItem("title");
			var cont=sessionStorage.getItem("ccc");
			window.title=tit;
			$('#article_title').html(tit);
			$('#js_content').html(cont);
			
			
		        var date = new Date();  
		        //获取年份  
		        var year = date.getFullYear();  
		        //获取月份  
		        var month = date.getMonth() + 1;  
		        //获取日子  
		        var day = date.getDate();  
		        //拼接日期  
		        var thisDate = year + "-" + (month<10 ? "0" + month : month) + "-" + (day<10 ? "0" + day : day);  
		        $('#today1').html(thisDate);
		   
		        SyntaxHighlighter.all() //执行代码高亮  
		
		</script>
		
	</body>
</html>

