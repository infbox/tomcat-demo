package com.infbox.demo.article;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.infbox.demo.DBPoolTomcat;
import com.infbox.demo.MyUser;
import com.infbox.demo.Page;

public class ArticleCollectUtil {
	
	public static int addCollect(ArticleCollect articleCollect){
		Connection conn = null;
		int ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String sql = "insert into article_collect (userId,articleId,title,author,bgimg,collect_time,urlpath) values (?,?,?,?,?,now(),?);";
			pstmt = DBPoolTomcat.prepare(conn, sql);	
			pstmt.setLong(1, articleCollect.getUserId());
			pstmt.setInt(2, articleCollect.getArticleId());
			pstmt.setString(3, articleCollect.getTitle());
			pstmt.setString(4, articleCollect.getAuthor());			
			pstmt.setString(5, articleCollect.getBgimg());		
			pstmt.setString(6, articleCollect.getUrlpath());	
			pstmt.executeUpdate();			
			ret = 1;
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}
	
	public static int delCollect(long userId,int articleId){
		Connection conn = null;
		int ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//
			String sql = "DELETE FROM article_collect where userId=? and articleId = ?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, userId);	
			pstmt.setInt(2, articleId);	
			ret = pstmt.executeUpdate();	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}
	
	
	public static  ArrayList<ArticleCollect>  getCollectList(int userId,Page page) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArticleCollect fw = null;
		ArrayList<ArticleCollect> list=new ArrayList<ArticleCollect> ();
		try {
			//
			String sql = "select * from article_collect where userId=? order by collect_time";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, userId);
			pstmt.setMaxRows(page.getEndIndex());
			rs = pstmt.executeQuery();
            if (page.getBeginIndex() > 0) {  
                rs.absolute(page.getBeginIndex());
            }  
			while (rs.next()){
				fw = new ArticleCollect();	
				fw.setId(rs.getInt("id"));
				fw.setUserId(rs.getInt("userId"));
				fw.setArticleId(rs.getInt("articleId"));
				fw.setCollectTime(rs.getTimestamp("collect_time"));
				fw.setAuthor(rs.getString("author"));
				fw.setBgimg(rs.getString("bgimg"));
				fw.setUrlpath(rs.getString("urlpath"));//相对路径
				fw.setTitle(rs.getString("title"));
				list.add(fw);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return list;
	} 
	
	
	public static int getCount(int userId) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rowCount = 0; 
		try {
			String sql = "select count(id) from article_collect where userId = ?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) 
		       {
				rowCount = rs.getInt(1); 
		       }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return rowCount;
	}

	public static ArticleCollect findByUserId(long userId, int articleId) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArticleCollect activityCollect = null;
		try {
			conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
			String sql = "select * from article_collect where userId=? and articleId = ?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, userId);
			pstmt.setInt(2, articleId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				activityCollect = new ArticleCollect();				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return activityCollect;
	}
}
