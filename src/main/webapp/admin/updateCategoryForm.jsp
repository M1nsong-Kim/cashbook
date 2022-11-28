<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "/loginForm.jsp";
	// 관리자만
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	// 방어코드
	if(request.getParameter("categoryNo") == null || request.getParameter("categoryNo").equals("")){
		targetUrl = "/admin/categoryList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int categoryNo = Integer.parseInt(request.getParameter("categoryNo"));
	
	// 모델 호출
	CategoryDao categoryDao = new CategoryDao();
	Category category = categoryDao.selectCategoryOne(categoryNo);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 수정</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/admin/updateCategoryAction.jsp">
			<table>
				<tr>
					<td>카테고리번호</td>
					<td><input type="hidden" name="categoryNo" value="<%=category.getCategoryNo()%>"></td>
				</tr>
				<tr>
					<td>카테고리이름</td>
					<td>
						<input type="text" name="categoryName" value="<%=category.getCategoryName()%>">
					</td>
				</tr>
			</table>
			<button type="submit">수정</button>
		</form>
	</div>
</body>
</html>