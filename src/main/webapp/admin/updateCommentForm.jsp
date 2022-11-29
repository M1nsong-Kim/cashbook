<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "/admin/helpListAll.jsp";

	// 로그인 x OR 관리자 x
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}

	// 답변 번호 x
	if(request.getParameter("commentNo") == null || request.getParameter("commentNo").equals("")){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	
	CommentDao commentDao = new CommentDao();
	HelpDao helpDao = new HelpDao();
	Comment comment = commentDao.selectCommentOne(commentNo);	//모델 호출
	int helpNo = comment.getHelpNo();
	HashMap<String, Object> map = helpDao.selectInquiryOne(helpNo);	// 모델 호출
 %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 답변 수정</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<!-- 문의 내용 보면서 답변 수정할 수 있도록 -->
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
	<!-- 답변 수정 -->
	<div>
		<form method="post" action="<%=request.getContextPath()%>/admin/updateCommentAction.jsp?commentNo=<%=commentNo%>">
			<table>
				<tr>
					<td>답변</td>
					<td>
						<textarea rows="10" cols="50" name="commentMemo"><%=comment.getCommentMemo()%></textarea>
					</td>
				</tr>
			</table>
			<button type="submit">등록</button>
		</form>
	</div>
</body>
</html>