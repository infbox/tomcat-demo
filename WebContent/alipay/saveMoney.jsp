<%@ page language="java" import="java.util.*,com.infbox.demo.*,com.infbox.sdk.*" pageEncoding="UTF-8"%>
<%
MyUser user=(MyUser)session.getAttribute("user");
String articleId=request.getParameter("articleId");
if(articleId==null) return ;
if( user==null){
	String bsUrl2="alipay/saveMoney.jsp?articleId="+articleId;
	System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	return;
}

%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>支付赏金</title>
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
        <script src="../mobile/c/js/jngh.js?v=8"></script>
        <script type="text/javascript" src="//lib.sinaapp.com/js/jquery/1.8.3/jquery.min.js"></script>
		
	<style type="text/css">
<!--
.small-hint {
	font-color: red;
	font-size:9px;
}
-->

.money span{
	width: 30%;
	display: inline-block;
	height: 48px;
	line-height:48px;
	font-size:18px;
	border: 1px rgb(200,94,75) solid;
	color:  rgb(200,94,75);
	margin-bottom: 2%;
	border-radius: 3px;
}


.span_onchick{
	background: rgb(200,94,75);
	color:  white !important;
}

</style>
<script type="text/javascript">
function doUserInfo() {	
	var a = $("#form1").serialize();
		
	$.post("/doUserInfo.jsp", a, function(b, c) {
		Alert(b);
		setTimeout(function(){
			window.location.href="index.jsp";               
		},500);
		//
	});
	
}
</script>
    </head>
    <body>           
             <div class="content"> 
             <form id="form1" name="form1" method="post" action="wappay/alipayapi.jsp">
             	<div class="input_code" style="padding-left:3px;padding-right:3px;text-align:left;margin-top:-15px;">
                    <br/>欢迎您为喜欢的文章打赏！作者将会看到全部的打赏读者列表。您将有机会得到作者的特别关注！</p>
                   </div> 
               <div class="input_code">
                    <p>请选择打赏金额：<span class="small-hint"></span></p>
                    <input type="hidden" name="amount" id="amount" value="20" >  
                    <input type="hidden" name="payType" id="payType"  value="1" >                     
                     <input type="hidden" name="articleId" id="articleId"  value="<%=articleId %>" >
                    <input type="hidden" name="userType" id="userType"  value="1" >   
                     <input type="hidden" name="userId" id="userId"  value="<%=user.getId() %>" >                    
                </div> 
                 <div class="input_code money">                    
                   	<span onclick="checkAmount(5,this)" >5元</span>
                   	<span onclick="checkAmount(20,this)" class="span_onchick">20元</span>
                   	<span onclick="checkAmount(50,this)">50元</span>
                   	<span onclick="checkAmount(80,this)">80元</span>
                   	<span onclick="checkAmount(100,this)">100元</span>
                	<span onclick="checkAmount(200,this)">200元</span>
                </div>    
                  <div class="input_code">   
                  	<div style="width:45%; float:left;text-align:right;">
                  	<input type="radio" id="alipay" name="payChannel" style="width:50px;line-height:50px; height:50px;"  onclick="setType('1');"  value="1" checked><label for="alipay"><img src="alipay.jpg" style="height:50px;display:inline;text-align:right;"/></label>
  						
                  	</div><div style="width:45%;float:right;text-align:left;margin-bottom:15px;">
                  	<input type="radio" id="wechat" name="payChannel" style="width:50px;" onclick="setType('2');"  value="2"><label for="wechat"><img src="wechat.jpg" style="height:50px;display:inline;text-align: left;"/></label> 
                  	</div>
  				  		               
                </div>  
                <div class="input_code">                    
                    <button type="button" class="btn btn-positive btn-block" onclick="goPay();" >付款</button>                	
                </div>    
                 <div class="input_code" id="pay_qr_code" style="display:none;"> 
                	<center><img  src="<%=InfBoxUtil.SITE_URL%>/qrcode?type=4&url=<%=InfBoxUtil.SITE_URL%>/alipay/wappay/alipayapi.jsp?articleId=<%=articleId%>&payType=1&amount=5&userId=<%=user.getId()%>" width="60%"/>
                		</center>
                		<p>您也可以用其他手机的支付宝扫上方二维码完成支付</p>
                		<p></p><p></p><p></p><p></p>
                </div> 
             </div>  
             </form>
             <script type="text/javascript">
             var payType=1;
             function isInteger(obj) {            	
            	 if(obj=='' || obj.indexOf(".")>-1)return false;
            	return  parseInt(obj)!=NaN;            	
            }
             function setType(tp1){payType=tp1;}
           	function checkAmount(amount,event){
           		$("#amount").val(amount);
           		$("#pay_qr_code img").attr("src","<%=InfBoxUtil.SITE_URL%>/qrcode?type=4&url=<%=InfBoxUtil.SITE_URL%>/alipay/wappay/alipayapi.jsp?articleId=<%=articleId%>&payType=1&amount="+amount+"&userId=<%=user.getId()%>");
           		
           		 $(event).addClass("span_onchick");          		
           		
           		$(event).siblings().removeClass("span_onchick")
           	
           	}
           	function goPay(){           		
           		if(payType==1 || payType=='1') {           		
           			gotoAlipay();
           			$("#pay_qr_code").show();
           		}else{           			
           			gotoWxPay();
           			$("#pay_qr_code").hide();
           		}
           	}
           	function gotoWxPay(){           		
           		var amt=$("#amount").val();
           	 if(isInteger(amt)){
           		$.post("./wappay/wxPayApi.jsp", {amount:amt,articleId:<%=articleId %>,userId:<%=user.getId()%>}, 
           				function (data, textStatus){ 	
           					window.location.href="wxPayDo.jsp?money="+amt+"&articleId=<%=articleId %>&tradeNo="+data.trade_no;
           		        });	
           		 
           	 }else{
           		 alert("请输入一个整数!");
           		 $("#amount").focus();
           		 return;
           	 }
           		
           	}
             
             function gotoAlipay(){
            	 var amt=$("#amount").val();
            	 if(isInteger(amt)){
            		 $("#form1").submit();
            	 }else{
            		 alert("请输入一个整数!");
            		 $("#amount").focus();
            		 return;
            	 }
             }
             </script>
    </body>
</html>