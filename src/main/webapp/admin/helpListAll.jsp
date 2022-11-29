<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "";
	
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}

	// 페이징
	HelpDao helpDao = new HelpDao();
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;	//페이지별 보여줄 목록 개수
	int beginRow = (currentPage - 1)* rowPerPage;
	int pageList = 10;	// 페이지 10개 - (n)1 ~ (n+1)0
	int startPage = ((currentPage - 1)/pageList)*pageList + 1;	//n1
	int endPage = startPage + pageList - 1;	//(n+1)0
	int lastPage = (int)Math.ceil(helpDao.selectHelpCount()/(double)rowPerPage);	// 모델 호출
	if(endPage > lastPage){	//마지막 페이지가 페이지 목록의 마지막이 될 수 있도록
		endPage = lastPage;
	}
	
	ArrayList<HashMap<String, Object>> list = helpDao.selectHelpList(beginRow, rowPerPage); //모델 호출
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 문의 목록</title>
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
		<li><a href="<%=request.getContextPath()%>/admin/helpListAll.jsp">문의관리</a></li>
	</ul>
	
	<!-- 고객센터 문의 리스트 -->
	<div>
		<table>
			<tr>
				<th>문의내용</th>
				<th>회원ID</th>
				<th>문의날짜</th>
				<th>답변내용</th>
				<th>답변날짜</th>
				<th>답변추가/수정/삭제</th>
			</tr>
			<%
				for(HashMap<String, Object> m : list){
					%>
					<tr>
						<td><%=m.get("helpMemo")%></td>
						<td><%=m.get("memberId")%></td>
						<td><%=m.get("createdateHelp")%></td>
						<%
							if(m.get("commentMemo") == null){	// 답변 내용 없음 == 답변 날짜 없음
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
						<td>
							<%
							if(m.get("commentMemo") == null){
								%>
								<a href="<%=request.getContextPath()%>/admin/insertCommentForm.jsp?helpNo=<%=m.get("helpNo")%>">
									답변입력
								</a>
								<%
							}else {
								%>
								<a href="<%=request.getContextPath()%>/admin/updateCommentForm.jsp?commentNo=<%=m.get("commentNo")%>">
									답변수정
								</a>
								<a href="<%=request.getContextPath()%>/admin/deleteComment.jsp?commentNo=<%=m.get("commentNo")%>">
									답변삭제
								</a>
								<%
							}
							%>
						</td>
					</tr>
					<%
				}
			%>
		</table>
	</div>
	<!-- 페이징 -->
	<div>
		<a href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=1">&#9194;</a>
			<%
				if(currentPage > 1){
			%>
					<a href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=currentPage-1%>">◀</a>
			<%
				}
				for(int i = startPage; i <= endPage; i++){
					if(i == currentPage){	// 현재 페이지는
						%>
						<!-- 굵게 -->
						<strong><a href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=i%>"><%=i%></a></strong>
						<%
					}else {
						%>
						<a href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=i%>"><%=i%></a>
						<%
					}
				}
			%>
			<%
				if(currentPage < lastPage){
			%>
					<a href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=currentPage+1%>">▶</a>
			<%
				}
			%>
			<a href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=lastPage%>">&#9193;</a>
	</div>
</body>
</html>