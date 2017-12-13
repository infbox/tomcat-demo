<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*" 
	pageEncoding="UTF-8"%>
<%
String jump="infbox/login.jsp";
MyUser user =(MyUser) session.getAttribute("user");
String uid="";
if(user==null) {	
	
	uid=request.getParameter("uid");	
	if(uid==null){
		response.sendRedirect(jump);
		return;
	}
	user =new MyUser();
	Object obj=DemoUtil.getUserCache(uid)	; 
	if(obj==null){
		response.sendRedirect("jump");
		return;
	}else{
		user=(MyUser)obj;
		//用户信息保存到session里
		session.setAttribute("user", user);
		DemoUtil.delUserCache(uid);
		//删除登陆二维码的图片
		//
		//发送提醒通知的demo，恭喜您登陆成功！
		//InfBoxUtil.sendIBAlert(user.getIBOpenId(), "恭喜您扫码登陆成功！", "您已经成功地将您的系统对接到抓信服务器后台！恭喜您！", "http://www.baidu.com");
		//InfBoxUtil.main 函数里 还有发送任务和请示的示例代码，具体请参考
	} 
}


%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>抓信集成教程Demo</title>
	</head>
	<body>
	<center>
	欢迎访问
		<br/>
		<a href="<%=jump%>">点击此处登录</a>
	</center>	
		
		<!--conts end-->
	</body>
	<script type="text/javascript">
		
	</script>
</html>
