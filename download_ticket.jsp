<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String bookingIdStr = request.getParameter("booking_id");
    int bookingId = 0;

    if (bookingIdStr != null) {
        try {
            bookingId = Integer.parseInt(bookingIdStr);
        } catch (Exception e) {
            out.println("<h3>Invalid Booking ID!</h3>");
            return;
        }
    } else {
        out.println("<h3>Booking ID is missing!</h3>");
        return;
    }

    String location = "", email = "", date = "", status = "", paymentMode = "", mobileno = "";
    int persons = 0, price = 0, totalAmount = 0;
    List<String> personNames = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

        String bookingSQL = "SELECT * FROM bookings WHERE booking_id = ?";
        PreparedStatement ps = con.prepareStatement(bookingSQL);
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            location = rs.getString("location");
            email = rs.getString("user_email");
            mobileno = rs.getString("mobileno");
            date = rs.getString("booking_date");
            persons = rs.getInt("total_persons");
            price = rs.getInt("price_per_person");
            totalAmount = rs.getInt("total_amount");
            status = rs.getString("booking_status");
            paymentMode = rs.getString("payment_status");

            String namesRaw = rs.getString("persons_name");
            if (namesRaw != null && !namesRaw.trim().isEmpty()) {
                String[] namesArray = namesRaw.split(",");
                for (String name : namesArray) {
                    personNames.add(name.trim());
                }
            } else {
                for (int i = 1; i <= persons; i++) {
                    personNames.add("Person " + i);
                }
            }
        } else {
            out.println("<h3>Booking not found!</h3>");
            return;
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
        out.println("<h3>Error fetching booking: " + e.getMessage() + "</h3>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Camping Ticket - Pawna Lake</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: #f4f6f9;
            padding: 30px;
        }
        .ticket-container {
            max-width: 700px;
            margin: auto;
            background: white;
            border-radius: 12px;
            padding: 30px 40px;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
            border-left: 5px solid #2ecc71;
        }
        h2 {
            text-align: center;
            color: #2ecc71;
            margin-bottom: 25px;
        }
        .section {
            margin-bottom: 20px;
        }
        .section p {
            font-size: 15px;
            margin: 8px 0;
        }
        .section p strong {
            color: #2c3e50;
            display: inline-block;
            width: 160px;
        }
        .person-list {
            margin-top: 10px;
            margin-left: 180px;
        }
        .person-list li {
            font-size: 15px;
            margin-bottom: 5px;
        }
        .btn-group {
            text-align: center;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 22px;
            font-size: 15px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            margin: 0 10px;
        }
        .btn:hover {
            background: #2980b9;
        }

        @media print {
            .btn-group { display: none; }
            body { background: white; padding: 0; }
            .ticket-container { box-shadow: none; border: none; }
        }
    </style>
</head>
<body>

<div class="ticket-container">
    <h2>🎫 Camping Ticket</h2>

    <div class="section">
        <p><strong>Booking ID :</strong> <%= bookingId %></p>
        <p><strong>Location :</strong> <%= location %></p>
        <p><strong>Email :</strong> <%= email %></p>
        <p><strong>Mobile No :</strong> <%= mobileno %></p>
        <p><strong>Booking Date :</strong> <%= date %></p>
        <p><strong>Payment Method :</strong> <%= paymentMode %></p>
        <p><strong>Booking Status :</strong> <%= status %></p>
   
        <p><strong>Price per Person :</strong> ₹<%= price %></p>
        <p><strong>Total Amount :</strong> ₹<%= totalAmount %></p>
        <p><strong>Total Persons :</strong> <%= persons %></p>
        <p><strong>Person Name :</strong></p>
        <ul class="person-list">
            <% for (String pname : personNames) { %>
                <li><%= pname %></li>
            <% } %>
        </ul>
    </div>

    <div class="btn-group">
        <button class="btn" onclick="window.print()">🖨️ Print Ticket</button>
        <a href="user_dashboard.jsp" class="btn">🏠 Back to Dashboard</a>
    </div>
</div>

</body>
</html>
