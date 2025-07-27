<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String bookingId = request.getParameter("booking_id");
    String message = "";

    // Process form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("user_email");
        String location = request.getParameter("location");
        String date = request.getParameter("booking_date");
        int persons = Integer.parseInt(request.getParameter("total_persons"));
        int price = Integer.parseInt(request.getParameter("price_per_person"));
        String status = request.getParameter("booking_status");
        String checkInStr = request.getParameter("check_in");
        String checkOutStr = request.getParameter("check_out");
        int total = persons * price;

        try {
            Timestamp checkIn = Timestamp.valueOf(checkInStr.replace("T", " ") + ":00");
            Timestamp checkOut = Timestamp.valueOf(checkOutStr.replace("T", " ") + ":00");

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

            PreparedStatement pst = conn.prepareStatement(
                "UPDATE bookings SET user_email=?, location=?, booking_date=?, total_persons=?, price_per_person=?, total_amount=?, booking_status=?, check_in=?, check_out=? WHERE booking_id=?"
            );

            pst.setString(1, email);
            pst.setString(2, location);
            pst.setString(3, date);
            pst.setInt(4, persons);
            pst.setInt(5, price);
            pst.setInt(6, total);
            pst.setString(7, status);
            pst.setTimestamp(8, checkIn);
            pst.setTimestamp(9, checkOut);
            pst.setInt(10, Integer.parseInt(bookingId));

            int rows = pst.executeUpdate();
            if (rows > 0) {
                message = "Booking updated successfully!";
            } else {
                message = "Booking update failed!";
            }

            conn.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }

    // Fetch booking details
    String email = "", location = "", date = "", status = "";
    int persons = 0, price = 0;
    String checkInStr = "", checkOutStr = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

        PreparedStatement pst = conn.prepareStatement("SELECT * FROM bookings WHERE booking_id=?");
        pst.setInt(1, Integer.parseInt(bookingId));
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            email = rs.getString("user_email");
            location = rs.getString("location");
            date = rs.getString("booking_date");
            persons = rs.getInt("total_persons");
            price = rs.getInt("price_per_person");
            status = rs.getString("booking_status");

            Timestamp checkIn = rs.getTimestamp("check_in");
            Timestamp checkOut = rs.getTimestamp("check_out");

            if (checkIn != null) {
                checkInStr = checkIn.toLocalDateTime().toString().substring(0, 16);
            }
            if (checkOut != null) {
                checkOutStr = checkOut.toLocalDateTime().toString().substring(0, 16);
            }
        }

        conn.close();
    } catch (Exception e) {
        message = "Error fetching booking: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Booking</title>
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

        label {
            font-weight: bold;
            margin-top: 15px;
            display: block;
        }

        input[type="text"],
        input[type="date"],
        input[type="number"],
        input[type="datetime-local"],
        select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        input[type="submit"] {
            margin-top: 20px;
            padding: 12px;
            width: 100%;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #2980b9;
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
    <h2>Edit Booking</h2>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <form method="post">
        <label>User Email:</label>
        <input type="text" name="user_email" value="<%= email %>" required>

        <label>Location:</label>
        <input type="text" name="location" value="<%= location %>" required>

        <label>Booking Date:</label>
        <input type="date" name="booking_date" value="<%= date %>" required>

        <label>Check-in:</label>
        <input type="datetime-local" name="check_in" value="<%= checkInStr %>" required>

        <label>Check-out:</label>
        <input type="datetime-local" name="check_out" value="<%= checkOutStr %>" required>

        <label>Total Persons:</label>
        <input type="number" name="total_persons" value="<%= persons %>" min="1" required>

        <label>Price per Person (₹):</label>
        <input type="number" name="price_per_person" value="<%= price %>" min="0" required>

        <label>Booking Status:</label>
        <select name="booking_status" required>
            <option value="Confirmed" <%= "Confirmed".equals(status) ? "selected" : "" %>>Confirmed</option>
            <option value="Cancelled" <%= "Cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
            <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
        </select>

        <input type="submit" value="Update Booking">
    </form>

    <div class="back">
        <a href="view_bookings.jsp">← Back to Bookings</a>
    </div>
</div>
</body>
</html>
