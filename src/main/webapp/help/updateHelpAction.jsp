<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<% 
	// Controller
	request.setCharacterEncoding("UTF-8"); //한글 인코딩
	String targetUrl = "";
	
	// 방어코드 -로그인 x -> 로그인창으로
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 문의 번호 x -> 내 문의내역으로
	if(request.getParameter("helpNo") == null || request.getParameter("helpNo").equals("")){
		targetUrl = "/help/helpList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int helpNo = Integer.parseInt(request.getParameter("helpNo"));
%>