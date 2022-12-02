<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "dao.*" %>
<%@ page import= "vo.*" %>
<%
	// Controller
	request.setCharacterEncoding("UTF-8");
	String targetUrl = "/help/insertHelpForm.jsp";
	
	// 방어코드: 로그인 x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	String memberId = loginMember.getMemberId();
	
	// 방어코드: 입력 x
	if(request.getParameter("helpTitle") == null || request.getParameter("helpTitle").equals("")
		|| request.getParameter("helpMemo") == null || request.getParameter("helpMemo").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	String helpTitle = request.getParameter("helpTitle");
	String helpMemo = request.getParameter("helpMemo");
	
	Help help = new Help();
	help.setMemberId(memberId);
	help.setHelpTitle(helpTitle);
	help.setHelpMemo(helpMemo);
	
	HelpDao helpDao = new HelpDao();
	int check = helpDao.insertHelp(help);	// 모델 호출
	if(check == 0){	//문의 추가에 실패했다면
		System.out.println("문의 추가 실패");
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	System.out.println("문의 추가 성공");
	targetUrl = "/help/helpList.jsp";
	response.sendRedirect(request.getContextPath()+targetUrl);
%>