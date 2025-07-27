<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Payment Records - Admin Dashboard</title>
    <style>
        /* Reset and base */
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #74ebd5 0%, #ACB6E5 100%);
            margin: 0; padding: 20px;
            color: #333;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #0b486b;
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }
        .table-container {
            max-width: 1200px;
            margin: 0 auto 40px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            min-width: 700px;
        }
        thead th {
            background-color: #0b486b;
            color: white;
            padding: 15px 10px;
            text-align: center;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1;
            box-shadow: inset 0 -3px 5px rgba(0,0,0,0.15);
        }
        tbody td {
            padding: 12px 10px;
            border-bottom: 1px solid #ddd;
            text-align: center;
            vertical-align: middle;
        }
        tbody tr:nth-child(even) {
            background: #f9fafd;
        }
        tbody tr:hover {
            background-color: #d9e6f2;
            cursor: default;
            transition: background-color 0.3s ease;
        }

        /* Status color codes */
        .status-pending {
            color: #d97e00;  /* Orange */
            font-weight: 600;
        }
        .status-completed {
            color: #228B22;  /* Forest Green */
            font-weight: 700;
        }
        .status-other {
            color: #a00; /* Red */
            font-weight: 600;
        }

        /* Highlight zero amount rows */
        .zero-amount {
            background-color: #fff8dc; /* Light yellow */
            color: #555;
        }

        .back-btn {
            display: inline-block;
            background-color: #0b486b;
            color: white;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1rem;
            box-shadow: 0 4px 12px rgba(11,72,107,0.4);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
            margin: 0 auto;
            display: block;
            width: max-content;
            user-select: none;
        }
        .back-btn:hover {
            background-color: #074162;
            box-shadow: 0 6px 18px rgba(7,65,98,0.7);
        }
        @media (max-width: 768px) {
            thead th, tbody td {
                padding: 8px 6px;
                font-size: 0.9rem;
            }
            .table-container {
                padding: 15px;
                margin-bottom: 30px;
            }
        }
    </style>
</head>
<body>
    <h2>Payment Records</h2>
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Payment ID</th>
                    <th>User Email</th>
                    <th>Booking ID</th>
                    <th>Amount Paid (₹)</th>
                    <th>Payment Mode</th>
                    <th>Payment Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, HH:mm");
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT payment_id, user_email, booking_id, amount_paid, payment_mode, payment_date, status FROM payments");

                        while(rs.next()) {
                            int paymentId = rs.getInt("payment_id");
                            String userEmail = rs.getString("user_email");
                            int bookingId = rs.getInt("booking_id");
                            double amountPaid = rs.getDouble("amount_paid");
                            String paymentMode = rs.getString("payment_mode");
                            if (paymentMode == null || paymentMode.trim().isEmpty()) paymentMode = "N/A";
                            java.sql.Timestamp paymentDate = rs.getTimestamp("payment_date");
                            String status = rs.getString("status");
                            if (status == null || status.trim().isEmpty()) status = "Pending";

                            // Determine status CSS class
                            String statusClass = "status-other";
                            if ("Completed".equalsIgnoreCase(status)) {
                                statusClass = "status-completed";
                            } else if ("Pending".equalsIgnoreCase(status)) {
                                statusClass = "status-pending";
                            }

                            // Highlight zero amount rows
                            String zeroAmountClass = amountPaid == 0.0 ? "zero-amount" : "";
                %>
                <tr class="<%= zeroAmountClass %>">
                    <td><%= paymentId %></td>
                    <td><%= userEmail %></td>
                    <td><%= bookingId %></td>
                    <td><%= String.format("%.2f", amountPaid) %></td>
                    <td><%= paymentMode %></td>
                    <td><%= paymentDate != null ? sdf.format(paymentDate) : "N/A" %></td>
                    <td class="<%= statusClass %>"><%= status %></td>
                </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                        con.close();
                    } catch(Exception e) {
                %>
                <tr>
                    <td colspan="7" style="color:red; font-weight:bold;">
                        Error fetching payment data: <%= e.getMessage() %>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>
</body>
</html>
