<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    session.invalidate();

    // ⭐ index.jsp로 이동하도록 수정
    response.sendRedirect(request.getContextPath() + "/index.jsp");
%>