<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*,com.infbox.demo.*"%>
<%@ page import="java.io.*,com.infbox.sdk.*"%>
<%@ page import="com.jspsmart.upload.File"%>
<%@ page import="com.jspsmart.upload.Files"%>
<%@ page import="java.awt.Image,java.awt.image.*"%>
<%@ page import="com.sun.image.codec.jpeg.*"%>
<%@ page import="com.jspsmart.upload.SmartUpload"%>
<%@ page session="true" %>  
<%
/*
该页面用于处理抓信上传图片到插件的时候，如果没有用七牛，则使用这个页面来上传图片到服务器
头像保存到服务器的时候，七牛有缓存，所以，如果头像的名称如果每次都一样，那么用户更新头像的时候，从七牛读取不到最新的版本
所以，为了解决这个问题，每次都要在头像文件名中加入时间戳。
但为了防止tomcat服务器上的临时缓存太多，tomcat缓存的头像，每次文件名都一样。
*/
InfBoxUtil.log("上传图片了");
	request.setCharacterEncoding("UTF-8");
			//处理图片
			SmartUpload su = new SmartUpload();//creat new SmartUpload object 
			long file_size_max = 4000000;//the bigest size of file
			String fileExt = "";
			String photoFolder = "upload";
			String absolute=application.getRealPath("/");
			//if(!absolute.endsWith("/"))absolute=absolute+"/";
			String url = absolute + photoFolder; //the path of save upload file
			java.io.File file =new java.io.File(url);    
			//如果文件夹不存在则创建    
			if  (!file .exists()  && !file .isDirectory())      
			{       
			    System.out.println("//不存在");  
			    file .mkdir();    
			} else   
			{  
			    System.out.println("//目录存在");  
			}  
			//System.out.println("当前项目路径：" + url);//
			su.initialize(pageContext);// init su
			try {
				su.setAllowedFilesList("jpg,JPG,PNG,BMP,GIF,MP4,png,jpeg,bmp,gif,mp4,3gp");//the type of upload file
				su.upload();//上传
			} catch (Exception e) {
				e.printStackTrace();
				if(e instanceof NegativeArraySizeException){
					out.print("no_file_data_error");
					InfBoxUtil.log("no_file_data_error");
				}else{
					out.print("type_not_supported_error");
					InfBoxUtil.log("type_not_supported_error");
				}
				
				return;
		
			}	
			
			
			String token=su.getRequest().getParameter("token");
			if(token==null){
				out.print("no_token_error");
				InfBoxUtil.log("token not set");
				return;
			}
			//根据token获得用户id
			Long userid=ShareAPIUtil.isValidShareToken(token);
			if(userid==null || userid==0){
				out.print("illegal_token_error");
				InfBoxUtil.log("token illegal ");
				return;
			}
			String key=su.getRequest().getParameter("key");//客户端希望保存的文件名，也可以服务器自己生产key
			InfBoxUtil.log("key="+key+",userid="+userid+",token="+token);
		//如果没有文件上传，那么就直接返回
		int totalF=su.getFiles().getCount();
		if(totalF<1){
			out.print("no_file_data_error");
			InfBoxUtil.log("no_file_data");
			return;
		}
		try {
			for (int i = 0; i < totalF; i++) {
				com.jspsmart.upload.File myFile = su.getFiles().getFile(i);				
				if (myFile.isMissing()) {
					
				} else {
					fileExt = myFile.getFileExt(); //取得文件后缀名
					InfBoxUtil.log("fileExt="+fileExt);
					int file_size = myFile.getSize(); //取得文件的大小
					String fileurl = "";
					if (file_size < file_size_max) {
						//更改文件名，取得当前上传时间的毫秒数值
						//Calendar calendar = Calendar.getInstance();
						long t1 = System.currentTimeMillis(); //系统时间戳
						//用时间戳+文件的序号命名
						String filename = "ib_"+userid+t1 + Integer.toString(i)+"."+fileExt;	
						if(key!=null && key.contains("."))filename=key;
						fileurl = url + ("/");						
						fileurl += filename; //图片上传后的路径
						InfBoxUtil.log("save PHYSICAL path:"+fileurl);
						
						myFile.saveAs(fileurl, SmartUpload.SAVE_PHYSICAL);//保存上传的文件到web服务器路径下
						InfBoxUtil.log("save ok,fileurl="+fileurl);
						 
						 out.print(InfBoxUtil.SITE_URL+"/upload/"+filename);
							
							return;
					

					} else {
						out.print("file_size_exceed_error");
						return;
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			out.print(e.toString());
			out.print("error");
			InfBoxUtil.log("error 90");
			return;
		}
			
%>