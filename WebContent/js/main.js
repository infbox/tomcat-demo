function upBgImg(){
	
	
	$.ajaxFileUpload({  
	    type: "POST",  
	    url: "./doUpImg.jsp",  
	    data:{},//要传到后台的参数，没有可以不写  
	    secureuri : false,//是否启用安全提交，默认为false  
	    fileElementId:'logo_pic',//文件选择框的id属性  
	    dataType: 'html',//服务器返回的格式  
	    async : false,  
	    success: function(data){  
	    	console.log('上传成功'+data);
	    	if(data.indexOf(".") >0) $("#logo").val(data);
	    	else alert(data);
	    },  
	    error: function (data, status, e){  
	       console.log(data);
	       alert(data);
	    }  
	});  	
	
	
	
	
	 

}



/*
 * 
 * 
 * 
 * 
 * 
  
  	
 $("#logo_pic").change(function(){
		mainpic = false;	    	    
	    $("#logo_pic").uploadPreview({ Img: "ImgMain", Width: 150, Height: 120 });
			
		var file = this.files[0];
	    if (!/image\/\w+/.test(file.type)) {
	    	alert("只能上传图片.");
	        return false;
	    }
	    var reader = new FileReader();
	    reader.readAsDataURL(file);
	    reader.onload = function(e) {
	        var img = new Image,
	            width = 640, //image resize
	            quality = 0.8, //image quality
	            canvas = document.createElement("canvas"),
	            drawer = canvas.getContext("2d");
	        img.src = this.result;
	        img.onload = function() {
	            canvas.width = width;
	            canvas.height = width * (img.height / img.width);
	            drawer.drawImage(img, 0, 0, canvas.width, canvas.height);
	            img.src = canvas.toDataURL("image/jpeg", quality);
	            console.log(1);
	            var data = {'imgR': img.src}
	            img.onload = null;
		 $.ajax({  
	            url: siteurl+"/doUpImg.jsp",  
	            type: 'POST',  
	            data: data,  	            		           
	            success:function(data){  		                
	                if(data.code==1){
	            		console.log(data);
	            		alert('设置成功');
	            	}else if(data.code==999){
	            		alert("图片过大，请重新上传");
	            	}else if(data.code==998){
	            		alert("系统繁忙，请稍后再试");
	            	}		                
	               
	            }   
	        });  //ajax
	        }
	    }
	});//pic change		  
 		  
 		  
 		  
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * $.ajax({
        url:siteurl+"/getToken.jsp",
        type:"post",
        data:{username:'a'},
        success:function(data){		                   
        	console.log(data);
        },
        error:function(e){
        	if(e.responseText.length>10){
        		 console.log('e.responseText='+e.responseText);
        		 var token=$.trim(e.responseText);
        		 var uploader = Qiniu.uploader({
                     runtimes: 'html5,flash,html4',
                     browse_button: 'logo_pic',
                     uptoken: token,
                     get_new_uptoken: false,
                     domain: 'http://img8.infbox.net/',
//                     container: 'container',
                     max_file_size: '5mb',
                     flash_swf_url: siteurl+'/plupload/Moxie.swf',
                     max_retries: 2,
                     auto_start: true,
                     resize: {           //压缩上传
                         crop: true,
                         quality: 30,
                         preserve_headers: false
                     },
                     init: {
                         'FilesAdded': function (up, files) {
//                             plupload.each(files, function(file) {
//                                 // 文件添加进队列后，处理相关的事情
       //
//                             });
                         },
                         'BeforeUpload': function (up, file) {
                             // 每个文件上传前，处理相关的事情
                            
                         },
                         'UploadProgress': function (up, file) {
                             // 每个文件上传时，处理相关的事情
                         },
                         'FileUploaded': function (up, file, info) {
                        	 var key2=JSON.parse(info).key;
                            console.log('loaded file:'+key2) ;
                         },
                         'Error': function (up, err, errTip) {
                             //上传出错时，处理相关的事情
                             console.log(err);
                             console.log(err);
                             alert("上传失败，请重新上传");
                         },
                         'UploadComplete': function () {
                             //队列文件处理完毕后，处理相关的事情
                         },
                         'Key': function (up, file) {
                             var arr = (file.name + "").split('.');
                             var timestamp = (new Date()).valueOf(); 
                             key ="sq"+timestamp+ "." + arr[arr.length-1];
                             alert('key is:'+key);
                             return key
                         }//end key
                     }//end init
        		  });//end upload
        		 
        		 
        		 
        	}//responseText>10
           
           
        }
    });       
	
	
	
 * 
 */