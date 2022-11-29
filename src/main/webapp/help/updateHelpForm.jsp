<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//Controller
	String targetUrl = "";
	
	// 로그인 x -> 돌려보내기
	Member loginMember = (Member) session.getAttribute("loginMember");
	if(loginMember == null){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	// 문의 번호 없으면 전체 내 문의내역으로
	if(request.getParameter("helpNo") == null || request.getParameter("helpNo").equals("")){
		targetUrl = "/help/helpList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int helpNo = Integer.parseInt(request.getParameter("helpNo"));
	
	HelpDao helpDao = new HelpDao();
	HashMap<String, Object> map = helpDao.selectInquiryOne(helpNo);	// 모델 호출
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 수정하기</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<h3>문의 수정하기</h3>
		<form method="post" action="<%=request.getContextPath()%>/help/updateHelpAction.jsp?helpNo=<%=helpNo%>">
			<table>
				<tr>
					<td>문의날짜</td>
					<td><%=map.get("createdate")%></td>
				</tr>
				<tr>
					<td>문의내용</td>
					<td>
						<textarea rows="10" cols="50"><%=map.get("helpMemo")%></textarea>
					</td>
				</tr>
			</table>
			<button type="submit">수정</button>
		</form>
	</div>
</body>
</html>