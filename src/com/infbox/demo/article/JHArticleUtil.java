package com.infbox.demo.article;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.sql.Connection;
import java.util.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.StringTokenizer;

import org.bson.types.ObjectId;

import javax.imageio.ImageIO;

import org.bson.types.ObjectId;

import javax.servlet.ServletOutputStream;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.infbox.demo.DBPoolTomcat;
import com.infbox.demo.DemoUtil;
import com.infbox.demo.MiscUtil;
import com.infbox.demo.MyUser;
import com.infbox.demo.Page;
import com.infbox.sdk.InfBoxUtil;
import com.infbox.util.JsonTurn;
import com.mongodb.BasicDBObject;



public class JHArticleUtil {	
	public static final int PAGE_CAPACITY=20;
	public static String getArticleContent(int actvID) {
		String data=null;
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();			
			sql = "select content from article where id=" + actvID;
			MiscUtil.debug(sql);
			stmt = DBPoolTomcat.getStatement(conn);

			rs = stmt.executeQuery(sql);
			
			if (rs.next()) {					
				data=rs.getString("content");
				
				
			} 

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);
			
		}
		return data;
	}
	
	//---读取某个文章
	public static Article getArticle(int actvID) {
		Article data=null;
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();			
			sql = "select title,postdate,readnum,userid,content,likenum,hatenum,bgimg,account,comments,state from article where id=" + actvID;
			MiscUtil.debug(sql);
			stmt = DBPoolTomcat.getStatement(conn);

			rs = stmt.executeQuery(sql);
			
			if (rs.next()) {					
				data=new Article();								
				data.id=actvID;
				data.setState(rs.getShort("state"));
				data.title=rs.getString("title");	
				data.content=rs.getString("content");				
				data.bgImg=rs.getString("bgimg");
				data.readNum=rs.getInt("readnum");
				data.userid=rs.getInt("userid");
				data.likeNum=rs.getInt("likenum");
				data.dislikeNum=rs.getInt("hatenum");
				data.account=rs.getString("account");	
				data.commentNum=rs.getInt("comments");
				java.sql.Date dt=rs.getDate("postdate");
				if(dt!=null)data.postDate=new java.util.Date (dt.getTime());
				
			} 

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {			
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);
		}
		return data;
	}

	public static ArrayList<Article> getArticleList(int ownerId) {
		ArrayList<Article> retv=null;
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;		
		try {
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();			
			sql = "select id,title,postdate,readnum,likenum,hatenum,bgimg,account,comments from article where ";
			MiscUtil.debug(sql); 
			stmt = DBPoolTomcat.getStatement(conn);
			rs = stmt.executeQuery(sql);
			retv=new ArrayList<Article>();
			while (rs.next()) {	
				Article data=new Article();								
				data.id=rs.getInt("id");
				data.title=rs.getString("title");	
				data.bgImg=rs.getString("bgimg");
				data.readNum=rs.getInt("readnum");
				data.likeNum=rs.getInt("likenum");
				data.dislikeNum=rs.getInt("hatenum");
				data.account=rs.getString("account");	
				data.commentNum=rs.getInt("comments");
				java.sql.Date dt=rs.getDate("postdate");
				if(dt!=null)data.postDate=new java.util.Date (dt.getTime());	
				System.out.println(data.id+"，阅读数="+data.readNum);
				retv.add(data);
			} 

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);
			
		}
		return retv;
	}
	public static String queryArticleList(int pageNo,int pageSize){
		try{
			Page<Article> p = null;
			List<Article> articleList = null;
			articleList=getArticleList(pageNo,pageSize);
			int tatal= getArticleCount();
			p =new Page<Article>(tatal, pageNo,pageSize);

			p.setList(articleList);
			return JsonTurn.bean2json(p); 
		}catch(Exception e){
			e.printStackTrace();
		}
		return "{}";
	}
	public static int getArticleCount() {
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;	
		int retv=0;
		try {
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();
			sql = "select count(id) from article where state>-1 ";
			MiscUtil.debug(sql); 
			stmt = DBPoolTomcat.getStatement(conn);
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				 retv=rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);
			
		}
		return retv;
	}
	//----------------
	public static ArrayList<Article> getArticleList(int pageNo,int pageSize) {
		ArrayList<Article> retv=null;
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;		
		try {
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();	
			int start=(pageNo-1)*pageSize;
			
			//关于数据量较大时的高效查询方式，可参考文章  http://www.jb51.net/article/46015.htm 
			sql = "select id,title,postdate,readnum,userid,likenum,hatenum,bgimg,comments from article where state>-1 order by  postdate desc limit "+start+","+pageSize;
			MiscUtil.debug(sql); 
			stmt = DBPoolTomcat.getStatement(conn);
			rs = stmt.executeQuery(sql);
			retv=new ArrayList<Article>();
			while (rs.next()) {	
				Article data=new Article();								
				data.id=rs.getInt("id");
				data.title=rs.getString("title");	
				data.bgImg=rs.getString("bgimg");
				data.userid=rs.getInt("userid");
				MyUser author=DemoUtil.getUserById(data.userid);
				if(author!=null) data.author=author.getName();
				else data.author="";
				data.readNum=rs.getInt("readnum");
				data.likeNum=rs.getInt("likenum");
				data.dislikeNum=rs.getInt("hatenum");				
				data.commentNum=rs.getInt("comments");
				java.sql.Date dt=rs.getDate("postdate");
				if(dt!=null)data.postDate=new java.util.Date (dt.getTime());	
				System.out.println(data.id+"，阅读数="+data.readNum);
				retv.add(data);
			} 

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);
			
		}
		return retv;
	}
	
