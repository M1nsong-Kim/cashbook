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
	<!-- 문의 내용 보면서 답변 수정할 수 있도록 -->
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<table class="table">
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
	<!-- 답변 수정 -->
		<form method="post" action="<%=request.getContextPath()%>/admin/updateCommentAction.jsp?commentNo=<%=commentNo%>">
			<div class="card-header">답변 수정하기</div>
			<table class="table">
				<tr>
					<td>답변</td>
					<td>
						<textarea class="form-control" id="exampleTextarea" rows="3" name="commentMemo"><%=comment.getCommentMemo()%></textarea>
					</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="submit" class="btn btn-primary">등록</button>
			</div>
		</form>
	</div>
</body>
</html>