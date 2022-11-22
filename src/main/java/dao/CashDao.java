package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;
import util.DBUtil;

public class CashDao {
	// 조인 사용 --> HashMap
	public ArrayList<HashMap<String, Object>> selectCashListByMonth(String memberId, int year, int month) throws Exception{
		ArrayList<HashMap<String, Object>> list = new  ArrayList<HashMap<String, Object>>();
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql ="SELECT c.cash_no cashNo, c.cash_date cashDate, c.cash_price cashPrice, c.category_no categoryNo, c.cash_memo cashMemo, ct.category_kind categoryKind, ct.category_name categoryName FROM cash c INNER JOIN category ct ON c.category_no = ct.category_no WHERE c.member_id = ? AND YEAR(c.cash_date) = ? AND MONTH(c.cash_date) = ? ORDER BY c.cash_date ASC, ct.category_kind ASC;";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, memberId);
		stmt.setInt(2, year);
		stmt.setInt(3, month);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			// hashMap에 데이터 넣기
			m.put("cashNo", rs.getInt("cashNo"));
			m.put("cashDate", rs.getString("cashDate"));
			m.put("cashPrice", rs.getLong("cashPrice"));	// String으로
			m.put("categoryNo", rs.getInt("categoryNo"));	// 받았었음
			m.put("cashMemo", rs.getString("cashMemo"));
			m.put("categoryKind", rs.getString("categoryKind"));
			m.put("categoryName", rs.getString("categoryName"));
			list.add(m);	// list에 데이터 넣기
		}
		
		rs.close();
		stmt.close();
		conn.close();
		return list;
	}
	
	public int insertCashList(int year, int month, int date) throws Exception{
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "INSERT INTO cash(category_no, cash_date, cash_price, cash_memo, updatedate, createdate) VALUES (?, ?, ?, ?, CURDATE(), CURDATE())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		
		// 성공하면 1
		return 1;
		
		// 실패하면 0
	}
}
