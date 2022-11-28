<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	// Controller
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	String targetUrl = "/admin/categoryList.jsp";
	// 관리자만
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	// 방어코드
	if(request.getParameter("categoryNo") == null || request.getParameter("categoryNo").equals("")
		|| request.getParameter("categoryName") == null || request.getParameter("categoryName").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int categoryNo = Integer.parseInt(request.getParameter("categoryNo"));
	String categoryName = request.getParameter("categoryName");
	
	// 모델 호출
	CategoryDao categoryDao = new CategoryDao();
	Category category = new Category();
	category.setCategoryNo(categoryNo);
	category.setCategoryName(categoryName);
	
	int check = categoryDao.updateCategoryName(category);
	if(check == 0){
		System.out.println("카테고리 수정 실패");
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	System.out.println("카테고리 수정 성공");
	response.sendRedirect(request.getContextPath()+targetUrl);
%>