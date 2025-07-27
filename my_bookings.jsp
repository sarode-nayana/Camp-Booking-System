<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("role");

    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean isAdmin = "admin".equals(role);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Bookings & Refund Status</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f9fafb;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 25px;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 12px;
            background: white;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        thead tr {
            background: #2980b9;
            color: white;
            text-transform: uppercase;
            font-weight: 600;
            font-size: 0.9rem;
        }
        th, td {
            padding: 14px 20px;
            text-align: center;
        }
        tbody tr {
            background: #fff;
            border-bottom: 12px solid #f9fafb;
            transition: background 0.3s ease;
        }
        tbody tr:hover {
            background: #e3f2fd;
        }
        @media (max-width: 800px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }
            thead tr {
                display: none;
            }
            tbody tr {
                margin-bottom: 20px;
                border-bottom: 1px solid #ddd;
                padding-bottom: 10px;
            }
            tbody tr td {
                text-align: right;
                padding-left: 50%;
                position: relative;
            }
            tbody tr td::before {
                content: attr(data-label);
                position: absolute;
                left: 15px;
                width: 45%;
                padding-left: 10px;
                font-weight: 700;
                text-align: left;
                color: #555;
            }
        }
    </style>
</head>
<body>
    <h2><%= isAdmin ? "All Bookings and Refund Status" : "My Bookings and Refund Status" %></h2>
    <table>
        <thead>
            <tr>
                <% if (isAdmin) { %>
                    <th>User Email</th>
                    <th>Booking ID</th>
                <% } %>
                <th>Location</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Booking Status</th>
                <th>Refund Request Status</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                String sql;
                PreparedStatement ps;

                if (isAdmin) {
                    sql = "SELECT b.booking_id, b.user_email, b.location, b.check_in, b.check_out, b.booking_status, rr.status AS refund_request_status " +
                          "FROM bookings b LEFT JOIN refund_requests rr ON b.booking_id = rr.booking_id";
                    ps = con.prepareStatement(sql);
                } else {
                    sql = "SELECT b.booking_id, b.location, b.check_in, b.check_out, b.booking_status, rr.status AS refund_request_status " +
                          "FROM bookings b LEFT JOIN refund_requests rr ON b.booking_id = rr.booking_id " +
                          "WHERE b.user_email = ?";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, userEmail);
                }

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int bookingId = rs.getInt("booking_id");
                    String location = rs.getString("location");
                    Timestamp checkIn = rs.getTimestamp("check_in");
                    Timestamp checkOut = rs.getTimestamp("check_out");
                    String bookingStatus = rs.getString("booking_status");
                    String refundRequestStatus = rs.getString("refund_request_status");
                    if (refundRequestStatus == null) refundRequestStatus = "No Request";
        %>
            <tr>
                <% if (isAdmin) { %>
                    <td data-label="User Email"><%= rs.getString("user_email") %></td>
                    <td data-label="Booking ID"><%= bookingId %></td>
                <% } %>
                <td data-label="Location"><%= location %></td>
                <td data-label="Check-in"><%= checkIn %></td>
                <td data-label="Check-out"><%= checkOut %></td>
                <td data-label="Booking Status"><%= bookingStatus %></td>
                <td data-label="Refund Request Status"><%= refundRequestStatus %></td>
            </tr>
        <%
                }

                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
        %>
            <tr>
                <td colspan="7" style="color: red; text-align: center;">Error: <%= e.getMessage() %></td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
</body>
</html>
