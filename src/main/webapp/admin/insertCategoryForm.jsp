<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// controller
	
	// 관리자만 접근 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 추가</title>
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
	
	<!-- 카테고리 추가 -->
	<div class="card border-secondary mb-3 container " style="max-width: 40rem;">
		<div class="card-header">카테고리 추가</div>
		<form method="post" action="<%=request.getContextPath()%>/admin/insertCategoryAction.jsp" id="insertCategoryForm">
			<table class="table">
				<tr>
					<td>카테고리 종류</td>
					<td>
						<input type="radio" class="form-check-input categoryKind" name="categoryKind" value="수입">수입
						<input type="radio" class="form-check-input categoryKind" name="categoryKind" value="지출">지출
					</td>
				</tr>
				<tr>
					<td>카테고리 이름</td>
					<td><input type="text" name="categoryName" class="form-control" id="categoryName"></td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-primary" id="insertCategoryBtn">추가</button>
			</div>
		</form>
	</div>
	<!-- 유효성 검사 -->
	<script>
		let insertCategoryBtn = document.querySelector('#insertCategoryBtn');
		insertCategoryBtn.addEventListener('click', function(){
			
			// 수입/지출 라디오 유효성 검사
			let categoryKind = document.querySelectorAll('.categoryKind:checked'); 
			// querySelectorAll의 반환 타입은 배열(태그)	/ :checked는 선택된 라디오
			console.log(categoryKind.length); // 1
			if(categoryKind.length != 1){
				alert('수입/지출을 선택하세요');
				return;
			}
			
			// 카테고리이름 폼 유효성 검사
			let categoryName = document.querySelector('#categoryName');
			if(categoryName.value == ''){
				alert('카테고리 이름을 입력하세요');
				categoryName.focus();
				return;
			}
			
			// submit
			let insertCategoryForm = document.querySelector('#insertCategoryForm');
			insertCategoryForm.submit();
		});
	</script>
</body>
</html>