<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 1
	
	// 로그인x -> 접근 불가
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	String msgCurrentPw = request.getParameter("msgCurrentPw");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 수정</title>
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
		<form method="post" action="<%=request.getContextPath()%>/member/updateMemberPwAction.jsp" id="updateMemberPwForm">
			<div class="card-header">비밀번호 변경</div>
			<table class="table">
				<tr>
					<td>현재 비밀번호</td>
					<td>
						<input type="password" name="currentPw" class="form-control" id="currentPw">
					</td>
				</tr>
				<tr>
					<td>새 비밀번호</td>
					<td>
						<input type="password" name="updatePw" class="form-control" id="updatePw">
					</td>
				</tr>
				<tr>
					<td>새 비밀번호 확인</td>
					<td>
						<input type="password" name="updatePwCheck" class="form-control" id="updatePwCheck">
					</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-primary" id="updateMemberPwBtn">비밀번호 변경</button>
			</div>
		</form>
	</div>
	<!-- 검사 -->
	<script>
		<%
			// 현재 비밀번호가 일치하지 않을 때
			if(msgCurrentPw != null){
		%>
				alert('<%=msgCurrentPw%>');
		<%
			}
		%>
		let updateMemberPwBtn = document.querySelector('#updateMemberPwBtn');
		updateMemberPwBtn.addEventListener('click', function(){
			// 디버깅
			console.log('비밀번호 변경 클릭');
			
			// 현재 비밀번호 폼 유효성 검사 
			let currentPw = document.querySelector('#currentPw');
			if(currentPw.value == ''){
				alert('현재 비밀번호를 입력해 주세요');
				currentPw.focus();
				return;
			}
			
			// 비밀번호 일치 검사
			let updatePw = document.querySelector('#updatePw');
			let updatePwCheck = document.querySelector('#updatePwCheck');
			if(updatePw.value == '' || updatePw.value != updatePwCheck.value){
				alert('비밀번호가 일치하지 않습니다');
				updatePw.focus();
				return;
			}
			
			// submit
			let updateMemberPwForm = document.querySelector('#updateMemberPwForm');
			updateMemberPwForm.submit();
		});
	</script>
</body>
</html>