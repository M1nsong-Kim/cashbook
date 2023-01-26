package util;

import java.sql.*;

public class DBUtil {
	public Connection getConnection() throws Exception{
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://13.124.174.73:3306/cashbook", "root", "java1234");
		return conn;
	}
	
	public void close(ResultSet rs, PreparedStatement stmt, Connection conn) throws Exception{
		// 각 매개변수값이 없는 경우도 있을 수 있으므로
		if(rs != null) {rs.close();}
		if(stmt != null) {stmt.close();}
		if(conn != null) {conn.close();}
	}
}
