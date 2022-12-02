<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<% 
	// Controller
	request.setCharacterEncoding("UTF-8"); //한글 인코딩
	String targetUrl = "/help/helpList.jsp";
	
	// 방어코드 -로그인 x -> 로그인창으로
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 문의 번호 x -> 내 문의내역으로
	if(request.getParameter("helpNo") == null || request.getParameter("helpNo").equals("")
		|| request.getParameter("helpTitle") == null || request.getParameter("helpTitle").equals("")
		|| request.getParameter("helpMemo") == null || request.getParameter("helpMemo").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int helpNo = Integer.parseInt(request.getParameter("helpNo"));
	String helpTitle = request.getParameter("helpTitle");
	String helpMemo = request.getParameter("helpMemo");
	
	Help help = new Help();
	help.setHelpNo(helpNo);
	help.setHelpTitle(helpTitle);
	help.setHelpMemo(helpMemo);
	
	HelpDao helpDao = new HelpDao();
	int check = helpDao.updateHelp(help);	// 모델 호출
	if(check == 0){
		System.out.println("문의 변경 실패");
		targetUrl = "/help/updateHelpForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl+"?helpNo="+helpNo);
		return;
	}

	System.out.println("문의 변경 성공");
	response.sendRedirect(request.getContextPath()+targetUrl);
%>