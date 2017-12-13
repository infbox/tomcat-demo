<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="com.infbox.demo.article.*"%>
<%@ page import="com.infbox.demo.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String userId=request.getParameter("userId");
long uId=0;
if(userId!=null){
	uId=Integer.parseInt(userId);	
}else {
	MyUser user=(MyUser)session.getAttribute("user");
	if(user!=null)uId=user.getId();
}

if(uId<1){
	out.println("user null");
	return;
}


%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    	<title>收藏列表</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<link rel="stylesheet" href="css/list1.css" />
		<link rel="stylesheet" href="../lbs/dist/dropload.css">
		<script src="../lbs/dist/zepto.min.js"></script>
		<script src="../lbs/dist/dropload.min.js"></script>
		<script src="./js/jngh.js?v=12"></script>
	</head>
	<body>
		<div class="prev">
			<a onclick="javascript:window.history.back();"><</a>收藏列表
			<span>
				<img class="leftimg" src="img/icon06.png"/>|
				<img class="rightimg" src="img/icon02.png"  />
			</span>
		</div>
		<div class="main-foot element">
			<ul id="content">
			</ul>
		</div>
	</body>
	
	<script type="text/javascript">
	//分页
	var pagecount = 1;
	var pagesize = 5;
	var total;
	
	var url = "${ctx}/collect/list.action?userId=<%=uId%>";
	
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
					pagesize = 5;
					$
					.ajax({
						url : url+'&pagecount='
							+ pagecount + '&pagesize='
							+ pagesize,
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
						url : url+'&pagecount='
							+ pagecount + '&pagesize='
							+ pagesize,
						type : 'post',
						dataType : "json",
						success : function(data) {
							console.log(data);
							total = data.page.total;
							
							$("#content").append(getHtml( data.data));
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
			var elm = list[i];
			var newDate = new Date();
			newDate.setTime(elm.collectTime.time);
			//alert(newDate.toLocaleDateString());
			if(elm.urlpath!='' && elm.urlpath!='null' && elm.urlpath!=null)html+='<a href="../../'+elm.urlpath+'"><li>';
			else html+='<a href="./article.jsp?id='+elm.articleId+'"><li>';
			html+='<img class="pic" src="'+elm.bgimg+'-thum"/>';
			
			html+='<div>';
			html+='<p class="about">'+elm.title+'</p>';
			html+='<p class="grade">';
			html+='<img src="img/icon03.png"/>';
			html+=elm.author+'</p>';
			html+='<p class="lp"><img src="img/icon05.png"/>收藏于'+elm.author+'('+newDate.toLocaleDateString()+')</p>';
			html+='</div>';
			html+='';
			
			html+='</li></a>';
		}
		return html;
		
	}
	
	
	var topbarH=$(".prev").css("height");
	$(".element").css("margin-top",topbarH);
	
	</script>
</html>

