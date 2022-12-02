package dao;

import java.sql.*;
import java.util.ArrayList;
import util.*;
import vo.*;


public class NoticeDao {
	
	public int deleteNotice(Notice notice){
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		
		// 예외 가능성 있는 부분 처리
		try {
			conn = dbUtil.getConnection();
			String sql = "DELETE FROM notice WHERE notice_no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, notice.getNoticeNo());
			
			// 성공하면 1 반환
			row = stmt.executeUpdate();
		}catch(Exception e) {	// 다형성 이용
			e.printStackTrace();	//예외 메시지
		}finally {
			try {	//다시 예외 가능성 있어서 처리
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return row;
	}
	
	public int updateNotice(Notice notice){
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		
		// 예외 가능성 있는 부분 묶기
		try {
			conn = dbUtil.getConnection();
			String sql  = "UPDATE notice SET notice_memo = ?, updatedate = NOW() WHERE notice_no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, notice.getNoticeMemo());
			stmt.setInt(2, notice.getNoticeNo());
			
			// 성공하면 1 반환
			row = stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();	//예외 메시지
		}finally {	// 예외 발생 여부에 관계없이 무조건 실행
			try {	// 예외 가능성 있어 다시 try-catch
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return row;
	}
	
	public int insertNotice(Notice notice){
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;

		// 예외 가능성 있는 부분 묶기
		try {			
			conn = dbUtil.getConnection();
			String sql = "INSERT notice(notice_memo, updatedate, createdate) VALUES(?, NOW(), NOW())";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, notice.getNoticeMemo());
			
			// 성공하면 1 반환
			row = stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();	// 예외 메시지
		}finally { //무조건 실행			
			try {	//예외 가능성 -> 중첩 try-catch
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return row;
	}
	
	// 매개변수로 입력한 공지 번호에 해당하는 notice 객체 받기
	public Notice selectNotice(int noticeNo){
		Notice notice = null; 
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;

		try {
			conn = dbUtil.getConnection();
			String sql = "SELECT notice_memo noticeMemo\r\n"
					+ "	, updatedate\r\n"
					+ "	, createdate\r\n"
					+ "FROM notice\r\n"
					+ "WHERE notice_no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, noticeNo);
			
			ResultSet rs = stmt.executeQuery();
			notice = new Notice();
			if(rs.next()) {
				notice.setNoticeNo(noticeNo);
				notice.setNoticeMemo(rs.getString("noticeMemo"));
				notice.setUpdatedate(rs.getString("updatedate"));
				notice.setCreatedate(rs.getString("createdate"));
			}
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
		
		return notice;
	}
	
	// 마지막 페이지 구하기
	public int selectNoticeCount(){
		int count = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null; 
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			conn = dbUtil.getConnection();
			String sql="SELECT COUNT(*)\r\n"
					+ "FROM notice";
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt("COUNT(*)");
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
	
	
	// loginForm.jsp 공지 목록
	public ArrayList<Notice> selectNoticeListByPage(int beginRow, int rowPerPage){
		ArrayList<Notice> list = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {	
			conn = dbUtil.getConnection();
			String sql = "SELECT notice_no noticeNo\r\n"
					+ "	, notice_memo noticeMemo\r\n"
					+ "	, createdate \r\n"
					+ "FROM notice \r\n"
					+ "ORDER BY createdate DESC \r\n"
					+ "LIMIT ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
	
			rs = stmt.executeQuery();
			list = new ArrayList<>();
			while(rs.next()) {
				Notice n = new Notice();
				n.setNoticeNo(rs.getInt("noticeNo"));
				n.setNoticeMemo(rs.getString("noticeMemo"));
				n.setCreatedate(rs.getString("createdate"));
				list.add(n);
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
}
