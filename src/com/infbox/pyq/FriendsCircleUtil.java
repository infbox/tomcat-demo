package com.infbox.pyq;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.infbox.demo.DBPoolTomcat;
import com.infbox.demo.MyUser;
import com.infbox.demo.Page;


public class FriendsCircleUtil {
	private static final Logger log = LoggerFactory.getLogger(FriendsCircleUtil.class);
	
	//--------------
	public static  Map<String,Object>  getFriendCricleList(Page page,HttpServletRequest request) {
		
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmtCom = null;
		ResultSet rsCom = null;
		PreparedStatement pstmtLike = null;
		ResultSet rsLike = null;
		SharePyg fw = null;
		ArrayList<SharePyg> list=new ArrayList<SharePyg> ();
		StringBuffer sb= new StringBuffer();
		Map<String,Object> map =new HashMap<String,Object>();
		HttpSession session = request.getSession();
		MyUser user = (MyUser)session.getAttribute("user");
		try {
			String sql = "select id,type,content,url,add_time,author_id,author_name,author_img,num from share_pyq order by add_time desc ";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			//pstmt.setInt(1, authorId);
			pstmt.setMaxRows(page.getEndIndex());
			rs = pstmt.executeQuery();
            if (page.getBeginIndex() > 0) {  
                rs.absolute(page.getBeginIndex());
            }  
			while (rs.next()){
				fw = new SharePyg();				
				fw.setId(rs.getInt("id"));
				fw.setUrl(rs.getString("url"));
				fw.setType(rs.getShort("type"));
				fw.setContent(rs.getString("Content"));
				fw.setAuthorImg(rs.getString("author_img"));
				fw.setAuthorId(rs.getInt("author_id"));
				fw.setAuhtorName(rs.getString("author_name"));
				fw.setAddTime(rs.getTimestamp("add_time"));
				fw.setNum(rs.getInt("num"));
				if(rs.isLast()){
					sb.append("?");
				}else{
					sb.append("?,");
				}
				list.add(fw);
			}
			map.put("pyq", list);
			//-------------评论数----------------------------
			String sqlComment = "select * from pyq_comment  where pyq_id in ("+sb.toString() +") order by create_time asc;";
			pstmtCom = DBPoolTomcat.prepare(conn, sqlComment);
			for(int i=0;i<list.size(); i++){
				pstmtCom.setInt(i+1,list.get(i).getId());
			}
			rsCom = pstmtCom.executeQuery();
			Map<String,List<PyqComment>> commentMap =new LinkedHashMap<String,List<PyqComment>>();
			PyqComment com = null;
			while (rsCom.next()){
				com = new PyqComment();	
				int pyqId = rsCom.getInt("pyq_id");
				com.setId(rsCom.getInt("id"));
				com.setPyqId(pyqId);
				com.setComText(rsCom.getString("com_text"));
				com.setUserId(rsCom.getInt("user_id"));
				com.setUserName(rsCom.getString("user_name"));
				com.setCreateTime(rsCom.getTimestamp("create_time"));
				if(commentMap.containsKey(pyqId+"")){
					commentMap.get(pyqId+"").add(com);
				}else{
					List<PyqComment> comList = new LinkedList<PyqComment>();
					comList.add(com);
					commentMap.put(pyqId+"", comList);
				}
			}
			map.put("comment", commentMap);
			//-------------点赞数----------------------------
			String sqlLike = "select * from pyq_like  where pyq_id in ("+sb.toString() +") and user_id=?" ;
			pstmtLike = DBPoolTomcat.prepare(conn, sqlLike);
			for(int i=0;i<list.size(); i++){
				pstmtLike.setInt(i+1,list.get(i).getId());
			}
			pstmtLike.setInt(list.size()+1, (int)user.getId());
			rsLike = pstmtLike.executeQuery();
			Map<String,PyqLike> likeMap =new HashMap<String,PyqLike>();
			PyqLike like = null;
			while (rsLike.next()){
				like = new PyqLike();	
				int pyqId = rsLike.getInt("pyq_id");
				like.setId(rsLike.getInt("id"));
				like.setPyqId(pyqId);
				like.setUserId(rsLike.getInt("user_id"));
				like.setUserName(rsLike.getString("user_name"));
				like.setState(rsLike.getString("state"));
				like.setCreateTime(rsLike.getTimestamp("create_time"));
				likeMap.put(pyqId+"_"+user.getId(),like);
			}
			map.put("like", likeMap);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(rsCom);
			DBPoolTomcat.close(pstmtCom);
			DBPoolTomcat.close(rsLike);
			DBPoolTomcat.close(pstmtLike);
			DBPoolTomcat.close(conn);
		}
		return map;
	} 

	
	public static int getFriendCircleCount() {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rowCount = 0; 
		try {
			String sql = "select count(id) from share_pyq";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			//pstmt.setInt(1, authorId);
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
	
	
}
