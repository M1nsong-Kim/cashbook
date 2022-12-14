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
	
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<form method="post" action="<%=request.getContextPath()%>/member/updateMemberAction.jsp" id="updateMemberForm">
			<div class="card-header">회원정보 변경</div>
			<table class="table">
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
						<input type="text"  name="memberName" value="<%=memberName%>" class="form-control">
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" name="memberPw" class="form-control" id="memberPw">
					</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-primary" id="updateMemberBtn">정보 수정</button>
			</div>
		</form>
	</div>
	<!-- 검사 -->
	<script>
		<%
			// 비밀번호가 일치하지 않는다면
			if(msg != null){
		%>
				alert('<%=msg%>');
		<%
			}
		%>
		let updateMemberBtn = document.querySelector('#updateMemberBtn');
		updateMemberBtn.addEventListener('click', function(){
			// 디버깅
			console.log('정보 수정 클릭');
			
			// 비밀번호 폼 유효성 검사
			let memberPw = document.querySelector('#memberPw');
			if(memberPw.value == ''){
				alert('비밀번호를 입력해 주세요');
				memberPw.focus();
				return;
			}
			
			// submit
			let updateMemberForm = document.querySelector('#updateMemberForm');
			updateMemberForm.submit();
		});
	</script>
	
</body>
</html>