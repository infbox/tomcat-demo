<%@ page language="java" import="java.util.*,com.infbox.sdk.*,com.infbox.demo.*,com.infbox.demo.article.*" pageEncoding="UTF-8"%>
<%	

	MyUser user =(MyUser) session.getAttribute("user");
	
	if(user==null) { 
		System.out.println("error:扫码登陆后才能使用");
		return;//已登录用户才能使用
	}
	

	
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	
	String postId=request.getParameter("post_id");
	String content=request.getParameter("content");
	int intArticleId=Integer.parseInt(postId);
	long id=DemoUtil.addComment(user.getId(), content, intArticleId); 
	JHArticleUtil.incCount(intArticleId, JHArticleUtil.COMMENT_COUNT);
	//给该帖子的关注者发送通知
	Article article=JHArticleUtil.getArticle(Integer.parseInt(postId));
	
	String title="您关注的帖子有了新的回复";
	String msg="您在抓信社区关注的帖子："+article.title+",有了新的回复："+content+",您可以点击以下链接查看详情。";
	String referURL=InfBoxUtil.SITE_URL+"/mobile/c/article.jsp?id="+postId+"&needId=1&siteid="+InfBoxUtil.siteId;//实际业务中此处可以填写该帖子的url地址
	
	ArrayList<Follow>  list=DemoUtil.getFollows(postId, "tiezi");//param=tiezi代表帖子的关注
	for(int i=0;i<list.size();i++){
		Follow follow=list.get(i);
		//给每一个订关注者发送通知
		//把最后一个参数是告诉抓信服务器，不知道接收者的openid，只知道抓信服务器保存的关注记录编号
		InfBoxUtil.sendIBAlert(follow.fwId, title, msg, referURL,InfBoxUtil.USE_FOLLOW_ID); 		
	}
	System.out.println("别忘记给关注者发通知");
	out.print(id);
	
	

%>
