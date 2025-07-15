<%-- File: WebContent/product/productEnrollAction.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.File" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }

    Connection conn = null;
    try {
        String savePath = request.getServletContext().getRealPath("/resources/product_images/");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        int maxSize = 10 * 1024 * 1024;
        String encoding = "UTF-8";
        
        MultipartRequest multiRequest = new MultipartRequest(request, savePath, maxSize, encoding, new DefaultFileRenamePolicy());
        
        // 필수 파라미터 검증
        String productName = multiRequest.getParameter("productName");
        String artistName = multiRequest.getParameter("artistName");
        String startPriceStr = multiRequest.getParameter("startPrice");
        String endTimeStr = multiRequest.getParameter("endTime");
        String productDesc = multiRequest.getParameter("productDesc");
        String category = multiRequest.getParameter("category");
        
        if(productName == null || productName.trim().isEmpty() ||
           artistName == null || artistName.trim().isEmpty() ||
           startPriceStr == null || startPriceStr.trim().isEmpty() ||
           endTimeStr == null || endTimeStr.trim().isEmpty() ||
           productDesc == null || productDesc.trim().isEmpty() ||
           category == null || category.trim().isEmpty()) {
            session.setAttribute("alertMsg", "모든 필수 항목을 입력해주세요.");
            response.sendRedirect("productEnrollForm.jsp");
            return;
        }
        
        int startPrice;
        try {
            startPrice = Integer.parseInt(startPriceStr);
            if(startPrice <= 0) {
                session.setAttribute("alertMsg", "시작가는 0보다 큰 값을 입력해주세요.");
                response.sendRedirect("productEnrollForm.jsp");
                return;
            }
        } catch(NumberFormatException e) {
            session.setAttribute("alertMsg", "올바른 시작가를 입력해주세요.");
            response.sendRedirect("productEnrollForm.jsp");
            return;
        }
        
        // 즉시 구매가 처리
        String buyNowPriceStr = multiRequest.getParameter("buyNowPrice");
        int buyNowPrice = 0;
        if(buyNowPriceStr != null && !buyNowPriceStr.trim().isEmpty()) {
            try {
                buyNowPrice = Integer.parseInt(buyNowPriceStr);
                if(buyNowPrice <= startPrice) {
                    session.setAttribute("alertMsg", "즉시구매가는 시작가보다 높아야 합니다.");
                    response.sendRedirect("productEnrollForm.jsp");
                    return;
                }
            } catch(NumberFormatException e) {
                session.setAttribute("alertMsg", "올바른 즉시구매가를 입력해주세요.");
                response.sendRedirect("productEnrollForm.jsp");
                return;
            }
        }
        
        String originalFileName = multiRequest.getOriginalFileName("productImage");
        String renamedFileName = multiRequest.getFilesystemName("productImage");
        
        ProductDTO p = new ProductDTO();
        p.setProductName(productName.trim());
        p.setArtistName(artistName.trim());
        p.setStartPrice(startPrice);
        p.setBuyNowPrice(buyNowPrice);
        p.setProductDesc(productDesc.trim());
        p.setCategory(category.trim());
        p.setImageOriginalName(originalFileName);
        p.setImageRenamedName(renamedFileName);
        p.setSellerId(loginUser.getMemberId());
        
        // 날짜 파싱
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        Date utilDate = sdf.parse(endTimeStr);
        Date now = new Date();
        if(utilDate.before(now)) {
            session.setAttribute("alertMsg", "경매 마감일은 현재 시간 이후로 설정해주세요.");
            response.sendRedirect("productEnrollForm.jsp");
            return;
        }
        p.setEndTime(new Timestamp(utilDate.getTime()));

        conn = getConnection();
        int result = new ProductDAO().insertProduct(conn, p);
        
        if(result > 0) {
            commit(conn);
            session.setAttribute("alertMsg", "상품이 성공적으로 등록되었습니다. 관리자 승인 후 경매가 시작됩니다.");
            response.sendRedirect(request.getContextPath() + "/index.jsp"); 
        } else {
            rollback(conn);
            session.setAttribute("alertMsg", "상품 등록에 실패했습니다.");
            response.sendRedirect("productEnrollForm.jsp");
        }
        
    } catch(Exception e) {
        if(conn != null) rollback(conn);
        e.printStackTrace();
        session.setAttribute("alertMsg", "상품 등록 중 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect("productEnrollForm.jsp");
    } finally {
        if(conn != null) close(conn);
    }
%>
