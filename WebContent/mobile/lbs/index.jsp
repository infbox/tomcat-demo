<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.infbox.demo.article.*"%>	
<%@ page import="com.infbox.demo.*,com.infbox.sdk.*"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

	
<%
/*
要在html的<head>标签里引用百度地图库，注意src后的地址以//开头，而不是http://开头
<script type="text/javascript" src="//api.map.baidu.com/api?v=2.0&ak=oIafOTIGFmxQeSf9FUDQ0aoGqiWVVf36"></script>

*/
request.setCharacterEncoding("UTF-8");

MyUser user=(MyUser) session.getAttribute("user");


if(user==null){	
	String bsUrl2="mobile/lbs/index.jsp";
	System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	response.sendRedirect(InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+InfBoxUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	
	return;
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<title>附近的人</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="css/list2.css" />
<link rel="stylesheet" href="dist/dropload.css">
<script type="text/javascript" src="//api.map.baidu.com/api?v=2.0&ak=oIafOTIGFmxQeSf9FUDQ0aoGqiWVVf36"></script>
<script src="../c/js/ib_a_blank.js?v=3"></script>	
<script src="../c/js/jngh.js?v=38"></script>	
<style type="text/css">
.show {
	display: block;
}

.hide {
	display: none !important;
}

#find button {
	color: #fff;
    background-color: #286090;
    border-color: #204d74;
	display: inline-block;
	padding: 6px 12px;
	margin-bottom: 0;
	font-size: 14px;
	font-weight: 400;
	line-height: 1.42857143;
	text-align: center;
	white-space: nowrap;
	vertical-align: middle;
	-ms-touch-action: manipulation;
	touch-action: manipulation;
	cursor: pointer;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
	background-image: none;
	border: 1px solid transparent;
	border-radius: 4px;
	margin: 0px auto;
}
</style>
</head>
<body>	
	
	<div class="main-foot inner element" style="margin-top:5px;">
		
		<ul id="userData">	
		</ul>
	</div>
	<div id="find" style="width:100%;">
		<center>
			<button  onclick="libs()">点击开始查找</button>
		</center>
	</div>
	
	<div class="hide" id="sel" style="width:100%;">
		<center>
			<img  src="img/sel.gif" style="width:150px;height:150px;">
		</center>
	</div>
</body>


<script src="dist/zepto.min.js"></script>
<script src="dist/dropload.min.js"></script>
<script type="text/javascript">
	var lat;
	var lng;
	var city;
	var raidus = 980;
	//分页
	var pagecount = 1;
	var pagesize = 5;
	var total;
	
	function libs(){		
		show();		
		var geolocation = new BMap.Geolocation();		
		geolocation.getCurrentPosition(function(r) {			
			if (this.getStatus() == BMAP_STATUS_SUCCESS) {	
				lng = r.point.lng;
				lat = r.point.lat;
				city = r.address.city;				
				getHtml();
				firstView = 2;
			} else {
				alert('failed' + this.getStatus());
			}
		}, {
			enableHighAccuracy : true
		})
	}
	

	function getHtml() {
		show();		
		$('.element')
				.dropload(
						{
							scrollArea : window,
							domUp : {
								domClass : 'dropload-up',
								domRefresh : '<div class="dropload-refresh">↓下拉刷新</div>',
								domUpdate : '<div class="dropload-update">↑列表更新!</div>',
								domLoad : '<div class="dropload-load "><span class="loading"></span>加载中...</div>'
							},
							domDown : {
								domClass : 'dropload-down',
								domRefresh : '<div class="dropload-refresh">↑上拉加载更多</div>',
								domLoad : '<div class="dropload-load "><span class="loading"></span>加载中...</div>',
								domNoData : '<div class="dropload-noData">暂无数据</div>'
							},
							loadUpFn : function(me) {
								pagecount = 1;
								pagesize = 5;
								$
										.ajax({
											url : '${ctx}/near.action?raidus='
													+ raidus + '&lng=' + lng
													+ '&lat=' + lat + '&city='
													+ city + '&pagecount='
													+ pagecount + '&pagesize='
													+ pagesize,
											type : 'post',
											dataType : "json",
											success : function(data) {
												alert('hahha');
												var users = data.data;
												total = data.page.total;
												console.log(data)
												var html = '';
												for (var i = 0; i < users.length; i++) {
													var user = users[i];
													if (user.headPic == null
															|| user.headPic.length < 6)
														user.headPic = "img/pic02.png";

													html += '<li>';
													html += '<img class="pic" src="'+user.headPic+'"/>';
													html += '<div>';
													html += '<span class="left">';
													html += '<h2>' + user.name
															+ '</h2>';
													html += '<p class="about">'+user.memo+'</p>';
													html += '<p class="grade">';
													html += '<img src="img/icon07.png"/>';
													html += '<img src="img/icon07.png"/>';
													html += '<img src="img/icon08.png"/>';
													html += '<img src="img/icon09.png"/>';
													html += '<img src="img/icon09.png"/>';
													html += '</p>';
													html += '</span>';
													html += '<a href="'+getUrl4_Blank('<%=InfBoxUtil.SITE_URL%>/mobile/c/userInfo.jsp?id='
															+ user.id)
															+ '" >查看资料</a>';

													html += '<p class="dq"><img src="img/icon12.png"/>'
															+ user.city

															+ getDis(user.distance)
															+ '</p>';
													html += '<p class="sj"><img src="img/icon10.png"/>粉丝<span>（'+user.fansCount+'）</span></p>';
													html += '<p class="hy"><img src="img/icon11.png"/>关注<span>（'+user.idolCount+'）</span></p>';
													html += '</div>';
													html += '</li>';
												}
												$("#userData").html(html);

												// 每次数据加载完，必须重置
												me.resetload();
												me.unlock();
												me.noData(false);
												pagecount++;

											},
											error : function(e) {
												console.log(e);
												me.resetload();

											},
											complete : function(e) {

											}
										})
							},
							loadDownFn : function(me) {
								$
										.ajax({
											url : '${ctx}/near.action?raidus='
													+ raidus + '&lng=' + lng
													+ '&lat=' + lat + '&city='
													+ city + '&pagecount='
													+ pagecount + '&pagesize='
													+ pagesize,
											type : 'post',
											dataType : "json",
											success : function(data) {
												var users = data.data;
												console.log(data.page);

												total = data.page.total;

												var html = '';
												for (var i = 0; i < users.length; i++) {
													var user = users[i];
													if (user.headPic == null
															|| user.headPic.length < 6)
														user.headPic = "img/pic02.png";

													html += '<li>';
													html += '<img class="pic" src="'+user.headPic+'"/>';
													html += '<div>';
													html += '<span class="left">';
													html += '<h2>' + user.name
															+ '</h2>';
													html += '<p class="about">'+user.memo+'</p>';
													html += '<p class="grade">';
													html += '<img src="img/icon07.png"/>';
													html += '<img src="img/icon07.png"/>';
													html += '<img src="img/icon08.png"/>';
													html += '<img src="img/icon09.png"/>';
													html += '<img src="img/icon09.png"/>';
													html += '</p>';
													html += '</span>';
													html += '<a href="'+getUrl4_Blank('<%=InfBoxUtil.SITE_URL%>/mobile/c/userInfo.jsp?id='
															+ user.id)
															+ '" >查看资料</a>';

													html += '<p class="dq"><img src="img/icon12.png"/>'
															+ user.city
															+ getDis(user.distance)
															+ '</p>';
													html += '<p class="sj"><img src="img/icon10.png"/>粉丝<span>（'+user.fansCount+'）</span></p>';
													html += '<p class="hy"><img src="img/icon11.png"/>关注<span>（'+user.idolCount+'）</span></p>';
													html += '</div>';
													html += '</li>';
												}
												if (total == 0
														|| pagecount == total) {
													// 锁定
													me.lock();
													// 无数据
													me.noData();
												} else {
													pagecount++;
												}
												$("#userData").append(html);
												fshow();
												// 每次数据加载完，必须重置
												me.resetload();

											},
											error : function(e) {
												console.log(e);
												me.resetload();
											},
											complete : function(e) {
											}
										})
							}
						});

	}
	function getDis(dis) {
		if (dis < 1) {
			return dis * 1000 + "米";
		} else {
			return dis + "公里";

		}
	}
	function show() {
		$("#sel").removeClass("hide");
		$("#find").addClass("hide");
	}
	function fshow() {
		$("#sel").addClass("hide");
	}
</script>

</html>
