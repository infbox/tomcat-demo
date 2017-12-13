window.onload=function(){
	var oUl=document.getElementById('foot');
	var aLi=oUl.getElementsByTagName('li');
	
	for(var i=0; i<aLi.length; i++){
		
		aLi[i].onclick=function(){
			for(var i=0; i<aLi.length; i++){
				aLi[i].className="";
			}
			this.className='active2';
		}
	}
}
function show(obj,ob,n){
	var oDiv = document.getElementById(obj);
	var oDiv2 = document.getElementById(ob);
	var oBg = document.getElementById('pageOverlay');
	var aLi = oDiv.getElementsByTagName("li")[n];
	
	aLi.onclick=function(){
		oDiv2.style.display="block";
		oBg.style.display="block";
	}
};

function toNum(obj,ob,act){
	var oP=document.getElementById(obj);
	var oDiv = document.getElementById(ob);
	var oBg = document.getElementById('pageOverlay');
	var aLi = oDiv.getElementsByTagName("li");
	
	for(var i=0; i<aLi.length; i++){
		
		aLi[i].onmousemove=function(){
			for(var i=0; i<aLi.length; i++){
				aLi[i].className="";
				this.className=act;
			}
		}
		
		aLi[i].onclick=function(){
			for(var i=0; i<aLi.length; i++){
				oP.innerHTML = this.innerHTML;
				oDiv.style.display="none";
				oBg.style.display="none";
			}
		}
	}
}

window.onload=function(){
	show("list1","probox",0);
	toNum("proize","probox","orange");
}

