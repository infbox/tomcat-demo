package com.infbox.demo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.infbox.sdk.AccessToken;
import com.infbox.sdk.IBWSServer;
import com.infbox.sdk.InfBoxUtil;

/*
 * 用于处理手机客户端分享信息的代码，先获取用户的身份，然后解析要分享的数据
 * */
public class ShareAPIUtil {
	private static HashMap<String,Long> userTokenCache;
	private static HashMap<String,Long> getUserTokenCache(){
		if(userTokenCache==null) userTokenCache=new HashMap<String,Long>();
		return userTokenCache;
	}
	public static String shareWeb(HttpServletRequest request,
			HttpServletResponse response) {
		System.out.println("ShareAPIUtil.shareWeb is called");
		String appName = request.getParameter("appName");
		if (appName == null) {
			return "{\"result\":\"0\",\"value\":\"error1\"}";
		}
			
		String code = request.getParameter("code");// 我们要的code
		System.out.println("code=" + code);
		long userid=getUserId(code);
		if(userid==-3) return "{\"result\":\"0\",\"value\":\"code_error\"}";
		else if(userid==-4) return "{\"result\":\"0\",\"value\":\"param_error\"}";
		else if(userid==-5) return "{\"result\":\"0\",\"value\":\"token_error\"}";
		else if(userid>0){
			//已经获得用户Id,现在开始把分享的信息存入数据库中
			String comment=request.getParameter("comment");
			String title=request.getParameter("title");
			String pic=request.getParameter("pic");
			String url=request.getParameter("url");
			System.out.println("comment=" + comment+",title"+title+",pic="+pic+",url"+url);	
			/*JSONObject obj= new JSONObject();
			obj.put("type", 1);//1=分享链接
			obj.put("title", title);
			obj.put("pic", pic);
			obj.put("url", url);
			CircleUtil.addShareImgs(obj.toString(), comment, userid, appName);*/
			//华中龙的分享页面
			JSONObject obj= new JSONObject();			
			obj.put("title", title);
			obj.put("img", pic);
			obj.put("url", url);
			CircleUtil.addShareWeb2(obj.toString(), comment, userid, appName);
			return "{\"result\":\"1\",\"value\":\"ok\"}";
		}else return "{\"result\":\"0\",\"value\":\"error\"}";
		
	}
	//------------------------
	public static String shareText(HttpServletRequest request,
			HttpServletResponse response) {
		System.out.println("ShareAPIUtil.shareText is called");
		String appName = request.getParameter("appName");
		if (appName == null) {
			return "{\"result\":\"0\",\"value\":\"error1\"}";
		}
			
		String code = request.getParameter("code");// 我们要的code
		System.out.println("code=" + code);
		long userid=getUserId(code);
		if(userid==-3) return "{\"result\":\"0\",\"value\":\"code_error\"}";
		else if(userid==-4) return "{\"result\":\"0\",\"value\":\"param_error\"}";
		else if(userid==-5) return "{\"result\":\"0\",\"value\":\"token_error\"}";
		else if(userid>0){
			//已经获得用户Id,现在开始把分享的信息存入数据库中
			String comment=request.getParameter("comment");
			//CircleUtil.addShareImgs("", comment, userid, appName);//杨冠林版本
			CircleUtil.addShareImgs2("", comment, userid, appName);//华中龙
			System.out.println("comment=" + comment+",userid="+userid);			
			
			return "{\"result\":\"1\",\"value\":\"ok\"}";
		}else return "{\"result\":\"0\",\"value\":\"error\"}";
		
	}
	
	public static Boolean isQiNiuPic(){
		Boolean ret=false;//如果使用了七牛服务器，设为true
		return ret;
	}
	
