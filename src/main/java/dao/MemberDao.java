package dao;

import java.sql.*;
import java.util.*;
import util.*;
import vo.*;

public class MemberDao {
	// 관리자 : 멤버등급수정
	public int updateMemberLevel(Member member) throws Exception{
		int row = 0;
		String sql = "UPDATE member\r\n"
				+ "SET member_level = ?\r\n"
				+ "WHERE member_id = ?";
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, member.getMemberLevel());
		stmt.setString(2, member.getMemberId());
		
		row = stmt.executeUpdate();
		
		dbUtil.close(null, stmt, conn);
		return row;
	}
	
	// 관리자: 멤버 수
	public int selectMemberCount() throws Exception{
		int count = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT COUNT(*)\r\n"
				+ "FROM member";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			count=rs.getInt("COUNT(*)");
		}
		return count;
	}
	
	// 관리자: 멤버 리스트
	public ArrayList<Member> selectMemberListByPage(int beginRow, int rowPerPage) throws Exception{
		ArrayList<Member> list = new ArrayList<>();
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT member_no memberNo\r\n"
				+ "	, member_id memberId\r\n"
				+ "	, member_level memberLevel\r\n"
				+ "	, member_name memberName\r\n"
				+ "	, updatedate\r\n"
				+ "	,createdate\r\n"
				+ "FROM member\r\n"
				+ "ORDER BY createdate DESC\r\n"
				+ "LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Member m = new Member();
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberId(rs.getString("memberId"));
			m.setMemberLevel(rs.getInt("memberLevel"));
			m.setMemberName(rs.getString("memberName"));
			m.setUpdatedate(rs.getString("updatedate"));
			m.setCreatedate(rs.getString("createdate"));
			list.add(m);
		}
		return list;
	}
	
	// 관리자: 멤버 강퇴 / 회원: 본인 계정 탈퇴
	public int deleteMember(int memberNo) throws Exception{
		int row = 0;
		String sql = "DELETE FROM member\r\n"
				+ "WHERE member_no = ?";
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		PreparedStatement stmt = null;
		
		conn = dbUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
		row = stmt.executeUpdate();
		
		dbUtil.close(null, stmt, conn);
		return row;
	}
	
	// 관리자: 입력 회원 번호에 해당하는 member 객체 뽑기
	public Member selectMember(int memberNo) throws Exception{
		Member member = new Member();
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT member_id memberId\r\n"
				+ "	, member_name memberName\r\n"
				+ "	, member_level memberLevel\r\n"
				+ "	, updatedate\r\n"
				+ "	, createdate\r\n"
				+ "FROM member\r\n"
				+ "WHERE member_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			member.setMemberId(rs.getString("memberId"));
			member.setMemberName(rs.getString("memberName"));
			member.setMemberLevel(rs.getInt("memberLevel"));
			member.setUpdatedate(rs.getString("updatedate"));
			member.setCreatedate(rs.getString("createdate"));
		}
		return member;
	}
		
	// 로그인 - id, pw 받음 ->Member타입
	public Member login(Member paramMember) throws Exception{	
		Member resultMember = null;
		
		// 공통 코드 메서드로 분리
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT member_no memberNo, member_id memberId, member_pw memberPw, member_name memberName, member_level memberLevel FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberId());
		stmt.setString(2, paramMember.getMemberPw());
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {	//일치한다면
			resultMember = new Member();
			resultMember.setMemberNo(rs.getInt("memberNo"));
			resultMember.setMemberId(rs.getString("memberId"));
			resultMember.setMemberName(rs.getString("memberName"));
			resultMember.setMemberLevel(rs.getInt("memberLevel"));
		}
		
		dbUtil.close(rs, stmt, conn);
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
		
		dbUtil.close(rs, stmt, conn);
		return row;
	}
	/*
	// true: 아이디 이미 존재, false: 사용 가능
	public boolean selectMemberIdCheck(String memberId) throws Exception{
		boolean result = false;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT member_id FROM member WHERE member_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, memberId);
		
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()){
			result = true;
		}
		
		dbUtil.close(rs, stmt, conn);
		return result;
	}
	 */
	
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
		
		// rs 없어서 null
		dbUtil.close(null, stmt, conn);
		return resultRow;	// 성공하면 1
	}
	
	// 비밀번호 일치 확인
	public int selectMemberPw(Member paramMember) throws Exception{
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT * FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberId());
		stmt.setString(2, paramMember.getMemberPw());
		
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
	public int updateMember(Member paramMember) throws Exception{
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE member\r\n"
				+ "SET member_name = ?, updatedate = CURDATE() \r\n"
				+ "WHERE member_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberName());
		stmt.setInt(2, paramMember.getMemberNo());
		
		// 성공하면 row == 1
		row=stmt.executeUpdate();
		
		dbUtil.close(null, stmt, conn);
		return row;
	}

	
}
