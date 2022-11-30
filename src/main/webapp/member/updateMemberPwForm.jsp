<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 1
	
	// 로그인x -> 접근 불가
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	String msgCurrentPw = request.getParameter("msgCurrentPw");
	String msgUpdatePw = request.getParameter("msgUpdatePw");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 수정</title>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
			<form method="post" action="<%=request.getContextPath()%>/member/updateMemberPwAction.jsp">
				<div class="card-header">비밀번호 변경</div>
				<table class="table">
					<tr>
						<td>현재 비밀번호</td>
						<td>
							<input type="password" name="currentPw" class="form-control" id="exampleInputPassword1">
							<%
								if(msgCurrentPw != null){
							%>
									<div><strong><%=msgCurrentPw%></strong></div>
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td>새 비밀번호</td>
						<td>
							<input type="password" name="updatePw" class="form-control" id="exampleInputPassword1">
						</td>
					</tr>
					<tr>
						<td>새 비밀번호 확인</td>
						<td>
							<input type="password" name="updatePwCheck" class="form-control" id="exampleInputPassword1">
							<%
								if(msgUpdatePw != null){
							%>
									<span><%=msgUpdatePw%></span>
							<%
								}
							%>
						</td>
					</tr>
				</table>
				<div class="text-center">
					<button type="submit" class="btn btn-primary">비밀번호 변경</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>