<%@ page language="java" import="java.util.*,com.infbox.demo.article.*,com.infbox.demo.*,com.infbox.sdk.*" pageEncoding="UTF-8"%>

<%
/* *
 * 功能：微信支付确认页面
 * 
 */
%>
<%

MyUser user=(MyUser)session.getAttribute("user");
if(user==null){out.print("错误：user null");
return;
}
String articleId=request.getParameter("articleId");
String money=request.getParameter("money");
String tradeNo=request.getParameter("tradeNo");

if(articleId==null || user==null || money==null){
	out.print("错误：参数不对");
	return;
}
Article ar=JHArticleUtil.getArticle(Integer.parseInt(articleId));
float money_f=Float.parseFloat(money);
money_f=money_f*100;//元->分
%>
<!DOCTYPE html>
<html>
	<head>
	<title>确认支付</title>	
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<script type="text/javascript" src="https://lib.sinaapp.com/js/jquery/1.8.3/jquery.min.js"></script>	
	<script src="<%=InfBoxUtil.SITE_URL%>/js/sweetalert2.min.js"></script>
	<link rel="stylesheet" href="<%=InfBoxUtil.SITE_URL%>/css/sweetalert2.min.css">	
	<script src="../mobile/c/js/jngh.js?v=40"></script>		
<style>
    *{
        margin:0;
        padding:0;
    }
    ul,ol{
        list-style:none;
    }
    body{
        font-family: "Helvetica Neue",Helvetica,Arial,"Lucida Grande",sans-serif;
    }
    .hidden{
        display:none;
    }
    .new-btn-login-sp{
        padding: 1px;
        display: inline-block;
        width: 75%;
    }
    .new-btn-login {
        background-color: #02aaf1;
        color: #FFFFFF;
        font-weight: bold;
        border: none;
        width: 100%;
        height: 50px;
        border-radius: 5px;
        font-size: 20px;
    }
    #main{
        width:100%;
        margin:0 auto;
        font-size:14px;
    }
    .red-star{
        color:#f00;
        width:10px;
        display:inline-block;
    }
    .null-star{
        color:#fff;
    }
    .content{
        margin-top:5px;
    }
    .content dt{
        width:100px;
        display:inline-block;
        float: left;
        margin-left: 20px;
        color: #666;
        font-size: 13px;
        margin-top: 8px;
    }
    .content dd{
        margin-left:120px;
        margin-bottom:5px;
    }
    .content dd input {
        width: 85%;
        height: 28px;
        border: 0;
        -webkit-border-radius: 0;
        -webkit-appearance: none;
    }
    #foot{
        margin-top:10px;
        position: absolute;
        bottom: 15px;
        width: 100%;
    }
    .foot-ul{
        width: 100%;
    }
    .foot-ul li {
        width: 100%;
        text-align:center;
        color: #666;
    }
    .note-help {
        color: #999999;
        font-size: 12px;
        line-height: 130%;
        margin-top: 5px;
        width: 100%;
        display: block;
    }
    #btn-dd{
        margin: 20px;
        text-align: center;
    }
    .foot-ul{
        width: 100%;
    }
    .one_line{
        display: block;
        height: 1px;
        border: 0;
        border-top: 1px solid #eeeeee;
        width: 100%;
        margin-left: 20px;
    }
     .am-header2 {      
        width: 100%;
        color: #fff;
        background: #fff;
        height: 50px;
        text-align: center;      
    }
    .am-header {
        display: -webkit-box;
        display: -ms-flexbox;
        display: block;
        width: 100%;
        position: relative;
        padding: 7px 0;
        -webkit-box-sizing: border-box;
        -ms-box-sizing: border-box;
        box-sizing: border-box;
        background: #1D222D;
        height: 50px;
        text-align: center;
        -webkit-box-pack: center;
        -ms-flex-pack: center;
        box-pack: center;
        -webkit-box-align: center;
        -ms-flex-align: center;
        box-align: center;
    }
    .am-header h1 {
        -webkit-box-flex: 1;
        -ms-flex: 1;
        box-flex: 1;
        line-height: 18px;
        text-align: center;
        font-size: 18px;
        font-weight: 300;
        color: #fff;
    }
</style>
</head>
<body text=#000000 bgColor="#ffffff" leftMargin=0 topMargin=4>
<header class="am-header2">
        <h1>支付确认</h1>
</header>
<div id="main">
        
            <div id="body" style="clear:left">
                <dl class="content">                    
                    <hr class="one_line">
                    <dt>订单名称：</dt>
                    <dd>
                        		文章打赏
                    </dd>
                    <hr class="one_line">
                    <dt>付款金额：</dt>
                    <dd>
                        	<%=money%>元
                    </dd>
                    <hr class="one_line"/>
                    <dt>被赏文章：</dt>
                    <dd>
                       <%=ar.title %>
                    </dd>
                    <hr class="one_line">
                    <dt></dt>
                    
                    
                </dl>
                <dl class="content" style="margin:0 auto;">
                <dd id="btn-dd" style="margin-top:10px;">
                  		<span class="new-btn-login">
                            <button id="checkBtn1" onclick="checkPay()" class="new-btn-login"  style="text-align:center;display:none;">已经完成支付</button>
                        </span>
                        <span class="note-help"></span>
                        <span class="note-help"></span>
                        <span class="new-btn-login">
                            <button id="payBtn2"  onclick="pay()" class="new-btn-login"  style="text-align:center;">确 认支付</button>
                        </span>
                        <span class="note-help">请确保您的手机已经安装微信</span>
                    </dd></dl>
                    
                  
            </div>
		
        <div id="foot">
			<ul class="foot-ul">
				<li>
					
				</li>
			</ul>
		</div>
	</div>
</body>
<script language="javascript">
	function pay(){
		var vs=infbox.wx_pay("{\"siteid\":<%=InfBoxUtil.siteId%>,\"tradeid\":\"<%=tradeNo%>\"}");			
		$("#payBtn2 ").html("即将启动微信..."); 
		setTimeout("$('#checkBtn1').show();",5000);
		setTimeout("$('#payBtn2').html('重新支付');",3000)
	}
	function checkPay(){
		infbox.goBack();
		 $.post("./wappay/renewJHState.jsp", {tradeNo:'<%=tradeNo%>'}, 
    				function (data, textStatus){ 		    		 
			 			if(data.indexOf("ok")>-1)sAlert("支付确认成功！请返回！");
			 			else if(data.indexOf("not_payed")>-1)sAlert("服务器未收到支付确认，请重新支付！");
			 			else sAlert("服务器无法确认支付");
    		        });			
			 
	}
	/*防止支付服务器没有回调通知，自己主动查询支付状态*/	
	window.onbeforeunload = function(event) { 
		$.post("./wappay/renewJHState.jsp", {tradeNo:'<%=tradeNo%>'}, 
 				function (data, textStatus){ });
	}
	
</script>
</html>