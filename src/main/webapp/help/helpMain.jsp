<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객센터</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<div>
		<h2>가계부 고객센터</h2>
		<h3>자주 찾는 도움말</h3>
		
		<h3>다른 도움이 필요하신가요?</h3>
		<a href="<%=request.getContextPath()%>/help/insertHelpForm.jsp">1:1 문의하기</a>
		<a href="<%=request.getContextPath()%>/help/helpList.jsp">내 문의내역</a>
		<!-- 관리자 페이지에 최근 문의 보여주기 -->
	</div>
</body>
</html>