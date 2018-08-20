<%@ page language="java" import="java.util.*,com.infbox.demo.article.*,com.infbox.sdk.*,com.infbox.demo.*" pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.mongodb.BasicDBObject"%>
<%@ page import="java.io.*,org.bson.types.ObjectId"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
MyUser user = (MyUser) session.getAttribute("user");
response.setHeader("Access-Control-Allow-Origin", "*");
InfBoxUtil ibUtil=InfBoxUtil.getInstance(appName);
request.setCharacterEncoding("UTF-8");
if(user==null){
	String bsUrl2="pyq.jsp";
	System.out.println("session user is null, redirect to:"+InfBoxUtil.SITE_URL+"/checkUser.jsp?siteid="+ibUtil.siteId+"&fd_url="+bsUrl2+"&needId=1");
	response.sendRedirect(InfBoxUtil.SITE_URL+"/mobile/c/checkUser.jsp?appName="+appName+"&siteid="+ibUtil.siteId+"&needId=1&fd_url="+bsUrl2);
	return;
}
String picBase=QiNiuUploadUtil.accessDomain;
%>

<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>群友圈</title>
		<!-- <link rel="stylesheet" href="css/headBar2.css" /> -->
		<link rel="stylesheet" type="text/css" href="css/sweetalert.css">
		<link rel="stylesheet" href="../lbs/dist/dropload.css">
		<link rel="stylesheet" href="css/video/mui.css" />
		 <link rel="stylesheet" href="css/pyq.css?v=3">
		 <link rel="stylesheet" href="css/sweetalert.css?v=1">
		 <link rel="stylesheet" href="css/topNavi1.css?v=4">
		 <!-- Core CSS file -->
		<link rel="stylesheet" href="css/photoswipe.css"> 
		<script src="https://cdn.jsdelivr.net/npm/vue"></script>
		<!-- Skin CSS file (styling of UI - buttons, caption, etc.)
			 In the folder of skin CSS file there are also:
			 - .png and .svg icons sprite, 
			 - preloader.gif (for browsers that do not support CSS animations) -->
		<link rel="stylesheet" href="css/default-skin/default-skin.css"> 
		
		<!-- Core JS file -->
		<script src="js/photoswipe.min.js"></script> 
		<script src="js/sweetalert.min.js"></script> 
		
		<!-- UI JS file -->
		<script src="js/photoswipe-ui-default.min.js"></script> 
		<style type="text/css">
	        * {cursor: pointer;}
	        .weui_mask_transition {
	            display: none;
	            position: fixed;
	            z-index: 1;
	            width: 100%;
	            height: 100%;
	            top: 0;
	            left: 0;
	            background: rgba(0, 0, 0, 0);
	            -webkit-transition: background .3s;
	            transition: background .3s;
	        }
	        .weui_fade_toggle {
	            background: rgba(0, 0, 0, 0.6);
	        }
	        .weui_actionsheet {
	            position: fixed;
	            left: 0;
	            bottom: 0;
	            -webkit-transform: translate(0, 100%);
	            -ms-transform: translate(0, 100%);
	            transform: translate(0, 100%);
	            -webkit-backface-visibility: hidden;
	            backface-visibility: hidden;
	            z-index: 2;
	            width: 100%;
	            background-color: #EFEFF4;
	            -webkit-transition: -webkit-transform .3s;
	            transition: transform .3s;
	        }
	        .weui_actionsheet_toggle {
	            -webkit-transform: translate(0, 0);
	            -ms-transform: translate(0, 0);
	            transform: translate(0, 0);
	        }
	        .weui_actionsheet_menu {
	            background-color: #FFFFFF;
	        }
	        .weui_actionsheet_cell:before {
	            content: " ";
	            position: absolute;
	            left: 0;
	            top: 0;
	            width: 100%;
	            height: 1px;
	            border-top: 1px solid #D9D9D9;
	            -webkit-transform-origin: 0 0;
	            -ms-transform-origin: 0 0;
	            transform-origin: 0 0;
	            -webkit-transform: scaleY(0.5);
	            -ms-transform: scaleY(0.5);
	            transform: scaleY(0.5);
	        }
	        .weui_actionsheet_cell:first-child:before {
	            display: none;
	        }
	        .weui_actionsheet_cell {
	            position: relative;
	            padding: 10px 0;
	            text-align: center;
	            font-size: 18px;
	        }
	        .weui_actionsheet_cell.title {
	            color: #999;
	        }
	        .weui_actionsheet_action {
	            margin-top: 6px;
	            background-color: #FFFFFF;
	        }
	        .mui-popover
			{
			    position: absolute;
			    z-index: 999;
			
			    display: none;
			
			    width: 80px;
			
			    -webkit-transition: opacity .3s;
			            transition: opacity .3s;
			    -webkit-transition-property: opacity;
			            transition-property: opacity;
			    -webkit-transform: none;
			            transform: none;
			
			    opacity: 0;
			    border-radius: 7px;
			    background-color: #f7f7f7;
			    -webkit-box-shadow: 0 0 15px rgba(0, 0, 0, .1);
			            box-shadow: 0 0 15px rgba(0, 0, 0, .1);
			}
			.pldel a{
    			color:#444;
    			text-decoration:none;
            }
	    </style>
	</head>

	<body>
	
	<!-- Root element of PhotoSwipe. Must have class pswp. -->
