<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	//Controller
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
	if(request.getParameter("adminPw") == null || request.getParameter("adminPw").equals("")){
		String msg = URLEncoder.encode("관리자 비밀번호를 입력해 주세요.","UTF-8");
		targetUrl = "/admin/deleteMemberForm.jsp";
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
		String msg = URLEncoder.encode("관리자 비밀번호가 다릅니다.","UTF-8");
		targetUrl = "/admin/deleteMemberForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl+"?msg="+msg+"&memberNo="+memberNo);
		return;
	}
	

	// 회원 강제 탈퇴
	int check = memberDao.deleteMember(memberNo);
	if(check == 0){
		System.out.println("회원 강제 탈퇴 실패");
		String msg = URLEncoder.encode("회원 강제 탈퇴를 성공하지 못했습니다.","UTF-8");
		targetUrl = "/admin/deleteMemberForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl+"?msg="+msg+"&memberNo="+memberNo);
		return;
	}
	
	System.out.println("회원 강제 탈퇴 성공");
	response.sendRedirect(request.getContextPath()+targetUrl);
%>