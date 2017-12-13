<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ page import="com.infbox.demo.article.*"%>	
<%@ page import="com.infbox.demo.*,com.infbox.sdk.*"%>
<%
request.setCharacterEncoding("UTF-8");

MyUser user=(MyUser) session.getAttribute("user"); 


if(user==null){	
	String bsUrl2="mobile/c/searchInput.jsp";
	System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	return;
}

%>


<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<title>搜索文章</title>
		<link rel="stylesheet" href="css/proposal.css?v=5" />
		<link rel="stylesheet" href="css/sweetalert.css?v=1" />
		<script src="https://apps.bdimg.com/libs/jquery/1.8.3/jquery.min.js"></script>		 
		
		<script src="js/sweetalert.min.js?v=1.0" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	function sAlert(content){
		swal({   title: "",   text: content,   timer: 6200,   showConfirmButton: true });
	}
		
		
		</script>
		<style type="text/css">
	a:link{
	
 background-color: #990000; 
 border:#ffff00 1px solid;
 border-radius:5px;
 color: #ffff00; 
 height: 30px; 
 width:70px;
 padding:8px; 
 font-size:1.8em;
 text-decoration: none;
 
}
</style>
	</head>
	<body style="background-color:#f0efee;">
		
		<div class="main" style="margin-top:15px;">			
			
			<div style="margin:0 auto;text-align:center;">
			<form id="myform" method="post" action="searchResult.jsp">			
					<input type="text" placeholder="请输入关键词" name="myKey" id="myKey"  size="10" style="width:50%; margin:0px 0px 0px 12px;height:36px;border-radius:5px; border:1px solid #DBDBDB ;font-size:2.0em;">	
						<a href="javascript:alert('暂时没有提供该服务');"><span>提交</span></a>  		
					<br/>
				</form>	
				</div>
		</div>
		
		
	</body>
</html>
