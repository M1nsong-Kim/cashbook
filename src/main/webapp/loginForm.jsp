<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//1
	if(session.getAttribute("loginMember") != null) {
		// 로그인되어 있다면
		response.sendRedirect(request.getContextPath()+"/cash/cashList.jsp");
		return;
	}

	NoticeDao noticeDao = new NoticeDao();
	
	int currentPage = 1;	// page
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5;	// 한 페이지당 보여줄 공지 개수
	int beginRow = (currentPage-1)*rowPerPage;
	int pageList = 10; // 페이지 10개씩 보여줌
	int startPage = ((currentPage-1)/pageList)*pageList+1;	// n1
	int endPage = startPage + pageList - 1;	// (n+1)0
	int lastPage = (int)Math.ceil(noticeDao.selectNoticeCount()/(double)rowPerPage);	//모델 호출
	
	if(endPage > lastPage){	//마지막 페이지보다 더 큰 숫자의 페이지 존재하지 않도록
		endPage = lastPage;
	}
	
	ArrayList<Notice> list = noticeDao.selectNoticeListByPage(beginRow, rowPerPage);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<!-- 로그인 -->
	<div style="margin-bottom: 2.5rem;">
		<form method="post" action="<%=request.getContextPath()%>/loginAction.jsp">
			<div class="card border-secondary mb-3 container " style="max-width: 20rem;">
			  <div class="card-header">로그인</div>
			  <div class="card-body">
				<input type="text" name="memberId" class="form-control" id="inputDefault" placeholder="ID를 입력하세요">
				<input type="password" name="memberPw" class="form-control" id="exampleInputPassword1" placeholder="비밀번호를 입력하세요">
			  </div>
				<button type="submit" class="btn btn-primary">로그인</button>
				<span class="text-center">회원이 아니신가요?</span>
				<a class="text-center" href="<%=request.getContextPath()%>/member/signUpForm.jsp">회원가입</a>
			</div>
		</form>
	</div>
	<!-- 공지(5개)-->
	<div>
		<table class="container table table-hover">
			<tr class="table-secondary">
				<td scope="row">공지내용</td>
				<td>날짜</td>
			</tr>
			<%
				for(Notice n : list){
			%>
					<tr>
						<td><%=n.getNoticeMemo()%></td>
						<td><%=n.getCreatedate()%></td>
					</tr>
			<%
				}
			%>
		</table>
		
		<!-- 페이징 -->
		<div class="container">
		  <ul class="pagination justify-content-center">
		    <li class="page-item">
		      <a class="page-link" href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=1">&laquo;</a>
		    </li>
		    
		    <li class="page-item">
			    <%
				if(currentPage > 10){
				%>
					<a class="page-link" href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=startPage-1%>">&lt;</a>
				<%
				}
			    %>
		    </li>
		    
		    <li class="page-item">
		    	<span class="page-link">
		    	<%
			    for(int i = startPage; i <= endPage; i++){
					if(i == currentPage){	// 현재 페이지는
						%>
						<strong><a href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=i%>" style="background-color:var(--bs-pagination-hover-bg); color:white; text-decoration:none;"><%=i%></a></strong>
						<%
					}else {
						%>
						<a href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=i%>" style="color:white; text-decoration:none;"><%=i%></a>
						<%
					}
				}
		    	%>
		    	</span>
		    </li>
		    
		    <li class="page-item">
			    <%
				if(currentPage < lastPage){
				%>
					<a class="page-link" href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=startPage+10%>">&gt;</a>
				<%
				}
				%>
		    </li>
		    
		    <li class="page-item">
		    	<a class="page-link" href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=lastPage%>">&raquo;</a>
		    </li>
		  </ul>
		</div>
	</div>

</body>
</html>