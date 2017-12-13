<%@ page language="java" contentType="text/plain; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*"%>
<%@ page import="java.io.*,java.nio.CharBuffer"%>

<%
	request.setCharacterEncoding("UTF-8");
	String uid = request.getParameter("stat");
	MyUser user = null;

	String code = request.getParameter("code");//我们要的code		
	if (code == null || code.startsWith("error_")) {
		out.print(code);//如果出错，要把错误的code返回给InfBox
		return; 
	}
	
	String appid=request.getParameter("appid");//
		
	
	IBWSServer.debug("uid=" + uid+",code="+code);	
	Map<String, Object> data = InfBoxUtil.getAccessTokenInfo(code);

	if (data == null) {
		System.out
				.println("error:can not get user info from infbox code:"
						+ code);
		return;
	}
	IBWSServer.debug("InfBoxUtil.getAccessTokenInfo，return:"
			+ data.toString());
	Object obj = data.get("access_token");
	if (obj == null) {
		System.out.println("can not get access_token");
		return;
	}
	String accessToken = data.get("access_token").toString();
	if (InfBoxUtil.ac == null)
		InfBoxUtil.ac = new AccessToken();
	InfBoxUtil.ac.token = accessToken;
	obj = data.get("openid");
	if (obj == null)
		return;
	String OpenId = data.get("openid").toString();
	//先看看用户是否存在，如果不存在，则再从服务器读取头像信息
	user = DemoUtil.getUserByInfBoxId(OpenId);
	if (user == null) {
		data = InfBoxUtil.getUserInfo(OpenId, accessToken);
		user = new MyUser();
		String nickName = data.get("nickname").toString();
		String headImg = data.get("headImg").toString();
		user.setIBOpenId(OpenId);
		user.setName(nickName);
		user.setHeadPic(headImg);
		//既然本地数据库没有，就是新用户，先添加到本地数据库
		long id=DemoUtil.addUser(nickName, OpenId, headImg);
		user.setId(id);
	}

	//此处判断该用户信息是否已经存入数据库，如果没有，则作为新用户创建账号
	//
	//找到用户，保存起来
	//IBWSServer.loggedCache.put(uid, user);
	DemoUtil.addUserCache(uid, user);
	IBWSServer.debug("用户登陆通过，user=" + user.getName());
	com.mongodb.BasicDBObject result = new com.mongodb.BasicDBObject();

	result.put("cmd", "login");
	result.put("result", "ok");
	//此处改为您自定义的主页
	result.put("url", "../main.jsp?uid=" + uid);
	IBWSServer.sendMessageToMember(result.toString(), uid);	
	out.print("ok");
	if(user!=null)return;
%>

