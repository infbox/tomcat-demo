<%@ page language="java"
	import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*"
	pageEncoding="UTF-8"%>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1" />
	</head>
	<body>
<%
/*
假如用户在打开插件的时候关闭了手机屏幕，等一两个小时后才重新打开手机，继续浏览抓信插件里的信息
此时，用户在插件服务器上的session已经失效。而此时手机端点击页面后，后台就无法获取的用户信息了
此时，需要再重要页面判断一下，如果session没包含用户信息，应该自动跳转，让用户重新验证身份

*/

	MyUser user = null;//(MyUser) session.getAttribute("user");	

	String sCode = request.getParameter("code");//我们要的code		
	System.out.println("code=" + sCode);
	
	String appid=request.getParameter("appid");
	
	
	if (sCode == null || sCode.startsWith("error_")) {
		String url4 = request.getScheme()+"://"+ request.getServerName()+request.getRequestURI()+"?"+request.getQueryString(); 
		System.out.println("url4="+url4);
		System.out.println("验证用户信息出错:code=" + sCode);
		out.print("<br/><center>请在抓信中打开，<br/>或者到主流应用商店下载抓信。</center>");
		response.sendRedirect("http://a.app.qq.com/o/simple.jsp?pkgname=com.infbox.app");
		return;
		

	} else {
		
		Map<String, Object> data = InfBoxUtil.getAccessTokenInfo(sCode);
		//System.out.println("data=" + data.toString());
		//这儿的data只是access_token, openid，还没有nickname
		if (InfBoxUtil.ac == null)
			InfBoxUtil.ac = new AccessToken();
		//String accessToken=null;
		String OpenId = null;
		if(data.get("access_token")!=null){
			InfBoxUtil.ac.token = data.get("access_token").toString();
			}
		if(data.get("openid")!=null){
			OpenId = data.get("openid").toString();			
			
		}	else {
			//openid=null说明用户的token不对，提醒用户重新登录抓信
			out.println("用户身份失效，请重新登录抓信客户端！");
			return;
		}

		user = DemoUtil.getUserByInfBoxId(OpenId);

		if (user == null) {
			data = InfBoxUtil.getUserInfo(OpenId, InfBoxUtil.ac.token);
			user = new MyUser();
			String nickName = data.get("nickname").toString();
			String headImg = data.get("headImg").toString();
			user.setIBOpenId(OpenId);
			user.setName(nickName);
			user.setHeadPic(headImg);
			//既然本地数据库没有，就是新用户，先添加到本地数据库
			long id=DemoUtil.addUser(nickName, OpenId, headImg);
			user.setId(id);
		}//end of user==null
		System.out.println("user=" + user.getName());		
		request.getSession().setAttribute("user", user);	
		String fd_url=request.getParameter("fd_url");
		if(fd_url==null)
			response.sendRedirect("index.jsp");
		else{			
			String bsUrl=fd_url;
			System.out.println("checkUrser.jsp:fd_url="+bsUrl);
			response.sendRedirect(InfBoxUtil.SITE_URL+"/"+bsUrl);
		}
		
	}
%>
</body></html>