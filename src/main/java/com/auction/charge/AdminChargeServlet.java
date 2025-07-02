package com.auction.charge;

import com.auction.dao.AdminDAO;
import static com.auction.common.JDBCTemplate.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/admin/chargeAction")
public class AdminChargeServlet extends HttpServlet {
	 protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	        // GET 요청도 처리 가능하게 함
	        doPost(req, resp);  // 또는 doGet 로직 따로 작성 가능
	    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reqId = Integer.parseInt(request.getParameter("reqId"));
        String action = request.getParameter("action"); // approve 또는 reject

        Connection conn = getConnection();
        AdminDAO dao = new AdminDAO();
        int result = 0;

        
        
        if("approve".equals(action)) {
            result = dao.approveCharge(conn, reqId);
        } else if("reject".equals(action)) {
            result = dao.rejectCharge(conn, reqId);
        }

        if(result > 0) commit(conn);
        else rollback(conn);

        close(conn);
        response.sendRedirect(request.getContextPath() + "/admin/adminPage.jsp");
    }
}
