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
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div>
		<form method="post" action="<%=request.getContextPath()%>/admin/updateNoticeAction.jsp">
			<table>
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
						<textarea rows="3" cols="50" name="noticeMemo"><%=notice.getNoticeMemo()%></textarea>
					</td>
				</tr>
			</table>
			<button type="submit">수정</button>
		</form>
	</div>
</body>
</html>