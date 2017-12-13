<%@ page language="java" import="java.util.*,com.infbox.demo.article.*,com.infbox.sdk.*,com.infbox.demo.*" pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.mongodb.BasicDBObject"%>
<%@ page import="java.io.*,org.bson.types.ObjectId"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<% 
MyUser user2=(MyUser)session.getAttribute("user");
String userId=request.getParameter("userid");

if(user2==null){
	String bsUrl2="mobile/c/ArticleListByUser.jsp?userid="+userId;
	System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?fd_url="+bsUrl2+"&needId=1");
	response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?fd_url="+bsUrl2+"&needId=1");
	return;	
}

MyUser owner=DemoUtil.getUserById(Integer.parseInt(userId));
 if(owner==null){	
	 out.print("user not exist");
	return;
}
 /*
int myUserId=Integer.parseInt(myId);
MyUser user2=DemoUtil.getUserById(myUserId);
if(user2.headPic==null || user2.headPic.length()<5)user2.headPic="img/icon02.png";
MiscUtil.debug("myId="+myUserId); */


%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		
		<link rel="stylesheet" href="css/headBar2.css" />
		<link rel="stylesheet" href="css/jinghList3.css?v=7" />
		<link rel="stylesheet" type="text/css" href="css/sweetalert.css">
		<link rel="stylesheet" href="../lbs/dist/dropload.css">
		<title></title>
		
	</head>
	<body>
		<div class="prev">
			<a onclick="javascript:window.history.back();"><img class="go_back" src="img/icon_back.png"/></a><i style="font-size:12px; verticle-align:middle;"><%=owner.getName() %>的文章</i>
			<span>
				<img class="leftimg" src="img/icon06.png"/>|
				<img class="rightimg" src="img/icon02.png"  />
			</span>
		</div>
		
		<div class="main-foot element" id="hotDiv">
			<ul id="news-container">
			</ul>
		</div>
		<div class="nodata"></div>
		
	
	</body>
	<script src="../lbs/dist/zepto.min.js"></script>
	<script src="../lbs/dist/dropload.min.js"></script>
	<script src="./js/sweetalert.min.js"></script>
	<script src="./js/ib_a_blank.js?v=1"></script>	
	<script src="./js/jngh.js?v=35"></script>
	<script type="text/javascript">
	//分页
	var pagecount = 1;
	var pagesize = 10;
	var total;
	
	$('.element')
	.dropload(
			{
				scrollArea : window,
				domUp : {
					domClass : 'dropload-up',
					domRefresh : '<div class="dropload-refresh">↓下拉刷新</div>',
					domUpdate : '<div class="dropload-update">↑列表更新!</div>',
					domLoad : '<div class="dropload-load"><span class="loading"></span>加载中...</div>'
				},
				domDown : {
					domClass : 'dropload-down',
					domRefresh : '<div class="dropload-refresh">↑上拉加载更多</div>',
					domLoad : '<div class="dropload-load"><span class="loading"></span>加载中...</div>',
					domNoData : '<div class="dropload-noData">暂无数据</div>'
				},
				loadUpFn : function(me) {
					pagecount = 1;
					$
					.ajax({
						url : '${ctx}/mobile/c/getArticlesByUser.jsp?pagecount='
							+ pagecount + '&userid=<%=userId%>',
						type : 'post',
						dataType : "json",
						success : function(data) {
							console.log(data);			
							$("#content").html(getHtml( data.data));
							
							// 每次数据加载完，必须重置
							me.resetload();
							me.unlock();
							me.noData(false);
							pagecount++;
						},
						error : function(e) {
							me.resetload();
						},
						complete : function(e) {
						}
					})
					
					
				},
				loadDownFn : function(me) {
					$.ajax({
						url : '${ctx}/mobile/c/getArticlesByUser.jsp?pagecount='
							+ pagecount + '&userid=<%=userId%>',
						type : 'post',
						dataType : "json",
						success : function(data) {
							console.log(data);
							total = data.total;
							
							$("#news-container").append(getHtml( data.list));
							if (total == 0 ||pagecount == total) {
								// 锁定
								me.lock();
								// 无数据
								me.noData();
							} else {
								pagecount++;
							}
							// 每次数据加载完，必须重置
							me.resetload();
							
						},
						error : function(e) {
							me.lock();
							me.noData();
							me.resetload();
						},
						complete : function(e) {
						}
					})
				}
			});
	
	function getHtml(list){
		var html='';
		for(var i = 0; i < list.length; i++){
			var item = list[i];			
			html+= "<a data-ignore=\"push\" href=\""+getUrl4_Blank("https://s2.infbox.cn/news/"+item.urlpath)+"\"  >";
			html += "  <li>";
			html += "	<img class=\"pic\" src=\""+item.bgImg+"\" />";
			html += "	<div>";
			html += "		<p class=\"about\">"+item.title+"</p>";
			html += "		<p class=\"grade\">";
			html += "			<img src=\"img/icon03.png\"/>"+item.account+"";
			html += "		</p>";
			html += "		<p class=\"lp\"><img src=\"img/read.png\"/>阅读("+item.readNum+")</p>";
			html += "		<p class=\"hp\"><img src=\"img/icon04.png\"/>评论("+item.commentNum+")</p>";
			html += "	</div>";
			html += "  </li>";
			html += "</a>";
		}
		return html;
	}
	
	function getOwer(liuyan){
		console.log(liuyan)
		if(liuyan.owner==liuyan.sender){
			return '发给<a class="comment_name" href="userInfo.jsp?id='+liuyan.receiver+'">'+liuyan.friendName+'</a>的留言';
		}else{
			return '来自<a class="comment_name" href="userInfo.jsp?id='+liuyan.receiver+'">'+liuyan.friendName+'</a>的留言';
		}
	}
	
	function getTime(time){
		var newDate = new Date();
		newDate.setTime(time);
		return newDate.toLocaleString();
	}	

	
	function del(id){
		swal({ 
		    title: "", 
		    text: "确定要删除这条数据？", 		  
		    showCancelButton: true, 
		    closeOnConfirm: true, 
		    confirmButtonText: "确定删除", 
		    cancelButtonText: "取消", 
		    confirmButtonColor: "#ec6c62" 
		}, function() { 
			$.ajax({
				url : '${ctx}/liuyan/del.action?id='
					+ id,
				type : 'post',
				dataType : "json",
				success : function(data) {				
					$("#ly_item_"+id).remove();
					sAlert('已删除');
				},
				error : function(e) {
					me.lock();
					me.noData();
					me.resetload();
				},
				complete : function(e) {
				}
			})
		});
		
	}
	var hhh=$(".prev").css("height");
	$("#comment").css("margin-top",hhh);
	
	</script>
	
</html>
