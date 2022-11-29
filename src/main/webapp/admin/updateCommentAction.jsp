<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	request.setCharacterEncoding("UTF-8"); // 한글 인코딩
	String targetUrl = "/admin/helpListAll.jsp";
	
	// 로그인 x OR 관리자 x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}

	// 답변 번호 OR 답변 x
	if(request.getParameter("commentNo") == null || request.getParameter("commentNo").equals("")
		|| request.getParameter("commentMemo") == null || request.getParameter("commentMemo").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	System.out.println("번호랑 내용 잘 넘어가는지 확인");
	
	// 값 받아오기
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentMemo = request.getParameter("commentMemo");
	
	// 받아온 값 Comment 타입에 넣기
	Comment comment = new Comment();
	comment.setCommentNo(commentNo);
	comment.setCommentMemo(commentMemo);
	
	CommentDao commentDao = new CommentDao();
	int check = commentDao.updateComment(comment);
	
	if(check == 0){
		System.out.println("문의 답변 수정 실패");
		targetUrl = "/admin/updateCommentForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl+"?commentNo="+commentNo);
		return;
	}
	
	System.out.println("문의 답변 수정 성공");
	response.sendRedirect(request.getContextPath()+targetUrl);
%>
