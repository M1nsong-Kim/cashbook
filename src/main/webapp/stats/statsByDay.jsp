<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	String targetUrl = "/stats/statsMain.jsp";
	Member loginMember = (Member)session.getAttribute("loginMember");
	// 방어코드 - 로그인 x -> 로그인 창으로
	if(loginMember == null){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	String memberId = loginMember.getMemberId();
	// 방어코드 - 년도, 월 x -> 통계 메인으로
	if(request.getParameter("year") == null || request.getParameter("year").equals("")
		|| request.getParameter("month") == null || request.getParameter("month").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	int year = Integer.parseInt(request.getParameter("year"));
	int month = Integer.parseInt(request.getParameter("month"));
	// 월 1~12월 유지
	if(month == 0){		//1월에서 이전 누르면
		month = 12;
		year--;			// 전해 12월로
	}
	if(month == 13){	//12월에서 다음 누르면
		month = 1;
		year++;			// 다음해 1월로
	}
	
	StatsDao statsDao = new StatsDao();
	ArrayList<HashMap<String, Object>> list = statsDao.selectCashStatsByDay(memberId, year, month);	// 모델 호출
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일별 통계</title>
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
	<!-- 일별 통계 -->
	<div>
		<table class="container table table-hover">
			<tr>
				<th cols="7">
					<div>
						<%=year%>년
					</div>
					<div>
						<a href="<%=request.getContextPath()%>/stats/statsByDay.jsp?year=<%=year%>&month=<%=month-1%>">이전</a>
						<%=month%>월
						<a href="<%=request.getContextPath()%>/stats/statsByDay.jsp?year=<%=year%>&month=<%=month+1%>">다음</a>
					</div>
				</th>
			</tr>
			<tr class="table-secondary">
				<th>일</th>
				<th>수입입력횟수</th>
				<th>수입합계</th>
				<th>수입평균</th>
				<th>지출입력횟수</th>
				<th>지출합계</th>
				<th>지출평균</th>
			</tr>
			<% for(HashMap<String, Object> m : list){
				%>
				<tr>
					<td><%=m.get("day")%>일</td>
					<td><%=m.get("countImport")%></td>
					<td><%=m.get("sumImport")%>원</td>
					<td><%=m.get("avgImport")%>원</td>
					<td><%=m.get("countExport")%></td>
					<td><%=m.get("sumExport")%>원</td>
					<td><%=m.get("avgExport")%>원</td>
				</tr>
				<%
			} %>
		</table>
	</div>
</body>
</html>