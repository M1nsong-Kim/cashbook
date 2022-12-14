<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//C
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	
	String targetUrl = "/loginForm.jsp";
	
	// 로그인x -> 돌려보내기
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 입력 x -> 돌려보내기
	if(request.getParameter("memberId") == null || request.getParameter("memberId").equals("")
		|| request.getParameter("memberPw") == null || request.getParameter("memberPw").equals("")){
		targetUrl = "/member/deleteMemberForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 지금 접속중인 회원 번호
	Member loginMember = (Member)session.getAttribute("loginMember");
	int memberNo = loginMember.getMemberNo();
	
	Member paramMember = new Member();
	paramMember.setMemberId(request.getParameter("memberId"));
	paramMember.setMemberPw(request.getParameter("memberPw"));
	
	MemberDao memberDao = new MemberDao();
	// 비밀번호 일치 확인
	int checkPw = memberDao.selectMemberPw(paramMember);
	if(checkPw == 0){
		String msg = URLEncoder.encode("비밀번호가 일치하지 않습니다.", "UTF-8");
		targetUrl = "/member/deleteMemberForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl+"?msg="+msg);
		return;
	}

	// delete M 호출
	int check = memberDao.deleteMember(memberNo);
	if(check == 0){
		System.out.println("회원 탈퇴 실패");
		String msg = URLEncoder.encode("회원 탈퇴에 실패했습니다.", "UTF-8");
		targetUrl = "/member/deleteMemberForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl+"?msg="+msg);
		return;
	}
	
	System.out.println("회원 탈퇴 성공");
	session.invalidate();	//세션 초기화
	response.sendRedirect(request.getContextPath()+targetUrl);
%>