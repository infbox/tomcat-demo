<%@ page language="java" import="java.util.*,com.infbox.demo.article.*,com.infbox.sdk.*,com.infbox.demo.*" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<link rel="stylesheet" href="css/jinghList3.css?v=8" />
		<title>抓信社群</title>
		<script src="//apps.bdimg.com/libs/jquery/1.8.3/jquery.min.js"></script>
 		<script src="./js/jngh.js?v=26"></script>	
 		 <link rel="stylesheet" href="css/jhArticle.css?v=8" /> 	
 		 <link rel="stylesheet" href="../lbs/dist/dropload.css">	
 		 <link rel="stylesheet" type="text/css" href="css/naviBar.css?v=2" /> 
 		  <link rel="stylesheet" href="./popmenu/font-awesome/css/font-awesome.min.css"/>
 		 <style>
        .fa{font-size: 40px;line-height: 70px;}
 			.fa-bars{color: #3498db;}       
       </style>       
	</head>
	<body>
		<%@include file="inc/header.jsp" %> 	
		<div class="prev">			
			<span>
				<img class="leftimg" src="img/icon06.png"/ onclick="javascript:window.location.href='test1.jsp'">|
				<img class="rightimg" src="img/icon02.png" onclick="javascript:window.location.href='myInfo.jsp'" />
			</span>
		</div>
	
		<div class="main-foot element" id="hotDiv">
			<ul id="news-container">
			</ul>
		</div>
		<div class="nodata"></div>
	</body>
	<script type="text/javascript" src="../../js/jquery.min.js"></script>	
		<script src="../lbs/dist/dropload.js"></script>
		<script src="./js/ib_a_blank.js?v=1"></script>	
		
		<script src="./js/menuUtil.js?v=16"></script>	
		<script src="./js/jquery.popmenu.min.js"></script>
		<script type="text/javascript">		
			var pagecount = 1;
			var pagesize = 5;
			var total;
			var type = "2";
			
		
			$(function() {
				initTopMenu(3,"最新精选");
				showList();			
			})
			
			/**
			* 加载文章列表
			*/
			function showList(){
				console.log(type)
				$('.element').dropload(
						{
							scrollArea : window,
							domUp : {
								domClass : 'dropload-up',
								domRefresh : '<div class="dropload-refresh">↓下拉刷新</div>',
								domUpdate : '<div class="dropload-update">↑更新数据!</div>',
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
								$.ajax({ 
										url:"getNewsList.jsp?pagecount="+pagecount+"&type="+type+"&time="+(new Date().getTime()), 
										type:"post", 
										dataType : "json",
										success: function(data){
											total = data.total;
											$("#news-container").html('');
											getAppendContent(data.list);
						                   // 每次数据加载完，必须重置
											me.resetload();
											me.unlock();
											//me.noData(false);
											pagecount=pagecount+1;
										},
										error: function(){
											$j("#news-container").html("文章信息加载错误.");
											me.resetload();
										}
									});		
							},
							loadDownFn : function(me) {
								// 每次数据加载完，必须重置
								//me.resetload();
								// 每次数据加载完，必须重置
								$.ajax({ 
										url:"getNewsList.jsp?pagecount="+pagecount+"&type="+type+"&time="+(new Date().getTime()), 
										type:"post", 
										dataType : "json",
										success: function(data){
											total = data.total;
											getAppendContent(data.list);
						                    if(total == 0 || pagecount == total){
						                    	me.resetload();
						                    	// 锁定
												me.lock();
												// 无数据
												me.noData();
												me.noData(true);
						                    }else{
						                    	pagecount=pagecount+1;
						                    }
						                    me.resetload();
										},
										error: function(){
											$j("#news-container").html("文章信息加载错误.");
											me.resetload();
										}
									});	
							}
						});
			};
			
			function getAppendContent(data){
				var dd=$("#dropload-noData");
				if(typeof(dd)!="undefined"){
					var ss=dd.html();
					console.log(ss);
					if(typeof(ss)!="undefined" && ss.indexOf("无数据")>0)
					return;
				}
				
				$.each(data,function(i,list){  					
						                        var _tr = "<a  data-ignore=\"push\" href=\""+getUrl4_Blank("<%=InfBoxUtil.SITE_URL%>/mobile/c/article.jsp?id="+list.id)+"\"  >";
						                            _tr += "  <li id='litem_'"+list.id+">";
						                            _tr += "	<img class=\"pic\" src=\""+list.bgImg+"\" />";
						                            _tr += "	<div>";
						                            _tr += "		<p class=\"about\">"+list.title+"</p>";
						                            _tr += "		<p class=\"grade\">";
						                            _tr += "			<img src=\"img/icon03.png\"/>"+list.author+"";
						                            _tr += "		</p>";
						                            _tr += "		<p class=\"lp\"><img src=\"img/read.png\"/>阅读("+list.readNum+")</p>";
						                            _tr += "		<p class=\"hp\"><img src=\"img/icon04.png\"/>评论("+list.commentNum+")</p>";
						                            _tr += "	</div>";
						                            _tr += "  </li>";
						                            _tr += "</a>";
						                        $("#news-container").append(_tr);
						                    })
			}
			
			
		</script>	
</html>
