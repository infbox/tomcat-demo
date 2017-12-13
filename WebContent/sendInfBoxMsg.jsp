<%@ page language="java" import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%	

MyUser user =(MyUser) session.getAttribute("user");	
	if(user==null) {
		System.out.println("sendInfBoxMsg.jsp error:扫码登陆后才能使用");
		return;//已登录用户才能使用
	}
	
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	
	
	//发送提醒通知的demo,将来根据需要
	//请示标题
	String receiver=request.getParameter("receiverId");//消息接受者的openId
	if(receiver==null) receiver=user.getIBOpenId();//消息接受者的openId
	String title="恭喜您扫码登陆成功！";
	String content="您已经成功地将您的系统对接到抓信服务器后台！恭喜您！";

	//参考网址，用户点击参考链接后，跳转的url
	String actionURL="http://www.baidu.com"; 
	InfBoxUtil.sendIBAlert(receiver,title, content, actionURL,InfBoxUtil.USE_OPEN_ID,true);//
	
	
	
	//2,发送请示----------------------------
	
	//请示标题
	title="测试消息:周末是否加班？";
	content="请点击以下选项选择：";
	//请示反馈的url地址
	//String myWebSite="http://192.168.1.104:8081/demo1/";
	
	//首先把消息保存到本地数据库，供后续处理
	//生成一个随机的token,将来用户反馈的时候，需要凭借该token获得反馈权限
		String token=DemoUtil.randomString(15);//长度不要超过16
	int consultTypeId=13;//请示模板的编号
	//自己编写的处理请示结果的页面逻辑,不同的请示模板编号，对应不同的处理页面,
	actionURL=InfBoxUtil.SITE_URL+"/reConsult.jsp";
	long rowId=DemoUtil.addInfBoxConsult(title, content, consultTypeId, token);
	String msgId=rowId+"";//转成字符串
	InfBoxUtil.sendIBConsult(receiver,title,content,consultTypeId,msgId,actionURL,token,true);
	
	
	
	//3,发送任务----------------------------
	
	//任务标题
	title=request.getParameter("title");
	if(title==null)title="重要任务4";
	content="务必写清楚风险分析和财务预算";
			
	//首先把消息保存到本地数据库，供后续处理
	//生成一个随机的token,将来用户反馈的时候，需要凭借该token获得反馈权限
	token=DemoUtil.randomString(15);//长度不要超过16
	
	//自己编写的处理任务结果的页面逻辑,不同的请示模板编号，对应不同的处理页面,
	actionURL=InfBoxUtil.SITE_URL+"/replyTask.jsp";
	long begin=new Date().getTime();
	long deadLine=begin+24*2600*1000;
	
	String supervisor=user.getIBOpenId();
	//ff664bdf7d8c0d75d7f987fd84a37b3f 臭雷子 
	//28f805ce44965111a21b11d7f18f2827 小钧
	String executor=receiver;
	int level=0;//任务的重要等级
	rowId=DemoUtil.addInfBoxTask(title, content, begin, deadLine, supervisor, executor, level,token);
	String begins=DemoUtil.getDateStr(begin);
	String ends=DemoUtil.getDateStr(deadLine);
	InfBoxUtil.sendIBTask(executor,title,content,0,begins,ends,rowId+"",actionURL,supervisor,token);
		
	

%>
