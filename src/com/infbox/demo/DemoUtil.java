package com.infbox.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.StringTokenizer;








import org.json.JSONObject;

import com.infbox.demo.article.ArticleCollect;
import com.infbox.demo.article.Friend;
import com.infbox.sdk.InfBoxUtil;

/*
 * 如何提高分页查询的效率
http://blog.csdn.net/lengyue1084/article/details/60868406
 * */
public class DemoUtil {	
	private static Random randGen;
	private static char[] numbersAndLetters = null;
	public static Map<String,MyUser> loggedCache;//登陆之后后台的缓存,如果是集群，则可以改为放到redis里面
	//扫码登陆后，跳转到首页之前的缓存,如果是集群，则可以改为放到redis里面
	 public static void addUserCache(String s,MyUser u){
		 if(loggedCache==null)loggedCache = new HashMap<String,MyUser>();
		 loggedCache.put(s, u); 
	  }
	 public static void delUserCache(String s){
		 if(loggedCache==null)loggedCache = new HashMap<String,MyUser>();
		 loggedCache.remove(s); 
	  }
	 
	 public static MyUser getUserCache(String s){
		 if(loggedCache==null)loggedCache = new HashMap<String,MyUser>();
		 Object obj=loggedCache.get(s); 
		 if(obj!=null) return (MyUser)obj;
		 else return null;
	  }
	 
	// 判断某个openId的用户是否已经注册
	public static long isUserExist(String openId) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		long userId = 0;

		try {
			//
			String sql = "select id from tb_user where infbox_id=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setString(1, openId);
			rs = pstmt.executeQuery();
			if (rs.next())
				userId = rs.getLong(1);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return userId;
	}

	public static MyUser getUserByInfBoxId(String openId) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MyUser user = null;
		try {
			String sql = "select * from tb_user where infbox_id=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setString(1, openId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				user = new MyUser();
				user.setId(rs.getLong("id"));
				user.memo=rs.getString("memo");
				user.city=rs.getString("city");
				user.headPic = rs.getString("headpic");
				user.setName(rs.getString("nickname"));
				user.fansCount=rs.getInt("fans_count");
				user.idolCount=rs.getInt("idol_count");				
				user.setLevel(rs.getInt("level"));
				user.setIBOpenId(openId);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return user;
	}
	
	public static MyUser getUserById(long id) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MyUser user = null;
		try {
			String sql = "select * from tb_user where id=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				user = new MyUser();				
				user.headPic = rs.getString("headpic");
				user.memo=rs.getString("memo");
				user.city=rs.getString("city");
				user.fansCount=rs.getInt("fans_count");
				user.setIBOpenId(rs.getString("infbox_id"));
				user.idolCount=rs.getInt("idol_count");
				user.setName(rs.getString("nickname"));
				user.setLevel(rs.getInt("level"));
				
				user.setId(id);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return user;
	}

	

	// 根据抓信服务端的记录号，获取消息源关注记录
	public static Follow getFollow(String fwId) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Follow fw = null;

		try {
			//
			String sql = "select id,token from follow where fwid=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setString(1, fwId);
			
			rs = pstmt.executeQuery();
			if (rs.next())
				fw = new Follow();				
				fw.id=rs.getLong(1);
				fw.token = rs.getString(2);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return fw;
	}
	
