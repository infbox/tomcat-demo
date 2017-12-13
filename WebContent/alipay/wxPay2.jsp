<%@ page language="java" import="java.util.*,com.infbox.demo.*,com.infbox.sdk.*" pageEncoding="UTF-8"%>
<%

MyUser user=(MyUser)session.getAttribute("user");
String articleId=request.getParameter("articleId");
String money=request.getParameter("money");
if(articleId==null || user==null){
	out.print("错误：参数不对");
	return;
}

%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>正在发起微信支付...</title>
        <!-- Sets initial viewport load and disables zooming  -->
        <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui">
        <meta name="apple-mobile-web-app-capable" content="yes"> 
        <meta name="apple-mobile-web-app-status-bar-style" content="black"> 
         
        <link rel="stylesheet" href="usercenter/css/ratchet.min.css">
        <link rel="stylesheet" href="usercenter/css/ratchet-theme-ios.min.css">
        <link rel="stylesheet" href="usercenter/css/app.css">
      	<link rel="stylesheet" type="text/css" href="../mobile/c/css/sweetalert.css">
        <link href="usercenter/css/jizhehome_android.css" rel="stylesheet">
        <script src="usercenter/js/ratchet.min.js"></script>
        <script src="../mobile/c/js/sweetalert.min.js"></script>
       
        <script type="text/javascript" src="https://lib.sinaapp.com/js/jquery/1.8.3/jquery.min.js"></script>
	

    </head>
    <body>           
             <div class="content"> 
             <form id="form1" name="form1" method="post" action="wappay/alipayapi.jsp">
             	<div class="input_code" style="padding-left:3px;padding-right:3px;text-align:left;margin-top:-15px;">
                    <p>正在发起微信支付...</p>
                   </div> 
             
                  
                <div class="input_code">                    
                    <button type="button" class="btn btn-positive btn-block" onclick="goPay();" >已经完成付款</button>                	
                </div>    
                
             </div>  
             </form>
             <script type="text/javascript">            
           
           
           			$.post("./wappay/wxPayApi.jsp", {amount:<%=money%>,articleId:<%=articleId %>,userId:<%=user.getId()%>}, 
           				function (data, textStatus){ 
           					alert('wxPayApi.jsp:'+data.trade_no);
           					var ss=data.trade_no;	           					
           					var vs=infbox.wx_pay("{\"siteid\":<%=InfBoxUtil.siteId%>,\"tradeid\":\""+ss+"\"}");
           					alert('wx_pay return:'+vs);
           					
           		        });	          		 
           	 	      		
           
             
            
             </script>
    </body>
</html>