<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	
	// 방어코드
	if(request.getParameter("memberId") == null || request.getParameter("memberId").equals("")
		|| request.getParameter("memberPw") == null || request.getParameter("memberPw").equals("")
		|| request.getParameter("memberName") == null || request.getParameter("memberName").equals("")){
		response.sendRedirect(request.getContextPath()+"/member/signUpForm.jsp");
		return;
	}
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String memberName = request.getParameter("memberName");
	
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	paramMember.setMemberName(memberName);
	
	MemberDao memberDao = new MemberDao();
	memberDao.signUpMember(paramMember);	// 2 M 호출
	
	
%>