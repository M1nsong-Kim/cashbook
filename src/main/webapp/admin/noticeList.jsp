<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// controller
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}	

	// model : notice list
	NoticeDao noticeDao = new NoticeDao();
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5;	// 한 페이지당 보여줄 공지 개수
	int beginRow = (currentPage-1)*rowPerPage;
	int pageList = 10; // 페이지 10개씩 보여줌
	int startPage = ((currentPage-1)/pageList)*pageList+1;	// n1
	int endRow = startPage + pageList - 1;	// (n+1)0
	int lastPage = (int)Math.ceil(noticeDao.selectNoticeCount()/(double)rowPerPage);	//모델 호출
	
	if(endRow > lastPage){	//마지막 페이지보다 더 큰 숫자의 페이지 존재하지 않도록
		endRow = lastPage;
	}
	
	ArrayList<Notice> list = noticeDao.selectNoticeListByPage(beginRow, rowPerPage);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지관리</title>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
<!-- 드롭다운을 위해 -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
<style>
	.smallTd {
		width:6%;
	}
	.mediumTd {
		width:15%;
	}
</style>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<!-- noticeList content -->
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<div class="card-header">
			공지 목록
			<a href="<%=request.getContextPath()%>/admin/insertNoticeForm.jsp" style="text-align:right;">공지추가</a>
		</div>
		<table class="table">
			<tr>
				<th>공지내용</th>
				<th>공지날짜</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
			<%
				for(Notice n : list){
			%>
					<tr>
						<td><%=n.getNoticeMemo()%></td>
						<td class="mediumTd"><%=n.getCreatedate()%></td>
						<td class="smallTd">
							<a href="<%=request.getContextPath()%>/admin/updateNoticeForm.jsp?noticeNo=<%=n.getNoticeNo()%>">수정</a>
						</td>
						<td class="smallTd">
							<a href="<%=request.getContextPath()%>/admin/deleteNotice.jsp?noticeNo=<%=n.getNoticeNo()%>">삭제</a>
						</td>
					</tr>
			<%
				}
			%>
		</table>
	</div>
		<!-- 페이징 -->
		<div class="container">
			<ul class="pagination justify-content-center">
				<li class="page-item">
					<a class="page-link" href="<%=request.getContextPath()%>/admin/noticeList.jsp?currentPage=1">&laquo;</a>
				</li>
				
				<li class="page-item">
				<%
					if(currentPage > 10){
						%>				
						<a class="page-link" href="<%=request.getContextPath()%>/admin/noticeList.jsp?currentPage=<%=startPage-1%>">이전</a>
						<%
					}
				%>
				</li>
				
				<li class="page-item">
					<span class="page-link">
					<%
					for(int i = startPage; i <= endRow; i++){
						if(i == currentPage){
							%>
							<strong><a href="<%=request.getContextPath()%>/admin/noticeList.jsp?currentPage=<%=i%>" style="background-color:var(--bs-pagination-hover-bg); color:white; text-decoration:none;"><%=i%></a></strong>
							<%
						}else {
							%>
							<a href="<%=request.getContextPath()%>/admin/noticeList.jsp?currentPage=<%=i%>" style="color:white; text-decoration:none;"><%=i%></a>
							<%
						}
					}
					%>
					</span>
				</li>
				
				<li class="page-item">
				<%
					if(currentPage+10 < lastPage){
						%>
						<a class="page-link" href="<%=request.getContextPath()%>/admin/noticeList.jsp?currentPage=<%=startPage+10%>">다음</a>
						<%
					}
				%>
				</li>
				
				<li class="page-item">
				<a class="page-link" href="<%=request.getContextPath()%>/admin/noticeList.jsp?currentPage=<%=lastPage%>">&raquo;</a>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>