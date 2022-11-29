<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "/admin/helpListAll.jsp";
	// 방어코드 - 로그인/필요한 회원등급 여부
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	// 방어코드 -답변 번호 넘어와야
	if(request.getParameter("commentNo") == null || request.getParameter("commentNo").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	
	CommentDao commentDao = new CommentDao();
	int check = commentDao.deleteComment(commentNo);
	if(check == 0){
		System.out.println("답변 삭제 실패");
	}else{
		System.out.println("답변 삭제 성공");
	}
	
	response.sendRedirect(request.getContextPath()+targetUrl);
%>