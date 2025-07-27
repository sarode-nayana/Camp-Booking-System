<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard - View All Bookings</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #eef2f7;
            margin: 0; padding: 20px;
            color: #2c3e50;
        }
        .container {
            max-width: 1500px;
            margin: 0 auto;
            background: white;
            padding: 25px 35px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgb(0 0 0 / 0.1);
            overflow-x: auto;
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
            color: #34495e;
        }
        .nav {
            margin-bottom: 25px;
            text-align: center;
        }
        .nav a {
            text-decoration: none;
            color: #2980b9;
            font-weight: 600;
            font-size: 16px;
            border-bottom: 2px solid transparent;
            padding-bottom: 3px;
            transition: border-color 0.3s;
        }
        .nav a:hover {
            border-color: #2980b9;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
            min-width: 1200px;
        }
        thead {
            background-color: #3498db;
            color: white;
        }
        th, td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }
        tbody tr:nth-child(even) {
            background-color: #f8faff;
        }
        tbody tr:hover {
            background-color: #d6e9ff;
        }

        .actions a {
            display: inline-block;
            margin: 0 5px;
            padding: 6px 12px;
            border-radius: 5px;
            font-size: 13px;
            font-weight: 600;
            color: white;
            text-decoration: none;
            transition: background-color 0.3s ease;
            user-select: none;
            cursor: pointer;
        }
        .actions .edit-btn {
            background-color: #27ae60;
        }
        .actions .edit-btn:hover {
            background-color: #1e8449;
        }
        .actions .delete-btn {
            background-color: #e74c3c;
        }
        .actions .delete-btn:hover {
            background-color: #b03025;
        }

        /* Status badges */
        .badge {
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 700;
            color: white;
            display: inline-block;
            min-width: 80px;
        }
        .confirmed { background-color: #27ae60; }
        .pending   { background-color: #f39c12; }
        .cancelled { background-color: #e74c3c; }
        .paid      { background-color: #2980b9; }
        .unpaid    { background-color: #c0392b; }
        .refunded  { background-color: #8e44ad; }
        .not-refunded { background-color: #7f8c8d; }

        /* Tooltip for long text */
        .tooltip {
            position: relative;
            cursor: default;
        }
        .tooltip:hover::after {
            content: attr(data-tooltip);
            position: absolute;
            top: 120%;
            left: 50%;
            transform: translateX(-50%);
            background: #2c3e50cc;
            color: white;
            padding: 5px 8px;
            border-radius: 5px;
            white-space: normal;
            width: 200px;
            z-index: 10;
            box-shadow: 0 0 10px #0005;
        }

        /* Responsive */
        @media (max-width: 1100px) {
            table {
                font-size: 12px;
                min-width: 1000px;
            }
            th, td {
                padding: 8px 10px;
            }
        }
        @media (max-width: 700px) {
            table {
                min-width: 700px;
                font-size: 11px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>All Bookings (Latest First)</h1>
    <%
    String msg = request.getParameter("msg");
    if (msg != null) {
%>
    <div style="text-align:center; color:green; font-weight:600; margin-bottom:20px;">
        <%= msg %>
    </div>
<%
    }
%>

    <div class="nav">
        <a href="dashboard.jsp">← Back to Dashboard</a>
    </div>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>User Email</th>
                <th>Mobile</th>
                <th>Location</th>
                <th>Booking Date</th>
                <th>Persons' Names</th>
                <th>Persons</th>
                <th>Per-Person-Price</th>
                <th>Total Amount</th>
                <th>Days</th>
                <th>Booking Status</th>
                <th>Payment Status</th>
               
                <th>Check In</th>
                <th>Check Out</th>
               
              
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            SimpleDateFormat createdFormat = new SimpleDateFormat("dd MMM yyyy HH:mm");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM bookings ORDER BY booking_id DESC");

                while(rs.next()) {
                    int bookingId = rs.getInt("booking_id");
                    String userEmail = rs.getString("user_email");
                    String mobileNo = rs.getString("mobileno");
                    String location = rs.getString("location");
                   

                    java.sql.Date bookingDate = rs.getDate("booking_date");
                     //Timestamp createdAt = rs.getTimestamp("created_at");
                    //Timestamp createdAt = rs.getTimestamp("created_at");
                    String personsName = rs.getString("persons_name");
                    int totalPersons = rs.getInt("total_persons");
                    int pricePerPerson = rs.getInt("price_per_person");
                    int totalAmount = rs.getInt("total_amount");
                    String bookingStatus = rs.getString("booking_status");
                    String paymentStatus = rs.getString("payment_status");
                    String refundStatus = rs.getString("refund_status");
                    Timestamp checkIn = rs.getTimestamp("check_in");
                    Timestamp checkOut = rs.getTimestamp("check_out");
                    int days = rs.getInt("days");
                    

                    // Clean up data for display
                    String mobileDisplay = (mobileNo != null && !mobileNo.trim().isEmpty()) ? mobileNo : "-";
                    String personsDisplay = (personsName != null && personsName.length() > 25) ? 
                        personsName.substring(0, 25) + "..." : (personsName != null ? personsName : "-");

                    // Status badge classes
                    String bookingBadgeClass = "badge confirmed";
                    if (bookingStatus != null) {
                        switch (bookingStatus.toLowerCase()) {
                            case "confirmed": bookingBadgeClass = "badge confirmed"; break;
                            case "pending": bookingBadgeClass = "badge pending"; break;
                            case "cancelled": bookingBadgeClass = "badge cancelled"; break;
                            default: bookingBadgeClass = "badge"; break;
                        }
                    }
                    String paymentBadgeClass = "badge unpaid";
                    if (paymentStatus != null) {
                        if(paymentStatus.equalsIgnoreCase("paid")) paymentBadgeClass = "badge paid";
                        else paymentBadgeClass = "badge unpaid";
                    }
                    String refundBadgeClass = "badge not-refunded";
                    if (refundStatus != null) {
                        if(refundStatus.equalsIgnoreCase("refunded")) refundBadgeClass = "badge refunded";
                        else refundBadgeClass = "badge not-refunded";
                    }
        %>
            <tr>
                <td><%= bookingId %></td>
                <td><%= userEmail != null ? userEmail : "-" %></td>
                <td><%= mobileDisplay %></td>
                <td><%= location != null ? location : "-" %></td>
                <td><%= bookingDate != null ? dateFormat.format(bookingDate) : "-" %></td> 
               
                <td class="tooltip" data-tooltip="<%= personsName != null ? personsName : '-' %>"><%= personsDisplay %></td>
                <td><%= totalPersons %></td>
                <td>₹<%= pricePerPerson %></td>
                <td>₹<%= totalAmount %></td>
                <td><%= days > 0 ? days : "-" %></td>
                <td><span class="<%= bookingBadgeClass %>"><%= bookingStatus != null ? bookingStatus : "-" %></span></td>
                <td><span class="<%= paymentBadgeClass %>"><%= paymentStatus != null ? paymentStatus : "-" %></span></td>

                <td><%= checkIn != null ? datetimeFormat.format(checkIn) : "-" %></td>
                <td><%= checkOut != null ? datetimeFormat.format(checkOut) : "-" %></td>
                
               
                <td class="actions">
                    <a href="edit_booking.jsp?booking_id=<%= bookingId %>" class="edit-btn" title="Edit Booking">Edit</a>
                    <a href="delete_booking.jsp?booking_id=<%= bookingId %>" class="delete-btn" title="Delete Booking" onclick="return confirm('Are you sure you want to delete this booking?');">Delete</a>


                   

                </td>
            </tr>
        <%
                }
            } catch(Exception e) {
        %>
            <tr><td colspan="18" style="color: red; font-weight: 700;">Error loading bookings: <%= e.getMessage() %></td></tr>
        <%
            } finally {
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(conn != null) conn.close();
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
