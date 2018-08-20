package com.infbox.pyq;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
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
import com.infbox.sdk.InfBoxUtil;



public class PyqCommentUtil {
	private static final Logger log = LoggerFactory.getLogger(PyqCommentUtil.class);
	
	
	public static int save(PyqComment com){
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int userId = com.getUserId();
		String userName = com.getUserName();
		int pyqId = com.getPyqId();
		String comText = com.getComText();
		int row=0;
		int comId =0;
		try {
			String sqlAdd = "insert into pyq_comment (pyq_id,user_id,user_name,com_text,create_time) values (?,?,?,?,now())";
			pstmt = DBPoolTomcat.prepare(conn, sqlAdd,PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, pyqId);
			pstmt.setInt(2, userId);
			pstmt.setString(3, userName);
			pstmt.setString(4, comText);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if(rs!= null && rs.next()){
				java.sql.ResultSetMetaData mmm=rs.getMetaData();
				int cInt1=mmm.getColumnCount();
				//String s3=mmm.getColumnName(0);
				//comId = rs.getInt("GENERATED_KEY");
				comId = rs.getInt(1);
			     System.out.println("Generated Emp Id: "+comId);
			} else {
			     System.out.println("No KEYS GENERATED");
			}			
			//InfBoxUtil.log("rs="+rs.toString());
			//comId = rs.getInt("GENERATED_KEY");
			//row = rs.getRow();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return comId;
	}
	public static int delete(int id ){
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int row=0;
		try {
			String sqlAdd = "delete from  pyq_comment where id = ?";
			pstmt = DBPoolTomcat.prepare(conn, sqlAdd);
			pstmt.setInt(1, id);
			row = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return row;
	}	
}