	// 手机客户端在上传分享图片前，申请获取图片服务器的url和上传token
	public static String getUploadParameter(HttpServletRequest request,
			HttpServletResponse response) {
		System.out.println("ShareAPIUtil.getUploadParameter is called");
					
		String code = request.getParameter("code");// 我们要的code
		System.out.println("code=" + code);
		Long userid=getUserId(code);
		
		if(userid==-3) return "{\"result\":\"0\",\"value\":\"code_error\"}";
		else if(userid==-4) return "{\"result\":\"0\",\"value\":\"param_error\"}";
		else if(userid==-5) return "{\"result\":\"0\",\"value\":\"token_error\"}";
		else if(userid>0){
			//已经获得用户Id,现在生成一个uploadToken用于手机端上传图片到七牛 ，再生成一个shareToken,用于提交分享数据
			//如果是自定义服务器，可以让uploadToken和shareToken的内容一样
			//如果是七牛服务器，upToken是根据七牛算法生成的， shareToken是自己服务器处理分享数据提交的
			String shareToken=DemoUtil.randomString(12);
			 
			String upToken=QiNiuUploadUtil.getUploadToken();
			JSONObject json=JSONObject.fromObject("{}");
			json.put("userid", userid);
			
			json.put("shareToken", shareToken);
			//下面根据实际情况可以调整
			Boolean useQiNiu=true;
			if(useQiNiu){//七牛服务器
				upToken=QiNiuUploadUtil.getUploadToken();
				json.put("upToken", upToken);
				json.put("url", "qiniu");//如果是自有服务器，则填写图片上传的url,http://xxxx
				json.put("domain", QiNiuUploadUtil.accessDomain);//
			}else{//自有服务器
				upToken=shareToken;//适用于只有服务器
				json.put("upToken", upToken);
				json.put("url", InfBoxUtil.SITE_URL+"/upload.jsp");//如果是自有服务器，则填写图片上传的url,http://xxxx
				json.put("domain", InfBoxUtil.SITE_URL+"/upload/");//自己的图片存放网址的前缀 ，如果上传后直接返回图片url,则此处为空
				
			}
			
			//先保存起来，因为用户稍后还要提交分享数据的时候，校验shareToken
			//if(userTokenCache==null) userTokenCache=new HashMap<String,Long>();
			getUserTokenCache().put(shareToken, userid);
			System.out.println("return upload params=" + json.toString());						
			return json.toString();
		}else return  "{\"result\":\"0\",\"value\":\"error\"}";
		
	}
	public static Long isValidShareToken(String token){
		Long userId=getUserTokenCache().get(token);
		/*if(userId!=null)  {
			//getUserTokenCache().remove(token);//也可以设计为有效时间为5分钟，过期自动删除			
		}*/
		return userId;
		
	}
	public static String shareMedia(HttpServletRequest request,
			HttpServletResponse response) {
		System.out.println("ShareAPIUtil.shareMedia is called");
		String appName = request.getParameter("appName");
		if (appName == null) {
			return "{\"result\":\"0\",\"value\":\"error1\"}";
		}			
		String share_token = request.getParameter("share_token");
		
		Long userId=getUserTokenCache().get(share_token);
		if(userId==null) return "{\"result\":\"0\",\"value\":\"token_error\"}";
		String comment= request.getParameter("comment");
		String url= request.getParameter("pic_list");//
		if(url==null)url="";
		String[] picArray=url.split(",");//图片数组url
		String s1= picArray[0];
		if(s1.endsWith(".mp4") || s1.endsWith(".flv") ){
			//CircleUtil.addShareVideo(s1, comment, userId, appName);//杨冠林版本
			CircleUtil.addShareVideo2(s1, comment, userId, appName);
		}else {//判断要不要加图片的前缀路径
			StringBuilder sb2=new StringBuilder();
			for(String s:picArray){
				int ii=s.lastIndexOf("/");
				if(ii>4 && s.length()>5)sb2.append(s.substring(ii+1)).append(",");
				else if(s.length()>5)sb2.append(s).append(",");
			}
			url=sb2.toString();
			//CircleUtil.addShareImgs(url, comment, userId, appName);//杨冠林版本
			CircleUtil.addShareImgs2(url, comment, userId, appName);
		}
		//把前缀域名去掉,再保存
		
		System.out.println("share_token=" + share_token+",userid="+userId+",picArray="+url+",comment="+comment);		

		return "{\"result\":\"1\",\"value\":\"ok\"}";
		
	}
	
	private static long getUserId(String code){
		if (code == null || code.startsWith("error_")) {			
			return  -3;//"error_no_code";
		} else {
			MyUser user = null;			
			
			Map<String, Object> data = InfBoxUtil.getAccessTokenInfo(code);
			System.out.println("data=" + data.toString());
			// 这儿的data只是access_token, openid，还没有nickname
			if (InfBoxUtil.ac == null)
				InfBoxUtil.ac = new AccessToken();
			// String accessToken=null;
			String OpenId = null;
			if (data.get("access_token") != null) {
				InfBoxUtil.ac.token = data.get("access_token").toString();
			}
			if (data.get("openid") != null) {
				OpenId = data.get("openid").toString();

			} else {
				// openid=null说明用户的token不对，提醒用户重新登录抓信
				// out.println("用户身份失效，请重新登录抓信客户端！");
				return -5;//"token_error";
			}

			user = DemoUtil.getUserByInfBoxId(OpenId);

			if (user == null) {
				data = InfBoxUtil.getUserInfo(OpenId, InfBoxUtil.ac.token);
				user = new MyUser();
				String nickName = data.get("nickname").toString();
				String headImg = data.get("headImg").toString();
				user.setIBOpenId(OpenId);
				user.setName(nickName);
				user.setHeadPic(headImg);
				// 既然本地数据库没有，就是新用户，先添加到本地数据库
				long id = DemoUtil.addUser(nickName, OpenId, headImg);
				user.setId(id);
			}else if(user.headPic==null || user.headPic.length()<5){
				data = InfBoxUtil.getUserInfo(OpenId, InfBoxUtil.ac.token);						
				String headImg = data.get("headImg").toString();
				DemoUtil.updateHeadPic(user.getId(), headImg);
			}
			System.out.println("user=" + user.getName());
			return user.getId();
		}//end of if code else
		
	}
}
