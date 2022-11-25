<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	String targetUrl = "loginForm.jsp";
	// 로그인하지 않았거나 관리자가 아니라면 돌려보내기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) {
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	//방어코드
	if(request.getParameter("noticeNo") == null || request.getParameter("noticeNo").equals("")
		|| request.getParameter("noticeMemo") == null || request.getParameter("noticeMemo").equals("")){
		targetUrl = "/admin/updateNoticeForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeMemo = request.getParameter("noticeMemo");
	
	NoticeDao noticeDao = new NoticeDao();
	Notice notice = noticeDao.selectNotice(noticeNo);	// M 호출
	// noticeNo로 select한 notice 객체에서 내용만 다시 설정하기
	notice.setNoticeMemo(noticeMemo);	
	int check = noticeDao.updateNotice(notice);		// M 호출
	if(check == 0){
		System.out.println("공지 수정 실패");
	}else {
		System.out.println("공지 수정 성공");
	}
	
	targetUrl = "/admin/updateNoticeForm.jsp";
	response.sendRedirect(request.getContextPath()+targetUrl);
%>