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
	String loginMemberId = loginMember.getMemberId();
	String loginMemberName = loginMember.getMemberName();

	// 방어코드 - 일자 안 눌렀으면 오늘 날짜가 있는 가계부로
	if(request.getParameter("year") == null || request.getParameter("year").equals("")
		|| request.getParameter("month") == null || request.getParameter("month").equals("")
		|| request.getParameter("date") == null || request.getParameter("date").equals("")){
		response.sendRedirect(request.getContextPath()+"/cash/cashList.jsp");
		return;
	}
	
	System.out.println("중간 확인");
	
	int year = Integer.parseInt(request.getParameter("year"));
	int month = Integer.parseInt(request.getParameter("month"));
	int date = Integer.parseInt(request.getParameter("date"));
	
	System.out.println(year+"View 전 년");
	System.out.println(month+"View 전 월");
	System.out.println(date+"View 전 일");
	
	
	CategoryDao categoryDao = new CategoryDao();
	ArrayList<Category> categoryList = categoryDao.selectCategoryList(); // 2
	
	for(Category c : categoryList){
		System.out.println(c.getCategoryKind() + " <--- 확인");
	}
	
	CashDao cashDao = new CashDao(); 
	ArrayList<HashMap<String, Object>> list = cashDao.selectCashListByDate(loginMember.getMemberId(), year, month, date); // 2
	
	// 3
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가계부 상세보기</title>
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

	<!-- cash 입력 폼 -->
	<div style="margin-bottom: 5rem;">
		<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
			<div class="card-header"><%=year%>년 <%=month%>월 <%=date%>일</div>
			<form action="<%=request.getContextPath()%>/cash/insertCashAction.jsp" method="post">
				<input type="hidden" name="memberId" value="<%=loginMember.getMemberId()%>">
				<!-- 입력 후 해당 날짜 상세페이지로 가려고 -->
				<input type="hidden" name="year" value="<%=year%>">
				<input type="hidden" name="month" value="<%=month%>">
				<input type="hidden" name="date" value="<%=date%>">
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
							<input type="number" name="cashPrice" class="form-control" id="inputDefault" placeholder="단위: 원">
						</td>
					</tr>
					
					
					<tr>
						<td>내용</td>
						<td>
							<textarea class="form-control" id="exampleTextarea" rows="3" name="cashMemo"></textarea>
						</td>
					</tr>
				</table>
				<div class="text-center">
					<button type="submit" class="btn btn-primary">추가</button>
				</div>
			</form>
		</div>	
	</div>

	<!-- cash 목록 출력 -->
	<div>
		<table class="container table table-hover">
			<tr class="table-secondary">
				<th>수입/지출</th>
				<th>분류</th>
				<th>금액</th>
				<th>내용</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
		<%
			for(HashMap<String, Object> m : list){
				String cashDate = (String)(m.get("cashDate"));
				// 디버깅 
				System.out.println(cashDate.substring(0, 4));
				System.out.println(cashDate.substring(5, 7));
				//if(cashDate.substring(0, 7).equals(year+"-"+month) && Integer.parseInt(cashDate.substring(8)) == date){ ----- 월에도 0 붙고 안 붙고 있음
				if(Integer.parseInt(cashDate.substring(0, 4)) == year && Integer.parseInt(cashDate.substring(5, 7)) == month && Integer.parseInt(cashDate.substring(8)) == date){
					%>
					<tr>
						<td><%=(String)m.get("categoryKind")%></td>
						<td><%=(String)m.get("categoryName")%></td>
						<%
						String categoryKind = (String)m.get("categoryKind");
						if(categoryKind.equals("수입")){
							%>
							<td><span style="color:var(--bs-primary)"><%=(Long)m.get("cashPrice")%>원</span></td>
							<%
						}else {
							%>
							<td><span style="color:var(--bs-secondary)"><%=(Long)m.get("cashPrice")%>원</span></td>
							<%
						}
						%>
						<td><%=(String)m.get("cashMemo")%></td>
						<% 
							int cashNo = (Integer)m.get("cashNo");
							System.out.println(cashNo + "<--캐시번호");
						%>
						<td>
							<a href="<%=request.getContextPath()%>/cash/updateCashForm.jsp?cashNo=<%=cashNo%>&year=<%=year%>&month=<%=month%>&date=<%=date%>">수정</a>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/cash/deleteCash.jsp?cashNo=<%=cashNo%>&year=<%=year%>&month=<%=month%>&date=<%=date%>">삭제</a>
						</td>
					<tr>

					<%
				}
			}
		%>
		</table>
	</div>
</body>
</html>