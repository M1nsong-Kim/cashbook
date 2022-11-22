<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//1
	if(session.getAttribute("loginMember") != null) {
		// 로그인되어 있다면
		response.sendRedirect(request.getContextPath()+"/cash/cashList.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/loginAction.jsp">
			<h3>로그인</h3>	
			<div><input type="text" name="memberId" placeholder="ID를 입력하세요"></div>
			<div><input type="password" name="memberPw" placeholder="비밀번호를 입력하세요"></div>
			<div>
				<button type="submit">로그인</button>
			</div>
		</form>
		<div>
			<span>회원이 아니신가요?</span>
			<a href="<%=request.getContextPath()%>/member/signUpForm.jsp">회원가입</a>
		</div>
	</div>
</body>
</html>