<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Reports | Pawna Lake Camping</title>
    <style>
        /* Global styles */
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            color: #333;
        }

        .container {
            width: 80%;
            margin: 30px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Header styles */
        .report-header {
            text-align: center;
            color: #2c3e50;
            font-size: 28px;
            margin-bottom: 20px;
        }

        /* Table styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table th, table td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: left;
        }

        table th {
            background-color: #3498db;
            color: white;
        }

        table td {
            background-color: #ecf0f1;
        }

        table tr:hover {
            background-color: #f1f1f1;
        }

        /* Error message styling */
        .error {
            color: red;
            font-weight: bold;
            text-align: center;
            margin: 20px 0;
        }

        /* Button styles */
        .back-btn {
            display: inline-block;
            text-align: center;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            margin-top: 20px;
        }

        .back-btn:hover {
            background-color: #2980b9;
        }

    </style>
</head>
<body>

<div class="container">
    <h2 class="report-header">Generate Reports</h2>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping?useUnicode=true&characterEncoding=UTF-8", "root", "root");
            stmt = con.createStatement();
            
            // Query updated to use correct column names from the 'bookings' table
            rs = stmt.executeQuery("SELECT * FROM bookings ORDER BY booking_date DESC");
            
            if (!rs.next()) {
    %>
                <p class="error">No records found to generate a report.</p>
    <%
            } else {
    %>

    <table class="report-table">
        <tr>
            <th>Booking ID</th>
            <th>User Email</th>
            <th>Booking Date</th>
            <th>Total Amount</th>
            <th>Status</th>
        </tr>

    <%
                do {
    %>
        <tr>
            <td><%= rs.getInt("booking_id") %></td>
            <td><%= rs.getString("user_email") %></td>
            <td><%= rs.getDate("booking_date") %></td>
            <td>₹<%= rs.getInt("total_amount") %></td>
            <td><%= rs.getString("booking_status") %></td>
        </tr>
    <%
                } while (rs.next());
            }
        } catch (Exception e) {
    %>
        <p class="error">Error loading report: <%= e.getMessage() %></p>
    <%
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    %>

    </table>

    <a href="admin_dashboard.jsp" class="back-btn">Back to Dashboard</a>
</div>

</body>
</html>
