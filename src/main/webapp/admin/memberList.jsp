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
	int rowPerPage = 5;
	int beginRow = (currentPage-1)*rowPerPage;
	
	// 비밀번호 틀려서 받아올 메시지 있다면 받기
	String msg = null;
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");		
	}

	MemberDao memberDao = new MemberDao();
	ArrayList<Member> list = memberDao.selectMemberListByPage(beginRow, rowPerPage); // model 호출
	int memberCount = memberDao.selectMemberCount();
	int lastPage = (int)(Math.ceil((double)memberCount/rowPerPage));	// model 호출
	
	// view
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<ul>
		<li><a href="<%=request.getContextPath()%>/admin/noticeList.jsp">공지관리</a></li>
		<li><a href="<%=request.getContextPath()%>/admin/categoryList.jsp">카테고리관리</a></li>
		<li><a href="<%=request.getContextPath()%>/admin/memberList.jsp">멤버관리(목록, 레벨 수정, 강제탈퇴)</a></li>
	</ul>
	<div>
		<!-- 나중에 메시지로 띄울 거라서 -->
		<%
			if(msg != null){
				%>
					<span><%=msg%></span>
				<%
			}
		%>
		<!-- memberList content -->
		<h3>멤버 목록</h3>
		<table>
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
	<div>
		<a href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=1">&#9194;</a>
		<%
			if(currentPage > 1){
		%>
				<a href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=<%=currentPage-1%>">◀</a>
		<%
			}
		%>
		<span><%=currentPage%></span>
		<%
			if(currentPage < lastPage){
		%>
				<a href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=<%=currentPage+1%>">▶</a>
		<%
			}
		%>
		<a href="<%=request.getContextPath()%>/admin/memberList.jsp?currentPage=<%=lastPage%>">&#9193;</a>
	</div>
</body>
</html>