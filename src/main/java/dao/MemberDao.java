package dao;

import java.sql.*;
import java.util.*;
import util.*;
import vo.*;

public class MemberDao {
	// 관리자 : 멤버등급수정
	public int updateMemberLevel(Member member){
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "UPDATE member\r\n"
				+ "SET member_level = ?\r\n"
				+ "WHERE member_id = ?";
		PreparedStatement stmt = null;
		
		// 예외 가능성 있는 코드 묶기
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, member.getMemberLevel());
			stmt.setString(2, member.getMemberId());
			
			row = stmt.executeUpdate();
		}catch (Exception e) {	// 다형성 이용해서 모든 예외 잡기
			e.printStackTrace();	// 예외 메시지
		}finally {	// 예외 발생 여부에 관계없이 무조건 실행
			try {	// 예외 가능성 -> try-catch 중첩
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}			
		}
		
		return row;
	}
	
	// 관리자: 멤버 수
	public int selectMemberCount(){
		int count = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT COUNT(*)\r\n"
				+ "FROM member";
		PreparedStatement stmt = null;

		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			if(rs.next()) {
				count=rs.getInt("COUNT(*)");
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
		
		return count;
	}
	
	// 관리자: 멤버 리스트
	public ArrayList<Member> selectMemberListByPage(int beginRow, int rowPerPage){
		ArrayList<Member> list = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT member_no memberNo\r\n"
				+ "	, member_id memberId\r\n"
				+ "	, member_level memberLevel\r\n"
				+ "	, member_name memberName\r\n"
				+ "	, updatedate\r\n"
				+ "	,createdate\r\n"
				+ "FROM member\r\n"
				+ "ORDER BY createdate DESC\r\n"
				+ "LIMIT ?, ?";
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
			rs = stmt.executeQuery();
			list = new ArrayList<>();
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
	
	// 관리자: 멤버 강퇴 / 회원: 본인 계정 탈퇴
	public int deleteMember(int memberNo){
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "DELETE FROM member\r\n"
				+ "WHERE member_no = ?";
		PreparedStatement stmt = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, memberNo);
			row = stmt.executeUpdate();
		} catch(Exception e) {
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
	
	// 관리자: 입력 회원 번호에 해당하는 member 객체 뽑기
	public Member selectMember(int memberNo){
		Member member = null;
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT member_id memberId\r\n"
				+ "	, member_name memberName\r\n"
				+ "	, member_level memberLevel\r\n"
				+ "	, updatedate\r\n"
				+ "	, createdate\r\n"
				+ "FROM member\r\n"
				+ "WHERE member_no = ?";
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, memberNo);
			rs = stmt.executeQuery();
			member = new Member();
			if(rs.next()) {
				member.setMemberId(rs.getString("memberId"));
				member.setMemberName(rs.getString("memberName"));
				member.setMemberLevel(rs.getInt("memberLevel"));
				member.setUpdatedate(rs.getString("updatedate"));
				member.setCreatedate(rs.getString("createdate"));
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
		return member;
	}
		
	// 로그인 - id, pw 받음 ->Member타입
	public Member login(Member paramMember){	
		Member resultMember = null;
		// 공통 코드 메서드로 분리
		DBUtil dbUtil = new DBUtil();		
		Connection conn = null;
		String sql = "SELECT member_no memberNo, member_id memberId, member_pw memberPw, member_name memberName, member_level memberLevel FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, paramMember.getMemberId());
			stmt.setString(2, paramMember.getMemberPw());
			
			rs = stmt.executeQuery();
			if(rs.next()) {	//일치한다면
				resultMember = new Member();
				resultMember.setMemberNo(rs.getInt("memberNo"));
				resultMember.setMemberId(rs.getString("memberId"));
				resultMember.setMemberName(rs.getString("memberName"));
				resultMember.setMemberLevel(rs.getInt("memberLevel"));
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
		
		return resultMember;
	}
	
	// 아이디 중복 확인
	public int memberIdCheck(String memberId){
		int row = 0;		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT member_id FROM member WHERE member_id = ?";
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			
			conn = dbUtil.getConnection();		
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, memberId);
			
			rs = stmt.executeQuery();
			
			if(!rs.next()){	//중복되는 아이디가 없다면
				row = 1;
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
	public int signUpMember(Member paramMember){
		int resultRow = 0;
		
		// 공통 코드 메서드로 분리
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql ="INSERT INTO member(member_id, member_pw, member_name, updatedate, createdate) VALUES(?, PASSWORD(?), ?, CURDATE(), CURDATE())";
		PreparedStatement stmt = null;

		try {
			conn = dbUtil.getConnection();		
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, paramMember.getMemberId());
			stmt.setString(2, paramMember.getMemberPw());
			stmt.setString(3, paramMember.getMemberName());
			
			resultRow = stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			// rs 없어서 null
			try {
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return resultRow;	// 성공하면 1
	}
	
	// 비밀번호 일치 확인
	public int selectMemberPw(Member paramMember){
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "SELECT * FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {	
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, paramMember.getMemberId());
			stmt.setString(2, paramMember.getMemberPw());
			
			rs = stmt.executeQuery();
			if(rs.next()) {	//비밀번호가 일치한다면
				row = 1;
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
		
		return row;
	}

	// 비밀번호 수정
	public int updateMemberPw(String updatePw, String memberId){
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "UPDATE member\r\n"
				+ "SET member_pw = PASSWORD(?)\r\n"
				+ "WHERE member_id = ?";
		PreparedStatement stmt = null;

		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, updatePw);
			stmt.setString(2, memberId);
			
			// 성공하면 row == 1
			row = stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				dbUtil.close(null, stmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}			
		}

		return row;
	}
	
	// 회원 정보 수정
	public int updateMember(Member paramMember){
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = null;
		String sql = "UPDATE member\r\n"
				+ "SET member_name = ?, updatedate = CURDATE() \r\n"
				+ "WHERE member_no = ?";
		PreparedStatement stmt = null;

		try {
			conn = dbUtil.getConnection();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, paramMember.getMemberName());
			stmt.setInt(2, paramMember.getMemberNo());
			
			// 성공하면 row == 1
			row=stmt.executeUpdate();
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
