<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	String targetUrl = "/loginForm.jsp";
	// 로그인 x -> 로그인창으로 돌려보냄
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 현재 로그인한 사람
	Member loginMember = (Member)session.getAttribute("loginMember");
	String memberId = loginMember.getMemberId();
	
	// 날짜 입력 없으면 내 가계부로
	if(request.getParameter("year") == null || request.getParameter("year").equals("")
		|| request.getParameter("month") == null || request.getParameter("month").equals("")
		|| request.getParameter("date") == null || request.getParameter("date").equals("")){
		targetUrl = "/cash/cashList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int year = Integer.parseInt(request.getParameter("year"));
	int month = Integer.parseInt(request.getParameter("month"));
	int date = Integer.parseInt(request.getParameter("date"));
	
	int cashNo = Integer.parseInt(request.getParameter("cashNo"));
	
	// 카테고리 항목 보여주기
	CategoryDao categoryDao = new CategoryDao();
	ArrayList<Category> categoryList = categoryDao.selectCategoryList();
	
	// 캐시 목록 보여주기
	CashDao cashDao = new CashDao();
	HashMap<String, Object> map = cashDao.selectCashListByCashNo(cashNo);	// 2. M 호출
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내역 수정</title>
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
		<div class="card-header"><%=year%>년 <%=month%>월 <%=date%>일</div>
		<form method="post" action="<%=request.getContextPath()%>/cash/updateCashAction.jsp" id="updateCashForm">
			<!-- action에 날짜 보내기 -->
			<input type="hidden" name="year" value="<%=year%>">
			<input type="hidden" name="month" value="<%=month%>">
			<input type="hidden" name="date" value="<%=date%>">
			<input type="hidden" name="cashNo" value="<%=map.get("cashNo")%>">
			<table class="table">
				<tr>
					<td>날짜</td>
					<td>
						<input type="text" name="cashDate" value="<%=year%>-<%=month%>-<%=date%>" class="form-control" id="readOnlyInput" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td>분류</td>
					<td>
						<select name="categoryNo" class="form-select" id="exampleSelect1">
						<%
							for(Category c : categoryList){
						%>
								<option value="<%=c.getCategoryNo()%>">
								<%=c.getCategoryKind()%>
								&nbsp;
								<%=c.getCategoryName()%>
								</option>							
						<%
							}
						%>
						</select>
					</td>
				</tr>
				<tr>
					<td>금액</td>
					<td>
						<input type="number" name="cashPrice" class="form-control" id="cashPrice" placeholder="단위: 원">
					</td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea class="form-control" id="cashMemo" rows="3" name="cashMemo"></textarea>
					</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-primary" id="updateCashBtn">수정</button>
			</div>
		</form>
	</div>
	<!-- 유효성 검사 -->
	<script>
		let updateCashBtn = document.querySelector('#updateCashBtn');
		updateCashBtn.addEventListener('click', function(){
			// 디버깅
			console.log('가계부 내역 수정 클릭');
			
			// 금액 폼 유효성 검사
			let cashPrice = document.querySelector('#cashPrice');
			if(cashPrice.value.length == 0){
				alert('금액을 입력해주세요');
				cashPrice.focus();	// 커서 이동
				return;
			}
			
			// 내용 폼 유효성 검사
			let cashMemo = document.querySelector('#cashMemo');
			if(cashMemo.value.length == 0){
				alert('내용을 입력해주세요');
				cashMemo.focus();	// 커서 이동
				return;
			}
			
			let updateCashForm = document.querySelector('#updateCashForm');
			updateCashForm.submit();
		});
	</script>
</body>
</html>