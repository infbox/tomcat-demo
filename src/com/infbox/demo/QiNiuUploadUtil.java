package com.infbox.demo;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.infbox.util.BASE64;

import com.qiniu.common.QiniuException;
import com.qiniu.common.Zone;
import com.qiniu.http.Response;
import com.qiniu.storage.BucketManager;
import com.qiniu.storage.Configuration;
import com.qiniu.storage.UploadManager;
import com.qiniu.storage.model.DefaultPutRet;
import com.qiniu.storage.model.FileInfo;
import com.qiniu.storage.model.FileListing;
import com.qiniu.util.Auth;

public class QiNiuUploadUtil {
	//下面四项配置要改成您自己的七牛服务器的配置信息
	public final static String accessDomain = "http://xxx.xxx.com/";
	private final static String bucketRoot = "xxx";
	private final static String ACCESS_KEY = "xxxxxxxxx";
	private final static String SECRET_KEY = "xxxxxxxxxxx";
	private  static  Auth auth ;
	private static UploadManager uploadManager;
	private static BucketManager bucketManager ;
	private static Boolean param_error=false;
	private static BucketManager getBManager(){
		if(param_error )return null;
		try {
			if(bucketManager==null ) {
				if(auth==null)auth = Auth.create(ACCESS_KEY, SECRET_KEY);
				Configuration cfg = new Configuration(Zone.zone0());
				bucketManager = new BucketManager(auth, cfg);
			}
		} catch (Exception e) {
			param_error=true;
			e.printStackTrace();
		}
		return bucketManager;
	}
	
	public static List<String> listPrefix(String prefix){
		if(param_error )return null;
		List<String> data=new ArrayList<String>();
		try {
			FileListing fl=getBManager().listFiles(bucketRoot, prefix, "", 50, "");
			FileInfo[] itens=fl.items;			
			for(FileInfo info:fl.items){
				data.add(info.key);
			}
		} catch (QiniuException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return data;
	}
	/**
	 * 上传图片到云分布存储系统  http访问：accessDomain + fileKey
	 * @param fileUrl 本地文件路径
	 * @param fileKey 存储到云文件名称 
	 * @return 文件名称
	 */
	public static String uploadFileToRemoteFs(String fileUrl,String fileKey){		
		if(uploadManager==null){
			Configuration cfg = new Configuration(Zone.zone0());
			uploadManager = new UploadManager(cfg);
		}
		if(param_error )return null;
        try {
        	String upToken = auth.uploadToken(bucketRoot);        		
			System.out.println("uptoken: \n"+upToken);			
			Response response = uploadManager.put(fileUrl, fileKey, upToken);
			//解析上传成功的结果
		    DefaultPutRet putRet = new Gson().fromJson(response.bodyString(), DefaultPutRet.class);
			return putRet.key;
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.toString());
		}
        return null;
	}
	
	public static String getUpToken(){
		if(param_error )return null;
		return auth.uploadToken(bucketRoot);   
	}
	//客户端申请上传参数	
	public static String getUploadToken(){		
	        String bucketName = bucketRoot;
	        try {
	        	if(auth==null)auth = Auth.create(ACCESS_KEY, SECRET_KEY);				
				String uptoken = auth.uploadToken(bucketRoot); 
				return uptoken;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println(e.toString());
			}
	        return "";
	}
		
	
	public static void deleteFile(String key) {				
		if(bucketManager==null) {
			Configuration cfg = new Configuration(Zone.zone0());
			bucketManager = new BucketManager(auth, cfg);
		}
		if(param_error )return ;
		  try {
			bucketManager.delete(bucketRoot, key);
		} catch (QiniuException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
	
	
	public static void main(String[] args){			
		String fileURL="d:"+File.separator+"test.png";
		String fkey="sq_"+System.currentTimeMillis()+"_"+"test.png";
		String ss=uploadFileToRemoteFs(fileURL,fkey);
		System.out.println("return: "+ss);
	}
}
