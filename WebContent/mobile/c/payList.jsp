<%@ page language="java" import="java.util.*,com.infbox.demo.article.*,com.infbox.sdk.*,com.infbox.demo.*" pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.mongodb.BasicDBObject"%>
<%@ page import="java.io.*,org.bson.types.ObjectId"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
MyUser user=(MyUser)session.getAttribute("user");
if(user==null){		
	String bsUrl2="mobile/c/payList.jsp";
	System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	return;
}



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
		<title></title>
		
	</head>
	<body>
		<div class="prev">
			<a onclick="javascript:window.history.back();"><img class="go_back" src="img/icon_back.png"/></a>打赏记录
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
	<script src="./js/ib_a_blank.js?v=1"></script>	
	<script type="text/javascript">
	//分页
	var myUserId=<%=user.getId()%>
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
						url : '${ctx}/friendpaydetail/list.action?pagecount='
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
						url : '${ctx}/friendpaydetail/list.action?pagecount='
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
			var pay = list[i];
			if(pay.payType==2)pay.amount=parseInt(pay.amount)/100.0;
			var state="<a href=\""+getUrl4_Blank("<%=InfBoxUtil.SITE_URL%>/mobile/c/article.jsp?id="+pay.articleid)+"\" >相关文章</a>";
			if(pay.status<2)state='<a href="javascript:void(0);" onclick="refreshPayState('+pay.id+')" >服务器还没收到到账确认，点此刷新</a>';
			html+='<li id="ly_item_'+pay.id+'" usdata="20035"><div class="pd5"><a class="avt fl" target="_blank" href="#"><img src="img/pic02.png" /></a>';
			html+='<div class="comment_content"><h5>';
			html+='<div class="fl">'+getOwer(pay)+'<span>'+getTime(pay.createTime)+'</span></div>';
			html+='<div class="comment_p"><div class="comment_pct"></div></div></div>';
			html+='<div class="clear"></div><div class="comment_reply">'+state+'</div></div></li>';
			//html+='';
			//html+='';
			//html+='';
		}
		return html;
	}
	
	function getOwer(liuyan){
		console.log(liuyan)
		if(myUserId==liuyan.userid){
			return  '<a class="comment_name" href="userInfo.jsp?id='+liuyan.recv_id+'">'+'您打赏了'+liuyan.amount+'元'+'</a> ';
		}else{
			return '<a class="comment_name" href="userInfo.jsp?id='+liuyan.userid+'">'+'您收到'+liuyan.amount+'元打赏'+'</a> ';
			
		}
	}
	
	function getTime(ptime){
		if(ptime==null || ptime=="null" ) return "";
		var newDate = new Date();
		newDate.setTime(ptime.time);
		return newDate.toLocaleString();
	}	
	
	function refreshPayState(id){
		$.ajax({
			url : '${ctx}/mobile/c/refreshPay.jsp?id='
				+ id,
			type : 'post',
			dataType : "html",
			success : function(data) {
				var dd=$.trim(data);
				if(dd.indexOf('not_')>-1){
					sAlert('服务器没有确认到账，若1个小时后仍不到账，请联系管理员');
				}
				else if (dd=="confirmed"){
					$("#ly_item_"+id +" comment_reply").html('已确认支付');
					sAlert('已确认支付');
				}
				
			},
			error : function(e) {
				
			},
			complete : function(e) {
			}
		})
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
