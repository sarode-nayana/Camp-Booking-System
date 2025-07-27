<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
<html>
<head>
    <meta charset="UTF-8">
    <title>Payments | Pawna Lake Camping</title>
    <style>


        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 85%;
            margin: 40px auto;
            background-color: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
        }
        th {
            background-color: #2980b9;
            color: #fff;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e1f5fe;
        }
        .back-btn {
            display: inline-block;
            margin-top: 25px;
            padding: 10px 18px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }
        .back-btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Payment Records</h2>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT * FROM payments ORDER BY payment_date DESC");

            if (!rs.isBeforeFirst()) {
    %>
                <p>No payments found.</p>
    <%
            } else {
    %>

    <table>
        <tr>
            <th>Payment ID</th>
            <th>Booking ID</th>
            <th>User Email</th>
            <th>Amount</th>
            <th>Payment Method</th>
            <th>Payment Date</th>
        </tr>

        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("payment_id") %></td>
            <td><%= rs.getInt("booking_id") %></td>
            <td><%= rs.getString("user_email") %></td>
            <td>₹<%= rs.getDouble("amount") %></td>
            <td>&#8377;<%= String.format("%.2f", rs.getDouble("amount")) %></td>

            <td><%= rs.getString("payment_method") %></td>
            <td><%= rs.getTimestamp("payment_date") %></td>
        </tr>
        <%
            }
        %>
    </table>

    <%
            }
        } catch (Exception e) {
            out.println("<p>Error loading payments: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    %>

    <a class="back-btn" href="admin_dashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>
