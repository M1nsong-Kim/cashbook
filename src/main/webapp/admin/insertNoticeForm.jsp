<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "/admin/noticeList.jsp";

	// 로그인 x OR 관리자 x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 추가</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/admin/insertNoticeAction.jsp">
			<table>
				<tr>
					<td>공지내용</td>
					<td>
						<textarea rows="3" cols="50" name="noticeMemo"></textarea>
					</td>
				</tr>
			</table>
			<button type="submit">추가</button>
		</form>
	</div>
</body>
</html>