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
	
	// 회원가입
	public int insertMember(Member paramMember) throws Exception{
		int resultRow = 0;
		return resultRow;
	}
}
