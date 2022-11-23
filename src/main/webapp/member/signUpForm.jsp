<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8"); //한글 인코딩
	
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
<title>회원가입</title>
</head>
<body>
	<h3>회원가입</h3>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/signUpAction.jsp">
			<table>
				<tr>
					<td>아이디</td>
					<td>
						<input type="text" name="memberId">
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" name="memberPw">
					</td>
				</tr>
				<tr>
					<td>이름</td>
					<td>
						<input type="text" name="memberName">
					</td>
				</tr>
			</table>
			<button type="submit">회원가입</button>
		</form>
	</div>
</body>
</html>