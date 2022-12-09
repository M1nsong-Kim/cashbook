<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//Controller
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	String targetUrl = "/admin/memberList.jsp";
	// 로그인x OR 관리자x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 방어코드 - 회원번호x
	if(request.getParameter("memberNo") == null || request.getParameter("memberNo").equals("")){
		targetUrl = "/admin/memberList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));

	// 방어코드 - 회원 등급 OR 비밀번호 입력 x
	if(request.getParameter("memberLevel") == null || request.getParameter("memberLevel").equals("")
		|| request.getParameter("adminPw") == null || request.getParameter("adminPw").equals("")){
		String msg = URLEncoder.encode("모든 항목을 입력해 주세요.","UTF-8");
		targetUrl = "/admin/updateMemberLevelForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl+"?msg="+msg+"&memberNo="+memberNo);
		return;
	}
	
	MemberDao memberDao = new MemberDao();
	Member paramMember = new Member();
	paramMember.setMemberId(loginMember.getMemberId());
	paramMember.setMemberPw(request.getParameter("adminPw"));
	
	//관리자 비밀번호 일치 확인
	int checkAdminPw = memberDao.selectMemberPw(paramMember);	
	if(checkAdminPw == 0){
		String msg = URLEncoder.encode("비밀번호가 다릅니다.","UTF-8");
		targetUrl = "/admin/updateMemberLevelForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl+"?msg="+msg+"&memberNo="+memberNo);
		return;
	}
	
	// 회원 조회
	Member member = memberDao.selectMember(memberNo);	// 모델 호출
	
	// 회원 등급 변경
	member.setMemberLevel(Integer.parseInt(request.getParameter("memberLevel")));
	int check = memberDao.updateMemberLevel(member);	// 모델 호출
	if(check == 0){
		System.out.println("회원 등급 변경 실패");
		targetUrl = "/admin/updatememberLevelForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	System.out.println("회원 등급 변경 성공");
	response.sendRedirect(request.getContextPath()+targetUrl);
%>