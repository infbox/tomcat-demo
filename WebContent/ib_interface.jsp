<%@ page language="java"
	import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*"
	pageEncoding="UTF-8"%>

<%
	/*
	 此处是第三方网站作为抓信服务号插件，跟手机端对接的逻辑代码。 
	 用户在手机端点击插件的时候，先通过调用这个页面获得用户的个人信息。

	 */
	
	session.removeAttribute("user");
	MyUser user =null;
	
	String sCode = request.getParameter("code");

	String code = request.getParameter("code");//我们要的code		
	System.out.println("code=" + code);
	if (code == null || code.startsWith("error_")) {
		String url4 = request.getScheme()+"://"+ request.getServerName()+request.getRequestURI()+"?"+request.getQueryString(); 
		System.out.println("url4="+url4);
		out.println("code=" + code);
		

	} else {		
		
		Map<String, Object> data = InfBoxUtil.getAccessTokenInfo(sCode);
		System.out.println("data=" + data.toString());
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
		//此处判断该用户信息是否已经存入数据库，如果没有，则作为新用户创建账号
		//Boolean b=LoginTool.weixinLogin(user);
		request.getSession().setAttribute("user", user);
		
		String fd=request.getParameter("fd");
		if(fd==null)
			response.sendRedirect(InfBoxUtil.SITE_URL+"/mobile/c/index.jsp");
		else{
			String a_id=request.getParameter("fd_id");
			System.out.println("fd="+fd+",fd_id="+a_id);
			response.sendRedirect(InfBoxUtil.SITE_URL+"/mobile/c/article.jsp?id="+a_id);
		}
		return;
	}
%>
