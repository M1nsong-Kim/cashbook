<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "";
	
	// 로그인 x -> 돌려보내기
	Member loginMember = (Member) session.getAttribute("loginMember");
	if(loginMember == null){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	String memberId = loginMember.getMemberId();
	
	HelpDao helpDao = new HelpDao();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	list = helpDao.selectHelpList(memberId);	// 모델 호출
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의내역</title>
<style>
	img {
		width: 20px;
	}
</style>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<h3>내 문의내역</h3>
		<table>
			<tr>
				<th>문의내용</th>
				<th>작성날짜</th>
				<th>상태</th>
			</tr>
			<%
				for(HashMap<String, Object> m : list){
					%>
					<tr>
						<td><%=m.get("helpMemo")%></td>
						<td><%=m.get("createdateHelp")%></td>
					<%
					// 답변이 없다면
					if(m.get("commentMemo") == null){
					%>
						<td>
							<a href="<%=request.getContextPath()%>/help/updateHelpForm.jsp?helpNo=<%=m.get("helpNo")%>">수정</a>
							<a href="<%=request.getContextPath()%>/help/deleteHelp.jsp?helpNo=<%=m.get("helpNo")%>">삭제</a>
						</td>
					<%
					}else {	//답변이 있다면
						%>	
						<!-- 완료 누를 때마다 답변 펴거나 접기 -->
						<td>
							<a href="<%=request.getContextPath()%>/help/helpList.jsp">&#128316;</a>
						</td>
					</tr>
					<tr>
						<td>
							<img src="<%=request.getContextPath()%>/img/reply.png">
							<%=m.get("commentMemo")%>
						</td>
						<td><%=m.get("createdateComment")%></td>
						<%
					}
				}
			%>
					</tr>
		</table>
	</div>
</body>
</html>