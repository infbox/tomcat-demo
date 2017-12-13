<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ page import="com.infbox.demo.article.*"%>
<%@ page import="com.infbox.demo.*,com.infbox.sdk.*"%>
	<%	
	
	
	String targetId=request.getParameter("id");
	MyUser user=(MyUser) session.getAttribute("user");
	
	
	if(user==null){
		String bsUrl2="mobile/c/tousu.jsp?id="+targetId;
		System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&fd_url="+bsUrl2+"&needId=1");
		response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
		return;
	}
	%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<title>欢迎及时举报有害信息</title>
		<link rel="stylesheet" href="css/proposal.css?v=5" />
		<link rel="stylesheet" href="css/sweetalert.css?v=1" />
		<script src="https://apps.bdimg.com/libs/jquery/1.8.3/jquery.min.js"></script>		 
		<script src="js/proposal.js?v=1.1" type="text/javascript" charset="utf-8"></script>
		<script src="js/sweetalert.min.js?v=1.0" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	function sAlert(content){
		swal({   title: "",   text: content,   timer: 6200,   showConfirmButton: true });
	}
		function giveAdvice(){			
			var category=$("#proize").html();
			if(category=="欺诈") categId="1";
			else if(category=="色情") categId="2";
			else if(category=="违法犯罪") categId="3";
			else if(category=="不实信息") categId="4";
			else if(category=="侵权") categId="5";
			else  categId="6";
		
			var content=$("#myAdvice").val();
			
			content=$.trim(content);
			if(content.length<4){
				sAlert("填写的字数太少啦!请您写详细一点好吗?");
				return;
			}
		    if(content.length>200){
		    	sAlert("填写的字数太多啦!请您写简单一点好吗?");
				return;
			}
		  
			$.post("doTousu.jsp", {category:categId,advice:content,artId:<%=targetId%>}, 
					function (data, textStatus){ 	
					 	if(data.indexOf("ok")>-1) {
					 		sAlert('提交成功！非常感谢!\n请点击左上角返回。');							
							
						}else{
							sAlert("操作失败，请重新尝试！");
						}
			    
			        });	
		}
		
		</script>
	</head>
	<body>
		<div class="prev">
		
		</div>
		<div class="main">
			<div id="probox" class="pro-box" style="display: none;">
				<ul>
					<li style="color: #000;">投诉原因</li>
					<li class="orange">欺诈</li>					
					<li>色情</li>
					<li>违法犯罪</li>
					<li>不实信息</li>
					<li>侵权</li>
					<li>其它</li>
				</ul>
				<a class="pro-close" href="">X</a>
			</div>
			<ul id="list1">
				<li>
					<p>投诉原因：</p>
					<p id="proize">欺诈</p>
				</li>
				<li class="active"> 
					<textarea name="myAdvice" id="myAdvice" rows="" cols="" placeholder="请输入您的宝贵意见（200字以内）"></textarea>
					<span>0/200</span>
				</li>
				
			</ul>
		</div>
		<div class="foot">
			<input class="btn-submit" type="button" value="提交" onclick="javascript:return giveAdvice();" />
		</div>
		<div id="pageOverlay"></div>
		<script type="text/javascript">
		var hhh=$(".prev").css("height");
		$("#img_back").css("height",hhh);
		</script>
	</body>
</html>
