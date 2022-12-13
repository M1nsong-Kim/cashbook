package dao;

import java.sql.*;
import java.util.*;

import util.DBUtil;

public class StatsDao {
	// 최소/최대 년도
	public HashMap<String, Object> selectMaxMinYear(String memberId) {
		HashMap<String, Object> map = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT MAX(YEAR(cash_date)) maxYear\r\n"
				+ "		, MIN(YEAR(cash_date)) minYear\r\n"
				+ "FROM cash\r\n"
				+ "WHERE member_id = ? ";
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, memberId);
			rs = stmt.executeQuery();
			if(rs.next()) {
				map = new HashMap<String, Object>();
				map.put("maxYear", rs.getInt("maxYear"));
				map.put("minYear", rs.getInt("minYear"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return map;
	}
	
	// 일별 통계 보기
	public ArrayList<HashMap<String, Object>> selectCashStatsByDay(String memberId, int year, int month){
		ArrayList<HashMap<String, Object>> list = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT DAY(t2.cashDate) day\r\n"
				+ "		, COUNT(t2.importCash) countImport\r\n"
				+ "		, IFNULL(SUM(t2.importCash), 0) sumImport\r\n"
				+ "		, IFNULL(ROUND(AVG(t2.importCash)), 0) avgImport\r\n"
				+ "		, COUNT(t2.exportCash) countExport\r\n"
				+ "		, IFNULL(SUM(t2.exportCash), 0) sumExport\r\n"
				+ "		, IFNULL(ROUND(AVG(t2.exportCash)), 0) avgExport\r\n"
				+ "FROM \r\n"
				+ "	(SELECT memberId\r\n"
				+ "			, cashNo\r\n"
				+ "			, cashDate\r\n"
				+ "			, IF(categoryKind = '수입', cashPrice, NULL) importCash\r\n"
				+ "			, IF(categoryKind = '지출', cashPrice, NULL) exportCash\r\n"
				+ "	FROM (SELECT c.cash_no cashNo\r\n"
				+ "					, c.cash_date cashDate\r\n"
				+ "					, c.cash_price cashPrice\r\n"
				+ "					, ca.category_kind categoryKind\r\n"
				+ "					, c.member_id memberId\r\n"
				+ "			FROM cash c INNER JOIN category ca ON c.category_no = ca.category_no) t) t2\r\n"
				+ "WHERE t2.memberId = ? AND YEAR(t2.cashDate) = ? AND MONTH(t2.cashDate) = ? \r\n"
				+ "GROUP BY DAY(t2.cashDate)\r\n"
				+ "ORDER BY DAY(t2.cashDate) ASC ";
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, memberId);
			stmt.setInt(2, year);
			stmt.setInt(3, month);
			rs = stmt.executeQuery();
			list = new  ArrayList<HashMap<String, Object>>();
			while(rs.next()) {
				HashMap<String, Object> m = new HashMap<String, Object>();
				m.put("day", rs.getInt("day"));
				m.put("countImport", rs.getInt("countImport"));
				m.put("sumImport", rs.getInt("sumImport"));
				m.put("avgImport", rs.getInt("avgImport"));
				m.put("countExport", rs.getInt("countExport"));
				m.put("sumExport", rs.getInt("sumExport"));
				m.put("avgExport", rs.getInt("avgExport"));
				list.add(m);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return list;
	}
	
	// 월별 통계 보기
	public ArrayList<HashMap<String, Object>> selectCashStatsByMonth(String memberId, int year){
		ArrayList<HashMap<String, Object>> list = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT MONTH(t2.cashDate) month\r\n"
				+ "		, COUNT(t2.importCash) countImport\r\n"
				+ "		, IFNULL(SUM(t2.importCash), 0) sumImport\r\n"
				+ "		, IFNULL(ROUND(AVG(t2.importCash)), 0) avgImport\r\n"
				+ "		, COUNT(t2.exportCash) countExport\r\n"
				+ "		, IFNULL(SUM(t2.exportCash), 0) sumExport\r\n"
				+ "		, IFNULL(ROUND(AVG(t2.exportCash)), 0) avgExport\r\n"
				+ "FROM \r\n"
				+ "	(SELECT memberId\r\n"
				+ "			, cashNo\r\n"
				+ "			, cashDate\r\n"
				+ "			, IF(categoryKind = '수입', cashPrice, NULL) importCash\r\n"
				+ "			, IF(categoryKind = '지출', cashPrice, NULL) exportCash\r\n"
				+ "	FROM (SELECT c.cash_no cashNo\r\n"
				+ "					, c.cash_date cashDate\r\n"
				+ "					, c.cash_price cashPrice\r\n"
				+ "					, ca.category_kind categoryKind\r\n"
				+ "					, c.member_id memberId\r\n"
				+ "			FROM cash c INNER JOIN category ca ON c.category_no = ca.category_no) t) t2\r\n"
				+ "WHERE t2.memberId = ? AND YEAR(t2.cashDate) = ? \r\n"
				+ "GROUP BY MONTH(t2.cashDate)\r\n"
				+ "ORDER BY MONTH(t2.cashDate) ASC ";
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, memberId);
			stmt.setInt(2, year);
			rs = stmt.executeQuery();
			list = new  ArrayList<HashMap<String, Object>>();
			while(rs.next()) {
				HashMap<String, Object> m = new HashMap<String, Object>();
				m.put("month", rs.getInt("month"));
				m.put("countImport", rs.getInt("countImport"));
				m.put("sumImport", rs.getInt("sumImport"));
				m.put("avgImport", rs.getInt("avgImport"));
				m.put("countExport", rs.getInt("countExport"));
				m.put("sumExport", rs.getInt("sumExport"));
				m.put("avgExport", rs.getInt("avgExport"));
				list.add(m);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return list;
	}
	
	// 년도별 통계 보기
	public ArrayList<HashMap<String, Object>> selectCashStatsByYear(String memberId){
		ArrayList<HashMap<String, Object>> list = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT YEAR(t2.cashDate) year\r\n"
				+ "		, COUNT(t2.importCash) countImport\r\n"
				+ "		, IFNULL(SUM(t2.importCash), 0) sumImport\r\n"
				+ "		, IFNULL(ROUND(AVG(t2.importCash)), 0) avgImport\r\n"
				+ "		, COUNT(t2.exportCash) countExport\r\n"
				+ "		, IFNULL(SUM(t2.exportCash), 0) sumExport\r\n"
				+ "		, IFNULL(ROUND(AVG(t2.exportCash)), 0) avgExport\r\n"
				+ "FROM \r\n"
				+ "	(SELECT memberId\r\n"
				+ "			, cashNo\r\n"
				+ "			, cashDate\r\n"
				+ "			, IF(categoryKind = '수입', cashPrice, NULL) importCash\r\n"
				+ "			, IF(categoryKind = '지출', cashPrice, NULL) exportCash\r\n"
				+ "	FROM (SELECT c.cash_no cashNo\r\n"
				+ "					, c.cash_date cashDate\r\n"
				+ "					, c.cash_price cashPrice\r\n"
				+ "					, ca.category_kind categoryKind\r\n"
				+ "					, c.member_id memberId\r\n"
				+ "			FROM cash c INNER JOIN category ca ON c.category_no = ca.category_no) t) t2\r\n"
				+ "WHERE t2.memberId = ? \r\n"
				+ "GROUP BY YEAR(t2.cashDate)\r\n"
				+ "ORDER BY YEAR(t2.cashDate) ASC ";
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, memberId);
			rs = stmt.executeQuery();
			list = new  ArrayList<HashMap<String, Object>>();
			while(rs.next()) {
				HashMap<String, Object> m = new HashMap<String, Object>();
				m.put("year", rs.getInt("year"));
				m.put("countImport", rs.getInt("countImport"));
				m.put("sumImport", rs.getInt("sumImport"));
				m.put("avgImport", rs.getInt("avgImport"));
				m.put("countExport", rs.getInt("countExport"));
				m.put("sumExport", rs.getInt("sumExport"));
				m.put("avgExport", rs.getInt("avgExport"));
				list.add(m);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return list;
	}
}
