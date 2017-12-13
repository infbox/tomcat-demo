package com.infbox.demo.article;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;

import com.infbox.demo.DBPoolTomcat;
import com.infbox.demo.Page;

/*
 * 用户留言的数据库操作
 * */
public class LiuyanUtil {
	//发送一条留言
	public static int addLiuyan(long sendId, int recvId,String content,short type,String ownerName,String friendName) {

		Connection conn = null;
		int ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {

			String sql = "insert into liuyan (owner,friend,sender,receiver,type,content,send_time,owner_name,friend_name)" +
					" values (?,?,?,?,?,?,now(),?,?);";
			//注意，一次留言产生两条记录，参考设计思路：http://www.oschina.net/question/12_70252?sort=default&p=1
			pstmt = DBPoolTomcat.prepare(conn, sql);	
			pstmt.setInt(1, recvId );
			pstmt.setLong(2, sendId);
			pstmt.setLong(3, sendId);
			pstmt.setInt(4, recvId);
			pstmt.setInt(5, type);
			pstmt.setString(6, content);
			pstmt.setString(7, ownerName);
			pstmt.setString(8, friendName);
			pstmt.addBatch();		
			//如果不是系统消息，就给发送者保留记录
			if(type!=9){//9代表系统消息
				pstmt.setLong(1, sendId);
				pstmt.setInt(2, recvId);
				pstmt.setLong(3, sendId);
				pstmt.setInt(4, recvId);
				pstmt.setInt(5, type);
				pstmt.setString(6, content);
				pstmt.setString(7, friendName);
				pstmt.setString(8, ownerName);
				pstmt.addBatch();
			}
			
			pstmt.executeBatch();			
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
	
	//查询用户留言，我发的消息列表， 我接收的消息列表
	/*今天再sqlite上面试了试，比如下面的sql语句：
① selete * from testtable limit 2,1;
② selete * from testtable limit 2 offset 1;
这两个都是能完成需要，但是他们之间是有区别的：
①是从数据库中第三条开始查询，取一条数据，即第三条数据
②是从数据库中的第二条数据开始查询两条数据，即第二条和第三条。
	 * */
	public static  ArrayList<Liuyan>  getLiuyanList(int ownerId,Page page) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Liuyan fw = null;
		ArrayList<Liuyan> list=new ArrayList<Liuyan> ();
		try {
			//
			String sql = "select * from liuyan where owner=? order by send_time desc";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, ownerId);
			pstmt.setMaxRows(page.getEndIndex());
			rs = pstmt.executeQuery();
            if (page.getBeginIndex() > 0) {  
                rs.absolute(page.getBeginIndex());
            }  
			while (rs.next()){
				fw = new Liuyan();				
				fw.id=rs.getLong("id");
				fw.owner=rs.getInt("owner");
				fw.friend=rs.getInt("friend");
				fw.sender=rs.getInt("sender");
				fw.receiver=rs.getInt("receiver");
				fw.content = rs.getString("content");
				fw.sendTime=rs.getTimestamp("send_time");
				fw.readTime=rs.getTimestamp("read_time");
				fw.setFriendName(rs.getString("friend_name"));
				fw.setOwnerName(rs.getString("owner_name"));
				fw.type=rs.getShort("type");
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

	
	public static int getLiuyanListCount(int ownerId) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rowCount = 0; 
		try {
			String sql = "select count(id) from liuyan where owner=?";
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
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return rowCount;
	}
	
	
	public static int delLiuyan(long id,long ownerId) {
		Connection conn = null;
		int ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//
			String sql = "DELETE FROM liuyan WHERE id =? and owner = ?";
			pstmt = DBPoolTomcat.prepare(conn, sql,PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setLong(1, id);	
			pstmt.setLong(2, ownerId);	
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
}
