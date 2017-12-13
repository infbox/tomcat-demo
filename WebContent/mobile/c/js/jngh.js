function JTrim(s)
{
	/*去掉字符串的空格*/
    return s.replace(/(^\s*)|(\s*$)/g, "");
}




function sendComment(userID,postID) {
	if(userID==null){ sAlert("请登录抓信使用"); return;}
	
	var comment = $("#mycomment").val(); 
	if (JTrim(comment)== "")return;
	if (comment.length<5){
		/*提醒输入太少了*/
		sAlert("字数太少，加几个字吧！");
		return;}
	
	$.post("../../addComment.jsp", {post_id:postID,
		content:comment}, 
		function (data, textStatus){ 
		 	var retVal =parseInt( data);  		 	
		 	
			if(retVal>=0) {
				sAlert("发表评论成功！");	
				$("#mycomment").val("");
				/*然后在最新回帖栏目的第一个地方插入新回复的帖子*/
				var divstr="<div class='reply' id='hot-"+retVal+"' tieid='"+retVal+"' ding='0'>"+
					"<div class='inner  clearfix'>"+
					"<span class='author'> <span class='from'>我</span>"+
					"</span> <span class='postTime'>刚发布</span>"+
					"<div class='body'><p class='content'>"+comment+"</p></div></div></div>";
				
				$("#hotReplies .list").append(divstr);			
							
			}
			$('#pFooter').removeClass("goTop"); 
			$('#pFooter').addClass("stayBtm");
    
        });	
	  
}

function dingTie(){
	
	var id = $("#popDing").attr("tieid"); 
	
	$.post("jh_dingTie.jsp", {cID:id}, 
			function (data, textStatus){ 
				if(data="ok") {
					sAlert("恭喜！顶贴成功！");
					var i=$("#popDing").attr("ding");
					i=parseInt(i)+1;
					$( "#popDing").html("顶["+i+"]");
					$("#hot-"+id).attr("ding",i);
					$("#new-"+id).attr("ding",i);
					$("#popDing").attr("ding",i);
					
					
				}else{
					sAlert("顶贴失败！请在抓信内操作！");
				}
				$( "#popMenu" ).css({display:'none'});
	    
	        });	
}

function huifuInput(){	
	var id = $("#popDing").attr("tieid");
	$("#mycomment").attr("tieid",id);
	$( "#popMenu" ).css("display","none");
	$("#mycomment").focus();
	$( "#popMenu" ).css({display:'none'});
}
/*sAlert是显示1秒自动关闭的提醒*/
	function sAlert(content){
		swal({   title: "",   text: content,   timer: 1200,   showConfirmButton: false });
	}
	
/*居中显示一个div,参数为$("selector")*/
function center(obj) {       
    var screenWidth = $(window).width(), screenHeight = $(window).height();  
    var scrolltop = $(document).scrollTop();
    
    var objLeft = (screenWidth - obj.width())/2 ;
    var objTop = (screenHeight - obj.height())/2 + scrolltop;

    obj.css({left: objLeft + 'px', top: objTop + 'px','display': 'block'});
   
    $(window).resize(function() {
        screenWidth = $(window).width();
        screenHeight = $(window).height();
        scrolltop = $(document).scrollTop();       
        objLeft = (screenWidth - obj.width())/2 ;
        objTop = (screenHeight - obj.height())/2 + scrolltop;       
        obj.css({left: objLeft + 'px', top: objTop + 'px','display': 'block'});
       
    });
   
    $(window).scroll(function() {
        screenWidth = $(window).width();
        screenHeight = $(window).height();
        scrolltop = $(document).scrollTop();       
        objLeft = (screenWidth - obj.width())/2 ;
        objTop = (screenHeight - obj.height())/2 + scrolltop;       
        obj.css({left: objLeft + 'px', top: objTop + 'px','display': 'block'});
    });
   
}

/** 
 * 返回前一页（或关闭本页面） 
 * <li>如果没有前一页历史，则直接关闭当前页面</li> 
 */  
