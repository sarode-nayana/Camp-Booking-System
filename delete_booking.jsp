<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String bookingId = request.getParameter("booking_id");
    String message = "";

    // Process the deletion
    if (bookingId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

            PreparedStatement pst = conn.prepareStatement("DELETE FROM bookings WHERE booking_id=?");
            pst.setInt(1, Integer.parseInt(bookingId));
            int rows = pst.executeUpdate();

            if (rows > 0) {
                message = "Booking deleted successfully!";
            } else {
                message = "Booking deletion failed!";
            }

            conn.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    } else {
        message = "Booking ID not found!";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Booking</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f5f5;
            padding: 30px;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
        }

        .message {
            text-align: center;
            font-weight: bold;
            color: green;
            margin-top: 15px;
        }

        .back {
            text-align: center;
            margin-top: 20px;
        }

        .back a {
            text-decoration: none;
            color: #2980b9;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Delete Booking</h2>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <div class="back">
        <a href="view_bookings.jsp">← Back to Bookings</a>
    </div>
</div>
</body>
</html>
