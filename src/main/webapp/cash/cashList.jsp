<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1. Controller
	
	// 로그인 x -> 로그인창으로 돌려보냄
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	// 현재 로그인한 사람
	Member loginMember = (Member)session.getAttribute("loginMember");
	String loginMemberId = loginMember.getMemberId();
	String loginMemberName = loginMember.getMemberName();
	
	// request 년 + 월
	int year = 0;
	int month = 0;
	
	// 둘 중 하나라도 지정되지 않으면 오늘 날짜 출력
	if(request.getParameter("year") == null || request.getParameter("month") == null){
		Calendar today = Calendar.getInstance();	//오늘 날짜
		year = today.get(Calendar.YEAR);
		month = today.get(Calendar.MONTH);	// 0 ~ 11
	}else{
		year = Integer.parseInt(request.getParameter("year"));
		month = Integer.parseInt(request.getParameter("month"));
		// 이전달 클릭 -> year, month-1 / 다음달 클릭 -> year, month+1
		// month == -1 or 12 라면
		if(month == -1){	// 1월에서 이전 누르면
			month = 11;		// 12월
			year--;			// 작년
		}
		if(month == 12){	// 12월에서 다음 누르면
			month = 0;		// 1월
			year++;			// 내년
		}
	}
	
	// 출력하려는 년, 월, 월별 1일의 요일(1~7:일~월)
	Calendar targetDate = Calendar.getInstance();
	targetDate.set(Calendar.YEAR, year);
	targetDate.set(Calendar.MONTH, month);
	targetDate.set(Calendar.DATE, 1);
	// 1일의 요일
	int firstDay = targetDate.get(Calendar.DAY_OF_WEEK);
	// 월별 마지막 날짜
	int lastDate = targetDate.getActualMaximum(Calendar.DATE);
	// beginBlank 개수는 firstDay - 1
	int beginBlank = firstDay-1;
	int endBlank = 0;	// 7로 나누어 떨어지게끔
	if((beginBlank + lastDate) % 7 != 0){
		endBlank = 7 - ((beginBlank + lastDate) % 7);	
	}
	
	// 전체 td 개수 : 7로 나누어 떨어져야
	int totalTd = beginBlank + lastDate + endBlank;
	
	// 2. Model 호출
	CashDao cashDao = new CashDao();
	ArrayList<HashMap<String, Object>> list = cashDao.selectCashListByMonth(loginMemberId, year, month+1);	//month: 0~11
																			// loginMemberId의 정보만 가져오기 때문에 view 부분은 수정하지 않아도 된다	
	StatsDao statsDao = new StatsDao();
	ArrayList<HashMap<String, Object>> statsList = statsDao.selectCashStatsByDay(loginMemberId, year, month+1); //month: 0~11
	
	// 3. View: 달력 + 일별 cash 목록
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 가계부</title>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
<style>
	td{
		width: 14%;
		height: 10rem;
	}
	.sat {
		color:blue;
	}
	.sun {
		color:red;
	}
	.weekday{
		color:#888888;
	}
	#alignBottom {
		line-height: 50px;
		vertical-align: bottom;
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
	<div class="text-center">
		<!-- 로그인 정보(세션 loginMember 변수) -->
		<span><strong><%=loginMemberName%></strong> 님의 가계부</span>
	</div>
	
	<div class="text-center">
		<a href="<%=request.getContextPath()%>/cash/cashList.jsp?year=<%=year%>&month=<%=month-1%>">이전달</a>
		<%=year%>년 <%=month+1%>월
		<a href="<%=request.getContextPath()%>/cash/cashList.jsp?year=<%=year%>&month=<%=month+1%>">다음달</a>
	</div>
	
	<div>
		<!-- 달력 -->
		<table class="container table">
			<tr class="text-center">
				<th class="sun">일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th class="sat">토</th>
			</tr>
			<tr>
			<%
				for(int i=1; i <= totalTd; i++){
						%>
						<td>
						<%
						int date = i - beginBlank;
						if( date > 0 && date <= lastDate){
						%>
							<div>
								<a href="<%=request.getContextPath()%>/cash/cashDateList.jsp?year=<%=year%>&month=<%=month+1%>&date=<%=date%>">
									<%
									// 요일별 다른 색깔
									if(i % 7 == 0){	//토요일
										%>
										<span class="sat">
										<%
									}else if(i % 7 == 1){	// 일요일
										%>
										<span class="sun">
										<%
									}else {	//평일
										%>
										<span class="weekday">
										<%
									}
									%>
											<%=date%>
										</span>
								</a>
							</div>
							<div>
								<%
									// 해당 년월에 있는 일수를 date와 비교
									for(HashMap<String, Object> m : list){
										String cashDate = (String)(m.get("cashDate"));
										if(Integer.parseInt(cashDate.substring(8)) == date){
											if(m.get("categoryKind").equals("수입")){		// 수입 -> 민트색
											%>
												<div>
												<span style="color:var(--bs-primary)">
											<%
								%>
												[<%=(String)m.get("categoryKind")%>]
												<%=(String)m.get("categoryName")%>
												<%=(Long)m.get("cashPrice")%>원
												</span>
												</div>
								<%
											}else {
											%>
												<div>
												<span style="color:var(--bs-secondary)">
											<%
								%>
												[<%=(String)m.get("categoryKind")%>]
												<%=(String)m.get("categoryName")%>
												<%=(Long)m.get("cashPrice")%>원
												</span>
												</div>
											<%
											}
										}
									}
									%>
									<!-- ★★다시 정렬★★ -->
									<div id="alignBottom">
										<%
										// 일별 합계
										for(HashMap<String, Object> m : statsList){
											int cashDay = (int)(m.get("day"));
											if(cashDay == date){
												%>
												<span>[합계] <%=(int)m.get("sumImport") - (int)m.get("sumExport")%>원</span>
												<%
											}
										}
										%>
									</div>
									<%
								%>
							</div>
						<%
						}
			%>

					</td>
				<%
					//주마다 줄 바꾸기
					if(i % 7 == 0 && i != totalTd){	
				%>	
						</tr><tr>
				<%
					}
				}
				%>
			</tr>
		</table>
	</div>
</body>
</html>