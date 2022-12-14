<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "/loginForm.jsp";
	// 관리자만
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	// 방어코드
	if(request.getParameter("categoryNo") == null || request.getParameter("categoryNo").equals("")){
		targetUrl = "/admin/categoryList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int categoryNo = Integer.parseInt(request.getParameter("categoryNo"));
	
	// 모델 호출
	CategoryDao categoryDao = new CategoryDao();
	Category category = categoryDao.selectCategoryOne(categoryNo);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 수정</title>
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
	<!-- 카테고리 수정 -->
	<div class="card border-secondary mb-3 container " style="max-width: 30rem;">
		<div class="card-header">카테고리 수정</div>
		<form method="post" action="<%=request.getContextPath()%>/admin/updateCategoryAction.jsp" id="updateCategoryForm">
			<table class="table">
				<tr>
					<td>
						<span>카테고리 이름</span>
						<input type="hidden" name="categoryNo" value="<%=category.getCategoryNo()%>">
					</td>
					<td>
						<input type="text" name="categoryName" value="<%=category.getCategoryName()%>" class="form-control" id="categoryName">
					</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-primary" id="updateCategoryBtn">수정</button>
			</div>
		</form>
	</div>
	<!-- 유효성 검사 -->
	<script>
		let updateCategoryBtn = document.querySelector('#updateCategoryBtn');
		updateCategoryBtn.addEventListener('click', function(){
			// 디버깅
			console.log('카테고리 수정 클릭');
			
			// 카테고리이름 폼 유효성 검사
			let categoryName = document.querySelector('#categoryName');
			if(categoryName.value == ''){
				alert('카테고리 이름을 입력하세요');
				categoryName.focus();
				return;
			}
			
			// submit
			let updateCategoryForm = document.querySelector('#updateCategoryForm');
			updateCategoryForm.submit();
		});
	</script>
</body>
</html>