//1=增加评论数//2=增加点赞数，3=差评数，其他值=增加阅读数
	final public static int COMMENT_COUNT=1;
	final public static int LIKE_COUNT=2;
	final public static int DISLIKE_COUNT=3;	
	final public static int TOUSU_COUNT=4;
	final public static int READ_COUNT=5;
//如果缓存里面也存在文章的记录，那么也许更新缓存	
	public static int incCount(int actvID,int type) {		
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;
		int retv=0;
		try {
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();			
			if(type==1)sql = "update article set comments=comments+1 where id=" + actvID;
			else if(type==2) sql = "update article set likenum=likenum+1 where id=" + actvID;
			else if(type==3) sql = "update article set hatenum=hatenum+1 where id=" + actvID;
			else if(type==4) sql = "update article set tousu=tousu+1 where id=" + actvID;
			else sql = "update article set readnum=readnum+1 where id=" + actvID;
			  
			MiscUtil.debug(sql);
			stmt = DBPoolTomcat.getStatement(conn);
			retv= stmt.executeUpdate(sql);			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);		
		}
		return retv;
	}
	//----屏蔽文章
	public static int screenArticle(int artID) {		
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;
		int retv=0;
		try {
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();			
			sql = "update article set state=-1 where id=" + artID;			
			MiscUtil.debug(sql);
			stmt = DBPoolTomcat.getStatement(conn);
			retv= stmt.executeUpdate(sql);			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);		
		}
		return retv;
	}

