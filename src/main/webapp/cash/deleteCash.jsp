<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	
	// 로그인하지 않았다면 로그인창으로 보냄
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}

	// 로그인 중인 멤버 세션 받기
	Member loginMember = (Member)session.getAttribute("loginMember");
	String loginMemberId = loginMember.getMemberId();

	// 방어코드
	if(request.getParameter("year") == null || request.getParameter("year").equals("")
		|| request.getParameter("month") == null || request.getParameter("month").equals("")
		|| request.getParameter("date") == null || request.getParameter("date").equals("")
		|| request.getParameter("cashNo") == null || request.getParameter("cashNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/cash/cashDateList.jsp");
		return;
	}
	
	int year = Integer.parseInt(request.getParameter("year"));
	int month = Integer.parseInt(request.getParameter("month"));
	int date = Integer.parseInt(request.getParameter("date"));
	int cashNo = Integer.parseInt(request.getParameter("cashNo"));
	
	
	CashDao cashDao = new CashDao();
	int check = cashDao.deleteCash(cashNo);
	if(check == 1){
		System.out.println("삭제 성공");
	}else {
		System.out.println("삭제 실패");
	}
	

	// 삭제되면 해당 날짜의 상세페이지로
	response.sendRedirect(request.getContextPath()+"/cash/cashDateList.jsp?year="+year+"&month="+month+"&date="+date);
%>