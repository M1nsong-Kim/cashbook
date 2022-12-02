package dao;

import java.sql.*;
import java.util.*;
import util.*;
import vo.*;

public class HelpDao {
	
	// 문의 추가
	public int insertHelp(Help help) {
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "INSERT INTO help(help_title\r\n"
				+ "						, help_memo\r\n"
				+ "						, member_id\r\n"
				+ "						, updatedate\r\n"
				+ "						, createdate)\r\n"
				+ "VALUES(?\r\n"
				+ "		, ?\r\n"
				+ "		, ?\r\n"
				+ "		, NOW()\r\n"
				+ "		, NOW())";
		PreparedStatement stmt = null;
		
		// 예외 가능성 -> try-catch
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, help.getHelpTitle());
			stmt.setString(2, help.getHelpMemo());
			stmt.setString(3, help.getMemberId());
			
			// 성공하면 1
			row = stmt.executeUpdate();
		}catch(Exception e) {	// 다형성 이용 -> 모든 예외 처리
			e.printStackTrace();	// 예외 메시지
		}finally {	// 예외 발생 여부에 관계없이 무조건 실행
			try {	// 예외 가능성 -> try-catch(중첩)
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return row;
	}
	
	// 문의 수정
	// 1) 문의 하나씩 보기
	public HashMap<String, Object> selectInquiryOne(int helpNo){
		HashMap<String, Object> map = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT help_title helpTitle"
				+ " ,help_memo helpMemo\r\n"
				+ "	,member_id memberId\r\n"
				+ "	,createdate\r\n"
				+ "FROM help\r\n"
				+ "WHERE help_no = ?";		
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		// 예외 가능성 -> try-catch
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, helpNo);
			rs = stmt.executeQuery();
			
			map = new HashMap<String, Object>();
			if(rs.next()) {
				map.put("helpTitle", rs.getString("helpTitle"));
				map.put("helpMemo", rs.getString("helpMemo"));
				map.put("memberId", rs.getString("memberId"));
				map.put("createdate", rs.getString("createdate"));
			}
		} catch(Exception e) {	// 다형성 이용 -> 모든 예외 처리
			e.printStackTrace();	// 예외 메시지
		} finally {	// 예외 발생 여부에 관계없이 실행
			try {	// 예외 가능성 -> try-catch 중첩
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		
		return map;
	}
	
	// 2) 문의 수정 수행
	public int updateHelp(Help help){
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "UPDATE help \r\n"
				+ "SET help_title = ?\r\n"
				+ "	, help_memo = ?\r\n"
				+ "	, updatedate = NOW()\r\n"
				+ "WHERE help_no = ? ";
		PreparedStatement stmt = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, help.getHelpTitle());
			stmt.setString(2, help.getHelpMemo());
			stmt.setInt(3, help.getHelpNo());
			
			// 성공하면 1 반환
			row = stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return row;
	}
	
	// 문의 삭제
	public int deleteHelp(int helpNo) {
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "DELETE FROM help\r\n"
				+ "WHERE help_no = ?";
		PreparedStatement stmt = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, helpNo);
			
			row = stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		// 성공하면 1 실패하면 0 반환
		return row;
	}
	
	// 관리자 문의 목록(오버로딩)
	public ArrayList<HashMap<String, Object>> selectHelpList(int beginRow, int rowPerPage){
		ArrayList<HashMap<String,Object>> list = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT h.help_no helpNo\r\n"
				+ "		, h.help_title helpTitle\r\n"
				+ "		, h.help_memo helpMemo\r\n"
				+ "		, h.member_id memberId\r\n"
				+ "		, h.createdate createdateHelp\r\n"
				+ "		, c.comment_no commentNo\r\n"
				+ "		, c.comment_memo commentMemo\r\n"
				+ "		, c.createdate createdateComment\r\n"
				+ "FROM help h LEFT OUTER JOIN comment c ON h.help_no = c.help_no\r\n"
				+ "ORDER BY h.help_no DESC\r\n"
				+ "LIMIT ?, ?";		
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
			
			rs = stmt.executeQuery();
			list = new ArrayList<HashMap<String,Object>>();
			while(rs.next()) {
				HashMap<String, Object> m = new HashMap<String, Object>();
				m.put("helpNo", rs.getInt("helpNo"));
				m.put("helpTitle", rs.getString("helpTitle"));
				m.put("helpMemo", rs.getString("helpMemo"));
				m.put("memberId", rs.getString("memberId"));
				m.put("createdateHelp", rs.getString("createdateHelp"));
				m.put("commentNo", rs.getString("commentNo"));
				m.put("commentMemo", rs.getString("commentMemo"));
				m.put("createdateComment", rs.getString("createdateComment"));
				list.add(m);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		
		return list;
	}

	// 본인이 올린 문의만 확인하기
	public ArrayList<HashMap<String, Object>> selectHelpList(String memberId){
		ArrayList<HashMap<String,Object>> list = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT h.help_no helpNo\r\n"
					+ "	, h.help_title helpTitle\r\n"
					+ "	, h.help_memo helpMemo\r\n"
					+ "	, h.createdate createdateHelp\r\n"
					+ "	, c.comment_no commentNo\r\n"
					+ "	, c.comment_memo commentMemo\r\n"
					+ "	, c.createdate createdateComment\r\n"
					+ "FROM help h LEFT OUTER JOIN comment c ON h.help_no = c.help_no\r\n"
					+ "WHERE h.member_id = ?";		
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, memberId);
			
			rs = stmt.executeQuery();
			list = new ArrayList<HashMap<String,Object>>();
			while(rs.next()) {
				HashMap<String, Object> m = new HashMap<String, Object>();
				m.put("helpNo", rs.getInt("helpNo"));
				m.put("helpTitle", rs.getString("helpTitle"));
				m.put("helpMemo", rs.getString("helpMemo"));
				m.put("createdateHelp", rs.getString("createdateHelp"));
				m.put("commentMemo", rs.getString("commentNo"));
				m.put("commentMemo", rs.getString("commentMemo"));
				m.put("createdateComment", rs.getString("createdateComment"));
				list.add(m);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		
		return list;
	}
	
	
	// 페이징을 위한 전체 개수 구하기
	public int selectHelpCount(){
		int count = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql ="SELECT COUNT(*) cnt\r\n"
				+ "FROM help";
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt("cnt");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				dbUtil.close(rs, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		
		return count;
	}
}
