<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	// Controller
	String targetUrl = "/loginForm.jsp";
	
	// 로그인 x OR 관리자 x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 공지번호 x 
	if(request.getParameter("noticeNo") == null || request.getParameter("noticeNo").equals("")){
		targetUrl = "/admin/noticeList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	NoticeDao noticeDao = new NoticeDao();
	Notice notice = new Notice();
	notice.setNoticeNo(noticeNo);
	int check = noticeDao.deleteNotice(notice);
	if(check == 1){
		System.out.println("공지 삭제 성공");
	}else {
		System.out.println("공지 삭제 실패");
	}
	
	targetUrl = "/admin/noticeList.jsp";
	response.sendRedirect(request.getContextPath()+targetUrl);
%>