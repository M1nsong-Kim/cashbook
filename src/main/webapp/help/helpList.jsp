<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// Controller
	String targetUrl = "";
	
	// 로그인 x -> 돌려보내기
	Member loginMember = (Member) session.getAttribute("loginMember");
	if(loginMember == null){
		targetUrl = "/loginForm.jsp";
		response.sendRedirect(request.getContextPath()+targetUrl);
		return;
	}
	String memberId = loginMember.getMemberId();
	
	HelpDao helpDao = new HelpDao();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	list = helpDao.selectHelpList(memberId);	// 모델 호출
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의내역</title>
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
	
	<!-- 문의내용 -->
	<div class="card border-secondary mb-3 container " style="max-width: 60rem;">
		<div class="card-header">
			<span>내 문의내역</span>
			<a href="<%=request.getContextPath()%>/help/insertHelpForm.jsp">문의하기</a>
		</div>
			<div class="accordion" id="accordionExample">
			<%
				int i = 0;
				for(HashMap<String, Object> m : list){
					%>
					<div class="accordion-item">
						<h2 class="accordion-header" id="heading<%=i%>">
							<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%=i%>" aria-expanded="false" aria-controls="collapse<%=i%>">
								<%=m.get("helpTitle")%>
								<%=m.get("createdateHelp")%>
							</button>
						</h2>
						<div id="collapse<%=i%>" class="accordion-collapse collapse" aria-labelledby="heading<%=i%>" data-bs-parent="#accordionExample">
							<div class="accordion-body">
						<%
						// 답변이 없다면
						if(m.get("commentMemo") == null){
						%>
							<%=m.get("helpMemo")%>
							<a href="<%=request.getContextPath()%>/help/updateHelpForm.jsp?helpNo=<%=m.get("helpNo")%>">수정</a>
							<a href="<%=request.getContextPath()%>/help/deleteHelp.jsp?helpNo=<%=m.get("helpNo")%>">삭제</a>
							<div><strong>답변 대기중</strong></div>
						<%
						}else {	//답변이 있다면
							%>	
							<%=m.get("helpMemo")%>
							<p></p>
							<div>답변:</div>
							<span><%=m.get("createdateComment")%> <strong>답변완료</strong></span>
							<div><%=m.get("commentMemo")%></div>
							<%
						}
						i++;
						%>
							</div>
						</div>
					</div>
					<%
				}
			%>
			</div>
	</div>
</body>
</html>