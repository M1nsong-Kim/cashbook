<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%
	// 1
	
	//로그인x -> 접근 불가
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	// 현재 로그인한 사람
	Member loginMember = (Member)session.getAttribute("loginMember");
	String memberId = loginMember.getMemberId();
	String memberName = loginMember.getMemberName();
	
	// 비밀번호 틀리면 뜰 오류 메시지
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보 수정</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/member/updateMemberAction.jsp">
			<table>
				<tr>
					<td>아이디</td>
					<td>
						<%=memberId%>
						<input type="hidden" name="memberId" value="<%=memberId%>">
					</td>
				</tr>
				<tr>
					<td>이름</td>
					<td>
						<input type="text"  name="memberName" value="<%=memberName%>">
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" name="memberPw">
						<%
							if(msg != null){
						%>
								<span><%=msg%></span>
						<%
							}
						%>
					</td>
				</tr>
			</table>
			<button type="submit">정보 수정</button>
		</form>
	</div>
</body>
</html>