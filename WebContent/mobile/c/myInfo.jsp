<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%@ page import="com.infbox.demo.article.*"%>
<%@ page import="com.infbox.demo.*,com.infbox.sdk.*"%>
<% 
request.setCharacterEncoding("UTF-8");
MyUser user=(MyUser) session.getAttribute("user");

if(user==null){		
	String bsUrl2="mobile/c/myInfo.jsp";
	System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	return;
}
String mycity=user.getCity();
if(mycity==null)user.setCity("");

%>

<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<link rel="stylesheet" href="css/people.css" />
		<link rel="stylesheet" type="text/css" href="css/sweetalert.css">
		<title>我的个人信息</title>
		<link rel="stylesheet" type="text/css" href="css/jquery-confirm.css" />
		<script type="text/javascript" src="https://lib.sinaapp.com/js/jquery/1.8.3/jquery.min.js"></script>
		<script src="./js/sweetalert.min.js"></script>
		<script src="./js/jngh.js?v=28"></script>
		<style type="text/css">
			div,input,img{margin:0;padding:0;font-size:12px;}
.filt_box{position:relative;overflow:hidden;cursor:pointer;}
#add img{position:absolute;left:0;top:0;}
#add input{width: 29%;
    height: 180px;
    border-radius: 180px;
    height: 90px;
    float: left;display:block;position:absolute;left:5%;top:15px;z-index:10;filter:alpha(opacity=0);moz-opacity:0;opacity:0;}
    	.goTop{
top:30px;padding-top:90px;position:absolute;width:98%;left:1%;
}

.overlay,
 .loading-img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
