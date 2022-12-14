<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	
	//1
	request.setCharacterEncoding("UTF-8"); //한글 인코딩
	
	if(session.getAttribute("loginMember") != null) {
		// 로그인되어 있다면
		response.sendRedirect(request.getContextPath()+"/cash/cashList.jsp");
		return;
	}
	
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
	<!-- 템플릿 적용 -->
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.css">
	<link rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/css/Minty/bootstrap.min.css">
</head>
<body>
	<!-- 메뉴 페이지 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<!-- 회원가입 -->
	<div>
		<form method="post" action="<%=request.getContextPath()%>/member/signUpAction.jsp" id="signUpForm">
			<div class="card border-secondary mb-3 container" style="max-width: 40rem;">
			  <div class="card-header">회원가입</div>
			  <div class="card-body">
			  	<span class="card-text">아이디</span>
				<input type="text" name="memberId" class="form-control" id="memberId">
				<span class="card-text">비밀번호</span>
				<input type="password" name="memberPw" class="form-control" id="memberPw">
				<span class="card-text">이름</span>
				<input type="text" name="memberName" class="form-control" id="memberName">
			  </div>
				<button type="button" class="btn btn-primary" id="signUpBtn">회원가입</button>
				<span class="text-center">이미 회원이신가요?</span>
				<a class="text-center" href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a>
			</div>
		</form>
	</div>
	<script>
	// 아이디 중복 검사
	<%
		if(msg != null){
	%>		
			alert("<%=msg%>");
	<%	
		}
	%>
		let signUpBtn = document.querySelector('#signUpBtn');
		signUpBtn.addEventListener('click', function() {
			// 디버깅
			console.log('회원가입 클릭');
			
			// 아이디 유효성 검사
			let memberId = document.querySelector('#memberId');
			if(memberId.value == ''){
				alert('아이디를 입력하세요');
				memberId.focus();	// 커서 이동
				return;
			}
			
			// 비밀번호 유효성 검사
			let memberPw = document.querySelector('#memberPw');
			if(memberPw.value == ''){
				alert('비밀번호를 확인하세요');
				memberPw.focus();
				return;
			}
			
			// 이름 유효성 검사
			let memberName = document.querySelector('#memberName');
			if(memberName.value == ''){
				alert('이름을 입력하세요');
				memberName.focus();
				return;
			}
			
			let signUpForm = document.querySelector('#signUpForm');
			signUpForm.submit();
		});
	</script>
</body>
</html>