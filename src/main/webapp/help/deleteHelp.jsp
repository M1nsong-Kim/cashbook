<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "/help/helpList.jsp";
	// 방어코드 - 로그인x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	// 방어코드 - 번호x
	if(request.getParameter("helpNo") == null || request.getParameter("helpNo").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int helpNo = Integer.parseInt(request.getParameter("helpNo"));
	
	HelpDao helpDao = new HelpDao();
	int check = helpDao.deleteHelp(helpNo);	//모델 호출
	if(check == 0){	//삭제 실패
		System.out.println("문의 삭제 실패");
	}else {
		System.out.println("문의 삭제 성공");
	}
	
	response.sendRedirect(request.getContextPath()+targetUrl);
%>