package dao;

import java.sql.*;
import java.util.ArrayList;
import util.*;
import vo.*;


public class NoticeDao {
	
	public int deleteNotice(Notice notice) throws Exception{
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "DELETE FROM notice WHERE notice_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, notice.getNoticeNo());
		
		row = stmt.executeUpdate();
		// 성공하면 1 반환
		return row;
	}
	
	public int updateNotice(Notice notice) throws Exception{
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql  = "UPDATE notice SET notice_memo = ?, updatedate = NOW() WHERE notice_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, notice.getNoticeMemo());
		stmt.setInt(2, notice.getNoticeNo());
		
		row = stmt.executeUpdate();
		// 성공하면 1 반환
		return row;
	}
	
	public int insertNotice(Notice notice) throws Exception{
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "INSERT notice(notice_memo, updatedate, createdate) VALUES(?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, notice.getNoticeMemo());
		
		row = stmt.executeUpdate();
		// 성공하면 1 반환
		return row;
	}
	
	// 매개변수로 입력한 공지 번호에 해당하는 notice 객체 받기
	public Notice selectNotice(int noticeNo) throws Exception{
		Notice notice = new Notice();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT notice_memo noticeMemo\r\n"
				+ "	, updatedate\r\n"
				+ "	, createdate\r\n"
				+ "FROM notice\r\n"
				+ "WHERE notice_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, noticeNo);
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			notice.setNoticeNo(noticeNo);
			notice.setNoticeMemo(rs.getString("noticeMemo"));
			notice.setUpdatedate(rs.getString("updatedate"));
			notice.setCreatedate(rs.getString("createdate"));
		}
		return notice;
	}
	
	// 마지막 페이지 구하기
	public int selectNoticeCount() throws Exception{
		int count = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql="SELECT COUNT(*)\r\n"
				+ "FROM notice";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			count = rs.getInt("COUNT(*)");
		}
		return count;
	}
	
	
	// loginForm.jsp 공지 목록
	public ArrayList<Notice> selectNoticeListByPage(int beginRow, int rowPerPage) throws Exception{
		ArrayList<Notice> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT notice_no noticeNo\r\n"
				+ "	, notice_memo noticeMemo\r\n"
				+ "	, createdate \r\n"
				+ "FROM notice \r\n"
				+ "ORDER BY createdate DESC \r\n"
				+ "LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Notice n = new Notice();
			n.setNoticeNo(rs.getInt("noticeNo"));
			n.setNoticeMemo(rs.getString("noticeMemo"));
			n.setCreatedate(rs.getString("createdate"));
			list.add(n);
		}
		return list;
	}
}
