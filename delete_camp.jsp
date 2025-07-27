<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    // Check admin role
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String campId = request.getParameter("id");

    if (campId == null || campId.trim().isEmpty()) {
        // No ID provided, redirect back with error or silently
        response.sendRedirect("view_camps.jsp");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root")) {
            PreparedStatement pst = con.prepareStatement("DELETE FROM camp_packages WHERE id = ?");
            pst.setInt(1, Integer.parseInt(campId));
            int deleted = pst.executeUpdate();
            pst.close();
        }
    } catch (Exception e) {
        // Log error (you can print stack trace or set message)
        // For now, just redirect
        response.sendRedirect("view_camps.jsp");
        return;
    }

    // After deletion redirect to camp list page
    response.sendRedirect("manage_camps.jsp");
%>
