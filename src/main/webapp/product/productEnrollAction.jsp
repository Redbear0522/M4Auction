<%-- File: WebContent/product/productEnrollAction.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="com.auction.dao.ScheduleDAO" %>
<%@ page import="com.auction.vo.ScheduleDTO" %>
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

    String savePath = request.getServletContext().getRealPath("/resources/product_images/");
    File uploadDir = new File(savePath);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs();
    }
    
    int maxSize = 10 * 1024 * 1024;
    String encoding = "UTF-8";
    
    MultipartRequest multiRequest = new MultipartRequest(request, savePath, maxSize, encoding, new DefaultFileRenamePolicy());
    
    String productName = multiRequest.getParameter("productName");
    String artistName = multiRequest.getParameter("artistName");
    int startPrice = Integer.parseInt(multiRequest.getParameter("startPrice"));
    
    // ======== 즉시 구매가 받아오기 ========
    String buyNowPriceStr = multiRequest.getParameter("buyNowPrice");
    int buyNowPrice = 0;
    // 입력값이 비어있지 않은 경우에만 숫자로 변환
    if(buyNowPriceStr != null && !buyNowPriceStr.equals("")){
        buyNowPrice = Integer.parseInt(buyNowPriceStr);
    }
    
    String endTimeStr = multiRequest.getParameter("endTime");
    String productDesc = multiRequest.getParameter("productDesc");
    String category = multiRequest.getParameter("category");
    
    String originalFileName = multiRequest.getOriginalFileName("productImage");
    String renamedFileName = multiRequest.getFilesystemName("productImage");
    
    ProductDTO p = new ProductDTO();
    p.setProductName(productName);
    p.setArtistName(artistName);
    p.setStartPrice(startPrice);
    p.setBuyNowPrice(buyNowPrice); // Product 객체에 즉시 구매가 담기
    p.setProductDesc(productDesc);
    p.setCategory(category);
    p.setImageOriginalName(originalFileName);
    p.setImageRenamedName(renamedFileName);
    p.setSellerId(loginUser.getMemberId());
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    Date utilDate = sdf.parse(endTimeStr);
    p.setEndTime(new Timestamp(utilDate.getTime()));

    Connection conn = getConnection();
    try {
        // 1. 상품 등록
        int result = new ProductDAO().insertProduct(conn, p);
        
        if(result > 0) {
            // 2. 방금 등록한 상품 ID 가져오기
            int productId = new ProductDAO().selectLastInsertedProductId(conn);
            
            if(productId > 0) {
                // 3. ScheduleDTO 생성, 필요한 값 세팅 (예: 시작시간, 종료시간, 상태)
                ScheduleDTO schedule = new ScheduleDTO();
                schedule.setProductId(productId);
                
                // 예시로 시작시간=현재시간 + 1분, 종료시간=현재시간 + 7일 (필요에 따라 조정)
                long now = System.currentTimeMillis();
                schedule.setStartTime(new java.util.Date(now + 60 * 1000));       // 1분 후
                schedule.setEndTime(new java.util.Date(now + 7 * 24 * 60 * 60 * 1000)); // 7일 후
                
                schedule.setStatus("대기중");
                
                // 4. 스케줄 등록
                int scheduleResult = new ScheduleDAO().insertSchedule(conn, schedule);
                
                if(scheduleResult > 0) {
                    commit(conn);
                    session.setAttribute("alertMsg", "상품과 스케줄이 성공적으로 등록되었습니다.");
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                } else {
                    rollback(conn);
                    session.setAttribute("alertMsg", "상품 등록은 성공했으나 스케줄 등록에 실패했습니다.");
                    response.sendRedirect("productEnrollForm.jsp");
                }
            } else {
                rollback(conn);
                session.setAttribute("alertMsg", "상품 등록 후 상품 ID 조회에 실패했습니다.");
                response.sendRedirect("productEnrollForm.jsp");
            }
        } else {
            rollback(conn);
            session.setAttribute("alertMsg", "상품 등록에 실패했습니다.");
            response.sendRedirect("productEnrollForm.jsp");
        }
    } catch(Exception e) {
        rollback(conn);
        e.printStackTrace();
        session.setAttribute("alertMsg", "예외가 발생했습니다: " + e.getMessage());
        response.sendRedirect("productEnrollForm.jsp");
    } finally {
        close(conn);
    }

%>
