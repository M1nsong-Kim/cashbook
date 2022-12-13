<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	String targetUrl = "/loginForm.jsp";
	Member loginMember = (Member)session.getAttribute("loginMember");
	// 방어코드 - 로그인 x -> 로그인 창으로
	if(loginMember == null){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	String memberId = loginMember.getMemberId();
	
	StatsDao statsDao = new StatsDao();
	ArrayList<HashMap<String, Object>> list = statsDao.selectCashStatsByYear(memberId);	// 모델 호출
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>년도별 통계</title>
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
	<!-- 년도별 통계 -->
	<div>
		<table class="container table table-hover">
			<tr class="table-secondary">
				<th>년도</th>
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
					<td>
						<a href="<%=request.getContextPath()%>/stats/statsByMonth.jsp?year=<%=m.get("year")%>"><%=m.get("year")%>년</a>
					</td>
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