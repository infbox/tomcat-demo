<%@page pageEncoding="UTF-8" import="java.util.Date,com.infbox.demo.*,com.infbox.sdk.*,com.infbox.demo.article.*" contentType="text/html; charset=utf-8"%>

<%
MyUser user =(MyUser) session.getAttribute("user");

if(user==null) {	
	response.sendRedirect("infbox/login.jsp");
	return;
	
}
 	Article article = null;
 	String newsId = request.getParameter("newsId");
 	
 	if(newsId != null && MiscUtil.isInteger(newsId)){
 		article = JHArticleUtil.getArticle(Integer.parseInt(newsId));
 	}else{
 		article = new Article();
 		
 	}

	String actionStr = "编辑草稿文章";
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>发帖</title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<!-- basic styles -->
		<link href="./css/bootstrap.min.css" rel="stylesheet" />
		<link href="./css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="./css/font-awesome.min.css" />
		<!--[if IE 7]>
		  <link rel="stylesheet" href="./css/font-awesome-ie7.min.css" />
		<![endif]-->
		<!-- page specific plugin styles -->
		<script type="text/javascript" src="./js/jquery.min.js"></script>		
	
		<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.config.js"></script>  
		<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.all.min.js"> </script>  
		<script type="text/javascript" charset="utf-8" src="ueditor/lang/zh-cn/zh-cn.js"></script>  
		<script type="text/javascript" src="./js/qiniu.min.js"></script>	
		<script type="text/javascript" src="./plugload/moxie.js"></script>	
		<script type="text/javascript" src="./plugload/plupload.dev.js"></script>	
		<link rel="stylesheet" href="./css/jquery-ui-1.10.2.custom.min.css" />
		
		<!-- ace styles -->
		<link rel="stylesheet" href="./css/ace.min.css" />
		<link rel="stylesheet" href="./css/ace-responsive.min.css" />
		<link rel="stylesheet" href="./css/ace-skins.min.css" />		
		<!--[if lt IE 9]>
		  <link rel="stylesheet" href="./css/ace-ie.min.css" />
		<![endif]-->
		
		<style type="text/css">
		<!--
		#editProductDiv {
			width: 500px;
		}
		.STYLE1 {color: #0000FF}
		.STYLE2 {
			font-size: 24px;
			font-weight: bold;
		}
		
		#prov_city div{
			
			float: left;
			position: relative;
		}
		.pad-left10{
			padding-left:10px;
		}
		.productlistDiv{width:5em; font-weight:bold; float:left; text-align:center}
		-->
		</style>
		<script type="text/javascript">		
			var siteurl='<%=InfBoxUtil.SITE_URL%>';
		</script>
	</head>
	<body style="height:1132px;">
			<!-- 内容开始 -->
			<div id="main-content" class="clearfix">
				<div id="breadcrumbs">
						<ul class="breadcrumb">
							<li><i class="icon-home"></i> <a href="#">发帖</a><span class="divider"><i class="icon-angle-right"></i></span></li>
							<li><a href="#">内容编辑</a> <span class="divider"><i class="icon-angle-right"></i></span></li>
							<li class="active"><%=actionStr %></li>
						</ul><!--.breadcrumb-->
						<div id="nav-search">
							<form class="form-search" >
									<span class="input-icon">
										<input autocomplete="off" id="nav-search-input" type="text" class="input-small search-query" placeholder="搜索" />
										<i id="nav-search-icon" class="icon-search"></i>
									</span>
							</form>
						</div><!--#nav-search-->
					</div><!--#breadcrumbs-->
					
					<div id="page-content" class="clearfix">
						<div class="page-header position-relative">
							<h1> <small><i class="icon-double-angle-right"></i><%=actionStr %></small></h1>
						</div><!--/page-header-->
						<div class="row-fluid">
							<!-- 添加页面内容 -->
							<form id="form3" name="form3" class="form-horizontal" method="post" action="">
								<input type="hidden" id="newsId" name="newsId" value="<%=newsId%>"/>
								<input type="hidden" id="flag" name="flag" />
								<input type="hidden" id="logo" name="logo" value="<%=article.bgImg %>" />
								<div class="control-group">
									<label class="control-label" for="form-field-1">文章主题</label>
									<div class="controls"><input type="text" name="title" id="title" placeholder="文章主题" value="<%out.print(article.getTitle() == null ? "" : article.getTitle());%>"></div>
								</div>								
								<div class="control-group">
									<label class="control-label" for="form-field-select-3">文章大图</label>
									<div class="controls">
									<input type="hidden" id="qiniuToken" name="qiniuToken" /> 
										<%
											if(article.getState()==0){
										%>
										<input type="file" class="span12 m-wrap" name="logo_pic" id="logo_pic" accept="image/*" />
										
										<%
											}
										%>
										<img id="ImgMain" width="150" height="120" <%if(article.bgImg != null && !"".equals(article.bgImg)){%>src="<%=article.bgImg%>" <%} %>/>
									</div>
								</div>								
								<div class="control-group">
   									<label class="control-label" for="form-field-select-3">文章内容</label>
									<div class="controls">
										<div style="width: 100%; max-width: 640px; float: left;">
											<p>
												<label>
													<textarea id="content" class="editor" name="content" cols="100" rows="8" style="width:100%;height:360px;"><%out.print(article.getContent() == null ? "" : article.getContent());%></textarea>
												</label>
											</p>
										</div>
									</div>
								</div>
								<div class="form-actions">
									<%
										if(article.getState()==0){
									%>
									<button class="btn btn-info" type="button" onclick="saveInfo(1)"><i class="icon-ok"></i> 提交</button>&nbsp;&nbsp;&nbsp;&nbsp;
									<%
											if(newsId != null && !"".equals(newsId)){//只有先经过草稿的才允许发布
									%>
									<button class="btn btn-info" type="button" onclick="if(window.confirm('是否确认要发布此公众号文章信息？')){saveInfo(2);}"><i class="icon-ok"></i> 发布</button>&nbsp;&nbsp;&nbsp;&nbsp;
									<%
											}
										}else{
									%>
									<button class="btn btn-info" type="button" onclick="javascript:history.go(-1);"><i class="icon-ok"></i> 返回</button>&nbsp;&nbsp;&nbsp;&nbsp;
									<%
										}
									%>
									<button class="btn btn-info" type="button" onclick="viewdraft()"><i class="icon-ok"></i> 预览</button>
								</div>
							</form>							
						 </div><!--/row-->
					</div><!--/#page-content-->
					<div id="actv_container" style="display:none;"></div>
			</div><!-- #main-content -->
		<!--/.fluid-container#main-container-->
		<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
			<i class="icon-double-angle-up icon-only"></i>
		</a>
		<!-- basic scripts -->
		
		<script src="js/bootstrap.min.js"></script>
		<!-- page specific plugin scripts -->
		
		<!--[if lt IE 9]>
		<script type="text/javascript" src="js/excanvas.min.js"></script>
		<![endif]-->
		
		<!-- ace scripts -->
		<script src="js/ace-elements.min.js"></script>
		<script src="js/ace.min.js"></script>
		<!-- inline scripts related to this page -->
		
		<script type="text/javascript" src="js/bootstrap.min.js"></script>
		
		<script type="text/javascript" src="js/ui.js"></script>		
		<script type="text/javascript" src="js/highlight.js"></script>
		<script type="text/javascript" src="js/main.js?v=9"></script>
	
		<!-- pic upload -->
		<script type="text/javascript" src="js/ajaxfileupload.js"></script>
		<script type="text/javascript" src="js/uploadIMG.js"> </script>
		<script type="text/javascript" src="js/zh-cn.js"></script>
		<script type="text/javascript">
		hljs.initHighlightingOnLoad();
		var ueditor ;
			var mainpic = true;
			
			$(function (){				
				ueditor = UE.getEditor('content', {
					    toolbars: [
					      ['fullscreen','source','undo','redo','indent','bold','italic','underline','fontborder','snapscreen','print','preview','link','unlink','insertrow','insertcol','mergeright','mergedown','deleterow','deletecol','splittorows','splittocols','splittocells','fontfamily','fontsize','simpleupload','insertimage','spechars','searchreplace','justifyleft','justifyright','justifycenter'],
					      ['justifyjustify','forecolor','backcolor','attachment','imagecenter','wordimage','inserttable','strikethrough', 'superscript', 'subscript', 'removeformat', 'formatmatch', 'autotypeset', 'blockquote', 'pasteplain', '|', 'forecolor', 'backcolor', 'insertorderedlist', 'insertunorderedlist', 'selectall', 'cleardoc']
					    ],
					    iframeCssUrl: 'ueditor/themes/iframe.css',// 引入css
					    autoHeightEnabled: true,
					    autoFloatEnabled: true
					  });
				$("#logo_pic").uploadPreview({ Img: "ImgMain", Width: 150, Height: 120 });				 
	        });//end of $(funt)
			
	        $("#logo_pic" ).change(function() {
	        	upBgImg();
	        	});
	        		
	    	
			
			
			function checkNums(obj){
				var exp = /^(^[0-9]+)?$/;//验证数字
				if(!exp.test(obj.value)){
					alert("输入整数");
					obj.value = "";
					obj.focus();
					return;
				}
			}
			
			/**
			* 保存草稿/发布
			*/
			function saveInfo(str){
				var title = $("#title").val();
				
				if(title == ""){
					alert("文章主题不能为空");
					$("#title").focus();
					return false;
				}
				 
				
				 $("#flag").val(str);
				$("#form3").attr("action","doPostArticle.jsp");
				$("#form3").submit(); 
			}
			
			/**
			* 预览
			*/
			function viewdraft(){
				var title = $("#title").val();
				
				if(title == ""){
					alert("文章主题不能为空");
					$("#title").focus();
					return false;
				}
				sessionStorage.setItem("title",title);
				var html = ueditor.getContent();							
				sessionStorage.setItem("ccc",html);  				
				window.open("mobile/c/preview.jsp", "_blank"); //注意第二个参数	
			}
			
			function checkPic() {
				if (!mainpic) {
					alert("图片还在上传中，请稍后提交！");
					return false;
				} else {
					return true;
				}
			}
			
			
			
			/**
			* 新打开一个页面
			*/
			function openWindow(name){ 
				window.open('about:blank',name,'height=640, width=400, top=0, left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes'); 
			} 
			
					 
		</script>
		
		
	</body>
</html>