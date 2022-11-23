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
	String memberId = loginMember.getMemberId();
	
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
</head>
<body>
	<div>
		<%=year%>년 <%=month%>월 <%=date%>일
	</div>
	
	<div>
		<form method="post" action="<%=request.getContextPath()%>/cash/updateCashAction.jsp">
			<!-- action에 날짜 보내기 -->
			<input type="hidden" name="year" value="<%=year%>">
			<input type="hidden" name="month" value="<%=month%>">
			<input type="hidden" name="date" value="<%=date%>">
			<input type="hidden" name="cashNo" value="<%=map.get("cashNo")%>">
			<table>
				<tr>
					<td>날짜</td>
					<td>
						<input type="text" name="cashDate" value="<%=year%>-<%=month%>-<%=date%>" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td>분류</td>
					<td>
						<select name="categoryNo">
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
						<input type="number" name="cashPrice" value="<%=map.get("cashPrice")%>">
					</td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea name="cashMemo" rows="3" cols="50"><%=map.get("cashMemo")%></textarea>
					</td>
				</tr>
			</table>
			<button type="submit">수정</button>
		</form>
	</div>
</body>
</html>