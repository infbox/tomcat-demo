package com.infbox.pyq;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.infbox.demo.DBPoolTomcat;
import com.infbox.demo.MyUser;
import com.infbox.demo.Page;


public class PyqLikeUtil {
	private static final Logger log = LoggerFactory.getLogger(PyqLikeUtil.class);
	
	
	public static int saveOrUpdate(PyqLike like){
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmtLike = null;
		ResultSet rsLike = null;
		int userId = like.getUserId();
		String userName = like.getUserName();
		int pyqId = like.getPyqId();
		String state = like.getState();
		int row=0;
		try {
			String sql = "select * from pyq_like where user_id=? and pyq_id=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, pyqId);
			rs = pstmt.executeQuery();
			if(!rs.next()){
				String sqlAdd = "insert into pyq_like (pyq_id,user_id,user_name,state,create_time) values (?,?,?,?,now());";
				pstmtLike = DBPoolTomcat.prepare(conn, sqlAdd,PreparedStatement.RETURN_GENERATED_KEYS);
				pstmtLike.setInt(1, pyqId);
				pstmtLike.setInt(2, userId);
				pstmtLike.setString(3, userName);
				pstmtLike.setString(4, "1");
				row=pstmtLike.executeUpdate();
				//rsLike = pstmt.getGeneratedKeys();
				//row = rsLike.getRow();
				String sqlUpdate = "update share_pyq set num=? where id=?;";
				pstmt = DBPoolTomcat.prepare(conn, sqlUpdate);
				pstmt.setInt(1, 1);
				pstmt.setInt(2, pyqId);
				row = pstmt.executeUpdate();
			}else{
				int id = rs.getInt("id");
				String sqlUpdate = "update pyq_like set state=?,create_time=now() where id=?;";
				pstmt = DBPoolTomcat.prepare(conn, sqlUpdate);
				if("0".equals(state)){
					pstmt.setString(1, "1");
				}else{
					pstmt.setString(1, "0");
				}
				pstmt.setInt(2, id);
				row = pstmt.executeUpdate();
				
				String sqlPyq = "select num from share_pyq where id= ? ";
				pstmt = DBPoolTomcat.prepare(conn, sqlPyq);
				pstmt.setInt(1, pyqId);
				rs=pstmt.executeQuery();
				
				int num=0;
				while(rs.next()){
					num = rs.getInt("num");
				}
				String sqlUpdatePyq = "update share_pyq set num=? where id=?;";
				pstmt = DBPoolTomcat.prepare(conn, sqlUpdatePyq);
				if("0".equals(state)){
					pstmt.setInt(1, num+1);
				}else{
					if(num-1>0)pstmt.setInt(1, num-1);
					else pstmt.setInt(1, 0);
				}
				pstmt.setInt(2, pyqId);
				row=pstmt.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(rsLike);
			DBPoolTomcat.close(pstmtLike);
			DBPoolTomcat.close(conn);
		}
		return row;
	}	
}
