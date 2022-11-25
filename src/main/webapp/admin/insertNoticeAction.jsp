<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	String targetUrl = "/admin/insertNoticeForm.jsp";
	// 로그인x OR 관리자x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	// 안 넘어오면 폼으로 돌려보내기
	if(request.getParameter("noticeMemo") == null || request.getParameter("noticeMemo").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	String noticeMemo = request.getParameter("noticeMemo");
	
	NoticeDao noticeDao = new NoticeDao();
	Notice notice = new Notice();
	notice.setNoticeMemo(noticeMemo);
	int check =noticeDao.insertNotice(notice);	// M 호출
	if(check == 1){
		System.out.println("공지 추가 성공");
		targetUrl = "/admin/noticeList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
	}else {
		System.out.println("공지 추가 실패");
		response.sendRedirect(request.getContextPath()+targetUrl);
	}
	
	

%>