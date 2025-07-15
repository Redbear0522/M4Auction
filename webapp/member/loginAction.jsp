<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dao.MemberDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    String userId = request.getParameter("userId");
    String userPwd = request.getParameter("userPwd");

    Connection conn = getConnection();
    
    MemberDTO loginUser = new MemberDAO().loginMember(conn, userId, userPwd);
    
    close(conn);
    
    if(loginUser != null) {
        session.setAttribute("loginUser", loginUser);
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 처리</title>
</head>
<body>

    <script>
        <% if(loginUser != null) { %>
            // 로그인 성공 시
            alert("<%= loginUser.getMemberName() %>님, 환영합니다!");
            // ⭐ index.jsp로 이동하도록 수정
            location.href = "<%=request.getContextPath()%>/index.jsp";
        <% } else { %>
            // 로그인 실패 시
            alert("아이디 또는 비밀번호가 일치하지 않습니다.");
            // 이전 페이지(로그인 폼)로 돌아갑니다.
            history.back();
        <% } %>
    </script>
</body>
</html>