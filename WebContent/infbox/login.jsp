<%@ page language="java" import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*" pageEncoding="UTF-8"%> 
<% 	
	String path = request.getContextPath();
	int portI=request.getServerPort();	
	
	Boolean useSSL=false;		
	
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+portI+"/";
	
    Date dt=new Date();
    long now=dt.getTime();//当前的时间戳
    String uId=session.getId();//获得当前session的id  
   
    String siteURL=InfBoxUtil.SITE_URL;
    IBWSServer.debug("random login id="+uId+",siteURL="+siteURL);
    String acessScheme="http"; 
    if(useSSL)acessScheme="https";
    session.setAttribute("urlScheme", acessScheme);//将来其他页面需要判断ssl的时候使用
    
%> 
<!DOCTYPE html>
<html scroll="no">
<head>
<meta charset="utf-8" />
    <title>请使用抓信扫描二维码登陆</title>
    <link rel="stylesheet" href="css/layout.css" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
		<script type="text/javascript" src="//lib.sinaapp.com/js/jquery/1.9.1/jquery-1.9.1.min.js"></script>			
		<script type="text/javascript" src="js/infbox.js"></script>	
    <script type='text/javascript'>
		//infbox抓信设置点1
		setAppPath("<%=siteURL%>");
		ownerLogin('<%=uId %>');
    </script>
   
</head>
<body  scroll="no">	
		<div class="main" >		
				
			<div class="board" id="board2" style="display: block;width:350px;">				
				<%						
					String img=siteURL+"/qrcode?url="+InfBoxUtil.SITE_URL+"&id="+uId;
				%>
				<div class="login-right" style="height:30px;">		
					<center>欢迎访问抓信社群Demo</center>					 
										
				</div>
				
				<div class="login-right" >		
									 
					<img class="er" src="<%=img%>"/>					
				</div>
			</div>			
		</div>
</body>
</html>
