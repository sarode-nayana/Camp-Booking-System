<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    String checkInTimeStr = request.getParameter("check_in_time");  // e.g. "14:00"
    String checkOutTimeStr = request.getParameter("check_out_time"); // e.g. "11:00"

// parse or pass as string to your DAO/db layer

// when preparing SQL INSERT, set check_in_time and check_out_time fields accordingly

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Payment History - Pawna Camping</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #2c974b;
        }
        .no-data {
            text-align: center;
            margin-top: 40px;
            font-size: 18px;
            color: #666;
        }
        table {
            margin: 20px auto;
            width: 90%;
            max-width: 900px;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #2c974b;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        @media screen and (max-width: 768px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }
            thead tr {
                display: none;
            }
            tr {
                margin-bottom: 15px;
            }
            td {
                padding-left: 50%;
                text-align: left;
                position: relative;
            }
            td::before {
                content: attr(data-label);
                position: absolute;
                left: 15px;
                font-weight: bold;
                white-space: nowrap;
            }
        }
    </style>
</head>
<body>

<%
    if (userEmail == null) {
%>
    <div class="no-data">
        You are not logged in. Please <a href="login.jsp">login here</a> to view your payment history.
    </div>
<%
    } else {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

            String sql = "SELECT payment_id, booking_id, amount_paid, payment_mode, payment_date, status FROM payments WHERE user_email = ? ORDER BY payment_date DESC";

            pst = con.prepareStatement(sql);
            pst.setString(1, userEmail);
            rs = pst.executeQuery();

            if (!rs.isBeforeFirst()) {
%>
                <p class="no-data">You have no payment history yet.</p>
<%
            } else {
%>
                <h1>Payment History</h1>
                <table>
                    <thead>
                        <tr>
                            <th>Payment ID</th>
                            <th>Booking ID</th>
                            <th>Amount Paid (₹)</th>
                            <th>Payment Mode</th>
                            <th>Payment Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
<%
                while (rs.next()) {
%>
                    <tr>
                        <td data-label="Payment ID"><%= rs.getInt("payment_id") %></td>
                        <td data-label="Booking ID"><%= rs.getInt("booking_id") %></td>
                        <td data-label="Amount Paid (₹)"><%= String.format("%.2f", rs.getDouble("amount_paid")) %></td>
                        <td data-label="Payment Mode"><%= rs.getString("payment_mode") %></td>
                        <td data-label="Payment Date"><%= rs.getTimestamp("payment_date") %></td>
                        <td data-label="Status"><%= rs.getString("status") %></td>
                    </tr>
<%
                }
%>
                    </tbody>
                </table>
<%
            }
        } catch(Exception e) {
            out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception ignored) {}
            if(pst != null) try { pst.close(); } catch(Exception ignored) {}
            if(con != null) try { con.close(); } catch(Exception ignored) {}
        }
    }
%>

</body>
</html>
