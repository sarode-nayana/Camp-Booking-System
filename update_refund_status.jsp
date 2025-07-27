<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    String action = request.getParameter("action");

    if (idStr != null && action != null && (action.equals("Approved") || action.equals("Rejected"))) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            int requestId = Integer.parseInt(idStr);
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

            String sql = "UPDATE refund_requests SET status = ? WHERE request_id = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, action);
            ps.setInt(2, requestId);
            int updated = ps.executeUpdate();

            if (updated > 0) {
                // Optional: success message to session or request
                response.sendRedirect("manage_refunds.jsp");
            } else {
                out.println("Update failed. Invalid request ID.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }
    } else {
        out.println("Invalid input or action.");
    }
%>
