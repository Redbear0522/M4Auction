<%--
  File: WebContent/member/enrollAction_detail.jsp
  역할: enroll_step2.jsp에서 넘어온 모든 상세 정보를 실제로 처리하고 DB에 저장합니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ page import="com.auction.vo.MemberDTO"
%><%@ page import="com.auction.dao.MemberDAO"
%><%@ page import="java.sql.Connection"
%><%@ page import="static com.auction.common.JDBCTemplate.*" %><%
    // 1. POST 방식으로 넘어온 데이터의 한글이 깨지지 않도록 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    // 2. enroll_step2.jsp에서 사용자가 입력한 모든 값들을 변수에 저장
    String userId = request.getParameter("userId");
    String userPwd = request.getParameter("userPwd");
    String userName = request.getParameter("userName");
    String birthdate = request.getParameter("birthdate");
    String gender = request.getParameter("gender");
    String email = request.getParameter("email");
    String mobileCarrier = request.getParameter("mobileCarrier");
    String tel = request.getParameter("tel");

    // 3. 받아온 모든 정보들을 업그레이드된 '이름표 양식(Member 객체)'에 담습니다.
    MemberDTO m = new MemberDTO(userId, userPwd, userName, email, tel, birthdate, gender, mobileCarrier);
    
    // 4. '마법 열쇠(Connection)'를 가져옵니다.
    Connection conn = getConnection();

    // 5. '회원 관리 직원(MemberDAO)'을 불러와서, 상세 정보가 담긴 이름표를 전달하며 회원가입을 시킵니다.
    int result = new MemberDAO().enrollMember(conn, m);

    // 6. 결과에 따라 데이터 보관함에 최종 저장을 할지, 취소를 할지 결정합니다.
    if (result > 0) {
        commit(conn); // 성공했으니 최종 저장!
    } else {
        rollback(conn); // 실패했으니 모든 변경사항 취소!
    }
    
    // 7. 다 쓴 '마법 열쇠(Connection)'는 반납합니다.
    close(conn);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 처리</title>
</head>
<body>
    <script>
        <% if(result > 0) { %>
            // 성공했을 때
            alert("회원가입이 완료되었습니다. 로그인 페이지로 이동합니다.");
            // 로그인 페이지로 이동합니다.
            location.href = "loginForm.jsp";
        <% } else { %>
            // 실패했을 때
            alert("회원가입에 실패했습니다. 다시 시도해주세요.");
            // 1단계 약관 동의 페이지로 돌려보냅니다.
            location.href = "enroll_step1.jsp";
        <% } %>
    </script>
</body>
</html>