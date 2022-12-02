package dao;

import java.sql.*;
import java.util.*;
import util.DBUtil;
import vo.Cash;

public class CashDao {
	
	// 조인 사용 --> HashMap
	// cashDateList.jsp
	public ArrayList<HashMap<String, Object>> selectCashListByDate(String memberId, int year, int month, int date){
		ArrayList<HashMap<String, Object>> list = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		// 예외가 뜰 것으로 예상되는 줄을 try로 감싼다(close는 별개)
		try {
			// DB 일자 뽑는 함수: DAY()
			conn = dbUtil.getConnection();
			String sql ="SELECT c.cash_no cashNo, c.cash_date cashDate, c.cash_price cashPrice, c.category_no categoryNo, c.cash_memo cashMemo, ct.category_kind categoryKind, ct.category_name categoryName FROM cash c INNER JOIN category ct ON c.category_no = ct.category_no WHERE c.member_id = ? AND YEAR(c.cash_date) = ? AND MONTH(c.cash_date) = ? AND DAY(c.cash_date) = ? ORDER BY c.cash_date ASC, ct.category_kind ASC;";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, memberId);
			stmt.setInt(2, year);
			stmt.setInt(3, month);
			stmt.setInt(4, date);
			
			rs = stmt.executeQuery();
			list = new  ArrayList<HashMap<String, Object>>();
			while(rs.next()) {
				HashMap<String, Object> m = new HashMap<>();
				// hashMap에 데이터 넣기
				m.put("cashNo", rs.getInt("cashNo"));
				m.put("cashDate", rs.getString("cashDate"));
				m.put("cashPrice", rs.getLong("cashPrice"));
				m.put("cashMemo", rs.getString("cashMemo"));
				m.put("categoryKind", rs.getString("categoryKind"));
				m.put("categoryName", rs.getString("categoryName"));
				list.add(m);	// list에 데이터 넣기
			}
		} catch(Exception e) {	// 다형성을 이용해 더 큰 구조로 받기
			e.printStackTrace();	// 메시지 띄우기
		} finally { // 예외 나든 안 나든 finally구문은 무조건 실행
			try {	// close메서드도 예외가 뜰 수 있으니 다시 try-catch
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}			
		}
		
		return list;
	}
	
	// cashList.jsp
	public ArrayList<HashMap<String, Object>> selectCashListByMonth(String memberId, int year, int month){
		ArrayList<HashMap<String, Object>> list = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		// 예외 예상되는 구간 묶기
		try {				
			conn = dbUtil.getConnection();
			String sql ="SELECT c.cash_no cashNo, c.cash_date cashDate, c.cash_price cashPrice, c.category_no categoryNo, ct.category_kind categoryKind, ct.category_name categoryName FROM cash c INNER JOIN category ct ON c.category_no = ct.category_no WHERE c.member_id = ? AND YEAR(c.cash_date) = ? AND MONTH(c.cash_date) = ? ORDER BY c.cash_date ASC, ct.category_kind ASC;";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, memberId);
			stmt.setInt(2, year);
			stmt.setInt(3, month);
			
			rs = stmt.executeQuery();
			list = new ArrayList<HashMap<String, Object>>();
			while(rs.next()) {
				HashMap<String, Object> m = new HashMap<>();
				// hashMap에 데이터 넣기
				m.put("cashNo", rs.getInt("cashNo"));
				m.put("cashDate", rs.getString("cashDate"));
				m.put("cashPrice", rs.getLong("cashPrice"));	// String으로
				m.put("categoryNo", rs.getInt("categoryNo"));	// 받았었음
				m.put("categoryKind", rs.getString("categoryKind"));
				m.put("categoryName", rs.getString("categoryName"));
				list.add(m);	// list에 데이터 넣기
			}
		}catch(Exception e){
			e.printStackTrace();	// 예외 메시지
		}finally {
			try {	// 예외 가능성 있어서 다시 try-catch
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();	//예외 메시지
			}			
		}
		
		return list;
	}
	
	
	// insertCashList
	public int insertCashList(Cash cash){
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null; 
		PreparedStatement stmt = null;
		
		try { //예외 가능성 있는 코드
			conn = dbUtil.getConnection();
			String sql = "INSERT INTO cash(member_id, category_no, cash_price, cash_date, cash_memo, updatedate, createdate) VALUES (?, ?, ?, ?, ?, CURDATE(), CURDATE())";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, cash.getMemberId());
			stmt.setInt(2, cash.getCategoryNo());
			stmt.setLong(3, cash.getCashPrice());
			stmt.setString(4, cash.getCashDate());
			stmt.setString(5, cash.getCashMemo());
	
			row = stmt.executeUpdate();
		}catch(Exception e) {	//다형성 이용
			e.printStackTrace();	//예외 메시지
		}finally {	// 예외 발생 여부에 상관없이 무조건 실행
			try {	// 다시 try-catch
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		// 성공하면 1 실패하면 0
		return row;
		
	}
	
	// 해당 캐시번호 자료 보기
	public HashMap<String, Object> selectCashListByCashNo(int cashNo){
		HashMap<String, Object> map = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			String sql = "SELECT cash_no cashNo, cash_date cashDate, cash_price cashPrice, category_no categoryNo, cash_memo cashMemo \r\n"
					+ "FROM cash\r\n"
					+ "WHERE cash_no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, cashNo);
			
			map = new HashMap<>();
			rs = stmt.executeQuery();
			if(rs.next()) {
				map.put("cashNo", cashNo);
				map.put("cashDate", rs.getString("cashDate"));
				map.put("cashPrice", rs.getLong("cashPrice"));
				map.put("categoryNo", rs.getInt("categoryNo"));
				map.put("cashMemo", rs.getString("cashMemo"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {	// 예외 발생 여부에 관계없이 실행
			try {	// 다시 예외가능성 있어 try-catch
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}			
		}
		
		return map;
	}
	
	// 수정
	public int updateCashList(Cash cash){
		int row = 0; 

		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;

		//예외 발생 가능성 있는 코드 묶기
		try {	
			conn = dbUtil.getConnection();
			String sql = "UPDATE cash\r\n"
					+ "SET category_no = ?\r\n"
					+ "	, cash_price = ?\r\n"
					+ "	, cash_memo = ?\r\n"
					+ "	, updatedate = CURDATE()\r\n"
					+ "WHERE cash_no = ? AND member_id = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, cash.getCategoryNo());
			stmt.setLong(2, cash.getCashPrice());
			stmt.setString(3, cash.getCashMemo());
			stmt.setInt(4, cash.getCashNo());
			stmt.setString(5, cash.getMemberId());
			
			// 성공하면 row = 1
			row = stmt.executeUpdate();
		}catch(Exception e) {	//다형성 이용 -> 더 큰 구조로 모든 예외 받기
			e.printStackTrace();	//예외 메시지
		}finally {
			try {	// 예외 발생 가능성 있어서 감싸기
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return row;

	}
	
	// 삭제
	public int deleteCash(int cashNo){
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		
		// 예외 가능성 있는 코드들 묶기
		try {
			conn = dbUtil.getConnection();
			String sql = "DELETE FROM cash WHERE cash_no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, cashNo);
			
			// 성공하면 row = 1
			row = stmt.executeUpdate();
		} catch(Exception e) {	// 다형성 이용
			e.printStackTrace();	// 예외 메시지
		} finally {	// 예외 발생 여부에 관계없이 실행
			try {	// 예외 가능성 있어서 다시 try-catch
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return row;
	}
	
}
