<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "/loginForm.jsp";
	// 로그인x OR 관리자x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	// 회원 번호가 넘어오지 않았다면 회원 목록으로 돌려보내기
	if(request.getParameter("memberNo") == null || request.getParameter("memberNo").equals("")){
		targetUrl = "/admin/memberList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 받아올 메시지 있다면 받기
	String msg = null;
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");		
	}
	
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	MemberDao memberDao = new MemberDao();
	Member member = memberDao.selectMember(memberNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 강제탈퇴 폼</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/admin/deleteMemberAction.jsp">
			<!-- 나중에 메시지로 띄울 거라서 -->
			<%
				if(msg != null){
					%>
						<span><%=msg%></span>
					<%
				}
			%>
			<table>
				<tr>
					<td>회원번호</td>
					<td>
						<input type="number" name="memberNo" value="<%=memberNo%>" readonly="readonly">
					</td>
				</tr>			
				<tr>
					<td>아이디</td>
					<td><%=member.getMemberId()%></td>
				</tr>
				<tr>
					<td>이름</td>
					<td><%=member.getMemberName()%></td>
				</tr>
				<tr>
					<td>회원등급</td>
					<td><%=member.getMemberLevel()%></td>
				</tr>
				<!-- 비밀번호 확인 후 강제탈퇴 진행 -->
				<tr>
					<td>관리자 비밀번호</td>
					<td>
						<input type="password" name="adminPw">
					</td>
				</tr>
			</table>
			<button type="submit">강제탈퇴</button>
		</form>
	</div>
</body>
</html>