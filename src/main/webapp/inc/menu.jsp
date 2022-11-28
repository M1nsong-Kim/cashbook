<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<a href="<%=request.getContextPath()%>/cash/cashList.jsp">가계부</a>
	<a href="<%=request.getContextPath()%>/member/memberPage.jsp">내 정보</a>
	<%
		Member loginMember = (Member)session.getAttribute("loginMember");
		// 관리자라면
		if(loginMember.getMemberLevel() > 0){
	%>
			<a href="<%=request.getContextPath()%>/admin/adminMain.jsp">관리자 페이지</a>
	<%
		}
	%>
	<a href="<%=request.getContextPath()%>/">고객센터</a>
	<a href="<%=request.getContextPath()%>/logout.jsp">로그아웃</a>
</body>
</html>