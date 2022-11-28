<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//controller
	request.setCharacterEncoding("UTF-8"); //한글 인코딩
	String targetUrl = "/loginForm.jsp";
	
	// 관리자만 접근 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	if(request.getParameter("categoryKind") == null || request.getParameter("categoryKind").equals("")
		|| request.getParameter("categoryName") == null || request.getParameter("categoryName").equals("")){
		targetUrl = "/admin/insertCategoryForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 카테고리 설정
	Category category = new Category();
	category.setCategoryKind(request.getParameter("categoryKind"));
	category.setCategoryName(request.getParameter("categoryName"));
	
	// 모델 호출
	CategoryDao categoryDao = new CategoryDao();
	int check = categoryDao.insertCategory(category);
	if(check == 0){	//카테고리 추가에 실패했다면
		System.out.println("카테고리 추가 실패");
		targetUrl = "/admin/insertCategoryForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}else {
		System.out.println("카테고리 추가 성공");
	}

	targetUrl = "/admin/categoryList.jsp";
	response.sendRedirect(request.getContextPath()+targetUrl);
%>