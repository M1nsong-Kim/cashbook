<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "/loginForm.jsp";

	// 방어코드 - 로그인 x -> 돌려보내기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의하기</title>
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

	<!-- 문의 추가 -->
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<div class="card-header">문의하기</div>
		<form method="post" action="<%=request.getContextPath()%>/help/insertHelpAction.jsp" id="insertHelpForm">
			<table class="table">
				<tr>
					<td>제목</td>
					<td><input type="text" name="helpTitle" class="form-control" id="helpTitle"></td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea class="form-control" id="helpMemo" rows="3" name="helpMemo"></textarea>
					</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-primary" id="insertHelpBtn">등록</button>
			</div>
		</form>
	</div>
	<!-- 유효성 검사 -->
	<script>
		let insertHelpBtn = document.querySelector('#insertHelpBtn');
		insertHelpBtn.addEventListener('click', function(){
			// 디버깅
			console.log('문의 등록 클릭');
			
			// 제목 폼 유효성 검사
			let helpTitle = document.querySelector('#helpTitle');
			if(helpTitle.value == ''){
				alert('제목을 입력하세요');
				helpTitle.focus();
				return;
			}
			
			// 내용 유효성 검사
			let helpMemo = document.querySelector('#helpMemo');
			if(helpMemo.value.length == 0){
				alert('내용을 입력하세요');
				helpMemo.focus();
				return;
			}
			
			let insertHelpForm = document.querySelector('#insertHelpForm');
			insertHelpForm.submit();
		});
	</script>
</body>
</html>