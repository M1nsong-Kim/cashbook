<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	
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
	
	
	// 페이지에서 ?n=<%=%/>으로 넘긴 거 그대로 이름에 써도 되나? ㅇㅇ
	int year = Integer.parseInt(request.getParameter("year"));
	int month = Integer.parseInt(request.getParameter("month"));
	int date = Integer.parseInt(request.getParameter("date"));
	
	CashDao cashDao = new CashDao(); 
	ArrayList<HashMap<String, Object>> list = cashDao.selectCashListByMonth(loginMemberId, year, month); // 2
	
	
	// 3
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가계부 상세보기</title>
</head>
<body>
	<div>
		<%=year%>년 <%=month%>월 <%=date%>일
		<span>&nbsp;</span>
		<a href="<%=request.getContextPath()%>/cash/insertCashForm.jsp">추가</a>
	</div>
	<div>
		<table>
			<tr>
				<th>수입/지출</th>
				<th>분류</th>
				<th>금액</th>
				<th>내용</th>
				<th>수정/삭제</th>
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
						<td>[<%=(String)m.get("categoryKind")%>]</td>
						<td><%=(String)m.get("categoryName")%></td>
						<td><%=(Long)m.get("cashPrice")%>원</td>
						<td><%=(String)m.get("cashMemo")%></td>
						<td>
							<a href="<%=request.getContextPath()%>/cash/updateCashForm.jsp">수정</a>
							<a href="<%=request.getContextPath()%>/cash/deleteCashForm.jsp">삭제</a>
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