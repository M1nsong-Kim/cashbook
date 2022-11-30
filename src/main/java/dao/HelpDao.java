package dao;

import java.util.*;
import java.sql.*;
import util.*;

public class HelpDao {
	
	// 문의 추가
	
	// 문의 수정
	// 1) 문의 하나씩 보기
	public HashMap<String, Object> selectInquiryOne(int helpNo) throws Exception{
		HashMap<String, Object> map = new HashMap<String, Object>();
		String sql = "SELECT help_memo helpMemo\r\n"
				+ "	,member_id memberId\r\n"
				+ "	,createdate\r\n"
				+ "FROM help\r\n"
				+ "WHERE help_no = ?";
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, helpNo);
		rs = stmt.executeQuery();
		
		if(rs.next()) {
			map.put("helpMemo", rs.getString("helpMemo"));
			map.put("memberId", rs.getString("memberId"));
			map.put("createdate", rs.getString("createdate"));
		}
		
		dbUtil.close(rs, stmt, conn);
		return map;
	}
	
	// 2) 문의 수정 수행
	public int updateHelp(int helpNo) throws Exception{
		int row = 0;
		
		return row;
	}
	
	// 문의 삭제
	
	// 관리자 문의 목록(오버로딩)
	public ArrayList<HashMap<String, Object>> selectHelpList(int beginRow, int rowPerPage) throws Exception{
		ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
		String sql = "SELECT h.help_no helpNo\r\n"
				+ "		, h.help_memo helpMemo\r\n"
				+ "		, h.member_id memberId\r\n"
				+ "		, h.createdate createdateHelp\r\n"
				+ "		, c.comment_no commentNo\r\n"
				+ "		, c.comment_memo commentMemo\r\n"
				+ "		, c.createdate createdateComment\r\n"
				+ "FROM help h LEFT OUTER JOIN comment c ON h.help_no = c.help_no\r\n"
				+ "ORDER BY h.help_no DESC\r\n"
				+ "LIMIT ?, ?";
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		rs = stmt.executeQuery();

		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("helpNo", rs.getInt("helpNo"));
			m.put("helpMemo", rs.getString("helpMemo"));
			m.put("memberId", rs.getString("memberId"));
			m.put("createdateHelp", rs.getString("createdateHelp"));
			m.put("commentNo", rs.getString("commentNo"));
			m.put("commentMemo", rs.getString("commentMemo"));
			m.put("createdateComment", rs.getString("createdateComment"));
			list.add(m);
		}
		
		dbUtil.close(rs, stmt, conn);
		return list;
	}

	// 본인이 올린 문의만 확인하기
	public ArrayList<HashMap<String, Object>> selectHelpList(String memberId) throws Exception{
		ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
		String sql = "SELECT h.help_no helpNo\r\n"
					+ "	, h.help_memo helpMemo\r\n"
					+ "	, h.createdate createdateHelp\r\n"
					+ "	, c.comment_no commentNo\r\n"
					+ "	, c.comment_memo commentMemo\r\n"
					+ "	, c.createdate createdateComment\r\n"
					+ "FROM help h LEFT OUTER JOIN comment c ON h.help_no = c.help_no\r\n"
					+ "WHERE h.member_id = ?";
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, memberId);
		rs = stmt.executeQuery();

		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("helpNo", rs.getInt("helpNo"));
			m.put("helpMemo", rs.getString("helpMemo"));
			m.put("createdateHelp", rs.getString("createdateHelp"));
			m.put("commentMemo", rs.getString("commentNo"));
			m.put("commentMemo", rs.getString("commentMemo"));
			m.put("createdateComment", rs.getString("createdateComment"));
			list.add(m);
		}
		
		dbUtil.close(rs, stmt, conn);
		return list;
	}
	
	
	// 페이징을 위한 전체 개수 구하기
	public int selectHelpCount() throws Exception{
		int count = 0;
		String sql ="SELECT COUNT(*) cnt\r\n"
				+ "FROM help";
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		rs = stmt.executeQuery();
		
		if(rs.next()) {
			count = rs.getInt("cnt");
		}
		
		dbUtil.close(rs, stmt, conn);
		return count;
	}
}
