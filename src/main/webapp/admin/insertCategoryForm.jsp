<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// controller
	
	// 관리자만 접근 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 추가</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/admin/insertCategoryAction.jsp">
			<table>
				<tr>
					<td>카테고리 종류</td>
					<td>
						<input type="radio" name="categoryKind" value="수입">수입
						<input type="radio" name="categoryKind" value="지출">지출
					</td>
				</tr>
				<tr>
					<td>카테고리 이름</td>
					<td><input type="text" name="categoryName"></td>
				</tr>
			</table>
			<button type="submit">추가</button>
		</form>
	</div>
</body>
</html>