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
<title>회원 강제탈퇴</title>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
<!-- 드롭다운을 위해 -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<!-- 강제탈퇴 -->
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<div class="card-header">회원 강제탈퇴</div>
		<form method="post" action="<%=request.getContextPath()%>/admin/deleteMemberAction.jsp" id="deleteMemberForm">
			<table class="table">
				<tr>
					<td>회원번호</td>
					<td>
						<%=memberNo%>
						<input type="hidden" name="memberNo" value="<%=memberNo%>">
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
						<input type="password" name="adminPw" class="form-control" id="adminPw">
					</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-primary" id="deleteMemberBtn">강제탈퇴</button>
			</div>
		</form>
	</div>
	<!-- 검사 -->
	<script>
		// 관리자 비밀번호 일치하지 않으면 띄울 메시지
		<%
			if(msg != null){
				%>
					alert('<%=msg%>');
				<%
			}
		%>
		let deleteMemberBtn = document.querySelector('#deleteMemberBtn');
		deleteMemberBtn.addEventListener('click', function(){
			// 디버깅
			console.log('강제탈퇴 클릭');
			
			// 비밀번호 폼 유효성 검사
			let adminPw = document.querySelector('#adminPw');
			if(adminPw.value == ''){
				alert('비밀번호를 입력해 주세요');
				adminPw.focus();
				return;
			}
			
			// submit
			let deleteMemberForm = document.querySelector('#deleteMemberForm');
			deleteMemberForm.submit();
		});
	</script>
</body>
</html>