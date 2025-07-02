<%--
  File: WebContent/mypage/myPage.jsp
  역할: 내가 등록/입찰/낙찰받은 모든 상품 목록을 보여주는 최종 버전의 마이페이지입니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

    if(loginUser == null){
        session.setAttribute("alertMsg", "로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String alertMsg = (String)session.getAttribute("alertMsg");

    Connection conn = getConnection();
    ProductDAO pDao = new ProductDAO();
    
    // 1. 내가 등록한 상품 목록 조회
    List<ProductDTO> myProducts = pDao.selectProductsBySeller(conn, loginUser.getMemberId());
    
    // 2. 내가 입찰한 상품 목록 조회
    List<ProductDTO> myBids = pDao.selectProductsByBidder(conn, loginUser.getMemberId());

    // 3. 내가 낙찰받은 상품 목록 조회 (새로 추가)
    List<ProductDTO> myWonProducts = pDao.selectWonProducts(conn, loginUser.getMemberId());
    
    close(conn);

    DecimalFormat df = new DecimalFormat("###,###,###");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 마이페이지</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<style>
    body { margin: 0; background-color: #1a1a1a; color: #e0e0e0; font-family: 'Noto Sans KR', sans-serif; }
    a { text-decoration: none; color: inherit; }
    .header { display: flex; justify-content: space-between; align-items: center; padding: 20px 50px; background-color: rgba(0,0,0,0.3); border-bottom: 1px solid #333; }
    .header .logo { font-family: 'Playfair Display', serif; font-size: 28px; color: #d4af37; }
    .header .nav a { margin-left: 25px; font-size: 16px; transition: color 0.3s; }
    .header .nav a:hover { color: #d4af37; }
    .footer { text-align: center; padding: 40px; margin-top: 50px; background-color: #000; color: #777; font-size: 14px; }
    .mypage-container { max-width: 1200px; margin: 50px auto; padding: 40px; }
    .mypage-title { font-family: 'Playfair Display', serif; font-size: 42px; color: #fff; margin-bottom: 50px; text-align: center; }
    .section { margin-bottom: 60px; }
    .section-title { font-size: 28px; font-weight: 700; margin-bottom: 30px; color: #fff; border-left: 5px solid #d4af37; padding-left: 15px; }
    .product-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px; }
    .product-card { position:relative; background-color: #2b2b2b; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.2); transition: transform 0.3s, box-shadow 0.3s; }
    .product-card-link:hover .product-card { transform: translateY(-5px); }
    .product-card img { width: 100%; height: 220px; object-fit: cover; }
    .product-info { padding: 20px; }
    .product-info h3 { margin: 0 0 10px 0; font-size: 18px; color: #fff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .product-info .price { font-size: 20px; font-weight: 700; color: #d4af37; }
    .product-info .status { font-size: 14px; color: #aaa; margin-top: 5px; }
    .empty-message { padding: 50px; text-align: center; color: #aaa; background-color: #2b2b2b; border-radius: 8px; grid-column: 1 / -1; }
    .info-section { background-color: #2b2b2b; padding: 30px 40px; border-radius: 8px; }
    .info-group { display: flex; align-items: center; margin-bottom: 15px; }
    .info-group .label { width: 120px; font-weight: bold; color: #aaa; }
    .info-group .value { font-size: 16px; }
    #updateForm { display: none; margin-top: 30px; border-top: 1px solid #444; padding-top: 20px;}
    .form-section input { padding: 10px; font-size: 16px; background-color: #1a1a1a; border: 1px solid #555; color: #fff; border-radius: 5px; }
    #updateBtn, #showUpdateFormBtn, .charge-btn-wrapper a { padding: 10px 20px; background-color: #d4af37; color: #1a1a1a; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; }
    .delete-btn { position: absolute; top: 10px; right: 10px; width: 30px; height: 30px; background-color: rgba(0,0,0,0.5); color: white; border: none; border-radius: 50%; font-size: 16px; line-height: 30px; text-align: center; cursor: pointer; opacity: 0; transition: opacity 0.3s; }
    .product-card:hover .delete-btn { opacity: 1; }
    .mileage-section { border-top: 1px solid #444; margin-top:20px; padding-top:20px; }
</style>
<<<<<<< HEAD
<!-- 다음 우편번호 서비스 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
=======
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
</head>
<body>
    <% if(alertMsg != null) { %>
        <script>
            alert("<%= alertMsg %>");
        </script>
    <%
            session.removeAttribute("alertMsg");
       } 
    %>
    <header class="header">
        <div class="logo"><a href="<%= request.getContextPath() %>/index.jsp">Art Auction</a></div>
        <nav class="nav">
            <span><%= loginUser.getMemberName() %>님 환영합니다.</span>
            <a href="<%= request.getContextPath() %>/product/productEnrollForm.jsp">상품등록</a>
            <a href="<%= request.getContextPath() %>/mypage/myPage.jsp">마이페이지</a>
            <a href="<%= request.getContextPath() %>/member/logout.jsp">로그아웃</a>
        </nav>
    </header>

    <div class="mypage-container">
        <h1 class="mypage-title">My Page</h1>
        <div class="section">
            <h2 class="section-title">내 정보</h2>
            <div class="info-section">
                <div class="info-group"><span class="label">아이디</span><span class="value"><%= loginUser.getMemberId() %></span></div>
                <div class="info-group"><span class="label">이름</span><span class="value"><%= loginUser.getMemberName() %></span></div>
                <div class="info-group"><span class="label">이메일</span><span class="value"><%= loginUser.getEmail() %></span></div>
                <div class="info-group"><span class="label">연락처</span><span class="value"><%= loginUser.getTel() != null ? loginUser.getTel() : "미입력" %></span></div>
<<<<<<< HEAD
                
                <!-- 주소 정보 추가 -->
                <div class="info-group">
                    <span class="label">주소</span>
                    <span class="value">
                        <% if(loginUser.getZip() != null && !loginUser.getZip().isEmpty()) { %>
                            [<%= loginUser.getZip() %>] <%= loginUser.getAddr1() %> <%= loginUser.getAddr2() %>
                        <% } else { %>
                            미입력
                        <% } %>
                    </span>
                </div>
                
                <!-- 회원 등급 추가 -->
                <div class="info-group">
                    <span class="label">회원 등급</span>
                    <span class="value" style="<%= loginUser.getMemberType() == 2 ? "color: #d4af37; font-weight: bold;" : "" %>">
                        <%= loginUser.getMemberType() == 2 ? "VIP 회원" : "일반 회원" %>
                    </span>
                </div>
                
                <div class="info-group"><span class="label">보유 마일리지</span><span class="value"><%= df.format(loginUser.getMileage()) %> P</span></div>
                <button id="showUpdateFormBtn" onclick="showUpdateForm()">정보수정</button>
                
                <form id="updateForm" class="form-section" action="updateMember.jsp" method="post">
                    <div class="info-group">
                        <label for="updateName" class="label">이름</label>
                        <input type="text" id="updateName" name="updateName" value="<%= loginUser.getMemberName() %>" required>
                    </div>
                    <div class="info-group">
                        <label for="updateEmail" class="label">이메일</label>
                        <input type="email" id="updateEmail" name="updateEmail" value="<%= loginUser.getEmail() %>" required>
                    </div>
                    <div class="info-group">
                        <label for="updateTel" class="label">연락처</label>
                        <input type="tel" id="updateTel" name="updateTel" value="<%= loginUser.getTel() != null ? loginUser.getTel() : "" %>">
                    </div>
                    
                    <!-- 주소 수정 추가 -->
                    <div class="info-group">
                        <label class="label">주소</label>
                        <div>
                            <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                                <input type="text" id="updateZip" name="updateZip" 
                                       value="<%= loginUser.getZip() != null ? loginUser.getZip() : "" %>" 
                                       placeholder="우편번호" readonly style="width: 120px;">
                                <button type="button" onclick="execDaumPostcode()" 
                                        style="padding: 10px 15px; background: #555; color: white; 
                                               border: none; border-radius: 5px; cursor: pointer;">
                                    주소 검색
                                </button>
                            </div>
                            <input type="text" id="updateAddr1" name="updateAddr1" 
                                   value="<%= loginUser.getAddr1() != null ? loginUser.getAddr1() : "" %>" 
                                   placeholder="기본 주소" readonly style="width: 100%; margin-bottom: 10px;">
                            <input type="text" id="updateAddr2" name="updateAddr2" 
                                   value="<%= loginUser.getAddr2() != null ? loginUser.getAddr2() : "" %>" 
                                   placeholder="상세 주소" style="width: 100%;">
                        </div>
                    </div>
                    
                    <button id="updateBtn">수정완료</button>
                </form>
                
                <!-- 비밀번호 변경 버튼 추가 -->
                <div style="margin-top: 10px;">
                    <button onclick="location.href='changePwdForm.jsp'" 
                            style="padding: 10px 20px; background-color: #555; color: white; 
                                   border: none; border-radius: 5px; cursor: pointer;">
                        비밀번호 변경
                    </button>
                </div>
                
=======
                <div class="info-group"><span class="label">보유 마일리지</span><span class="value"><%= df.format(loginUser.getMileage()) %> P</span></div>
                <button id="showUpdateFormBtn" onclick="showUpdateForm()">정보수정</button>
                <form id="updateForm" class="form-section" action="updateMember.jsp" method="post">
                    <div class="info-group"><label for="updateName" class="label">이름</label><input type="text" id="updateName" name="updateName" value="<%= loginUser.getMemberName() %>" required></div>
                    <div class="info-group"><label for="updateEmail" class="label">이메일</label><input type="email" id="updateEmail" name="updateEmail" value="<%= loginUser.getEmail() %>" required></div>
                    <div class="info-group"><label for="updateTel" class="label">연락처</label><input type="tel" id="updateTel" name="updateTel" value="<%= loginUser.getTel() != null ? loginUser.getTel() : "" %>"></div>
                    <button id="updateBtn">수정완료</button>
                </form>
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
                <div class="mileage-section">
                     <div class="info-group charge-btn-wrapper">
                         <label class="label">마일리지 충전</label>
                         <a href="chargeForm.jsp">충전하기</a>
                     </div>
                </div>
            </div>
        </div>
<<<<<<< HEAD
        
=======
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
        <div class="section">
            <h2 class="section-title">내가 등록한 상품</h2>
            <div class="product-list">
                <% if(myProducts.isEmpty()) { %>
                    <div class="empty-message"><p>등록한 상품이 없습니다.</p></div>
                <% } else { %>
                    <% for(ProductDTO p : myProducts) { %>
                        <div class="product-card">
                            <a href="<%= request.getContextPath() %>/product/productDetail.jsp?productId=<%= p.getProductId() %>" class="product-card-link">
                                <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" alt="<%= p.getProductName() %>">
                                <div class="product-info">
                                    <h3><%= p.getProductName() %></h3>
                                    <p class="price">현재가: ₩ <%= df.format(p.getCurrentPrice()) %></p>
                                </div>
                            </a>
                            <button class="delete-btn" onclick="deleteProduct(<%= p.getProductId() %>);">&times;</button>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
        
<<<<<<< HEAD
=======
        <!-- ========================================================= -->
        <!-- 새로 추가된 '내가 낙찰받은 상품' 섹션                      -->
        <!-- ========================================================= -->
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
        <div class="section">
            <h2 class="section-title">내가 낙찰받은 상품</h2>
            <div class="product-list">
                 <% if(myWonProducts.isEmpty()) { %>
                    <div class="empty-message"><p>낙찰받은 상품이 없습니다.</p></div>
                 <% } else { %>
                    <% for(ProductDTO p : myWonProducts) { %>
                        <a href="<%= request.getContextPath() %>/product/productDetail.jsp?productId=<%= p.getProductId() %>">
                             <div class="product-card">
                                <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" alt="<%= p.getProductName() %>">
                                <div class="product-info">
                                    <h3><%= p.getProductName() %></h3>
                                    <p class="price">낙찰가: ₩ <%= df.format(p.getFinalPrice()) %></p>
                                    <% if(p.getStatus().equals("E")) { %>
                                        <p class="status" style="color: #ff6b6b;">결제 대기중</p>
                                    <% } else if(p.getStatus().equals("P")) { %>
                                        <p class="status" style="color: #28a745;">결제 완료</p>
                                    <% } %>
                                </div>
                            </div>
                        </a>
                    <% } %>
                 <% } %>
            </div>
        </div>

        <div class="section">
            <h2 class="section-title">내가 입찰한 상품</h2>
            <div class="product-list">
                 <% if(myBids.isEmpty()) { %>
                    <div class="empty-message"><p>입찰한 상품이 없습니다.</p></div>
                 <% } else { %>
                    <% for(ProductDTO p : myBids) { %>
                        <a href="<%= request.getContextPath() %>/product/productDetail.jsp?productId=<%= p.getProductId() %>">
                             <div class="product-card">
                                <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" alt="<%= p.getProductName() %>">
                                <div class="product-info">
                                    <h3><%= p.getProductName() %></h3>
                                    <p class="price">현재가: ₩ <%= df.format(p.getCurrentPrice()) %></p>
                                </div>
                            </div>
                        </a>
                    <% } %>
                 <% } %>
            </div>
        </div>
    </div>
<<<<<<< HEAD
    
    <footer class="footer">
        <p>&copy; 2025 Art Auction. All Rights Reserved.</p>
    </footer>
    
=======
    <footer class="footer">
        <p>&copy; 2025 Art Auction. All Rights Reserved.</p>
    </footer>
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
    <script>
        function showUpdateForm() {
            document.getElementById('updateForm').style.display = 'block';
            document.getElementById('showUpdateFormBtn').style.display = 'none';
        }
<<<<<<< HEAD
        
=======
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
        function deleteProduct(productId) {
            if(confirm("해당 상품을 정말로 삭제하시겠습니까?")){
                location.href = "deleteProduct.jsp?productId=" + productId;
            }
        }
<<<<<<< HEAD
        
        // 주소 검색 함수
        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    document.getElementById('updateZip').value = data.zonecode;
                    document.getElementById('updateAddr1').value = data.roadAddress;
                    document.getElementById('updateAddr2').focus();
                }
            }).open();
        }
    </script>
</body>
</html>
=======
    </script>
</body>
</html>
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