<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">

    <!-- Background of PhotoSwipe. 
         It's a separate element as animating opacity is faster than rgba(). -->
    <div class="pswp__bg"></div>

    <!-- Slides wrapper with overflow:hidden. -->
    <div class="pswp__scroll-wrap">

        <!-- Container that holds slides. 
            PhotoSwipe keeps only 3 of them in the DOM to save memory.
            Don't modify these 3 pswp__item elements, data is added later on. -->
        <div class="pswp__container">
            <div class="pswp__item"></div>
            <div class="pswp__item"></div>
            <div class="pswp__item"></div>
        </div>

        <!-- Default (PhotoSwipeUI_Default) interface on top of sliding area. Can be changed. -->
        <div class="pswp__ui pswp__ui--hidden">

            <div class="pswp__top-bar">

                <!--  Controls are self-explanatory. Order can be changed. -->

                <div class="pswp__counter"></div>
                <button class="pswp__button pswp__button--close" title="Close (Esc)"></button>   
                <button class="pswp__button pswp__button--fs" title="Toggle fullscreen"></button>
                <button class="pswp__button pswp__button--zoom" title="Zoom in/out"></button>

                <!-- Preloader demo http://codepen.io/dimsemenov/pen/yyBWoR -->
                <!-- element will get class pswp__preloader--active when preloader is running -->
                <div class="pswp__preloader">
                    <div class="pswp__preloader__icn">
                      <div class="pswp__preloader__cut">
                        <div class="pswp__preloader__donut"></div>
                      </div>
                    </div>
                </div>
            </div>

            <div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
                <div class="pswp__share-tooltip"></div> 
            </div>

            <button class="pswp__button pswp__button--arrow--left" title="Previous (arrow left)">
            </button>

            <button class="pswp__button pswp__button--arrow--right" title="Next (arrow right)">
            </button>

            <div class="pswp__caption">
                <div class="pswp__caption__center"></div>
            </div>

        </div>

    </div>

