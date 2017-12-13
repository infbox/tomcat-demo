<%@ page language="java" import="java.util.*,com.infbox.demo.article.*,com.infbox.sdk.*,com.infbox.demo.*" pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.mongodb.BasicDBObject"%>
<%@ page import="java.io.*,org.bson.types.ObjectId"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<% 
String myId=request.getParameter("userid");
/* if(myId==null){	
	return;
}
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
		<link rel="stylesheet" href="../lbs/css/list2.css" />
		<link rel="stylesheet" href="css/headBar2.css" />
		<link rel="stylesheet" href="css/commentList.css" />
		<link rel="stylesheet" type="text/css" href="css/sweetalert.css">
		<link rel="stylesheet" href="../lbs/dist/dropload.css">
		<title>留言记录</title>
		
	</head>
	<body>
		<div class="prev">
			<a onclick="javascript:window.history.back();"><img class="go_back" src="img/icon_back.png"/></a>留言记录
			<span>
				<img class="leftimg" src="img/icon06.png"/>|
				<img class="rightimg" src="img/icon02.png"  />
			</span>
		</div>
		
		<div id="comment" class="element">
			<ul id="content">
			
			</ul>
		</div>
		
	
	</body>
	<script src="../lbs/dist/zepto.min.js"></script>
	<script src="../lbs/dist/dropload.min.js"></script>
	<script src="./js/sweetalert.min.js"></script>
	<script src="./js/jngh.js?v=25"></script>
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
						url : '${ctx}/liuyan/list.action?pagecount='
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
						url : '${ctx}/liuyan/list.action?pagecount='
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
			var liuyan = list[i];
			html+='<li id="ly_item_'+liuyan.id+'" usdata="20035"><div class="pd5"><a class="avt fl" target="_blank" href="#"><img src="img/pic02.png" /></a>';
			html+='<div class="comment_content"><h5>';
			html+='<div class="fl">'+getOwer(liuyan)+'<span>'+getTime(liuyan.sendTime.time)+'</span></div>';
			html+='<div class="fr reply_this"><a href="javascript:del(\''+liuyan.id+'\');">[删除]</a></div><div class="clear"></div></h5>';
			html+='<div class="comment_p"><div class="comment_pct">'+liuyan.content+'</div></div></div>';
			html+='<div class="clear"></div><div class="comment_reply"></div></div></li>';
			//html+='';
			//html+='';
			//html+='';
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
