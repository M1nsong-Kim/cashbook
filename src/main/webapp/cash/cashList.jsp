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
	
																			
	// 3. View: 달력 + 일별 cash 목록
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 가계부</title>
</head>
<body>
	<div>
		<!-- 로그인 정보(세션 loginMember 변수) -->
		<span><%=loginMemberName%> 님 반갑습니다.</span>
		<span>&nbsp;</span>
		<a href="<%=request.getContextPath()%>/member/memberPage.jsp">내정보</a>
		<a href="<%=request.getContextPath()%>/logout.jsp">로그아웃</a>
	</div>
	
	<div>
		<a href="<%=request.getContextPath()%>/cash/cashList.jsp?year=<%=year%>&month=<%=month-1%>">이전달</a>
		<%=year%>년 <%=month+1%>월
		<a href="<%=request.getContextPath()%>/cash/cashList.jsp?year=<%=year%>&month=<%=month+1%>">다음달</a>
	</div>
	
	<div>
		<!-- 달력 -->
		<table>
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
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
									<%=date%>
								</a>
							</div>
							<div>
								<%
									// 해당 년월에 있는 일수를 date와 비교
									for(HashMap<String, Object> m : list){
										String cashDate = (String)(m.get("cashDate"));
										if(Integer.parseInt(cashDate.substring(8)) == date){
											if(m.get("categoryKind").equals("수입")){		// 수입 -> 파란색
											%>
												<div>
												<span style="color:blue">
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
												<span style="color:red">
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
							</div>
						<%
						}
			%>

					</td>
			<%
					if(i % 7 == 0 && i != lastDate){	//주마다 줄 바꾸기
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