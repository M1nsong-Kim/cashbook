<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	// Controller
	String targetUrl = "/admin/categoryList.jsp";
	// 관리자만
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 카테고리 번호 입력되지 않으면 돌려보내기
	if(request.getParameter("categoryNo") == null || request.getParameter("categoryNo").equals("")){
		System.out.println("입력된 카테고리 번호 없음");
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int categoryNo = Integer.parseInt(request.getParameter("categoryNo"));
	
	// 모델 호출
	CategoryDao categoryDao = new CategoryDao();
	Category category = new Category();
	int check = categoryDao.deleteCategory(categoryNo);
	if(check == 0){
		System.out.println("카테고리 삭제 실패");
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	System.out.println("카테고리 삭제 성공");
	response.sendRedirect(request.getContextPath()+targetUrl);
%>