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
	HelpDao helpDao = new HelpDao();
	// 최근공지 5개, 최근멤버 5명
	int beginRow = 0;
	int rowPerPage = 5;
	ArrayList<Notice> noticeList = noticeDao.selectNoticeListByPage(beginRow, rowPerPage);
	ArrayList<Member> memberList = memberDao.selectMemberListByPage(beginRow, rowPerPage);
	ArrayList<HashMap<String, Object>> helpList = helpDao.selectHelpList(beginRow, rowPerPage);
	
	// view
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
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

	<!-- 최근 공지 5개 -->
	<div class="container" style="margin-bottom: 2.5rem;">
		<h4>최근 공지</h4>
		<table class="table table-hover">
			<tr class="table-secondary">
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
	<div class="container" style="margin-bottom: 2.5rem;">
		<h4>최근 회원</h4>
		<table class="table table-hover">
			<tr class="table-secondary">
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
	
	<!-- 최근 문의 5개 -->
	<div class="container">
		<h4>최근 문의</h4>
		<table class="table table-hover">
			<tr class="table-secondary">
				<th>문의내용</th>
				<th>아이디</th>
				<th>문의날짜</th>
				<th>답변내용</th>
				<th>답변날짜</th>
			</tr>
			<%
			for(HashMap<String, Object> m : helpList){
				%>
				<tr>
					<td><%=m.get("helpMemo")%></td>
					<td><%=m.get("memberId")%></td>
					<td><%=m.get("createdateHelp")%></td>
					<%
						// 답변이 없다면 (--> 답변 날짜가 없다면)
						if(m.get("commentMemo") == null){
							%>
							<td colspan="2">답변 대기</td>
							<%
						}else {
							%>
							<td><%=m.get("commentMemo")%></td>
							<td><%=m.get("createdateComment")%></td>
							<%
						}
					%>
				</tr>
				<%
			}
			%>
		</table>
	</div>
</body>
</html>