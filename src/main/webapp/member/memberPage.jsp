<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	
	// 로그인 x -> 로그인창으로 돌려보냄
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	// 현재 로그인한 사람
	Member loginMember = (Member)session.getAttribute("loginMember");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보</title>
</head>
<body>
	<div>
		<h3>내 정보</h3>
		<table>
			<tr>
				<td>아이디</td>
				<td><%=loginMember.getMemberId()%></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
					**********
					<a href="<%=request.getContextPath()%>/member/updateMemberPwForm.jsp">비밀번호 수정</a>
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td><%=loginMember.getMemberName()%></td>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/member/updateMemberForm.jsp">내 정보 수정</a>
		<a href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp">회원탈퇴</a>
	</div>
</body>
</html>