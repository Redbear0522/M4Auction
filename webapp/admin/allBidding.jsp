<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.sql.Connection"%>
<%@ page import="com.auction.common.PageInfo"%>
<%@ page import="com.auction.dao.ProductDAO, com.auction.dto.ProductDTO"%>
<%@ page import="static com.auction.common.JDBCTemplate.*"%>
<%
    String ctx = request.getContextPath();

    // --- 페이징 파라미터 ---
    int currentPage = 1;
    int pageLimit   = 5;    // 페이지 네비 개수
    int boardLimit  = 100;  // 한 페이지당 상품 개수 (모두 보려면 충분히 크게)
    if(request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }

    // --- 커넥션과 DAO 호출 ---
    List<ProductDTO> productList = null;
    PageInfo pi = null;
    try (Connection conn = getConnection()) {
        // 전체 상품 수 조회
        int listCount = new ProductDAO().selectProductCount(conn);
        // PageInfo 생성
        pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);
        // 페이징 적용된 상품 리스트 조회
        productList = new ProductDAO().selectProductList(conn, pi);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>모든 상품</title>

  <!-- 공통 스타일 -->
  <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
  <link rel="stylesheet" href="<%=ctx%>/resources/css/layout.css">

  <style>
    .product-list-container {
      max-width: 1200px;
      margin: 60px auto;
      padding: 0 20px;
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px,1fr));
      gap: 20px;
    }
    .product-card { /* 카드 스타일 생략… */ }
  </style>
</head>
<body>
  <!-- 공통 헤더 -->
  <jsp:include page="/layout/header/luxury-header.jsp" flush="true"/>

  <div class="product-list-container">
    <%
      if (productList != null && !productList.isEmpty()) {
        for (ProductDTO p : productList) {
    %>
    <div class="product-card">
      <img src="<%= ctx %>/resources/product_images/<%= p.getImageRenamedName() %>"
           alt="<%= p.getProductName() %>">
      <h3><%= p.getProductName() %></h3>
      <p class="price">
        ₩ <%= new java.text.DecimalFormat("###,###").format(
             p.getCurrentPrice()==0 ? p.getStartPrice() : p.getCurrentPrice()
           ) %>
      </p>
      <a href="<%=request.getContextPath()%>/product/productDetail.jsp?productId=<%=p.getProductId()%>"
         class="details-btn">상세 보기</a>
    </div>
    <%
        }
      } else {
    %>
    <p style="text-align:center; margin:40px 0;">
      등록된 상품이 없습니다.
    </p>
    <%
      }
    %>
  </div>

  <!-- 페이징 네비 -->
  <%
    if (pi != null && pi.getMaxPage() > 1) {
  %>
  <div class="pagination">
    <% for(int i=1; i<=pi.getMaxPage(); i++) { %>
      <a href="?page=<%=i%>" 
         class="<%= (i==pi.getCurrentPage() ? "active" : "") %>">
        <%=i%>
      </a>
    <% } %>
  </div>
  <%
    }
  %>

  <!-- 공통 푸터 -->
  <jsp:include page="/layout/footer/luxury-footer.jsp" flush="true"/>
</body>
</html>
