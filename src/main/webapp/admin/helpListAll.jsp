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
	
		<!-- 고객센터 문의 리스트 -->
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<div class="card-header">문의 목록</div>
		<div class="accordion" id="accordionExample">
			<%
				int num = 0;
				for(HashMap<String, Object> m : list){
					%>
					<div class="accordion-item">
						<h2 class="accordion-header" id="heading<%=num%>">
							<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%=num%>" aria-expanded="false" aria-controls="collapse<%=num%>">
								<%=m.get("helpTitle")%>
								<%=m.get("createdateHelp")%>
							</button>
						</h2>
						<div id="collapse<%=num%>" class="accordion-collapse collapse" aria-labelledby="heading<%=num%>" data-bs-parent="#accordionExample">
							<div class="accordion-body">
							<span>작성자: <%=m.get("memberId")%></span>
							<div><%=m.get("helpMemo")%></div>
							<br>
							<span>답변 상태: </span>
						<%
							if(m.get("commentMemo") == null){	// 답변 내용 없음 == 답변 날짜 없음
								%>
								<div><strong>대기</strong></div>
								<%
							}else {
								%>
								<div><%=m.get("createdateComment")%> <strong>완료</strong></div>
								<%
							}
						%>
							<%
							if(m.get("commentMemo") == null){	// 답변이 달리지 않았다면
								%>
								<a href="<%=request.getContextPath()%>/admin/insertCommentForm.jsp?helpNo=<%=m.get("helpNo")%>">
									답변입력
								</a>
								<%
							}else {
								%>
								<span><%=m.get("commentMemo")%></span>
								<div>
									<a href="<%=request.getContextPath()%>/admin/updateCommentForm.jsp?commentNo=<%=m.get("commentNo")%>">
										답변수정
									</a>
									<a href="<%=request.getContextPath()%>/admin/deleteComment.jsp?commentNo=<%=m.get("commentNo")%>">
										답변삭제
									</a>
								</div>
								<%
							}
							num++;
							%>
							</div>
						</div>
					</div>
					<%
				}
			%>
		</div>
	</div>
	
	<!-- 페이징 -->
	<div class="container">
		<ul class="pagination justify-content-center">
			<li class="page-item">
				<a class="page-link" href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=1">&laquo;</a>
			</li>
			
			<li class="page-item">
				<%
					if(currentPage > 10){
				%>
						<a class="page-link" href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=currentPage-1%>">&lt;</a>
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
							<!-- 굵게 -->
							<strong><a href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=i%>"  style="background-color:var(--bs-pagination-hover-bg); color:white; text-decoration:none;"><%=i%></a></strong>
							<%
						}else {
							%>
							<a href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=i%>" style="color:white; text-decoration:none;"><%=i%></a>
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
						<a class="page-link" href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=currentPage+1%>">&gt;</a>
				<%
					}
				%>
			</li>
			
			<li class="page-item">
				<a class="page-link" href="<%=request.getContextPath()%>/admin/helpListAll.jsp?currentPage=<%=lastPage%>">&raquo;</a>
			</li>
		</ul>
	</div>
</body>
</html>