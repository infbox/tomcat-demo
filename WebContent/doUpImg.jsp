
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="com.jspsmart.upload.SmartUpload"%>
<%@ page import="java.util.*"%>
<%@ page import="com.infbox.demo.*"%>

<%@ page import="com.jspsmart.upload.File"%>
<%@ page import="com.jspsmart.upload.Files"%>
<%@ page import="java.awt.Image,java.awt.image.*"%>
<%@ page import="com.sun.image.codec.jpeg.*"%>
<%
			/* MyUser user = (MyUser) session.getAttribute("user");
			if (user == null) {
				response.sendRedirect("/login.jsp");
				return;
			} */
			request.setCharacterEncoding("UTF-8");
			String action = request.getParameter("action");

				//处理上传图片	
				String pic1 = null;
				
				SmartUpload su = new SmartUpload();//creat new SmartUpload object
				long file_size_max = 1024000;//the bigest size of file1M
				String fileExt = "";
				String photoFolder = "uploadImgs";//将来从数据库中读取
				String absolute=application.getRealPath("/");
				if( (!absolute.endsWith("/")) && (!absolute.endsWith("\\")) )absolute=absolute+"/";
				String url = absolute + photoFolder; //the path of save upload file
				//String url = application.getRealPath("/") + photoFolder; //the path of save upload file
				System.out.println("当前项目路径：" + url);//
				MiscUtil.checkdDir(url);
				
				su.initialize(pageContext);// init su
				try {
					su.setAllowedFilesList("jpg,JPG,PNG,BMP,GIF,png,jpeg,bmp,gif");//the type of upload file
					su.upload();//上传
				} catch (Exception e) {
					e.printStackTrace();		
					out.println("只允许上传jpg,png,jpeg,bmp和gif类型图片文件");
					return;	
				}
				try {

					for (int i = 0; i < su.getFiles().getCount(); i++) {
							com.jspsmart.upload.File myFile = su.getFiles().getFile(i);
			
							if (myFile.isMissing()) {							
									out.println("请选择要上传的文件");
									return;					
					
							} else {
								fileExt = myFile.getFileExt(); //取得文件后缀名
								int file_size = myFile.getSize(); //取得文件的大小
								String fileurl = "";
								if (file_size < file_size_max) {
									//更改文件名，取得当前上传时间的毫秒数值
									//Calendar calendar = Calendar.getInstance();
									long t1 = System.currentTimeMillis(); //系统时间戳
									//用时间戳+文件的序号命名
									String filename = t1 + Integer.toString(i);//myFile.getFileName();

									//fileurl=application.getRealPath("/")+url;
									fileurl = url + ("/");
									fileurl += filename + "." + fileExt; //图片上传后的路径
									myFile.saveAs(fileurl,SmartUpload.SAVE_PHYSICAL);//保存上传的文件到web服务器路径下
									String fileAcessKey="test"+filename+"."+fileExt;
									String retKey= QiNiuUploadUtil.uploadFileToRemoteFs(fileurl,fileAcessKey);
									if(retKey!=null && retKey.length()>4){
										MiscUtil.debug("成功上传图片返回："+QiNiuUploadUtil.accessDomain+retKey);
										//然后别忘了删除临时文件
										java.io.File f = new java.io.File(fileurl);  
										f.delete();
										out.print(QiNiuUploadUtil.accessDomain+retKey);
									}else{
										//使用本地目录										
										MiscUtil.debug("成功上传图片返回："+fileAcessKey);
										out.print("uploadImgs"+java.io.File.separator+filename + "." + fileExt);
									}
									
										
									
								} else {					
									out.println("上传文件大小不能超过"
									+ (file_size_max / 1000) + "K");
									return;
								}
							}//end file missing
						}//end for file index
						
					} catch (Exception e) {
							e.printStackTrace();		
							out.println("上传出错");
							return;	
					}
			
					
				
				

		%>