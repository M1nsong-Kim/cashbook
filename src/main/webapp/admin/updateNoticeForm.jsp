<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// controller
	// 로그인하지 않았거나 관리자가 아니라면 돌려보내기
	String targetUrl = "/loginForm.jsp";
	
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	
	//방어코드
	if(request.getParameter("noticeNo") == null || request.getParameter("noticeNo").equals("")){
		targetUrl = "/admin/noticeList.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// model 호출
	NoticeDao noticeDao = new NoticeDao();
	Notice notice = new Notice();
	notice = noticeDao.selectNotice(noticeNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 수정</title>
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
	<!-- 공지 수정 -->
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<div class="card-header">공지 수정</div>
		<form method="post" action="<%=request.getContextPath()%>/admin/updateNoticeAction.jsp" id="updateNoticeForm">
			<table class="table">
				<tr>
					<td>공지번호</td>
					<td>
						<%=notice.getNoticeNo()%>
						<input type="hidden" name="noticeNo" value="<%=notice.getNoticeNo()%>">
					</td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea class="form-control" id="noticeMemo" rows="3" name="noticeMemo"><%=notice.getNoticeMemo()%></textarea>
					</td>
				</tr>
			</table>
			<div class="text-center">
				<button type="button" class="btn btn-primary" id="updateNoticeBtn">수정</button>
			</div>
		</form>
	</div>
	<!-- 유효성 검사 -->
	<script>
		let updateNoticeBtn = document.querySelector('#updateNoticeBtn');
		updateNoticeBtn.addEventListener('click', function(){
			// 디버깅
			console.log('공지 수정 클릭');
			
			// 답변 유효성 검사
			let noticeMemo = document.querySelector('#noticeMemo');
			if(noticeMemo.value.length == 0){
				alert('공지 내용을 입력해 주세요');
				noticeMemo.focus();
				return;
			}
			
			// submit
			let updateNoticeForm = document.querySelector('#updateNoticeForm');
			updateNoticeForm.submit();
		});
	</script>
</body>
</html>