.overlay {
  z-index: 1010;
  background: rgba(255, 255, 255, 0.7);
}
.overlay.dark {
  background: rgba(0, 0, 0, 0.5);
}
 .loading-img {
  z-index: 1020;
  background: transparent url('img/ajax-loader1.gif') 50% 50% no-repeat;
}
   .hide {
  display: none !important;
}

		</style>
		
	</head>
	<body>
		<div class="prev">
			我的信息
			<span>
				<img class="leftimg" src="img/icon06.png"/>|
				<img class="rightimg" src="img/icon02.png"  />
			</span>
		</div>
		<div class="main-foot filt_box">
			<ul>
			<%
				if(user==null){
					out.println("没找到该用户资料！");
				}else{
					if(user.headPic==null || "".equals(user.headPic)) user.headPic="img/pic02.png";
					if(user.memo==null || "".equals(user.memo)) user.memo="";
			%>
				<li>
					<form id="add">
					<input type="file"  name="pic" id="pic" accept="image/*" />
					</form>
					
					<img class="pic" id="headPic" src="<%=user.headPic%>"/>
					<div>
						<span class="left">
							<h2 id="myName" onclick="upName()"><%=user.getName() %></h2>
							<p class="about">
							<% 
								if(user.getLevel()==0){
									out.println("");
								}else{
									for(int i=0;i<user.getLevel() && i<5;i++){
										out.println("<img src='img/icon03.png' style='vertical-align:middle;width:21px;height:21px;'/>");
									}
									out.println("已认证专家");
									
								}
							%>
							</p>
							<p class="dq"><img src="img/icon12.png"/><%=user.getCity() %></p>
						</span>
						
					</div>
				</li>
				<%} %>
			</ul>
		</div>
		<%if(user!=null){ %>
		<div class="main-center">
			<ul>
				<li onclick="javascript:window.location.href='myIdols.jsp?userid=<%=user.getId()%>';">
					<p><span>关注(<%=user.idolCount %>)</span></p>
					<a href="">></a>						
				</li>
				<li onclick="javascript:window.location.href='myFans.jsp?userid=<%=user.getId()%>';">
					<p><span>粉丝(<%=user.fansCount %>)</span></p>
					<a href="">></a>						
				</li>						
				
				<li onclick="javascript:window.location.href='payList.jsp';">
					<p><span>打赏记录</span></p>
					<a href="">></a>
				</li>
				<li onclick="javascript:window.location.href='ActivityCollectList.jsp?userId=<%=user.getId()%>';">
					<p><span>收藏的文章</span></p>
					<a href="">></a>
				</li>
				<li onclick="javascript:window.location.href='liuyanList.jsp';">
					<p><span>消息历史</span></p>
					<a href="">></a>
				</li>
				<li onclick="javascript:window.location.href='ArticleCommend.jsp';">
					<p><span>推荐文章</span></p>
					<a href="">></a>
				</li>
				<li onclick="javascript:window.location.href='about.html';">
					<p><span>关于社群</span></p>
					<a href="">></a>
				</li>
				<li class="message">
					<p> 修改签名信息</p>
					<a href="">></a>
					<a class="btn" href="javascript:setMyMemo('<%=user.getId()%>');">修改</a>
				</li>
				
			</ul>
		</div>
		<div class="message-box" style="display:none;">
			<textarea name="liuyan_str" id="liuyan_str"   rows="" cols="" placeholder="设置您的签名信息"><%=user.memo %></textarea>
			<span>0/500</span>
			<div class="up"></div>
		</div>
		<div class="loading-img hide"></div>
		<div class="overlay hide"></div> 
		<%} %>
	</body>
	
	<script src="./js/lrz.all.bundle.js?v=1"></script>
	<script type="text/javascript">
	$(function(){
		$('#liuyan_str').focus(function (){ 			
			$('.message-box').addClass("goTop"); 
		}) ;
		$('#liuyan_str').blur(function (){ 
			$('.message-box').removeClass("goTop"); 			
		});
		
		$("#pic").on("change",function(){
			showLoading();
			var file = this.files[0];
		    if (!/image\/\w+/.test(file.type)) {
		    	sAlert("只能上传图片.");
		        return false;
		    }
		    var reader = new FileReader();
		    reader.readAsDataURL(file);
		    reader.onload = function(e) {
		        var img = new Image,
		            width = 640, //image resize
		            quality = 0.8, //image quality
		            canvas = document.createElement("canvas"),
		            drawer = canvas.getContext("2d");
		        img.src = this.result;
		        img.onload = function() {
		            canvas.width = width;
		            canvas.height = width * (img.height / img.width);
		            drawer.drawImage(img, 0, 0, canvas.width, canvas.height);
		            img.src = canvas.toDataURL("image/jpeg", quality);
		            console.log(1);
		            var data = {'imgR': img.src}
		            img.onload = null;
			 $.ajax({  
		            url: '${ctx}/updatePic.action',  
		            type: 'POST',  
		            data: data,  
		            dataType: 'JSON',  		           
		            success:function(data){  		                
		                if(data.code==1){
		            		$("#headPic").attr("src",data.data);
		            		sAlert('修改成功');
		            	}else if(data.code==999){
		            		sAlert("图片过大，请重新上传");
		            	}else if(data.code==998){
		            		sAlert("系统繁忙，请稍后再试");
		            	}		                
		                hideLoading();
		            }   
		        });  //ajax
		        }
		    }
		});//pic change
	
	});//$function
	
	function upName(){
		swal({
			  title: "",
			  text: '请输入新昵称:',
			  type: 'input',
			  showCancelButton: true,
			  closeOnConfirm: true,
			  confirmButtonText: "提交", 
			  cancelButtonText: "取消",
			  animation: "slide-from-top"
			}, function(inputValue){
			  console.log("You wrote", inputValue);
			  if(inputValue==""){
		    		return;
		    	}
		    	$.ajax({  
		            url: '${ctx}/updateName.action?name='+inputValue,  
		            type: 'POST',  
		            dataType: 'JSON',  
		            cache: false,  
		            processData: false,  
		            contentType: false, 
		            success:function(data){  
		                $("#myName").html(inputValue);
		                sAlert('修改成功');
		            }   
		        });  
			});		
		
	}
	
	function showLoading(){
		$(".loading-img").removeClass("hide");
		$(".overlay").removeClass("hide");
	}

	function hideLoading(){
		$(".loading-img").addClass("hide");
		$(".overlay").addClass("hide");
	}
	
	</script>
	
</html>
