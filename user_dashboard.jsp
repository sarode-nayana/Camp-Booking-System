You said:
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Bookings - Pawna Lake Camping</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            display: flex;
        }
        .sidebar {
            width: 250px;
            height: 100vh;
            background-color: #2f3640;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            left: 0;
        }
        .sidebar-header {
            color: #f5f6fa;
            font-size: 22px;
            text-align: center;
            padding: 20px 0;
            background-color: #353b48;
        }
        .sidebar img {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            margin: 10px auto;
            border: 3px solid white;
        }
        .email {
            color: #dcdde1;
            text-align: center;
            font-size: 14px;
            margin-bottom: 20px;
            word-wrap: break-word;
            padding: 0 10px;
        }
        .sidebar a {
            padding: 15px 25px;
            color: #f5f6fa;
            text-decoration: none;
            display: block;
            transition: 0.3s;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #44bd32;
            color: white;
        }
        .logout {
            margin-top: auto;
        }

        .container {
            margin-left: 270px;
            width: calc(100% - 270px);
            padding: 30px;
        }
        h2 {
            text-align: center;
            color: #2f3640;
            margin-bottom: 10px;
        }
        h3 {
            text-align: center;
            color: #718093;
            margin-bottom: 30px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 14px 12px;
            border: 1px solid #eee;
            text-align: center;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .btn {
            padding: 8px 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            color: white;
            font-weight: bold;
        }
        .cancel-btn {
            background-color: #e74c3c;
        }
        .edit-btn {
            background-color: #3498db;
        }
        .status-paid {
            color: green;
            font-weight: bold;
        }
        .status-unpaid {
            color: green;
            font-weight: bold;
        }
        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: center;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-header">User Dashboard</div>
    <img src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="User">
    <div class="email"><%= userEmail %></div>
    <a href="user_dashboard.jsp">🏠 Dashboard</a>
    <a href="book_camping.jsp">📅 Book Camp</a>
    <a href="my_bookings.jsp" class="active">📖 My Bookings</a>
    <a href="payment_history.jsp">💳 Payment History</a>
    <a href="profile.jsp">👤 Profile</a>
    <a href="change_password.jsp">🔒 Change Password</a>
    <a href="contact_support.jsp">📞 Contact Support</a>
    <a href="payment_refund.jsp">↩️ Refund Request</a>
    <div class="logout">
        <a href="logout.jsp">🚪 Logout</a>
    </div>
</div>

<!-- Main Content -->
<div class="container">
    <h2>Welcome, <%= userEmail %></h2>
    <h3>Your Camping Booking History</h3>

    <table>
        <tr>
            <th>Location</th>
            <th>Price/Person</th>
            <th>Total Persons</th>
            <th>Booking Date</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Total Amount</th>
            <th>Mobile No</th>
            <th>Payment Status</th>
            <th>Actions</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                PreparedStatement ps = con.prepareStatement(
                    "SELECT b.*, p.status AS payment_status, p.payment_mode " +
                    "FROM bookings b LEFT JOIN payments p ON b.booking_id = p.booking_id " +
                    "WHERE b.user_email = ?"
                );
                ps.setString(1, userEmail);
                ResultSet rs = ps.executeQuery();

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm a");
                SimpleDateFormat dateOnly = new SimpleDateFormat("yyyy-MM-dd");

                while (rs.next()) {
                    int bookingId = rs.getInt("booking_id");
                    String location = rs.getString("location");
                    int pricePerPerson = rs.getInt("price_per_person");
                    int totalPersons = rs.getInt("total_persons");
                    Date bookingDate = rs.getDate("booking_date");
                    Timestamp checkIn = rs.getTimestamp("check_in");
                    Timestamp checkOut = rs.getTimestamp("check_out");
                    int totalAmount = rs.getInt("total_amount");
                    String mobile = rs.getString("mobileno");
                    String paymentStatus = rs.getString("payment_status");
                    if (paymentStatus == null) paymentStatus = "Unpaid";
        %>
        <tr>
            <td><%= location %></td>
            <td><%= pricePerPerson %></td>
            <td><%= totalPersons %></td>
            <td><%= bookingDate != null ? dateOnly.format(bookingDate) : "" %></td>
            <td><%= checkIn != null ? sdf.format(checkIn) : "" %></td>
            <td><%= checkOut != null ? sdf.format(checkOut) : "" %></td>
            <td><%= totalAmount %></td>
            <td><%= mobile %></td>
            <td>
                <span class="<%= "Paid".equalsIgnoreCase(paymentStatus) ? "status-paid" : "status-unpaid" %>">
                    <%= paymentStatus %>
                </span>
            </td>
            <td class="action-buttons">
                <form method="post" action="cancel_booking.jsp" style="display:inline;">
                    <input type="hidden" name="booking_id" value="<%= bookingId %>" />
                    <button type="submit" class="btn cancel-btn">Cancel</button>
                </form>
                <form method="get" action="edit_booking.jsp" style="display:inline;">
                    <input type="hidden" name="booking_id" value="<%= bookingId %>" />
                    <button type="submit" class="btn edit-btn">Edit</button>
                </form>
            </td>
        </tr>
        <%
                }
                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
        %>
        <tr>
            <td colspan="10" style="color:red;">Error: <%= e.getMessage() %></td>
        </tr>
        <%
            }
        %>
    </table>
</div>
</body>
</html>