<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	
	//1
	request.setCharacterEncoding("UTF-8"); //한글 인코딩
	
	if(session.getAttribute("loginMember") != null) {
		// 로그인되어 있다면
		response.sendRedirect(request.getContextPath()+"/cash/cashList.jsp");
		return;
	}
	
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<!-- 회원가입 -->
	<div>
		<form method="post" action="<%=request.getContextPath()%>/member/signUpAction.jsp">
			<div class="card border-secondary mb-3 container" style="max-width: 40rem;">
			  <div class="card-header">회원가입</div>
			  <div class="card-body">
			  	<span class="card-text">아이디</span>
				<input type="text" name="memberId" class="form-control" id="inputDefault">
				<%
					// 아이디가 중복된다면
					if(msg != null){
				%>
						<div><strong><%=msg%></strong></div>
				<%
					}
				%>
				<span class="card-text">비밀번호</span>
				<input type="password" name="memberPw" class="form-control" id="exampleInputPassword1">
				<span class="card-text">이름</span>
				<input type="text" name="memberName" class="form-control" id="inputDefault">
			  </div>
				<button type="submit" class="btn btn-primary">회원가입</button>
				<span class="text-center">이미 회원이신가요?</span>
				<a class="text-center" href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a>
			</div>
		</form>
	</div>
</body>
</html>