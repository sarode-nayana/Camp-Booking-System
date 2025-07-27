<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String idParam = request.getParameter("id");
    String message = "";

    if (idParam != null) {
        int userId = Integer.parseInt(idParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

            PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id = ?");
            ps.setInt(1, userId);

            int rowsDeleted = ps.executeUpdate();

            ps.close();
            conn.close();

            if (rowsDeleted > 0) {
                // Redirect with success message
                response.sendRedirect("registered_users.jsp?msg=User deleted successfully!");
            } else {
                // Redirect with failure message
                response.sendRedirect("registered_users.jsp?msg=User not found or already deleted.");
            }
        } catch (Exception e) {
            response.sendRedirect("registered_users.jsp?msg=Error deleting user: " + e.getMessage());
        }
    } else {
        response.sendRedirect("registered_users.jsp?msg=Invalid User ID.");
    }
%>
