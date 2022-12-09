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

	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5;	// 한 페이지당 보여줄 개수
	int pageList = 10;	// 페이지 10개씩 보여주기 n1~(n+1)0
	int beginRow = (currentPage-1)*rowPerPage;
	int startPage = ((currentPage-1)/pageList)*pageList+1;	//n1
	int endPage = startPage + pageList -1;	//(n+1)0
	MemberDao memberDao = new MemberDao();
	ArrayList<Member> list = memberDao.selectMemberListByPage(beginRow, rowPerPage); // model 호출
	int memberCount = memberDao.selectMemberCount();
	int lastPage = (int)(Math.ceil((double)memberCount/rowPerPage));	// model 호출
	if(endPage > lastPage){	// 마지막 페이지를 넘어서 가지 않도록
		endPage = lastPage;
	}
	
	// 비밀번호 틀려서 받아올 메시지 있다면 받기
	String msg = null;
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");		
	}

	
	// view
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멤버 목록</title>
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
	
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<!-- 나중에 메시지로 띄울 거라서 -->
		<%
			if(msg != null){
				%>
					<span><%=msg%></span>
				<%
			}
		%>
		<!-- memberList content -->
		<div class="card-header">회원 목록</div>
		<table class="table">
			<tr>
				<th>멤버번호</th>
				<th>아이디</th>
				<th>레벨</th>
				<th>이름</th>
				<th>마지막수정일자</th>
				<th>생성일자</th>
				<th>등급수정</th>
				<th>강제탈퇴</th>
			</tr>
			<% 
				for(Member m : list){
			%>
					<tr>
						<td><%=m.getMemberNo()%></td>
						<td><%=m.getMemberId()%></td>
						<td><%=m.getMemberLevel()%></td>
						<td><%=m.getMemberName()%></td>
						<td><%=m.getUpdatedate()%></td>
						<td><%=m.getCreatedate()%></td>
						<td>
							<a href="<%=request.getContextPath()%>/admin/updateMemberLevelForm.jsp?memberNo=<%=m.getMemberNo()%>">등급수정</a>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/admin/deleteMemberForm.jsp?memberNo=<%=m.getMemberNo()%>">강제탈퇴</a>
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
				<a class="page-link" href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=1">&laquo;</a>
			</li>
			
			<li class="page-item">
				<%
					if(currentPage > 10){
				%>
						<a class="page-link" href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=<%=startPage-1%>">&lt;</a>
				<%
					}
				%>
			</li>
			
			 <li class="page-item">
			 	<span class="page-link">
				<%
				for(int i = startPage; i <= endPage; i++){
						if(i == currentPage){	//현재 페이지 굵게
							%>
							<strong><a href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=<%=i%>" style="background-color:var(--bs-pagination-hover-bg); color:white; text-decoration:none;"><%=i%></a></strong>
							<%
						}else {
						%>
							<a href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=<%=i%>" style="color:white; text-decoration:none;"><%=i%></a>
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
						<a class="page-link" href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=<%=currentPage+1%>">&gt;</a>
				<%
					}
				%>
			</li>
			
			<li class="page-item">
				<a class="page-link" href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=<%=lastPage%>">&raquo;</a>
			</li>
		</ul>
	</div>
</body>
</html>