package dao;

import java.sql.*;
import util.DBUtil;
import vo.Member;

public class MemberDao {
	// 로그인 - id, pw 받음 ->Member타입
	public Member login(Member paramMember) throws Exception{	
		Member resultMember = null;
		
		// 공통 코드 메서드로 분리
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT member_id memberId, member_name memberName FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberId());
		stmt.setString(2, paramMember.getMemberPw());
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {	//일치한다면
			resultMember = new Member();
			resultMember.setMemberId(rs.getString("memberId"));
			resultMember.setMemberName(rs.getString("memberName"));
		}
		
		rs.close();
		stmt.close();
		conn.close();
		return resultMember;
	}
	
	// 아이디 중복 확인
	public int memberIdCheck(String memberId) throws Exception {
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT member_id FROM member WHERE member_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, memberId);
		
		ResultSet rs = stmt.executeQuery();
		
		if(!rs.next()){	//중복되는 아이디가 없다면
			row = 1;
		}
		
		rs.close();
		stmt.close();
		conn.close();
		return row;
	}
	
	// 회원가입
	public int signUpMember(Member paramMember) throws Exception{
		int resultRow = 0;
		
		// 공통 코드 메서드로 분리
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
				
		String sql ="INSERT INTO member(member_id, member_pw, member_name, updatedate, createdate) VALUES(?, PASSWORD(?), ?, CURDATE(), CURDATE())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberId());
		stmt.setString(2, paramMember.getMemberPw());
		stmt.setString(3, paramMember.getMemberName());
		
		resultRow = stmt.executeUpdate();
		return resultRow;	// 성공하면 1
	}
	
	// 비밀번호 일치 확인
	public int selectMemberPw(String memberId, String memberPw) throws Exception{
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT * FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, memberId);
		stmt.setString(2, memberPw);
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {	//비밀번호가 일치한다면
			row = 1;
		}
		
		rs.close();
		stmt.close();
		conn.close();
		return row;
	}

	// 비밀번호 수정
	public int updateMemberPw(String updatePw, String memberId) throws Exception{
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE member\r\n"
				+ "SET member_pw = PASSWORD(?)\r\n"
				+ "WHERE member_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, updatePw);
		stmt.setString(2, memberId);
		
		// 성공하면 row == 1
		row = stmt.executeUpdate();

		stmt.close();
		conn.close();
		return row;
	}
	
	// 회원 정보 수정
	public int updateMember(String memberName, String memberId, String memberPw) throws Exception{
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE member\r\n"
				+ "SET member_name = ?\r\n"
				+ "WHERE member_id = ? AND member_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, memberName);
		stmt.setString(2, memberId);
		stmt.setString(3, memberPw);
		
		// 성공하면 row == 1
		row=stmt.executeUpdate();
		
		stmt.close();
		conn.close();
		return row;
	}
}
