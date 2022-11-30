<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 x -> 로그인창으로 돌려보냄
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객센터</title>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<div style="margin-bottom: 2.5rem;">
			<div class="card-header">가계부 고객센터</div>
				<div class="text-center">
				<a href="<%=request.getContextPath()%>/help/helpList.jsp">내 문의내역</a>
				</div>
		</div>
		
		<div style="margin-bottom: 2.5rem;">
			<div class="card-header">자주 찾는 도움말</div>
				<p class="card-text">카테고리 추가가 필요하다면 1:1 문의하기로 요청해주시기 바랍니다.</p>
				<p class="card-text">수입은 민트색, 지출은 분홍색으로 표시됩니다.</p>
		</div>
		
		<div style="margin-bottom: 2.5rem;">
			<div class="card-header">다른 도움이 필요하신가요?</div>
				<div class="text-center">
					<a href="<%=request.getContextPath()%>/help/insertHelpForm.jsp">1:1 문의하기</a>
				</div>
		</div>
	</div>
</body>
</html>