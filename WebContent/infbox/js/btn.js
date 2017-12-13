function myInit(){
	room.chat("init");
}

var  myTimer,Speed = 100;
function StartGame(){
    clearInterval(myTimer);
    myTimer = setInterval(endCycle, Speed);        
}
function StopGame(phones){
    clearInterval(myTimer);
    var str=phones;   
    if(str.charAt(str.length-1)==',')str=str.substring(0,str.length-1);
	var strs= new Array(); //定义一数组
	strs=str.split(","); //字符分割    
	if(strs.length==1){
		phone=strs[0];
		for(i=1;i<12;i++){
			tmpNum= phone.charAt(i-1);
			if(i>3 && i<8)$("#less .num"+i).html("*");
			else $("#less .num"+i).html(tmpNum);
		} 
	}
	else if(strs.length>1){
		for (k=0;k<8 ;k++ )   
    	{ 
			phone="-----------";
			if(k<strs.length)phone=strs[k];
			
			for(i=1;i<12;i++){
					tmpNum= phone.charAt(i-1);
					if(i>3 && i<8)$("#many"+k+" .num"+i).html("*");
					else $("#many"+k+" .num"+i).html(tmpNum);
			} 
			
    	} 
	}
    
    
    
}
var secMobiNo=[3,5,8];
function endCycle(){
	var tmpNum=0;
	for(i=1;i<12;i++){
		if(i==1)continue;
		if(i==2){
			var tmpIndex=Math.floor(Math.random() * ( 2 + 1));
			tmpNum=secMobiNo[tmpIndex];
		} else 	tmpNum= Math.floor(Math.random() * ( 9 + 1));
		$(".num"+i).html(tmpNum);
	}
} 
function beginDraw(){
     StartGame();
}
function endDraw(winner){
	 StopGame(winner);
}

//登陆信息
function login(){
	$("#board1, #board3, #prize, #endtitle").hide();
	$("#board2, #login, #endtitle2").show();
}
//奖品展示
function prize(){
	$("#board1, #board3, #login, #endtitle").hide();
	$("#board2, #prize, #endtitle2").show();
}
//正式开始8号码
function displayBigBg(){
	$("#board1, #many, #endtitle").show();
	$("#board2, #board3, #less, #endtitle2").hide();
}
//1号码
function displaysmallBg(){
	$("#board1, #less, #endtitle").show();
	$("#board2, #board3, #many, #endtitle2").hide();
}
//获奖名单
function endlist(){
	$("#board3, #list, #list2, #endtitle2").show();
	$("#board1, #board2, #end, #endtitle").hide();
}
//结束
function end(){
	$("#board3, #end, endtitle2").show();
	$("#board1, #board2, #list, #list2, #endtitle").hide();
}
function blurMobile(phone){
	if(phone.length<11)return phone;
	var ret="";
	for(i=1;i<12;i++){
		tmpNum= phone.charAt(i-1);
		if(i>3 && i<8)ret=ret+"*";
		else ret=ret+tmpNum;
	} 
	return ret;
}