function goBack(){  
    if ((navigator.userAgent.indexOf('MSIE') >= 0) && (navigator.userAgent.indexOf('Opera') < 0)){ 
        if(history.length > 0){  
            window.history.back( -1 );  
        }else{  
            window.opener=null;window.close();  
        }  
    }else{ 
    		
        if (navigator.userAgent.indexOf('Firefox') >= 0 ||  
            navigator.userAgent.indexOf('Opera') >= 0 ||  
            navigator.userAgent.indexOf('Safari') >= 0 ||           
            navigator.userAgent.indexOf('WebKit') >= 0){  
        	console.log(navigator.userAgent);
        	
            if(window.history.length > 1){             	
                window.history.back( -1 );           	
            }else {            	
            	 window.open('', '_self', ''); window.close();   
            	   
            } 
        }else if(navigator.userAgent.indexOf('Chrome') >= 0){
        	if(window.history.length > 1){             	
                window.history.back( -1 );          		
             }else {
             	sAlert2('Chrome' );
             	 window.open('', '_self', ''); window.close();   
             }
        }else{ 
            window.history.back( -1 );  
        }  
    }  
}  

function shoucang(siteURL,article_id,title1,author1,bgimg1,urlpath){	
	$.post(siteURL+"/collect/add.action", {articleId:article_id,author:author1,bgimg:bgimg1,title:title1,url:urlpath}, 
			function (data, textStatus){ 
		var obj = eval('(' + data + ')');
				if(obj.code=="1") {
					sAlert("恭喜！收藏成功！");				
					
				}else{
					sAlert("收藏失败！请在抓信内操作！");
				}
				
	    
	        });	
}

function addLiuyan(frdId){	
	var liuyan = $("#liuyan_str").val(); 
	var liuyan_name = $("#liuyan_name").val(); 
	if(liuyan.length<3){ return;}
	$.post("doSendSMS.jsp", {recvId:frdId,msg:liuyan,name:liuyan_name}, 
			function (data, textStatus){ 
				if(data.indexOf("ok")>-1) {
					sAlert("恭喜！留言成功！");				
					
				}else{
					sAlert("留言失败！请在抓信内操作！");
				}				
	    
	        });	
}
function setMyMemo(myId){
	var vv=$(".message-box").css("display");
	if(vv=="none"){
		$(".message-box").css("display","block");
		  $("body").scrollTop(Number.MAX_VALUE);
		return;
	}
	var liuyan = $("#liuyan_str").val(); 
	if(liuyan.length<3){ return;}
	$.post("doSetMyMemo.jsp", {msg:liuyan}, 
			function (data, textStatus){ 
				if(data.indexOf("ok")>-1) {
					sAlert("设置备注成功！");
					$(".message-box").css("display","none");
					
				}else{
					sAlert("操作失败！请在抓信内操作！");
				}				
	    
	        });	
}

function addPrase(siteUrl,artId,type1){		
	$.post(siteUrl+"/mobile/c/doPrase.jsp", {aId:artId,type:type1}, 
			function (data, textStatus){ 
				if(data.indexOf("ok")>-1) {
					if(type1==2){						
						var num1=$("#likeNum3").html();
						var num2=parseInt(num1); 
						num2=num2+1;						
						$("#likeNumLink3").attr("href","javascript:");
						$("#likeNum3").html(num2);
					
					}
					else if(type1==8) {
						sAlert("打赏成功！");
						var num1=$("#bonusNum3").html();
						var num2=parseInt(num1); 
						num2=num2+1;
						$("#bonusNum3").html(num2);
					}
					
				}else{
					sAlert("操作失败！请在抓信内操作！");
				}				
	    
	        });	
}

function addFollow(friendId,type1){		
	$.post("doFans.jsp", {frdId:friendId,type:type1}, 
			function (data, textStatus){ 
				if(data.indexOf("ok")>-1) {
					if(type1==1){
						sAlert("关注成功！");	
						
					
					}
					else {
						
					}
					
				}else{
					sAlert("操作失败！请在抓信内操作！");
				}				
	    
	        });	
}
function sAlert2(content){
	swal({ 
	    title: "", 
	    text: content, 	   
	    showCancelButton: true, 
	    closeOnConfirm: true, 
	    confirmButtonText: "关闭", 
	    confirmButtonColor: "#ec6c62" 
	}, function() { 
	   
	});

}

function goBack2(){
	window.history.go(1 - window.history.length); 
}

function getAdv(siteUrl,containerId){
	$.post(siteUrl+"/mobile/c/getAdvert.jsp", {}, 
		function (data, textStatus){ 
			if(textStatus=="success"){
				$("#"+containerId).html(data); 
			}
			   
        });	
	  
	
}


