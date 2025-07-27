<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String bookingId = request.getParameter("bookingId");
    String email = (String) session.getAttribute("userEmail");

    if (bookingId == null || email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

        String sql = "UPDATE bookings SET booking_status = 'Cancelled' WHERE booking_id = ? AND user_email = ?";
        ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(bookingId));
        ps.setString(2, email);

        int rows = ps.executeUpdate();

        if (rows > 0) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Cancelled</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f8f8f8;
            text-align: center;
            padding-top: 100px;
        }
        .message-box {
            background: #fff;
            padding: 40px;
            margin: auto;
            width: 500px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.15);
        }
        h2 {
            color: #e74c3c;
        }
        a {
            text-decoration: none;
            padding: 10px 20px;
            background: #3498db;
            color: #fff;
            border-radius: 5px;
            margin-top: 20px;
            display: inline-block;
        }
        a:hover {
            background: #2980b9;
        }
    </style>
</head>
<body>
    <div class="message-box">
        <h2>Your booking has been successfully cancelled.</h2>
        <p>Booking ID: <strong><%= bookingId %></strong></p>
        <a href="user_dashboard.jsp">Return to Dashboard</a>
    </div>
</body>
</html>
<%
        } else {
%>
<script>
    alert("Failed to cancel booking. Please try again.");
    window.location.href = "dashboard.jsp";
</script>
<%
        }

    } catch (Exception e) {
        e.printStackTrace();
%>
<script>
    alert("Error occurred: <%= e.getMessage() %>");
    window.location.href = "dashboard.jsp";
</script>
<%
    } finally {
        try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception e) {}
    }
%>
