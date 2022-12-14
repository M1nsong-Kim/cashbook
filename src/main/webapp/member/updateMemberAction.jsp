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
	System.out.println(loginMember.getMemberId()+"---------세션 아이디 확인");
	
	// 방어 코드 - 입력되지 않으면 폼으로 돌려보냄
	if(request.getParameter("memberName") == null || request.getParameter("memberName").equals("")
		|| request.getParameter("memberPw") == null || request.getParameter("memberPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp");
		return;
	}
		
	
	// 넘어온 정보 확인
	String memberId = request.getParameter("memberId");
	String memberName = request.getParameter("memberName");
	String memberPw = request.getParameter("memberPw");
	
	// 비밀번호 일치 매개 변수 / 수정한 session에 넣을 값이라 다 설정해줘야 함
	Member paramMember = new Member();
	paramMember.setMemberNo(loginMember.getMemberNo());
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	paramMember.setMemberName(memberName);
	paramMember.setMemberLevel(loginMember.getMemberLevel());
	paramMember.setUpdatedate(loginMember.getUpdatedate());
	paramMember.setCreatedate(loginMember.getCreatedate());
	
	
	MemberDao memberDao = new MemberDao();

	// 비밀번호 일치 확인
	int checkPw = memberDao.selectMemberPw(paramMember);
	if(checkPw == 0){	// 비밀번호가 틀렸다면
		String msg = URLEncoder.encode("비밀번호를 정확하게 입력해 주세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp?msg="+msg);
		return;
	}
	
	System.out.println("비밀번호 일치 확인 완료");
	
	System.out.println(paramMember.getMemberNo()+"번호 확인");
	System.out.println(paramMember.getMemberId()+"아이디 확인");
	System.out.println(paramMember.getMemberName()+"이름 확인");
	System.out.println(paramMember.getMemberPw()+"비밀번호 확인");
	
	// 정보 수정 수행
	int check = memberDao.updateMember(paramMember);
	if(check == 1){
		System.out.println("회원정보 변경 성공");
		// 수정 성공 -> ★★★★★★★session에 저장된 값 바꾸기★★★★★★★
		session.setAttribute("loginMember", paramMember);
	}else {
		System.out.println("회원정보 변경 실패");
		String msg = URLEncoder.encode("회원 정보 변경에 실패하였습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/member/updateMemberForm.jsp?msg="+msg);
		return;
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