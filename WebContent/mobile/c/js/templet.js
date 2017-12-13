function queryCounter(siteURL,id,apName){
	console.log('queryCounter:'+siteURL);
	$.ajax({
		type: "GET",	
		async: false,
		url: siteURL+"/mobile/c/getCounter.jsp",
		data: "articleId="+id+"&time="+(new Date())+"&appName="+apName,
		success:function(msg11){
			var msg = $.trim(msg11);
			console.log(msg);
			var arr = msg.split("@");
			if(arr[0] == "0" || arr[0] ==0){
				var num = arr[1].split(",");
				$("#readNum3").html("已阅读"+num[0]);
				$("#commentNum3").html("("+num[1]+")");
				$("#likeNum3").html(num[2]);
				$("#bonusNum3").html(num[3]);
			}else{
				alert("错误："+arr[1]+"。");
		   	}
		}
	});
}

$(function(){
	var wi = $("#js_content").width();
	$(".video_iframe").css("width",wi).css("height",wi/1.77);
	var src = $(".video_iframe").attr("src");
	if(src){
		src = src.replace("preview","player");
		src = replaceParamVal(src,"width",wi);
		src = replaceParamVal(src,"height",wi/1.70);
		 $(".video_iframe").attr("src",src);
	}	
})

function replaceParamVal(oldUrl, paramName, replaceWith) {
var re = eval('/(' + paramName + '=)([^&]*)/gi');
var nUrl = oldUrl.replace(re, paramName + '=' + replaceWith);
return nUrl;
}
