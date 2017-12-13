package com.infbox.pay;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.infbox.demo.DBPoolTomcat;
import com.infbox.demo.DemoUtil;
import com.infbox.demo.MiscUtil;
import com.infbox.demo.MyUser;
import com.infbox.demo.Page;
import com.infbox.demo.article.LiuyanUtil;
import com.infbox.sdk.InfBoxUtil;


public class PayUtil {
	//第一次调用支付，要判断是否已经告诉抓信支付服务器我的回调地址，如果false,则先告诉抓信，参考alipayapi.jsp代码
	public static Boolean tellMyCallBack=false; //不要修改这个参数

	private static final Logger log = LoggerFactory.getLogger(PayUtil.class);
	
	public static String addLog(long userid, int articleid,String reamrk,byte status,byte pay_type,double amout ,long recv_id) {		
	
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String out_trade_no=null;
		try {	
			//假定一个人给每个文章只有一次打赏机会，先查询一下，看看这个人有没有已经有打赏，有的话，取出上次的订单号
			PayLog log2=isLogExist(articleid,userid);
			if(log2!=null){
				return log2.getOutTradeNo();
			}
			//订单号要唯一，不能随机生成，因为用户支付过程有可能中断后重新扫码支付，要防止用户重复支付
			out_trade_no="ar_"+InfBoxUtil.siteId+"_"+articleid+"by"+userid;			
			
			MiscUtil.debug("out_trade_no="+out_trade_no+",recv_id="+recv_id);
			String sql = "insert into pay_log (userid,articleid,out_trade_no,reamrk,status,pay_type,amount,recv_id) values (?,?,?,?,?,?,?,?);";

			pstmt = DBPoolTomcat.prepare(conn, sql,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setLong(1, userid);
			pstmt.setInt(2, articleid);
			pstmt.setString(3,out_trade_no);
			pstmt.setString(4,reamrk);
			pstmt.setByte(5, status);
			pstmt.setByte(6, pay_type);
			pstmt.setDouble(7, amout);
			pstmt.setLong(8, recv_id);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			rs.next();

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return out_trade_no;
	}
	public static Boolean refreshStatus(long pId){
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PayLog payLog = null;
		Boolean retv=false;
		try {
			String sql = "select id,status,pay_type,out_trade_no  from pay_log where id=?  limit 1";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, pId);			
			rs = pstmt.executeQuery();
			if (rs.next()) {
				byte status=rs.getByte("status");
				int pay_type=rs.getInt("pay_type");
				int id=rs.getInt("id");
				String tradeNo=rs.getString("out_trade_no");
				if(status<2){
					//查询抓信服务器
					 Map<String, Object> ss=null;
					if(pay_type==1)		 ss=InfBoxUtil.getAlipayState(tradeNo) ;
					else  ss=InfBoxUtil.getWxPayState(tradeNo) ;
					if(ss!=null){
						Integer stateI=(Integer)ss.get("state");
						if(stateI!=null && stateI==6){
							//说明支付成功,更新本地
							if(pay_type==1)PayUtil.updateStatus(id, (String)ss.get("ali_trade_no"), "", (byte)6);
							else PayUtil.updateStatus(id, "", "", (byte)6);
							retv=true;
						}
						
					}
				}
			
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return retv;
	}
	public static PayLog isLogExist(long articleId,long userid){
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PayLog payLog = null;
		try {
			String sql = "select id,amount,out_trade_no,status  from pay_log where articleid=? and userid=? limit 1";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, articleId);
			pstmt.setLong(2, userid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				payLog = new PayLog();
				payLog.setId(rs.getInt("id"));				
				payLog.setAmount(rs.getDouble("amount"));
				payLog.setStatus(rs.getByte("status"));
				payLog.setOutTradeNo(rs.getString("out_trade_no"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return payLog;
	}
	public static PayLog getLogByOutTradeNo(String out_trade_no) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PayLog payLog = null;
		try {
			String sql = "select * from pay_log where out_trade_no=? limit 1";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setString(1, out_trade_no);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				payLog = new PayLog();
				payLog.setId(rs.getInt("id"));
				payLog.setAmount(rs.getDouble("amount"));
				payLog.setStatus(rs.getByte("status"));
				payLog.setToAcct(rs.getInt("recv_id")+"");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return payLog;
	}
	
	public static void updateStatus(int id, String pay_trade_no,String to_acct,byte status) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn.setAutoCommit(false);
			String sql = "update pay_log set pay_trade_no=?,to_acct=?,pay_time=?,status=? where id = ?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(5, id);
			pstmt.setString(1, pay_trade_no);
			pstmt.setString(2, to_acct);
			pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
			pstmt.setByte(4, (byte)status);
			pstmt.executeUpdate();
			pstmt.close();
			sql = "update article set bonusnum=bonusnum+1 where id in (select articleid from pay_log where id=?)";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, id);			
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();//
	        conn.setAutoCommit(true);//鍦ㄦ妸鑷姩鎻愪氦鎵撳紑
	        Statement stmt=DBPoolTomcat.getStatement(conn);
	        int reveiverId=0,sendId=0;
	        float amount=0;
	        String artTitle="";
	        rs=stmt.executeQuery("select articleid,userid,recv_id,amount,pay_type from pay_log where id="+id);
	        if(rs.next()){
	        	int articleId=rs.getInt(1);
	        	sendId=rs.getInt(2);
	        	reveiverId=rs.getInt(3);	        	
	        	amount=rs.getFloat(4);
	        	byte payTye=rs.getByte(5);
	        	if(payTye==2)amount=amount/100.0f;//微信支付的时候，存的是分，要转为元
	        	
	        }
	        rs.close();
	        MyUser sender=DemoUtil.getUserById(sendId);
	        MyUser receiver=DemoUtil.getUserById(reveiverId);
	       if(receiver!=null && amount>0){ 
	    	   LiuyanUtil.addLiuyan(sendId, reveiverId, sender.getName()+"给您打赏了"+amount+"元，文章名称:"+artTitle, (short)1, sender.getName(), receiver.getName());	    	  	    	   
	    	   String msg="您有一篇文章获得了打赏:"+artTitle;
	    	   String url=InfBoxUtil.SITE_URL+"/mobile/c/payList.jsp?needId=1&asiteid="+InfBoxUtil.siteId;
	    	   InfBoxUtil.sendIBAlert(receiver.getIBOpenId(), sender.getName()+"给您打赏"+amount+"元", msg, url, InfBoxUtil.USE_OPEN_ID, true);
	       }
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
	}


	
	
	public static void notify(String out_trade_no,String total_fee,String pay_trade_no,String to_acct){
		
		System.out.println("系统订单号==="+out_trade_no);
		System.out.println("支付金额==="+total_fee);
		System.out.println("支付宝订单号==="+out_trade_no);

		
		PayLog payLog = PayUtil.getLogByOutTradeNo(out_trade_no);
		if(payLog.getStatus()==2){
			System.out.println("订单已支付");
			log.info("订单已支付");
			return;
		}
			
		if(payLog.getAmount()!=Double.parseDouble(total_fee)){
			System.out.println("订单金额有误");
			log.info("订单金额有误");
			return;
		}			
	
		updateStatus(payLog.getId(), pay_trade_no, to_acct,(byte)6);
	}	
	
	
	//---------打赏记录查询--------
	public static  ArrayList<PayLog>  getFriendPayList(int userid,Page page) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PayLog fw = null;
		ArrayList<PayLog> list=new ArrayList<PayLog> ();
		try {
			//
			String sql = "select id,amount,articleid,create_time,pay_type,status,recv_id,userid from pay_log where  userid=? or recv_id=? order by create_time desc ";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, userid);
			pstmt.setInt(2, userid);
			pstmt.setMaxRows(page.getEndIndex());
			rs = pstmt.executeQuery();
            if (page.getBeginIndex() > 0) {  
                rs.absolute(page.getBeginIndex());
            }  
			while (rs.next()){
				fw = new PayLog();				
				fw.setId(rs.getInt("id"));				
				fw.setAmount(rs.getDouble("amount"));
				fw.setCreateTime(rs.getTimestamp("create_time") );
				fw.setPayType(rs.getByte("pay_type"));
				fw.setArticleid(rs.getInt("articleid"));
				fw.setStatus(rs.getByte("status"));
				fw.setRecv_id(rs.getInt("recv_id") );
				fw.setUserid(rs.getInt("userid"));
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

	
	public static int getFriendPayCount(int userid ) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rowCount = 0; 
		try {
			String sql = "select count(id) from pay_log where  userid=? or recv_id=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, userid);
			pstmt.setInt(2, userid);
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
