<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	request.setCharacterEncoding("UTF-8");	//한글 인코딩
	
	// 로그인 x -> 로그인 창으로
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	// 현재 로그인
	Member loginMember = (Member)session.getAttribute("loginMember");
	String memberId = loginMember.getMemberId();
	
	// 방어 코드 - 입력되지 않으면 폼으로 돌려보냄
	if(request.getParameter("memberName") == null || request.getParameter("memberName").equals("")
		|| request.getParameter("memberPw") == null || request.getParameter("memberPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp");
		return;
	}
		
	
	// 넘어온 정보 확인
	String memberName = request.getParameter("memberName");
	String memberPw = request.getParameter("memberPw");
	
	MemberDao memberDao = new MemberDao();
	
	// 비밀번호 일치 확인
	int checkPw = memberDao.selectMemberPw(memberId, memberPw);
	if(checkPw == 0){	// 비밀번호가 틀렸다면
		String msg = URLEncoder.encode("비밀번호를 정확하게 입력해 주세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp?msg="+msg);
		return;
	}
	
	// 정보 수정 수행
	int check = memberDao.updateMember(memberName, memberId, memberPw);
	if(check == 1){
		System.out.println("회원정보 변경 성공");
	}else {
		System.out.println("회원정보 변경 실패");
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보 변경 성공</title>
</head>
<body>
	<div>
		<span>내 정보 변경에 성공했습니다.</span>
		<div>
			<a href="<%=request.getContextPath()%>/member/memberPage.jsp">내 정보로 돌아가기</a>
		</div>
	</div>
</body>
</html>