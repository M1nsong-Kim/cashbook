<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
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
	
	// 비밀번호 틀려서 받아올 메시지 있다면 받기
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
<title>회원 등급 수정</title>
</head>
<body>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/admin/updateMemberLevelAction.jsp?memberNo=<%=memberNo%>">
			<table>
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
					<td>
						<input type="number" name="memberLevel" value="<%=member.getMemberLevel()%>">
					</td>
				</tr>
				<tr>
					<td>마지막수정일자</td>
					<td><%=member.getUpdatedate()%></td>
				</tr>
				<tr>
					<td>생성일자</td>
					<td><%=member.getCreatedate()%></td>
				</tr>
			</table>
			<br>
			<!-- 등급 수정 전 확인 -->
			<table>
				<tr>
					<!-- 비밀번호 일치해야 멤버 등급 변경 -->
					<td>관리자 비밀번호</td>
					<td>
						<input type="password" name="adminPw">
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
			<button type="submit">수정</button>
		</form>
	</div>
</body>
</html>