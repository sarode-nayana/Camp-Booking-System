<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Status | Pawna Lake Camping</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f8fa;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #3498db;
            color: white;
            text-align: center;
            padding: 20px 0;
            border-radius: 0 0 10px 10px;
        }
        .container {
            max-width: 1000px;
            margin: 40px auto;
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        h2, h3 {
            text-align: center;
            color: #2c3e50;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 14px;
            text-align: center;
        }
        th {
            background-color: #3498db;
            color: white;
        }
        .status-paid {
            color: green;
            font-weight: bold;
        }
        .status-unpaid {
            color: red;
            font-weight: bold;
        }
        .status-refunded {
            color: #e67e22;
            font-weight: bold;
        }
        .no-bookings {
            text-align: center;
            color: #999;
            font-style: italic;
            padding: 20px;
        }
    </style>
</head>
<body>

<div class="header">
    <h2>Payment Status</h2>
</div>

<div class="container">
    <h3>Welcome, <%= email %></h3>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

            PreparedStatement ps = con.prepareStatement("SELECT * FROM bookings WHERE user_email = ?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            boolean hasData = false;
    %>

    <table>
        <tr>
            <th>Booking ID</th>
            <th>Booking Date</th>
            <th>Amount</th>
            <th>Status</th>
            <th>Payment</th>
        </tr>

        <%
            while (rs.next()) {
                hasData = true;
                String status = rs.getString("booking_status");
                String paymentStatus = rs.getString("payment_status"); // column: 'Paid', 'Unpaid', 'Refunded'
        %>
        <tr>
            <td><%= rs.getInt("booking_id") %></td>
            <td><%= rs.getDate("booking_date") %></td>
            <td>₹<%= rs.getInt("total_amount") %></td>
            <td><%= status %></td>
            <td>
                <% if ("Paid".equalsIgnoreCase(paymentStatus)) { %>
                    <span class="status-paid">Paid</span>
                <% } else if ("Refunded".equalsIgnoreCase(paymentStatus)) { %>
                    <span class="status-refunded">Refunded</span>
                <% } else { %>
                    <span class="status-unpaid">Unpaid</span>
                <% } %>
            </td>
        </tr>
        <%
            }
            if (!hasData) {
        %>
            <tr>
                <td colspan="5" class="no-bookings">No payment records found.</td>
            </tr>
        <%
            }

            rs.close();
            ps.close();
            con.close();
        } catch(Exception e) {
        %>
            <p style="color:red; text-align:center;">Error: <%= e.getMessage() %></p>
        <%
        }
    %>
    </table>
</div>

</body>
</html>