//只查看文章的标题
	public static String getTitle(long actvID) {
		String data=null;
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();			
			sql = "select title from activity where id=" + actvID;
			MiscUtil.debug(sql);
			stmt = DBPoolTomcat.getStatement(conn);
			rs = stmt.executeQuery(sql);			
			if (rs.next()) {					
				data=rs.getString("title");					
			} 

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {			
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);
			
		}
		return data;
	}
	public static String getArticlesByUser (int userid,int page,int pageSize){
		StringBuffer sb = new StringBuffer();
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;	
		ArrayList<UserArticles> userArtCnt=new ArrayList<UserArticles>();
		try{			
			UserArticles tmpuac=null;
			for(int k=0;k<userArtCnt.size();k++){
				UserArticles u2=userArtCnt.get(k);
				if(u2.userid==userid){
					tmpuac=u2;
					break;}
			}
			if(tmpuac==null){
				int total2=getUserArticlesCount(userid);
				tmpuac=new UserArticles();
				tmpuac.userid=userid;
				tmpuac.total=total2;
				userArtCnt.add(tmpuac);
			}
			Page<Article> p = new Page<Article>(tmpuac.total,page,pageSize);
			List<Article> articleList = null;
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();	
			//
			sql = "select id,title,postdate,pub_date,readnum,likenum,hatenum,bonusnum,bgimg,account,comments,urlpath,author,gzh_id,copyrightlogo from article where userid="+userid+" and state = 1 ";
			sql += "order by pub_date desc limit "+(page-1)*pageSize+","+pageSize;
			
			MiscUtil.debug(sql); 
			stmt = DBPoolTomcat.getStatement(conn);
			rs = stmt.executeQuery(sql);
			articleList=new ArrayList<Article>();
			while (rs.next()) {	
				Article data=new Article();								
				data.id=rs.getInt("id");
				//System.out.print("id="+data.id+",");
				data.title=rs.getString("title");	
				data.bgImg=rs.getString("bgimg");
				data.readNum=rs.getInt("readnum");
				data.likeNum=rs.getInt("likenum");
				data.bonusNum=rs.getInt("bonusnum");
				data.dislikeNum=rs.getInt("hatenum");
				data.account=rs.getString("account");	
				data.commentNum=rs.getInt("comments");
				java.sql.Date dt=rs.getDate("postdate");
				if(dt!=null)data.postDate=new java.util.Date (dt.getTime());
				
				java.sql.Timestamp pub_date=rs.getTimestamp("pub_date");
				if(pub_date==null)data.pub_date=data.postDate.getTime();
				else data.pub_date=pub_date.getTime();
					
				//System.out.println(data.id+"，阅读数="+data.readNum);
				data.urlpath = rs.getString("urlpath");//静态页面地址localurl
				data.author = rs.getString("author");
				//data.content = rs.getString("content");
				data.copyrightlogo = rs.getString("copyrightlogo");
				data.gzh_id = rs.getString("gzh_id");
				articleList.add(data);
			}			
			
			p.setList(articleList);
			sb.append(JsonTurn.bean2json(p)); 
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);
		}
		return sb.toString();
	}
	
	public static int getUserArticlesCount(int ownerId) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rowCount = 0; 
		try {
			String sql = "select count(id) from article where userid=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, ownerId);
			rs = pstmt.executeQuery();
			if (rs.next()) 
		       {
				rowCount = rs.getInt(1); 
		       }
			return rowCount;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.closeJDBCObj(rs, pstmt, conn);
		}
		return rowCount;
	}
	
	public static boolean addArticle(Article art) {
		Connection conn = null;
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean flag = false;
		String sql = null;
		
		try {		
			conn = DBPoolTomcat.getMainDBConn();
			if(art.id==0){//记录不存在
				sql = "insert into article (title,postdate,author,content,bgimg,userid) values (?,now(),?,?,?,?);";
				pstmt = DBPoolTomcat.prepare(conn, sql);
				pstmt.setString(1, art.title);
				pstmt.setString(2, art.author);
				pstmt.setString(3, art.content);
				pstmt.setString(4, art.bgImg);
				pstmt.setInt(5, art.userid);
				int i=pstmt.executeUpdate();
				if(i>0)flag=true;
				
			}else{//更新操作
				sql = "update article set title=?,author=?,content=?,bgimg=?,state=? where id=?";
				pstmt = DBPoolTomcat.prepare(conn, sql);
				pstmt.setString(1, art.title);
				pstmt.setString(2, art.author);
				pstmt.setString(3, art.content);
				pstmt.setString(4, art.bgImg);
				pstmt.setInt(5, art.getState());
				pstmt.setInt(6, art.id);
				int i=pstmt.executeUpdate();
				if(i>0)flag=true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.closeJDBCObj(rs, pstmt, conn);
		}
		return flag;
	}
	public static String getCounter(int actvID) {
		String result = "1@系统异常";
		Connection conn = null;		
		Statement stmt = null;
		ResultSet rs = null;	
	
		try {
			int readNum = 0;
			int commentNum = 0;
			int likeNum = 0;
			int bonusNum = 0;
			String sql = null;
			conn = DBPoolTomcat.getMainDBConn();
			sql = "update article set readnum = readnum + 1 where id="+actvID;
			stmt = DBPoolTomcat.getStatement(conn);
			stmt.executeUpdate(sql);
			sql = "select readnum,likenum,comments,bonusnum from article where id=" + actvID;
			rs=stmt.executeQuery(sql);
			if(rs.next()){
							
				readNum = rs.getInt(1);
				commentNum = rs.getInt(3);
				likeNum = rs.getInt(2);
				bonusNum = rs.getInt(4);
				
			}
			
			
			result = "0@"+readNum+","+commentNum+","+likeNum+","+bonusNum;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.closeJDBCObj(rs, stmt, conn);
		}
		return result;
	}
}