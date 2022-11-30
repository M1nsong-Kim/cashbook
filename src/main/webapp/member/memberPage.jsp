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
<title>내 프로필</title>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
<style>
	ul li {
		list-style-type: none; 
		float: left;
	}
</style>
<!-- 드롭다운을 위해 -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<div class="card-header">내 정보</div>
		<table class="table table-hover">
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
		<a class="text-center" href="<%=request.getContextPath()%>/member/updateMemberForm.jsp">내 정보 수정</a>
		<a class="text-center"  href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp">회원탈퇴</a>
		</div>
	</div>
</body>
</html>