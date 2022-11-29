<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//Controller
	String targetUrl = "/admin/helpListAll.jsp";
	// 로그인x OR 관리자x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	// 문의번호x
	if(request.getParameter("helpNo") == null || request.getParameter("helpNo").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	int helpNo = Integer.parseInt(request.getParameter("helpNo"));

	// 번호로 문의 가져오기
	HelpDao helpDao = new HelpDao();
	HashMap<String, Object> map = helpDao.selectInquiryOne(helpNo);	//모델 호출
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 답변하기</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<!-- 문의 내용 보면서 답변 쓸 수 있도록 -->
	<div>
		<table>
			<tr>
				<td>문의내용</td>
				<td><%=map.get("helpMemo")%></td>
			</tr>
			<tr>
				<td>작성자아이디</td>
				<td><%=map.get("memberId")%></td>
			</tr>
			<tr>
				<td>작성날짜</td>
				<td><%=map.get("createdate")%></td>
			</tr>
		</table>
	</div>
	<br>
	<!-- 답변 -->
	<div>
		<form method="post" action="<%=request.getContextPath()%>/admin/insertCommentAction.jsp?helpNo=<%=helpNo%>">
			<table>
				<tr>
					<td>답변</td>
					<td>
						<textarea rows="10" cols="50" name="commentMemo"></textarea>
					</td>
				</tr>
			</table>
			<button type="submit">등록</button>
		</form>
	</div>
</body>
</html>