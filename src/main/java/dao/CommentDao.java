package dao;

import java.sql.*;
import util.*;
import vo.*;

public class CommentDao {
	
	// 답변 추가
	public int insertComment(Comment comment){
		int row = 0;		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "INSERT INTO comment(\r\n"
				+ "	help_no\r\n"
				+ "	, comment_memo\r\n"
				+ "	, member_id\r\n"
				+ "	, updatedate\r\n"
				+ "	, createdate)\r\n"
				+ "VALUES(\r\n"
				+ "	?\r\n"
				+ "	, ?\r\n"
				+ "	, ?\r\n"
				+ "	, NOW()\r\n"
				+ "	, NOW())";
		PreparedStatement stmt = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, comment.getHelpNo());
			stmt.setString(2, comment.getCommentMemo());
			stmt.setString(3, comment.getMemberId());
	
			// 성공하면 1
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
	
	// 답변 수정
	// 수정 전 답변 보기
	public Comment selectCommentOne(int commentNo){
		Comment comment = null;
		String sql = "SELECT help_no helpNo\r\n"
				+ "	,comment_memo commentMemo\r\n"
				+ "FROM comment\r\n"
				+ "WHERE comment_no = ?";
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, commentNo);
	
			rs = stmt.executeQuery();
			comment = new Comment();
			if(rs.next()) {
				comment.setHelpNo(rs.getInt("helpNo"));
				comment.setCommentMemo(rs.getString("commentMemo"));
				comment.setCommentNo(commentNo);
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
		
		return comment;
	}
	
	// 답변 수정 수행
	public int updateComment(Comment comment){
		int row = 0;		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "UPDATE comment\r\n"
				+ "SET comment_memo = ?\r\n"
				+ "	, updatedate = NOW()\r\n"
				+ "WHERE comment_no = ?";
		PreparedStatement stmt = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, comment.getCommentMemo());
			stmt.setInt(2, comment.getCommentNo());
			
			// 성공하면 1
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
	
	// 답변 삭제
	public int deleteComment(int commentNo){
		int row = 0;		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "DELETE FROM comment\r\n"
				+ "WHERE comment_no = ?";
		PreparedStatement stmt = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, commentNo);
			
			// 성공하면 1
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
}
