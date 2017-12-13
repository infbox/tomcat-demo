/**
 * 抓信社群菜单工具，能帮助用户切换不同风格的导航菜单
 * menuType 是菜单的类型,pageTitle是网页的标题
 */

/*http://www.jb51.net/article/54597.htm
 * jquery动态加载js/css文件方法(自写小函数)
 * 用法：$.include(['hdivbox.js','pop_win.css']);
 * 
 * ，$("head").prepend()方法的作用是在<head>标签的最前端追加写入内容。
//how to use the function below: 
//$.include('../js/jquery-ui-1.8.21.custom.min.js'); 
//$.include('../css/black-tie/jquery-ui-1.8.21.custom.css');
//$.include('file/ajaxa.js');$.include('file/ajaxa.css'); 
//or $.includePath = 'file/';$.include(['ajaxa.js','ajaxa.css']);(only if .js and .css files are in the same directory) 

*/

$.extend({ 
includePath: '', 
include: function(file) 
{ 
var files = typeof file == "string" ? [file] : file; 
for (var i = 0; i < files.length; i++) 
{ 
var name = files[i].replace(/^\s|\s$/g, ""); 
var att = name.split('.'); 
var ext = att[att.length - 1].toLowerCase(); 
var isCSS = ext == "css"; 
var tag = isCSS ? "link" : "script"; 
var attr = isCSS ? " type='text/css' rel='stylesheet' " : " type='text/javascript' "; 
var link = (isCSS ? "href" : "src") + "='" + $.includePath + name + "'"; 
if ($(tag + "[" + link + "]").length == 0) $("head").append("<" + tag + attr + link + "></" + tag + ">"); 
} 
} 
}); 



function initTopMenu(menuType,pageTitle){
	document.title=pageTitle;
	$(".pageTitle").html(pageTitle);
	initMenu_(menuType);
}

function initMenu_(menuType){
	if(menuType==3) $('#demo_box').popmenu({'width': '300px', 'background':'#e67e22','focusColor':'#c0392b','borderRadius':'10px', 'top': '20', 'left': '-1', 'border':'3px solid #0035fe'});
	else if(menuType==2){
		$.include('../skin/2/css/style.css');
		$.include('../skin/2/css/component.css');
		$.include('../skin/2/js/modernizr.custom.js');
		$.include('../skin/2/js/jquery.dlmenu.js');
		$( '#dl-menu' ).dlmenu();		
		var clHeight=window.screen.availHeight ;
		console.log("clHeight="+clHeight);
		var maxMenuHeight=clHeight-200;
		console.log("菜单maxMenuHeight="+maxMenuHeight);
		$( '#dl-menu ul' ).css('max-height',maxMenuHeight+'px');
		$( '#dl-menu ul' ).css('overflow','auto');
	}else if(menuType==1){
		$.include('../skin/2/css/style.css');
		$.include('../skin/2/css/component.css');
		$.include('../skin/2/css/mocha.min.css');		
		$.include('../skin/1/css/test.css');
		$.include('../skin/1/css/index.css');
		
		$.include('../skin/1/js/mocha.min.js');
		$.include('../skin/1/js/slideout.js');
		$.include('../skin/1/js/index.js');
		$.include('../skin/1/js/test.js');
		 document.querySelector('.js-slideout-toggle').addEventListener('click', function() {
	          slideout.toggle();
	        });

	        document.querySelector('.menu').addEventListener('click', function(eve) {
	          if (eve.target.nodeName === 'A') { slideout.close(); }
	        });

	        var runner = mocha.run();
	}

}
