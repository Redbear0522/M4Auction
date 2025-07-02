<%--
  File: WebContent/member/logout.jsp
  역할: 세션을 무효화하여 로그아웃을 처리하고 메인 페이지로 이동시킵니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // session.invalidate() : 현재 사용자의 세션(개인 사물함)을 완전히 무효화시킵니다.
    // 'loginUser' 정보뿐만 아니라 세션에 저장된 모든 정보가 사라집니다.
    session.invalidate();

    // 로그아웃 처리 후, 메인 페이지로 다시 돌려보냅니다.
    response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
