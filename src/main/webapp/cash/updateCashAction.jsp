<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	
	//로그인 x -> 로그인창으로 돌려보냄
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	//현재 로그인한 사람
	Member loginMember = (Member)session.getAttribute("loginMember");
	String loginMemberId = loginMember.getMemberId();

	// 방어코드 - 일자/캐시번호 없으면 오늘 날짜가 있는 가계부로
	if(request.getParameter("year") == null || request.getParameter("year").equals("")
		|| request.getParameter("month") == null || request.getParameter("month").equals("")
		|| request.getParameter("date") == null || request.getParameter("date").equals("")
		|| request.getParameter("cashNo") == null || request.getParameter("cashNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/cash/cashList.jsp");
		return;
	}
	
	int year = Integer.parseInt(request.getParameter("year"));
	int month = Integer.parseInt(request.getParameter("month"));
	int date = Integer.parseInt(request.getParameter("date"));
	int cashNo = Integer.parseInt(request.getParameter("cashNo"));
	
	// 방어코드 - 입력되지 않았으면 해당 캐시번호의 업데이트 폼으로 돌려보내기
	if(request.getParameter("cashDate") == null || request.getParameter("cashDate").equals("")
		|| request.getParameter("categoryNo") == null || request.getParameter("categoryNo").equals("")
		|| request.getParameter("cashPrice") == null || request.getParameter("cashPrice").equals("")
		|| request.getParameter("cashMemo") == null || request.getParameter("cashMemo").equals("")){
		response.sendRedirect(request.getContextPath()+"/cash/updateCashForm.jsp?cashNo="+cashNo+"&year="+year+"&month="+month+"&date="+date);
		return;
	}
	
	int categoryNo = Integer.parseInt(request.getParameter("categoryNo"));
	long cashPrice = Long.parseLong(request.getParameter("cashPrice"));
	String cashMemo = request.getParameter("cashMemo");
	
	Cash cash = new Cash();
	cash.setCategoryNo(categoryNo);
	cash.setCashPrice(cashPrice);
	cash.setCashMemo(cashMemo);
	cash.setCashNo(cashNo);
	cash.setMemberId(loginMemberId);
	
	CashDao cashDao = new CashDao();
	int check = cashDao.updateCashList(cash);
	if(check == 1){
		System.out.println("업데이트 성공");
	}else {
		System.out.println("업데이트 실패");
	}


	// 해당 날짜의 상세 페이지로 이동
	response.sendRedirect(request.getContextPath()+"/cash/cashDateList.jsp?year="+year+"&month="+month+"&date="+date);
%>