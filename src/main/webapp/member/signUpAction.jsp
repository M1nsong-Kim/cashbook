<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	request.setCharacterEncoding("UTF-8"); //한글 인코딩
	
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
	
	MemberDao memberDao = new MemberDao();
	int check = memberDao.memberIdCheck(memberId);
	
	if(check == 1){
		System.out.println("중복된 아이디가 아닙니다");
	}else {
		String msg = URLEncoder.encode("중복된 아이디입니다.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/member/signUpForm.jsp?msg="+msg);
		return;
	}
	
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	paramMember.setMemberName(memberName);
	
	memberDao.signUpMember(paramMember);	// 2 M 호출
	
	response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
%>