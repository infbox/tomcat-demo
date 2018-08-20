package com.infbox.demo;

import java.sql.*; 
  
import com.zaxxer.hikari.HikariConfig;  
import com.zaxxer.hikari.HikariDataSource;  

public class DBPoolTomcat {
	public static Boolean localTest = false;
	private static HikariDataSource ds; 
	private static String url;
	public static void setDBUrl(String url1){
		url=url1;
	}
	public static Connection getMainDBConn() {
		if (ds == null)
			initDBPool();
		Connection conn = null;
		try {
			conn = ds.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
			if(e instanceof  SQLTimeoutException){
				ds=null;//下次 
			}else{
				
			}
			
		}
		return conn;
	}

	private static void initDBPool() {
		init(3,12);
	}
	public static void shutdown(){  
        ds.close();  
    }  
	 /** 
     * 初始化连接池 
     * @param minimum 
     * @param Maximum 
     */  
    public static void init(int minimum,int Maximum){  
      	MiscUtil.debug("DB url:"+url);
        HikariConfig config = new HikariConfig();  
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");  
        config.setJdbcUrl(url);    
        config.addDataSourceProperty("cachePrepStmts", true);
        config.addDataSourceProperty("prepStmtCacheSize", 250);
        config.addDataSourceProperty("prepStmtCacheSqlLimit", 2048);
        config.setConnectionTestQuery("SELECT 1");
        config.setLeakDetectionThreshold(15000);
        config.setConnectionTimeout(60000);
        config.setValidationTimeout(3000);      
        config.setMaxLifetime(60000);
        config.setIdleTimeout(60000);
        config.setAutoCommit(true);
        //池中最小空闲链接数量  
        config.setMinimumIdle(minimum);  
        //池中最大链接数量  
        config.setMaximumPoolSize(Maximum);  
          
        ds = new HikariDataSource(config);  
          
    }  
	

	public static PreparedStatement prepare(Connection conn, String sql) {
		PreparedStatement pstmt = null;
		try {
			if (conn == null) {
				conn=getMainDBConn();
			}
			
				pstmt = conn.prepareStatement(sql);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return pstmt;
	}

	public static PreparedStatement prepare(Connection conn, String sql,
			int autoGenereatedKeys) {
		PreparedStatement pstmt = null;
		try {
			if (conn == null) {
				conn=getMainDBConn();
			}
			
				pstmt = conn.prepareStatement(sql, autoGenereatedKeys);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return pstmt;
	}

	public static Statement getStatement(Connection conn) {
		Statement stmt = null;
		try {
			if (conn == null) {
				conn=getMainDBConn();
			}
			stmt = conn.createStatement();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return stmt;
	}

	public static ResultSet getResultSet(Statement stmt, String sql) {
		ResultSet rs = null;
		try {
			if (stmt != null) {
				rs = stmt.executeQuery(sql);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return rs;
	}

	public static void executeUpdate(Statement stmt, String sql) {
		try {
			if (stmt != null) {
				stmt.executeUpdate(sql);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void close(Statement stmt) {
		try {
			if (stmt != null) {
				stmt.close();
				stmt = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void close(ResultSet rs) {
		try {
			if (rs != null) {
				rs.close();
				rs = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	//
	public static void ping() {
		Connection conn = null;
		conn = DBPoolTomcat.getMainDBConn();
		Statement pstmt = null;
		try {
			
			String sql = "select 1 ";
			pstmt = DBPoolTomcat.prepare(conn, sql);			
			pstmt.execute(sql);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			
			DBPoolTomcat.close(pstmt);
			DBPoolTomcat.close(conn);
		}
		
	}
	
	public static void close(Connection conn) {
		try {
			if (conn != null && !conn.isClosed()) {
				conn.close();
				conn=null;
			}
		} catch (SQLException e) {
			throw new RuntimeException("关闭数据库连接失败");
		}
	}
	public static void closeJDBCObj(ResultSet rs,Statement stmt,Connection conn){
		close(rs);
		close(stmt);
		close(conn);
	}
}


