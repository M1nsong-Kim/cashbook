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
	<!-- 문의 내용 보면서 답변 쓸 수 있도록 -->
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
	<!-- 답변 -->
		<form method="post" action="<%=request.getContextPath()%>/admin/insertCommentAction.jsp?helpNo=<%=helpNo%>">
			<div class="card-header">문의 답변하기</div>
			<table class="table">
				<tr>
					<td>답변</td>
					<td>
						<textarea class="form-control" id="exampleTextarea" rows="3" name="commentMemo"></textarea>
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