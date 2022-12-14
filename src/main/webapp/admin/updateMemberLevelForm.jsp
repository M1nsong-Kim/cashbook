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
	
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	MemberDao memberDao = new MemberDao();
	Member member = memberDao.selectMember(memberNo);
	
	// 받아올 메시지 있다면 받기
	String msg = null;
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");		
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 등급 수정</title>
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
	<!-- 회원 등급 변경 -->
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<div class="card-header">회원 등급 변경</div>
		<form method="post" action="<%=request.getContextPath()%>/admin/updateMemberLevelAction.jsp?memberNo=<%=memberNo%>" id="updateMemberLevelForm">
			<table class="table">
				<tr>
					<td>아이디</td>
					<td>
						<%=member.getMemberId()%>
						<input type="hidden" name="memberNo" value="<%=member.getMemberNo()%>">
					</td>
				</tr>
				<tr>
					<td>이름</td>
					<td><%=member.getMemberName()%></td>
				</tr>
				<tr>
					<td>회원등급</td>
					<td>
						<input type="number" class="form-control" id="memberLevel" name="memberLevel" value="<%=member.getMemberLevel()%>">
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
				<!-- 등급 수정 전 확인 -->
				<tr>
					<!-- 비밀번호 일치해야 멤버 등급 변경 -->
					<td>관리자 비밀번호</td>
					<td>
						<input type="password" name="adminPw" class="form-control" id="adminPw">
					</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-primary" id="updateMemberLevelBtn">수정</button>
			</div>
		</form>
	</div>
	<!-- 검사 -->
	<script>
		// 관리자 비밀번호가 일치하지 않으면
		<%
			if(msg != null){
				%>
				alert('<%=msg%>');
				<%
			}
		%>
		let updateMemberLevelBtn = document.querySelector('#updateMemberLevelBtn');
		updateMemberLevelBtn.addEventListener('click', function(){
			// 디버깅
			console.log('회원 등급 수정 클릭');
			
			// 회원 등급 유효성 검사
			let memberLevel = document.querySelector('#memberLevel');
			if(memberLevel.value.length == 0){
				alert('회원 등급을 입력해 주세요');
				memberLevel.focus();	// 커서 이동
				return;
			}
			
			// 비밀번호 폼 유효성 검사
			let adminPw = document.querySelector('#adminPw');
			if(adminPw.value == ''){
				alert('비밀번호를 입력해 주세요');
				adminPw.focus();
				return;
			}
			
			// submit
			let updateMemberLevelForm = document.querySelector('#updateMemberLevelForm');
			updateMemberLevelForm.submit();
		});
	</script>
</body>
</html>