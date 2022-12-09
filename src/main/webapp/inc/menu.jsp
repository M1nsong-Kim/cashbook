<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%
	// 로그인 확인
	Member loginMember = (Member)session.getAttribute("loginMember");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	  <div class="container-fluid">
	  	<!-- 로그인한 상태에서 loginForm으로 가면 내 가계부 화면으로 보내진다 -->
	    <a class="navbar-brand" href="<%=request.getContextPath()%>/loginForm.jsp">나만의 가계부</a>
	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarColor02" aria-controls="navbarColor02" aria-expanded="false" aria-label="Toggle navigation">
	      <span class="navbar-toggler-icon"></span>
	    </button>
	    <div class="collapse navbar-collapse" id="navbarColor02">
	      <ul class="navbar-nav me-auto">
	        <li class="nav-item">
	          <a class="nav-link" href="<%=request.getContextPath()%>/member/memberPage.jsp">마이페이지</a>
	        </li>
	        
	        
	        <li class="nav-item dropdown">
				<%
					if(loginMember != null){
						
						// 관리자라면
						if(loginMember.getMemberLevel() > 0){
					%>
				          <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">관리자페이지</a>
				          <div class="dropdown-menu">
				          	<a class="dropdown-item" href="<%=request.getContextPath()%>/admin/adminMain.jsp">관리자메인</a>
				          	<div class="dropdown-divider"></div>
							<a class="dropdown-item" href="<%=request.getContextPath()%>/admin/noticeList.jsp">공지관리</a>
							<a class="dropdown-item" href="<%=request.getContextPath()%>/admin/categoryList.jsp">카테고리관리</a>
							<a class="dropdown-item" href="<%=request.getContextPath()%>/admin/memberList.jsp">멤버관리(목록, 레벨 수정, 강제탈퇴)</a>
							<a class="dropdown-item" href="<%=request.getContextPath()%>/admin/helpListAll.jsp">문의관리</a>
				          </div>
					<%
						}
					}
				%>
	        </li>
	        
	        
        
        
        
	        <li class="nav-item">
				<a class="nav-link" href="<%=request.getContextPath()%>/help/helpMain.jsp">고객센터</a>
			</li>
	      </ul>
	      <!-- 오른쪽 -->
	      <span class="d-flex nav-item dropdown">
	      <%
	      	// 로그인하지 않았다면
	      	if(loginMember == null){
	  	      %>
	      		<a class="nav-link" href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a>
	      		<span>&nbsp;</span>
	      		<a class="nav-link" href="<%=request.getContextPath()%>/member/signUpForm.jsp">회원가입</a>
	      		<%
	      	}else {
	      		%>
	      		<div class="dropstart">
		      		<a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
		      			<span style="color:white;"><%=loginMember.getMemberName()%></span>님
		      		</a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="<%=request.getContextPath()%>/logout.jsp">로그아웃</a>
						</div>
	      		</div>
	      		<%
	      	}
	      %>
	      </span>
	    </div>
	  </div>
	</nav>
</body>
</html>