</div><!-- end of photoswipe -->
		
		<div class="header3" id="topNavi">
			 <ul class="nav blue">
				 <li>	<a href="jinghList3.jsp" target="_blank" >
				 			 
				  文章精选
				  </a>
				 </li>
				 <li><a href="../lbs/index.jsp" target="_blank" >
				 				 
				 附近群友</a>
				 </li>
				 <li>	<a href="javascript:void(0);" onclick="swal('','请点击抓信底部主菜单\'发现\'->\'分享\'')" >	
				 		 
				  发帖</a>
				 </li>
				
			 </ul>
		</div>
        	
		<div id="main"><!-- class="element" -->
		
		<p style="display:none;">
							 <video controls="controls" style="object-fit: fill" webkit-playsinline="true" x-webkit-airplay="true" playsinline="true" x5-video-player-type="h5" x5-video-player-fullscreen="true" width="100%" height="300"  >
								<source  src="http://img8.infbox.net/1010_79_1525405458786.mp4" >
							 </video>
                            </p>
		
		
		
		
		
			<div id="list">
				<ul id="content">
				
				</ul>
			</div>
		</div>
		 <div id="popover" class="mui-popover" style="width:100;left: 100px;">
		  <ul class="mui-table-view">
		     <li class="mui-table-view-cell">
                    <span class='dlePl'>删除</span>
              </li>
		  </ul>
       </div>
		<script src="../lbs/dist/zepto.min.js"></script>
		<script src="../lbs/dist/dropload.min.js"></script>
		<script src="./js/sweetalert.min.js"></script>
		<script src="./js/jngh.js?v=25"></script>
		<script src="./js/ib_a_blank.js?v=1"></script>	
		<script type="text/javascript" src="js/video/ckplayer/ckplayer.js?v=2" charset="utf-8"></script>
        <script src="js/video/mui.js" type="text/javascript"></script>
        <script type="text/javascript">
        var needUrlBase=false;
        /*var initPhotoSwipeFromDOM = function(gallerySelector) {
        	       var parseThumbnailElements = function(el) {
        	           var thumbElements = el.childNodes,
        	               numNodes = thumbElements.length,
        	               items = [],
        	              figureEl,
        	              linkEl,
        	              size,
        	              item;
        	  
        	          for(var i = 0; i < numNodes; i++) {
        	  
        	              figureEl = thumbElements[i]; // <figure> element
        	  
        	              // 仅包括元素节点
        	              if(figureEl.nodeType !== 1) {
        	                  continue;
        	              } 
        	              linkEl = figureEl.children[0]; // <a> element
        	              var img = new Image();  
                          img.src = linkEl.getAttribute('href'); 
                          linkEl.setAttribute('data-size', img.naturalWidth + 'x' + img.naturalHeight);        	              
        	              size = linkEl.getAttribute('data-size').split('x');
        	  
        	              // 创建幻灯片对象
        	              item = {
        	                  src: linkEl.getAttribute('href'),
        	                  w: parseInt(size[0], 10),
        	                  h: parseInt(size[1], 10)
        	              };
        	  
        	  
        	  
        	              if(figureEl.children.length > 1) {
        	                  // <figcaption> content
        	                  item.title = figureEl.children[1].innerHTML; 
        	              }
        	  
        	              if(linkEl.children.length > 0) {
        	                  // <img> 缩略图节点, 检索缩略图网址
        	                  item.msrc = linkEl.children[0].getAttribute('src');
        	              } 
        	  
        	              item.el = figureEl; // 保存链接元素 for getThumbBoundsFn
        	              items.push(item);
        	          }
        	  
        	          return items;
        	      };*/
        	      
       	function showPic3(pic){
        	    	  var newimage = new Image();
        	    	  newimage.src = pic;    
        	    	  newimage.onload = function()
        	    	  {
        	    	      var width = this.naturalWidth;
        	    	      var height=this.naturalHeight;
        	    	      showPic2(pic,width,height);
        	    	  }  	  
        }
        
        function showPic(picGrpId){        	
        	var items = [];
        	var imgList=$("#picgroup_"+picGrpId+" img")	;        	
        	imgList.forEach(function( val, index ) {
        		var dataItem = new Object();
        		dataItem.src =val.src;        		
        		dataItem.w=val.naturalWidth;
        		dataItem.h=val.naturalHeight;
        		items.push(dataItem);        		
        	});
        
        	var pswpElement = document.querySelectorAll('.pswp')[0];
        	
        //	alert('img.naturalWidth='+w1+',img.naturalHeight='+h1);
        	

        	// define options (if needed)
        	var options = {        	  
        	    index: 0 // start at first slide
        	};

        	// Initializes and opens PhotoSwipe
        	var gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options);
        	gallery.init();
        	//initPhotoSwipeFromDOM('.my-gallery');
        }
        
       
	      //分页
	   	    var myUserId=<%=user.getId()%>
	   	    var userName="<%=user.getName()%>";
	   	    var inputValue ="";
	    	var pagecount = 1;
	    	var pagesize = 10;
	    	var total;
	    	$('.element').dropload({
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
	  					
	  					$.ajax({
	  						url : '${ctx}/mobile/c/circleAPI.jsp?action=list&pagecount='
	  							+ pagecount + '&pagesize='
	  							+ pagesize,
	  						type : 'post',
	  						dataType : "json",
	  						success : function(data) {
	  							var iNeed=data.needURLBase;
	  							if(iNeed!=null && iNeed=="1")needUrlBase=true;
	  							needUrlBase=true;
	  							var map = data.data;
	  							var list=map["pyq"]
	  							$("#content").html(getHtml(map));
	  							binClick();
	  							// 每次数据加载完，必须重置
	  							createVideo(list);
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
	  						url : '${ctx}/mobile/c/circleAPI.jsp?action=list&pagecount='
	  							+ pagecount + '&pagesize='
	  							+ pagesize,
	  						type : 'post',
	  						dataType : "json",
	  						success : function(data) {	  							
	  							
	  							var html="";
	  							var map=data.data;
	  							var iNeed=data.needURLBase;
	  							if(iNeed!=null && iNeed=="1")needUrlBase=true;
	  							else needUrlBase=false;
	  							var list = map["pyq"];
	  							html=getHtml(map);
	  							total = data.page.total;
	  							$("#content").append(html);
	  							binClick();
	  							createVideo(list);
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
	    	function createVideo(list){
	    		var support=['all'];
				for(var i = 0; i < list.length; i++){
	    			var pyq = list[i];
	    			var id=pyq.id;
	    			var type=pyq.type;
	    			var url=pyq.url;
	    			if(type==2){
	    				url=url.split(",");
	    				for(var j in url){
	    					var idd=id+"_"+j;
	    					var video=[url[j]];
	    					var VideoCover=null;
	    					//playVideo2(idd,VideoCover,video,support);
							videoPlay(idd,VideoCover,video,support);
	    				}
	    			}
				}
	    	}
	    	function getCom(com){
	    		var html ="";
	    		if(com){
		    		for(var i=0;i<com.length;i++){
		    			html+="<p class='pldel'><a  key='"+com[i].id+"' href=\"userInfo.jsp?id="+com[i].userId+"\" target=\"_blank\" ><span>"+com[i].userName+"：</span>"+com[i].comText+"</a></p>";
		    		}
	    		}
	    		return html;
	    	}
	    	function getTime(addTime){
	    		var time="刚刚";
	    		var nowDate = new Date();
	    		var now=nowDate.getTime();
	    		var before=addTime.time;
	    		var s=(now-before)/1000;
	    		if(s>=0&&s<60){
	    			time="刚刚";
	    		}else{
	    		    var m=(now-before)/1000/60;
	    		    if(m>0&&m<60){
	    		    	time=parseInt(m)+"分钟前";
	    		    }else{
	    		    	var h=(now-before)/1000/60/60;
	    		    	if(h>0&&h<24){
	    		    		time=parseInt(h)+"小时前";
	    		    	}else{
	    		    		var d=(now-before)/1000/60/60/24;
	    		    		time=parseInt(d)+"天前";
	    		    	}
	    		    }
	    		}
				return time;
	    	}
	    	function getHtml(map){
	    		var list=map["pyq"];
	    		var comMap=map["comment"];
	    		var likeMap=map["like"];
	    		var picBase='<%=picBase%>';
	    		var html="";
	    		for(var i = 0; i < list.length; i++){	    				    		
	    			var pyq = list[i];	    			
	    			var id=pyq.id;
	    			var addTime=pyq.addTime;
	    			var showTime=getTime(addTime);
	    			var type=pyq.type;	    			
	    			var content=pyq.content;	    			
	    			var url=pyq.url;	    			
	    			var authorId=pyq.authorId;
	    			var auhtorName=pyq.auhtorName;	    			
	    			var authorImg=pyq.authorImg;
	    			if(authorImg==null || authorImg.length<4)authorImg="img/me2.png";
	    			var addTime=pyq.addTime;	    			
	    			var com=comMap[id];
	    			var comHtml=getCom(com);
	    			
	    			var like=pyq.num;
	    			if(!like){
	    				like="";
	    			}	  
	    			if(like=="-1" || like==-1) like="1";
	    			var state=0;
	    			if(likeMap[id+"_"+myUserId]){
	    				state=likeMap[id+"_"+myUserId]["state"];
	    			}	    			
	    			if(type==0){//文章
	    				url=JSON.parse(url);
	    				html+=" <li>"+
	    				"             <div class=\"po-avt-wrap\">"+
	    				"                  <a href=\""+getUrl4_Blank("<%=InfBoxUtil.SITE_URL%>/mobile/c/userInfo.jsp?id="+authorId)+"\" ><img class=\"po-avt data-avt\" src="+authorImg+"></a>"+
	    				"             </div>"+
	    				"                <div class=\"po-cmt\">"+
	    				"                    <div class=\"po-hd\">"+
	    				"                        <p class=\"po-name\"><span class=\"data-name\">"+auhtorName+"</span></p>"+
	    				"                        <div class=\"post\">"+
	    				"							<h3>"+content  +"</h3>"+
	    			
	    				"                            <p>"+
	    				"								<a  href=\""+getUrl4_Blank(url.url)+"\">"+
	    				"                                <img class=\"list-img\" src="+url.img+" style=\"width:80px;height: 80px;z-index:10;\">"+
	    				"                               <div style=\"z-index:1;vertical-align:middle;display: table-cell;height:80px;width:100%; \">"+url.title+"</div></a>"+
	    				"                            </p>"+  
	    				"                        </div>"+
	    				"                        <p class=\"time\">"+showTime+"</p><img key="+id+"  class=\"c-icon pldz\" src=\"images/c.png\">"+
	    				"                    </div>"+
	    				"                    <div class=\"r\"></div>"+
	    				"                    <div class=\"cmt-wrap\">"+
	    				"                        <div class=\"like\" key="+id+">";
	    				html+=judgeLike(state);
	    				html+="                            <span>"+like+"</span></div>"+
	    				"                        <div id=com_"+id+" class=\"cmt-list\">";
	    				                            html+=comHtml;							
	    				html+="                  </div>"+
	    				"                    </div>"+
	    				"                </div>"+
	    				"            </li>";
	    			}else if(type==1){//图片
	    				url=url.split(",");
	    			    html+=" <li>"+
	    				"             <div class=\"po-avt-wrap\">"+
	    				"                  <a href=\""+getUrl4_Blank("<%=InfBoxUtil.SITE_URL%>/mobile/c/userInfo.jsp?id="+authorId)+"\"><img class=\"po-avt data-avt\" src="+authorImg+"></a>"+
	    				"             </div>"+
	    				"                <div class=\"po-cmt\">"+
	    				"                    <div class=\"po-hd\">"+
	    				"                        <p class=\"po-name\"><span class=\"data-name\">"+auhtorName+"</span></p>"+
	    				"                        <div class=\"post\">"+
	    				"                            <p>"+content+"</p>"+
	    				"                            <p id=\"picgroup_"+id+"\" ><a href=\"javascript:void(0);\" onclick=\"showPic('"+id+"')\" >";
	    				for(var j in url){
	    					var uu2=url[j];	    					
	    					if(uu2.length<4)continue;	
	    					if(needUrlBase)uu2=picBase+'/'+uu2;
	    					html +="<img class=\"list-img\" src=\""+uu2+"\" style=\"height: 80px;\">";
		    			}
	    				
	    				html +="                            </a></p>"+
	    				"                        </div>"+
	    				"                        <p class=\"time\">"+showTime+"</p><img key="+id+" class=\"c-icon pldz\" src=\"images/c.png\">"+
	    				"                    </div>"+
	    				"                    <div class=\"r\"></div>"+
	    				"                    <div class=\"cmt-wrap\">"+
	    				"                        <div class=\"like\" key="+id+" >";
	    				html+=judgeLike(state);
	    				html+="                          <span>"+like+"</span></div>"+	    				
	    				"                        <div id=com_"+id+" class=\"cmt-list\">";
	    				                            html+=comHtml;	
	    				html+="                  </div>"+
	    				"                    </div>"+
	    				"                </div>"+
	    				"            </li>";
	    			}else if(type==2){//视频
	    				url=url.split(",");
	   					html+=" <li>"+
	    				"             <div class=\"po-avt-wrap\">"+
	    				"                  <a href=\""+getUrl4_Blank("<%=InfBoxUtil.SITE_URL%>/mobile/c/userInfo.jsp?id="+authorId)+"\"><img class=\"po-avt data-avt\" src="+authorImg+"></a>"+
	    				"             </div>"+
	    				"                <div class=\"po-cmt\">"+
	    				"                    <div class=\"po-hd\">"+
	    				"                        <p class=\"po-name\"><span class=\"data-name\">"+auhtorName+"</span></p>"+
	    				"                        <div class=\"post\">"+
	    				"                            <p>"+content+"</p>"+
	    				"                            <div>";
	    				for(var j in url){
	    					   html+="<div id="+id+"_"+j+"></div><hr/>";
	    				}
	    				html+="                            </div>"+
	    				"                        </div>"+
	    				"                        <p class=\"time\">"+showTime+"</p><img key="+id+" class=\"c-icon pldz\" src=\"images/c.png\">"+
	    				"                    </div>"+
	    				"                    <div class=\"r\"></div>"+
	    				"                    <div class=\"cmt-wrap\">"+
	    				"                        <div class=\"like\" key="+id+">";
	    				html+=judgeLike(state);                      
		    			html+="	                         <span>"+like+"</span>"+
	    				"                        </div>"+
	    				"                        <div id=com_"+id+" class=\"cmt-list\">";
	    				                            html+=comHtml;	
	    				html+="                   </div>"+
	    				"                    </div>"+
	    				"                </div>"+
	    				"            </li>";
	    				
	    			}
	
	    		}
	    		return html;
	    	}
	    	function judgeLike(state){
	    		var html="";
	    		if(state==1){
	    			html="<img state="+ state +" src=\"img/icon07.png\">";
	    		}else{
	    			html="<img state="+ state +" src=\"img/icon09.png\" class=\"like20\">";
	    		}
	    		return html;
	    	}
	    	function playVideo2(id,VideoCover,videoURL,support){
	    		$("#"+id).append("<a href='javascript:void(0);' onclick='if(infbox)infbox.playVideo(\""+videoURL+"\");' ><img src='./images/play_cover.jpg' style='width:40px;height:40px;' /></a>");
	    	}
	    	function videoPlay(id,VideoCover,videoURL,support){
	       		//alert(videoURL);//用alert可以判断延迟加载
	    		/*
	    		var flashvars={
	       				p:0,
	       				e:2,
	       				i:'http://www.ckplayer.com/static/images/cqdw.jpg'
	       		};
	       		var support2=['iPad','iPhone','ios','android+false','msie10+false'];
	       		CKobject.embedHTML5(id,'ckplayer_a1',"100%",350,video,flashvars,support2);
	   			 */
	    		var videoObject = {
	    				container: '#'+id,
	    				variable: 'player',//该属性必需设置，值等于下面的new chplayer()的对象
	    				poster:'./images/play_cover.jpg',
	    				video: ''+videoURL
	    			};
	    			var player=new ckplayer(videoObject);
	    	
	    	
	    	
	    	}
	    function binClick(){
	    	var $comId=0;
	    	var $comThis="";
	    	$(".mui-table-view").on("click",function(){
	    		mui('#popover').popover('hide');
	    		$.ajax({
					url : "${ctx}/mobile/c/circleAPI.jsp?action=delComment&id="+$comId,
					type : 'post',
					dataType : "json",
					success : function(data) {
						var id=data.id;
						//var html="<p class='pldel'><a key="+comId+" href='#popover'><span>"+userName+"：</span>"+text+"</a></p>";
						if(id){
							$comThis.remove();
						}
					},
					error : function(e) {
					},
					complete : function(e) {
					}
			   })
	    		
	    	});
	    	$(".pldel input").on("tap",function(){
	    		$comId=$(this).attr("key");
	    		$comThis=$(this.parentNode);
	            //指定<a>标签的href  
	            this.href = "#popover";  
	            //取消<a>标签原先的onclick事件,使<a>标签点击后通过href跳转(因为无法用js跳转)^-^  
	            this.setAttribute("onclick",'');  
	            //激发标签点击事件OVER  
	            this.click("return false");  
	    	}) 
	    	$(".pldz").on("click",function(){
	    		var $THIS=$(this);
    		    mui.prompt('', '', '评论', ["取消","确定"], function(e) {
	 		    	if (e.index == 1) {
		 		    	var text = $('.mui-popup-input textarea').val();
		 		    	if(!text){
		 		    	   return false;
		 		    	}
			    		var pyqId=$THIS.attr("key");
						var userId=myUserId;
						$.ajax({
							url : "${ctx}/mobile/c/circleAPI.jsp?action=comment&userId="+userId+"&pyqId="+pyqId+"&comText="+text,
							type : 'post',
							dataType : "json",
							success : function(data) {
								var comId=data.id;
								var html="<p class='pldel'><a key="+comId+"><span>"+userName+"：</span>"+text+"</a></p>";
								$("#com_"+pyqId).append(html);
							},
							error : function(e) {
							},
							complete : function(e) {
							}
					   })
	 		    	}
 		    	},'div');
 		    	$('.mui-popup-input').html('');
 		    	$('.mui-popup-input').append('<textarea rows="3" ></textarea>')
	    	});
			$(".like").on("click",function(){
				debugger
				var pyqId=$(this).attr("key");
				var state=$(this).find("img").attr("state");
				var $THIS=$(this);
				var userId=myUserId;
				$.ajax({
					url : '${ctx}/mobile/c/circleAPI.jsp?action=like&state='+state+"&userId="+userId+"&pyqId="+pyqId,
					type : 'post',
					dataType : "json",
					success : function(data) {
						if(state==1){
							$THIS.find("img").attr("src","img/icon09.png");
							$THIS.find("img").attr("state",0);
							var num=$THIS.find("span").text();
							if(num=="" || num=="0")num="1";
							$THIS.find("span").text(parseInt(num)-1);							
						}else{
							$THIS.find("img").attr("src","img/icon07.png");
							$THIS.find("img").attr("state",1);
							var num=$THIS.find("span").text();
							if(num=="")num="0";
							$THIS.find("span").text(parseInt(num)+1);
						}
					},
					error : function(e) {
					},
					complete : function(e) {
					}
				})
	    	});
	    }
	    function  muiText(){
		    mui.prompt('', '', '评论', ["取消","确定"], function(e) {
		    	if (e.index == 1) {
		    	var value = $('.mui-popup-input textarea').val();
		    	if(!value){
		    	return false;
		    	}
		    	commitData(1,value);
		    	}
		    	},'div');
		    	$('.mui-popup-input').html('');
		    	$('.mui-popup-input').append('<textarea></textarea>')
	    }
		
	    var topNav	 =new Vue({
		  el: '#topNavi2',
		  data: {
			  isSelect: '银行',
			  footNav: [{title: '文章精选', url: 'jinghList3.jsp', url1: '../../static/baiduMap/22@2x.png'},
			   {title: '附近的人', url: '../lbs/index.jsp?appName=<%=appName%>', url1: '../../static/baiduMap/10@2x.png'},
			   {title: '发帖', url: '', url1: '../../../static/baiduMap/12@2x.png'},
			  
			   {title: '关于 ', url: 'about.html', url1: '../../static/baiduMap/16@2x.png'}
			   
			  ]
		  },
		  methods: {
			  selectNav: function (url) {
			      // `this` 在方法里指当前 Vue 实例
				  //this.isSelect = title;
			      alert(url);
				  window.open(url);
			    }
			  }
		})
	</script>
	</body>
</html>