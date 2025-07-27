<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

        // JOIN refund_requests with bookings to get full info
        String sql = "SELECT rr.request_id, rr.booking_id, rr.request_date, rr.status, b.user_email, b.total_amount " +
                     "FROM refund_requests rr " +
                     "JOIN bookings b ON rr.booking_id = b.booking_id " +
                     "ORDER BY rr.request_date DESC";

        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
%>

<html>
<head>
    <title>Manage Refunds</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
            padding: 30px;
        }

        h2 {
            text-align: center;
            color: #0984e3;
        }

        table {
            width: 100%;
            background: #fff;
            border-collapse: collapse;
            margin-top: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background: #00b894;
            color: #fff;
        }

        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
        }

        .approve {
            background-color: #55efc4;
        }

        .reject {
            background-color: #fab1a0;
        }
    </style>
</head>
<body>
    <h2>Refund Requests</h2>
    <table>
        <tr>
            <th>Request ID</th>
            <th>User Email</th>
            <th>Booking ID</th>
            <th>Amount</th>
            <th>Request Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <%
            while (rs.next()) {
                int requestId = rs.getInt("request_id");
                String userEmail = rs.getString("user_email");
                int bookingId = rs.getInt("booking_id");
                double amount = rs.getDouble("total_amount");
                String requestDate = rs.getString("request_date");
                String status = rs.getString("status");
        %>
        <tr>
            <td><%= requestId %></td>
            <td><%= userEmail %></td>
            <td><%= bookingId %></td>
            <td>₹<%= String.format("%.2f", amount) %></td>
            <td><%= requestDate %></td>
            <td><%= status %></td>
            <td>
                <form action="update_refund_status.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="id" value="<%= requestId %>">
                    <button class="btn approve" name="action" value="Approved">Approve</button>
                    <button class="btn reject" name="action" value="Rejected">Reject</button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>
