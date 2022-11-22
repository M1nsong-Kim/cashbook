<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1. C
	// 방어코드
	if(request.getParameter("memberId")==null || request.getParameter("memberPw")==null || request.getParameter("memberId").equals("") || request.getParameter("memberPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}

	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	System.out.println(memberId);	// 디버깅

	Member paramMember = new Member();	// 모델 호출 시 매개값
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	System.out.println(paramMember.getMemberId());	// 디버깅
	
	MemberDao memberDao = new MemberDao();
	Member resultMember = memberDao.login(paramMember);	// 2. M 호출
	
	String redirectUrl = "/loginForm.jsp";
	if(resultMember != null){
		System.out.println("로그인 성공");	//디버깅
		//세션에 로그인 정보 저장
		session.setAttribute("loginMember", resultMember);	// session 안에 로그인ID, 이름 저장
		redirectUrl = "/cash/cashList.jsp";
	}
	
	response.sendRedirect(request.getContextPath()+redirectUrl);
	
	
	// 3. V - 여긴 없음
%>
