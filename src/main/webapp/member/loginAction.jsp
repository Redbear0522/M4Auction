<%--
  File: WebContent/member/loginAction.jsp
  역할: loginForm.jsp에서 넘어온 로그인 정보를 실제로 처리하는 로직을 담당합니다.
       이 페이지는 사용자에게 직접 보이지 않습니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.dao.MemberDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    // 1. loginForm.jsp에서 사용자가 입력한 아이디와 비밀번호를 가져옵니다.
    String userId = request.getParameter("userId");
    String userPwd = request.getParameter("userPwd");

    // 2. '마법 열쇠(Connection)'를 가져옵니다.
    Connection conn = getConnection();
    
    // 3. '회원 관리 직원(MemberDAO)'을 불러와서, 아이디와 비밀번호를 전달하며 로그인을 시도합니다.
    //    성공하면 회원 정보가 담긴 '이름표(Member 객체)'를, 실패하면 null을 돌려받습니다.
    MemberDTO loginUser = new MemberDAO().loginMember(conn, userId, userPwd);
    
    // 4. DB 연결은 이제 필요 없으니, 다 쓴 '마법 열쇠'는 바로 반납합니다.
    close(conn);
    
    // 5. 로그인 성공 여부를 확인합니다.
    if(loginUser != null) {
        // 로그인 성공!
        // session이라는 '개인 사물함'에 로그인한 회원의 이름표를 'loginUser'라는 이름으로 보관합니다.
        // 이렇게 하면, 다른 페이지에서도 누가 로그인했는지 알 수 있습니다.
        session.setAttribute("loginUser", loginUser);
    }
    
    // 6. 이제 화면에 결과를 보여주고 페이지를 이동시킵니다.
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
            // 메인 페이지로 이동
            location.href = "../index.jsp";
        <% } else { %>
            // 로그인 실패 시
            alert("아이디 또는 비밀번호가 일치하지 않습니다.");
            // 이전 페이지(로그인 폼)로 돌아갑니다.
            history.back();
        <% } %>
    </script>
</body>
</html>
