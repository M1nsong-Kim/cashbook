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

	// model 호출
	NoticeDao noticeDao = new NoticeDao();
	MemberDao memberDao = new MemberDao();
	// 최근공지 5개, 최근멤버 5명
	int beginRow = 0;
	int rowPerPage = 5;
	ArrayList<Notice> noticeList = noticeDao.selectNoticeListByPage(beginRow, rowPerPage);
	ArrayList<Member> memberList = memberDao.selectMemberListByPage(beginRow, rowPerPage);
	
	// view
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
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
		<!-- adminMain content -->
	</div>
	<!-- 최근 공지 5개 -->
	<div>
		<h3>최근 공지</h3>
		<table>
			<tr>
				<th>내용</th>
				<th>날짜</th>
			</tr>
			<%
			for(Notice n : noticeList){
			%>
				<tr>
					<td><%=n.getNoticeMemo()%></td>
					<td><%=n.getCreatedate()%></td>
				</tr>
			<%
			}
			%>
		</table>
	</div>
	<!-- 최근 회원 5명 -->
	<div>
		<h3>최근 회원</h3>
		<table>
			<tr>
				<th>회원번호</th>
				<th>아이디</th>
				<th>등급</th>
				<th>이름</th>
				<th>마지막수정날짜</th>
				<th>가입날짜</th>
			</tr>
			<%
			for(Member m : memberList){
			%>
				<tr>
					<td><%=m.getMemberNo()%></td>
					<td><%=m.getMemberId()%></td>
					<td><%=m.getMemberLevel()%></td>
					<td><%=m.getMemberName()%></td>
					<td><%=m.getUpdatedate()%></td>
					<td><%=m.getCreatedate()%></td>
				</tr>
			<%
			}
			%>
		</table>
	</div>
</body>
</html>