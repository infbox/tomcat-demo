/**
 * 抓信扫码登陆函数库 V1.0
 * @kanxj 2013-12-12
 * 更多信息，请访问 http://www.infbox.com
 */

	var phase='login';	
	var userJoined=false;
	var userId="";
	var app_path="";
	
    var room = {
            join: function (name)
            {
                this._username = userId;               
                send(room._username, 'has joined!', room._poll, true);
            },           
            _poll: function (m)
            {
                console.debug(m);
                if (m.chat)
                { 
                   if(m.chat.indexOf("joined")>0){
                	    if(phase!='login'){               			
               				showReCon();	               		
	               		}
                   }                
                    var key="cmd";
                    if(m.chat.indexOf(key) > 0 && m.chat.indexOf("}") > 0){
                    //开始设置显示问题
                    var data=eval('('+m.chat+')');
	                   if(data.cmd=="login"){
	                    	
	                    	if(data.result=="ok"){ 
	                            	window.location.href=data.url;
	                            	return;	                    		
	                    	}	                    	
	                    }                   
                    }
                }
                send(room._username, null, room._poll, false);
            },
            _end: ''
        };
        
    
	 function getKeyCode(ev)
     {
         if (window.event) return window.event.keyCode;
         return ev.keyCode;
     };
     
     function xhr(method, uri, body, handler)
     {
         var req = (window.XMLHttpRequest) ? new XMLHttpRequest() : new ActiveXObject('Microsoft.XMLHTTP');
         req.onreadystatechange = function ()
         {
             if (req.readyState == 4 && handler)
             {
                 eval('var o=' + req.responseText);
                 handler(o);
             }
         }
         req.open(method, uri, true);
         req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
         req.send(body);
     }
     
     function send(user, message, handler, join)
     {
         if (message) message = message.replace('%', '%25').replace('&', '%26').replace('=', '%3D');
         if (user) user = user.replace('%', '%25').replace('&', '%26').replace('=', '%3D');
         var requestBody = 'user=' + user + (message ? '&message=' + message : '') + (join ? '&join=true' : '');
         xhr('POST', app_path+'/ws', requestBody , handler);
     }
     
     document.onkeydown=function(event){ 
         var e = event || window.event || arguments.callee.caller.arguments[0];
        if(e && e.keyCode==122){
        	setwindow();
        } else if(e && e.keyCode==32){
        	//断了，重新连接
        	ownerLogin(userId);
        } 
    } 

     
     
     function ownerLogin(UID)
     {
    	 userId=UID;
         room.join(userId);
         
         return false;
         
     };
     function setAppPath(pp){
    	 app_path=pp;
     }