	// 根据抓信服务端的记录号，获取消息源关注记录
	public static  ArrayList<Follow>  getFollows(String postId,String param) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Follow fw = null;
		ArrayList<Follow> list=new ArrayList<Follow> ();
		try {
			//
			String sql = "select id,fwid,token from follow where tid=? and param=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setString(1, postId);
			pstmt.setString(2, param);
			
			rs = pstmt.executeQuery();
			while (rs.next()){
				fw = new Follow();				
				fw.id=rs.getLong(1);
				fw.fwId = rs.getString(2);
				fw.token = rs.getString(3);
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
	

	public static long addUser(String name, String infbox_id, String headpic) {
		long userId = isUserExist(infbox_id);
		if (userId > 0)
			return userId;// 已经存在的用户，不需要重建

		Connection conn = null;

		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int total = 0;

		try {

			String sql = "insert into tb_user (nickname,headpic,level,regtime,infbox_id) values (?,?,0,now(),?);";

			pstmt = DBPoolTomcat.prepare(conn, sql,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, name);
			pstmt.setString(2, headpic);
			pstmt.setString(3, infbox_id);

			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

			rs.next();
			userId = rs.getLong(1);//

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return userId;
	}

	// 保存一条请示消息，返回该消息的id
	public static long addInfBoxConsult(String title, String content,
			int consultType, String token) {

		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {

			String sql = "insert into msg_consult (title,content,consult_type,token) values (?,?,?,?);";

			pstmt = DBPoolTomcat.prepare(conn, sql,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, title);
			pstmt.setString(2, content);
			pstmt.setInt(3, consultType);
			pstmt.setString(4, token);

			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

			rs.next();
			ret = rs.getLong(1);//

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}

	// 更新请示消息，一般用于记录用户的反馈
	public static Boolean updateInfBoxConsult(String svrId, String token,
			String optionAnswer, String btnAnswer) {

		Connection conn = null;
		Boolean ret = false;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {

			String sql = "update msg_consult set optionAnswer=?,btnAnswer=?,replyTime=now() where id=? and token=?;";

			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setString(1, optionAnswer);
			pstmt.setString(2, btnAnswer);
			pstmt.setInt(3, Integer.parseInt(svrId));
			pstmt.setString(4, token);

			int i = pstmt.executeUpdate();
			if (i > 0)
				ret = true;

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}

	// 保存任务消息,supervisor= 任务监督者的openId，executor是任务执行者的openId
	public static long addInfBoxTask(String title, String content,
			long beginTime, long deadLine, String supervisor, String executor,
			int level, String token) {
		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String sql = "insert into task (title,content,begin,deadline,level,supervisor,executor,token) values (?,?,?,?,?,?,?,?);";
			pstmt = DBPoolTomcat.prepare(conn, sql,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, title);
			pstmt.setString(2, content);
			pstmt.setTimestamp(3, new Timestamp(beginTime));
			pstmt.setTimestamp(4, new Timestamp(deadLine));
			pstmt.setInt(5, level);

			pstmt.setString(6, supervisor);
			pstmt.setString(7, executor);
			pstmt.setString(8, token);

			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

			rs.next();
			ret = rs.getLong(1);//

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}

	// 更新任务消息状态，一般用于记录用户的反馈
	public static Boolean updateInfBoxTask(String svrId, String token, int state) {

		Connection conn = null;
		Boolean ret = false;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {

			String sql = "update task set state=? where id=? and token=?";
			if (state == InfBoxUtil.MSG_STATE_CN.已处理完毕.ordinal())
				sql = "update task set state=?,finish_time=now() where id=? and token=?;";

			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, state);
			pstmt.setLong(2, Long.parseLong(svrId));
			pstmt.setString(3, token);

			int i = pstmt.executeUpdate();
			if (i > 0)
				ret = true;

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}

	// 任务监督者点评任务状态
	public static Boolean commentInfBoxTask(String svrId, String token,
			String comment, float score) {
		Connection conn = null;
		Boolean ret = false;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String sql = sql = "update task set score=?, comment=? where id=? and token=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setFloat(1, score);
			pstmt.setString(2, comment);
			pstmt.setLong(3, Long.parseLong(svrId));
			pstmt.setString(4, token);
			int i = pstmt.executeUpdate();
			if (i > 0)
				ret = true;

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}

	public static final String randomString(int length) {
		if (length < 1) {
			return null;
		}
		if (randGen == null) {
			randGen = new Random();
			numbersAndLetters = ("0123456789abcdefghijklmnopqrstuvwxyz"
					+ "_456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").toCharArray();
			// numbersAndLetters =
			// ("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").toCharArray();
		}
		char[] randBuffer = new char[length];
		for (int i = 0; i < randBuffer.length; i++) {
			randBuffer[i] = numbersAndLetters[randGen.nextInt(68)];

			// randBuffer[i] = numbersAndLetters[randGen.nextInt(35)];
		}
		return new String(randBuffer);
	}

	public static String getTimeString(long timeStamp) {
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(timeStamp);

		// c.add(Calendar.HOUR_OF_DAY, 24);
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		return dateFormat.format(c.getTime());
	}

	public static String getDateStr(long timeStamp) {
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(timeStamp);

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		return dateFormat.format(c.getTime());
	}


	// 读取帖子的评论列表
	public static ArrayList<Comment> getComments(int postId) {
		Connection conn = null;
		ArrayList<Comment> commentList = new ArrayList<Comment>();

		conn = DBPoolTomcat.getMainDBConn();
		Statement stmt = null;
		ResultSet rs = null;

		try {
			String sql = "select * from comment where post_id=" + postId;
			stmt = DBPoolTomcat.getStatement(conn);
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				Comment comment = new Comment();
				comment.id = rs.getInt("id");
				comment.post_id = postId;
				comment.content = rs.getString("content");
				comment.author_id = rs.getInt("user_id");
				comment.addTime = new Date(rs.getTimestamp("add_time")
						.getTime());
				commentList.add(comment);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(stmt);
			DBPoolTomcat.close(conn);
		}
		return commentList;
	}

	// 保存帖子的评论
	public static long addComment(long authorId, String content, long postId) {
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
			pstmt.setLong(3, authorId);

			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

			rs.next();
			ret = rs.getLong(1);//

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}

	// 添加一个消息源的关注者，此处是一个帖子的关注者
	public static long addFollow(String fwId, String param, String postId,String token) {
		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		try {
			String sql = "insert into follow (fwid,tid,param,token) values (?,?,?,?);";
			pstmt = DBPoolTomcat.prepare(conn, sql,
					PreparedStatement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, fwId);
			pstmt.setString(2, postId);
			pstmt.setString(3, param);
			pstmt.setString(4, token);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

			rs.next();
			ret = rs.getLong(1);//

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}

	public static Boolean deleteFollow(long id) {
		Connection conn = null;
		Boolean ret = false;
		conn = DBPoolTomcat.getMainDBConn();
		Statement stmt = null;
		ResultSet rs = null;

		try {

			String sql = "delete from follow where id="+id;			
			stmt = DBPoolTomcat.getStatement(conn);			
			int i = stmt.executeUpdate(sql);
			if (i > 0)
				ret = true;

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(stmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}
	
	
	public static int getAroundCount(Long id,Double minLat, Double maxLat, Double minLng, Double maxLng) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rowCount = 0; 
		try {
			String sql = "select count(u.id) from tb_user u where id != ?"
					+ " and longitude >= ?"
					+ " and longitude <= ?"
					+ " and latitude  >= ?"
					+ " and latitude  <= ?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, id);
			pstmt.setDouble(2, minLng);
			pstmt.setDouble(3, maxLng);
			pstmt.setDouble(4, minLat);
			pstmt.setDouble(5, maxLat);
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
	
	public static List<MyUser> getUserNearby(Page page,Long id,Double minLat, Double maxLat, Double minLng, Double maxLng,Double lat,Double lng){
		
	
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<MyUser> list = new ArrayList<MyUser>();

		try {
//			,ACOS(SIN((? * 3.1415) / 180 ) * SIN((latitude * 3.1415) / 180 )"
//			+ " +COS((? * 3.1415) / 180 ) * COS((latitude * 3.1415) / 180 )  "
//			+ " * COS((? * 3.1415) / 180 - (longitude * 3.1415) / 180 ) ) as distance 
			String sql = "select * from tb_user where id != ?"
					+ " and longitude >= ?"
					+ " and longitude <= ?"
					+ " and latitude  >= ?"
					+ " and latitude  <= ?"
					+ " order by ACOS(SIN((? * 3.1415) / 180 ) * SIN((latitude * 3.1415) / 180 )"
					+ " +COS((? * 3.1415) / 180 ) * COS((latitude * 3.1415) / 180 )  "
					+ " * COS((? * 3.1415) / 180 - (longitude * 3.1415) / 180 ) ) "
					+ " * 6380 asc";
			pstmt = DBPoolTomcat.prepare(conn, sql);			
			
			pstmt.setLong(1, id);
			pstmt.setDouble(2, minLng);
			pstmt.setDouble(3, maxLng);
			pstmt.setDouble(4, minLat);
			pstmt.setDouble(5, maxLat);
			pstmt.setDouble(6, lat);
			pstmt.setDouble(7, lat);
			pstmt.setDouble(8, lng);
			pstmt.setMaxRows(page.getEndIndex());
			rs = pstmt.executeQuery();
            if (page.getBeginIndex() > 0) {  
                rs.absolute(page.getBeginIndex());
            }  
			while (rs.next()) {
				MyUser user = new MyUser();		
				user.setId(rs.getLong("id"));
				user.headPic = rs.getString("headpic");			
				user.setName(rs.getString("nickname"));
				user.setMemo(rs.getString("memo"));
				user.setCity(rs.getString("city"));
				user.setLatitude(rs.getDouble("latitude"));
				user.setLongitud(rs.getDouble("longitude"));
				user.fansCount=rs.getInt("fans_count");
				user.idolCount=rs.getInt("idol_count");
				user.setDistance(AroudUtil.getDistance(lat,lng,user.getLatitude(), user.getLongitud())/1000);
				
				list.add(user);
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



	public static void update(String city, double lng, double lat, long id) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int total = 0;

		try {

			String sql = "update tb_user set city=?,longitude=?,latitude=? where id = ?";

			pstmt = DBPoolTomcat.prepare(conn, sql,
					PreparedStatement.RETURN_GENERATED_KEYS);
		
			String city1=city.replaceFirst("中国", "");
			int ill=city1.indexOf("市");
			if(ill>0)city1=city1.substring(0, ill);
			pstmt.setString(1,city1 );
			pstmt.setDouble(2, lng);
			pstmt.setDouble(3, lat);
			pstmt.setLong(4, id);
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
	}

	public static int  addAdvice(String category, String userId,String advice,String mobile) {
		Connection conn = null;
		int retv=0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		String actTime = MiscUtil.nowTime2Str();
		try {
			
			String sql ="insert into advice (category,userId,advice,mobile,addTime) values (?,?,?,?,'"+actTime+"');";			
			pstmt = DBPoolTomcat.prepare(conn, sql,
					PreparedStatement.RETURN_GENERATED_KEYS);			
			pstmt.setShort(1, Short.parseShort(category));
			pstmt.setString(2, userId);
			pstmt.setString(3, advice);	
			pstmt.setString(4, mobile);	
			pstmt.executeUpdate();			
			rs = pstmt.getGeneratedKeys();
			rs.next();
			retv = rs.getInt(1);//
			
			
		} catch (Exception e) {
			e.printStackTrace();
			
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return retv;
	}
	//增加好友
	public static int addFriend(long myid, long frdId,
			String frdName, String frdPic,String myName,String myPic) {
		Boolean isIdol=isMyIdol(myid,frdId);
		if(isIdol) return 0;
		Connection conn = null;
		int ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//要用事物机制同时处理三个操作：添加记录，我的关注数+1,对方粉丝数+1
		try {
			conn.setAutoCommit(false);
			String sql = "insert into friend(myId,myName,myPic,frdId,frdName,frdPic,addTime) values (?,?,?,?,?,?,now());";

			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, myid);
			pstmt.setString(2, myName);
			pstmt.setString(3, myPic);
			pstmt.setLong(4, frdId);
			pstmt.setString(5, frdName);
			pstmt.setString(6, frdPic);
			ret=pstmt.executeUpdate();
			//我的关注+1
			sql = "update tb_user set idol_count=idol_count+1 where id=?";			
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, myid);
			pstmt.executeUpdate();
			//对方的粉丝+1
			sql = "update tb_user set fans_count=fans_count+1 where id=?";			
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, frdId);
			pstmt.executeUpdate();			
			conn.commit();
			ret = 1;
		} catch (Exception e) {
			e.printStackTrace();
			 try {
                 //.在catch块内添加回滚事务，表示操作出现异常，撤销事务：
                 conn.rollback();
             } catch (SQLException e1) {
                 // TODO Auto-generatedcatch block
                 e1.printStackTrace();
             }

		} finally {
			try {
                //设置事务提交方式为自动提交：
                conn.setAutoCommit(true);
             } catch (SQLException e) {
                // TODO Auto-generatedcatch block
                e.printStackTrace();
             }
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}
	
	public static long deleteFrd(long recId,long myId) {
		Connection conn = null;
		long ret = 0;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String sql = "delete from friend where id=? and myId=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, recId);
			pstmt.setLong(2, myId);
			ret=pstmt.executeUpdate();
			

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return ret;
	}
	//type=1 关注列表 ；type=2粉丝列表
	public static ArrayList<Friend> getFriendList(int userId,int type,Page page) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Friend fw = null;
		ArrayList<Friend> list=new ArrayList<Friend> ();
		try {
			//
			String sql = null;
			if(type==1)sql="select * from friend where myId=? ";
			else  sql = "select * from friend where frdId=? ";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setInt(1, userId);
		//	pstmt.setMaxRows(page.getEndIndex());
			rs = pstmt.executeQuery();
          /*  if (page.getBeginIndex() > 0) {  
                rs.absolute(page.getBeginIndex());
            }  */
			while (rs.next()){
				fw = new Friend();					
				fw.rowId=rs.getInt("id");
				if(type==1){
					fw.frdId=rs.getInt("frdId");	
					fw.name=rs.getString("frdName");
					fw.pic=rs.getString("frdPic");
				}
				else {
					fw.frdId=rs.getInt("myId");	
					fw.name=rs.getString("myName");
					fw.pic=rs.getString("myPic");
				}
								
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
	//---
	public static void setUserMemo(String memo, long id) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int total = 0;

		try {

			String sql = "update tb_user set memo=? where id = ?";

			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setString(1, memo);			
			pstmt.setLong(2, id);
			pstmt.executeUpdate();
		
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
	}
	public static void updateHeadPic(long id, String saveFileName) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int total = 0;

		try {

			String sql = "update tb_user set headpic=? where id = ?";

			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(2, id);
			pstmt.setString(1, saveFileName);
			pstmt.executeUpdate();
			
			

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
	}



	public static void updateName(long id, String nickname) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int total = 0;

		try {

			String sql = "update tb_user set nickname=? where id = ?";

			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(2, id);
			pstmt.setString(1, nickname);
			pstmt.executeUpdate();
			

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
	}
	//是否已经关注了某人
	public static Boolean isMyIdol(long myId,long frdId) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Boolean retv = false;

		try {
			//
			String sql = "select id from friend where myId=? and frdId=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setLong(1, myId);
			pstmt.setLong(2, frdId);
			rs = pstmt.executeQuery();
			if (rs.next())
				retv = true;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return retv;
	}
	//获得管理员的Id
	public static long getGzhAdminId(String gzh_wxid) {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		long userId = 0;
		try {
			String sql = "select admin_id from gzh where gzh_id=?";
			pstmt = DBPoolTomcat.prepare(conn, sql);
			pstmt.setString(1, gzh_wxid);
			rs = pstmt.executeQuery();
			if (rs.next()) {				
				userId=rs.getLong("admin_id");				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		return userId;
	}
	
//----------
	public static ArrayList<Comment> getCommentsByUser(int userId) {
		Connection conn = null;
		ArrayList<Comment> commentList = new ArrayList<Comment>();

		conn = DBPoolTomcat.getMainDBConn();
		Statement stmt = null;
		ResultSet rs = null;

		try {
			String sql = "select * from comment where user_id=" + userId+" order by add_time desc limit 10";
			stmt = DBPoolTomcat.getStatement(conn);
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				Comment comment = new Comment();
				comment.id = rs.getInt("id");
				comment.post_id = rs.getInt("post_id");
				comment.content = rs.getString("content");
				comment.author_id = rs.getInt("user_id");
				comment.addTime = new Date(rs.getTimestamp("add_time")
						.getTime());
				commentList.add(comment);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(stmt);
			DBPoolTomcat.close(conn);
		}
		return commentList;
	}
	public static MyUser getAdminUser() {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		Statement stmt = null;
		ResultSet rs = null;
		MyUser user = null;
		try {
			String sql = "select * from tb_user where level>7 order by level desc limit 1";
			stmt = DBPoolTomcat.getStatement(conn);			
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				user = new MyUser();				
				user.headPic = rs.getString("headpic");
				user.memo=rs.getString("memo");
				user.city=rs.getString("city");
				user.fansCount=rs.getInt("fans_count");
				user.idolCount=rs.getInt("idol_count");
				user.setName(rs.getString("nickname"));
				user.setLevel(rs.getInt("level"));				
				user.setId(rs.getLong("id"));
				user.setIBOpenId(rs.getString("infbox_id"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBPoolTomcat.close(rs);
			DBPoolTomcat.close(stmt);
			DBPoolTomcat.close(conn);
		}
		return user;
	}
}
