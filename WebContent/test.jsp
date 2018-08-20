<%@ page language="java" contentType="text/plain; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*"%>

<%
/*手动生成测试用户的信息，不用扫码，就能用*/
	request.setCharacterEncoding("UTF-8");
	//首先要确保用户表tb_user里有一条id=1的用户记录
	MyUser user = DemoUtil.getUserById(1);	
	if(user==null){
		InfBoxUtil.log("test.jsp error line 11:数据库中没有id=1的用户");
		return;
	}
	if(user.headPic==null || user.headPic.isEmpty())user.headPic="http://img1.infbox.com/ibu_112_14783988831390.jpg";//头像
	session.setAttribute("user", user);
	response.sendRedirect("./alipay/saveMoney.jsp?articleId=1");//在此处设置你希望测试的页面
%>

