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
</head>
<body>
	<!-- 공지(5개) 목록 페이징 -->
	<div>
		<table>
			<tr>
				<td>공지내용</td>
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

		<a href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=1">&#9194;</a>
		<%
			if(currentPage > 1){
		%>
				<a href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=currentPage-1%>">◀</a>
		<%
			}
			for(int i = startPage; i <= endPage; i++){
				if(i == currentPage){	// 현재 페이지는
					%>
					<!-- 굵게 -->
					<strong><a href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=i%>"><%=i%></a></strong>
					<%
				}else {
					%>
					<a href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=i%>"><%=i%></a>
					<%
				}
			}
		%>
		<%
			if(currentPage < lastPage){
		%>
				<a href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=currentPage+1%>">▶</a>
		<%
			}
		%>
		<a href="<%=request.getContextPath()%>/loginForm.jsp?currentPage=<%=lastPage%>">&#9193;</a>
	</div>
	
	<div>
		<form method="post" action="<%=request.getContextPath()%>/loginAction.jsp">
			<h3>로그인</h3>	
			<div><input type="text" name="memberId" placeholder="ID를 입력하세요"></div>
			<div><input type="password" name="memberPw" placeholder="비밀번호를 입력하세요"></div>
			<div>
				<button type="submit">로그인</button>
			</div>
		</form>
		<div>
			<span>회원이 아니신가요?</span>
			<a href="<%=request.getContextPath()%>/member/signUpForm.jsp">회원가입</a>
		</div>
	</div>
</body>
</html>