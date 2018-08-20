package com.infbox.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/*
 * 朋友圈的操作类，主要是向数据库写入分享的内容
 * */
public class CircleUtil {

	public static long addShareURL(String authorId, String content, long postId,String appName) {
		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String sql = "insert into comment (post_id,content,user_id,add_time) values (?,?,?,now());";
			pstmt = DBPoolTomcat.prepare(conn, sql,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setLong(1, postId);
			pstmt.setString(2, content);
			pstmt.setString(3, authorId);

			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

			rs.next();
			ret = rs.getLong(1);//

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.closeJDBCObj(rs, pstmt, conn);			
		}
		return ret;
	}
	
	public static long addShareImgs(String picList , String content, long authorId,String appName) {
		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			MyUser user=DemoUtil.getUserById(authorId);
			if(user!=null){
				String sql = "insert into announcement(ann_user_id,ann_user_name,ann_user_headpic,ann_title,ann_dec,ann_picUrls,ann_create_time,ann_update_time,ann_type,ann_content) values (?,?,?,?,?,?,now(),now(),2,'{}');";
				pstmt = DBPoolTomcat.prepare(conn, sql,
						PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setLong(1, authorId);
				pstmt.setString(2, user.getName());
				pstmt.setString(3, user.headPic);
				String sTitle=null;
				if(content.length()>29)sTitle=content.substring(0,28)+"...";
				else sTitle=content;
				pstmt.setString(4, sTitle);
				pstmt.setString(5, content);
				pstmt.setString(6, picList);

				pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();

				rs.next();
				ret = rs.getLong(1);//
			}
			

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.closeJDBCObj(rs, pstmt, conn);			
		}
		return ret;
	}
	
	public static long addShareVideo(String videoUrl , String content, long authorId,String appName) {
		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			MyUser user=DemoUtil.getUserById(authorId);
			if(user!=null){
				String sql = "insert into announcement(ann_user_id,ann_user_name,ann_user_headpic,ann_title,ann_dec,ann_mvUrls,ann_create_time,ann_update_time,ann_type,ann_content) values (?,?,?,?,?,?,now(),now(),2,'{}');";
				pstmt = DBPoolTomcat.prepare(conn, sql,
						PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setLong(1, authorId);
				pstmt.setString(2, user.getName());
				pstmt.setString(3, user.headPic);
				String sTitle=null;
				if(content.length()>29)sTitle=content.substring(0,28)+"...";
				else sTitle=content;
				pstmt.setString(4, sTitle);
				pstmt.setString(5, content);
				pstmt.setString(6, videoUrl);

				pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();

				rs.next();
				ret = rs.getLong(1);//
			}
			

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.closeJDBCObj(rs, pstmt, conn);			
		}
		return ret;
	}
	//--新版本的分享到朋友圈-----------------------
	public static long addShareImgs2(String picList , String content, long authorId,String appName) {
		String ss,sPic;
		if(content.length()>70)ss=content.substring(0,70)+"...";
		else ss=content;
		if(picList==null )sPic="";
		else sPic=picList;
		
		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			MyUser user=DemoUtil.getUserById(authorId);
			if(user!=null){
				String sql = "insert into share_pyq(type,content,url,add_time,author_id,author_name,author_img) values (1,?,?,now(),?,?,?);";
				pstmt = DBPoolTomcat.prepare(conn, sql,
						PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, ss);
				pstmt.setString(2, sPic);
				pstmt.setLong(3, user.getId());
				pstmt.setString(4, user.getName() );
				pstmt.setString(5, user.headPic);
				pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();

				rs.next();
				ret = rs.getLong(1);//
			}
			

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.closeJDBCObj(rs, pstmt, conn);			
		}
		return ret;
	}
	public static long addShareVideo2(String videoUrl , String content, long authorId,String appName) {
		String ss,sUrl;
		if(content==null)ss="";
		else ss=content;
		if(videoUrl==null )sUrl="";
		else sUrl=videoUrl;
		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			MyUser user=DemoUtil.getUserById(authorId);
			if(user!=null){
				String sql = "insert into share_pyq(type,content,url,add_time,author_id,author_name,author_img) values (2,?,?,now(),?,?,?);";
				pstmt = DBPoolTomcat.prepare(conn, sql,
						PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, ss);
				pstmt.setString(2, sUrl);
				pstmt.setLong(3, user.getId());
				pstmt.setString(4, user.getName() );
				pstmt.setString(5, user.headPic);

				pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();

				rs.next();
				ret = rs.getLong(1);//
			}
			

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.closeJDBCObj(rs, pstmt, conn);			
		}
		return ret;
	}
	public static long addShareWeb2(String jsonInfo , String content, long authorId,String appName) {
		String ss,sUrl;
		if(content==null)ss="";
		else ss=content;
		if(jsonInfo==null )return 0;
		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			MyUser user=DemoUtil.getUserById(authorId);
			if(user!=null){
				String sql = "insert into share_pyq(type,content,url,add_time,author_id,author_name,author_img) values (0,?,?,now(),?,?,?);";
				pstmt = DBPoolTomcat.prepare(conn, sql,
						PreparedStatement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, ss);
				pstmt.setString(2, jsonInfo);
				pstmt.setLong(3, user.getId());
				pstmt.setString(4, user.getName() );
				pstmt.setString(5, user.headPic);

				pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();

				rs.next();
				ret = rs.getLong(1);//
			}
			

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.closeJDBCObj(rs, pstmt, conn);			
		}
		return ret;
	}
}
