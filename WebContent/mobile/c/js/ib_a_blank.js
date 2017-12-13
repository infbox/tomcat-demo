/**
 * 解决抓信里插件动态生成的超链接无法再新窗口打开
 */

/**
 * [isMobile 判断平台]
 * @param test: 0:iPhone    1:Android
 * 使用方法：
var pla=ismobile(1);
如果pla返回的是0:iPhone 1:Android
 */
function ismobile(test){
    var u = navigator.userAgent, app = navigator.appVersion;
    if(/AppleWebKit.*Mobile/i.test(navigator.userAgent) || (/MIDP|SymbianOS|NOKIA|SAMSUNG|LG|NEC|TCL|Alcatel|BIRD|DBTEL|Dopod|PHILIPS|HAIER|LENOVO|MOT-|Nokia|SonyEricsson|SIE-|Amoi|ZTE/.test(navigator.userAgent))){
     if(window.location.href.indexOf("?mobile")<0){
      try{
       if(/iPhone|mac|iPod|iPad/i.test(navigator.userAgent)){
        return '0';
       }else{
        return '1';
       }
      }catch(e){}
     }
    }else if( u.indexOf('iPad') > -1){
        return '0';
    }else{
        return '1';
    }
}
/*得到抓信ios和安卓通用的url跳转到_blank页面的地址，因为抓信插件的原因*/ 
function getUrl4_Blank(url){
	var pla=ismobile(1);
	var newUrl='';
	if(pla==0)
		newUrl = 'a:'+url;
	else 
		newUrl = 'newtab:'+url;
	return newUrl;
}
/*网页是否在抓信浏览器里*/
function useInfBox(){
	var pla=ismobile(1);
	var in_zhuaxin=false;
	if(pla==0){
		var ss=infbox.ping('');
		if(ss!=null)in_zhuaxin=true;
	}else {
		if(typeof(infbox)=="object") in_zhuaxin=true;
	}
	return in_zhuaxin;
}

function doLinkBlank(){
	var allLinks = document.getElementsByTagName('a'); 
	var pla=ismobile(1);	
	if (allLinks) {
		var i;
		for (i=0; i<allLinks.length; i++) {
			var link = allLinks[i];
			var target = link.getAttribute('target'); 
			if (target && target == '_blank') {
				link.setAttribute('target','_self');				
				if(pla==0)
					link.href = 'a:'+link.href;
				else 
					link.href = 'newtab:'+link.href;
			}
		}
	}	
}