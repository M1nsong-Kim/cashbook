<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%
	// Controller
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	String targetUrl = "/admin/helpListAll.jsp";
	// 로그인 x OR 관리자 x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	// 관리자 아이디 저장
	String loginMemberId = loginMember.getMemberId();
	
	// 방어코드
	if(request.getParameter("helpNo") == null || request.getParameter("helpNo").equals("")
		|| request.getParameter("commentMemo") == null || request.getParameter("commentMemo").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 넘어온 값 저장
	int helpNo = Integer.parseInt(request.getParameter("helpNo"));
	String commentMemo = request.getParameter("commentMemo");
	
	// comment에 입력값 넣기
	Comment comment = new Comment();
	comment.setHelpNo(helpNo);
	comment.setCommentMemo(commentMemo);
	comment.setMemberId(loginMemberId);
	
	CommentDao commentDao = new CommentDao();
	int check = commentDao.insertComment(comment);	// 모델 호출
	if(check == 1){
		System.out.println("문의 답변 등록 성공");
	}else {
		System.out.println("문의 답변 등록 실패");
	}
	
	response.sendRedirect(request.getContextPath()+targetUrl);
%>