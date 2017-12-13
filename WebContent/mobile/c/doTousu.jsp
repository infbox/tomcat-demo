<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="sun.misc.*,com.infbox.sdk.*"%>
<%@ page import="java.util.*,com.infbox.demo.article.*,com.infbox.demo.*"%>
<%@ page import="java.io.*,org.bson.types.ObjectId"%>
<%@ page session="true" %> 
<%		


MyUser user = (MyUser) session.getAttribute("user");
if (user == null) {
	out.println("error");
	return;
}
		
		request.setCharacterEncoding("UTF-8");
			String artId = request.getParameter("artId");
			if(artId==null){
				out.println("error");
				return;
			}
			String category = request.getParameter("category");
			if (category == null) {
				category="6";
			};
			String categoryName="其他原因";
			if(category.equals("1"))categoryName="欺诈";		
			String advice = request.getParameter("advice");
			if (advice == null) {
				return;
			};
			int iartcId=Integer.parseInt(artId);
			Article article=JHArticleUtil.getArticle(iartcId);
			if(article==null){
				out.println("error");
				return;
			}
			//先发通知，让管理员查看一下这个被投诉的文章
			MyUser admin=DemoUtil.getAdminUser();
			if(admin==null){
				out.print("no_admin_found");
				return;
			}
			String receiver=admin.getIBOpenId();//消息接受者的openId			
	if(receiver==null) receiver=user.getIBOpenId();//消息接受者的openId
	String title="有人投诉了文章！";
	String content="被投诉文章："+article.title+"("+artId+"),投诉人："+user.getName()+",投诉类别："+categoryName+
			",备注信息:"+advice+",请点击下方链接查看该文章";
	//增加某个文章的投诉次数
	DemoUtil.addAdvice(category, user.getId()+"", advice, "");
	JHArticleUtil.incCount(iartcId, JHArticleUtil.TOUSU_COUNT);
	
	//参考网址，用户点击参考链接后，跳转的url
	String actionURL=InfBoxUtil.SITE_URL+"/mobile/c/article.jsp?id="+article.id+"&needId=1"; 
	InfBoxUtil.sendIBAlert(receiver,title, content, actionURL,InfBoxUtil.USE_OPEN_ID,true);//
	System.out.println(actionURL);
		
			//给管理员发送通知,有人投诉了某文章，是否要屏蔽该文章？ 选择是否，请示信息
					 title="有人投诉了文章";
					 content="被投诉文章："+article.title+"("+artId+"),投诉人："+user.getName()+",您是否要屏蔽这篇文章？";
		String token=DemoUtil.randomString(15);//长度不要超过16
	int consultTypeId=13;//请示模板的编号
	//自己编写的处理请示结果的页面逻辑,不同的请示模板编号，对应不同的处理页面,
	 actionURL=InfBoxUtil.SITE_URL+"/reConsult.jsp?cmd=article&param="+artId;
	long rowId=DemoUtil.addInfBoxConsult(title, content, consultTypeId, token);
	String msgId=rowId+"";//转成字符串
	
	InfBoxUtil.sendIBConsult(receiver,title,content,consultTypeId,msgId,actionURL,token,true);
	
	System.out.println(actionURL);
		
				out.print("ok");
			
				return;
			
	%>