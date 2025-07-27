<%@ page import="java.sql.*" %>
<%@ page session="true" %>

   <%
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("userEmail");

    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    int totalBookings = 0;
    double totalEarnings = 0;
    int totalCamps = 0;
    int totalRefunds = 0; // Declare here

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

        // Total bookings count
        PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM bookings");
        ResultSet rs1 = ps1.executeQuery();
        if (rs1.next()) totalBookings = rs1.getInt(1);

        // Total earnings from confirmed bookings
        PreparedStatement ps2 = con.prepareStatement("SELECT IFNULL(SUM(total_amount),0) FROM bookings WHERE booking_status = 'Confirmed'");
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next()) totalEarnings = rs2.getDouble(1);

        // Total camps
        PreparedStatement ps3 = con.prepareStatement("SELECT COUNT(*) FROM camp_packages");
        ResultSet rs3 = ps3.executeQuery();
        if (rs3.next()) totalCamps = rs3.getInt(1);

        // ✅ Total refunds
        PreparedStatement ps4 = con.prepareStatement("SELECT COUNT(*) FROM refund_requests");
        ResultSet rs4 = ps4.executeQuery();
        if (rs4.next()) totalRefunds = rs4.getInt(1);

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard | Pawna Lake Camping</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <style>
        /* Your CSS here (same as your previous styles) */
        * {
            box-sizing: border-box;
            padding: 0;
            margin: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #eef2f5;
            color: #2d3436;
        }

        .sidebar {
            position: fixed;
            width: 250px;
            height: 100vh;
            background: linear-gradient(135deg, #00b894, #0984e3);
            padding: 30px 20px;
            color: #fff;
            overflow-y: auto;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
            font-weight: 600;
        }

        .sidebar a {
            display: block;
            color: #fff;
            padding: 12px 15px;
            margin: 10px 0;
            text-decoration: none;
            border-radius: 8px;
            transition: background 0.3s;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .main {
            margin-left: 250px;
            padding: 30px;
        }

        .header {
            background-color: #00cec9;
            padding: 20px;
            border-radius: 10px;
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .logout {
            background-color: #d63031;
            color: #fff;
            padding: 10px 18px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .card {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card h3 {
            font-size: 20px;
            color: #0984e3;
        }

        .card p {
            margin-top: 10px;
            font-size: 22px;
            font-weight: 600;
            color: #2d3436;
        }

        .actions {
            margin-top: 40px;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
        }

        .actions h4 {
            margin-bottom: 20px;
            font-size: 20px;
        }

        .actions ul {
            list-style: none;
        }

        .actions li {
            margin-bottom: 15px;
        }

        .actions a {
            text-decoration: none;
            color: #0984e3;
            font-weight: 500;
            transition: color 0.3s;
        }

        .actions a:hover {
            color: #00cec9;
        }

        @media screen and (max-width: 768px) {
            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
            }

            .main {
                margin-left: 0;
                padding: 20px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div style="text-align: center; margin-bottom: 20px;">
            <img src="images/logo.jpeg" alt="Admin Logo" style="width: 80px; height: auto; border-radius: 10px;" />
            <h2 style="margin-top: 10px;">Admin Panel</h2>
        </div>

        <a href="admin_dashboard.jsp" class="active">&#127968; Dashboard</a>
        <a href="view_bookings.jsp">&#128221; View Bookings</a>
        <a href="manage_users.jsp">&#128101; Manage Users</a>
        <a href="manage_camps.jsp">&#127961; Manage Camps</a>
        <a href="view_payments.jsp">&#128181; View Payments</a>
        <a href="manage_refunds.jsp">&#128176; Manage Refunds</a>
        <a href="generate_reports.jsp">&#128200; Reports</a>
    </div>

    <div class="main">
        <div class="header">
            <h3>Welcome, Admin (<%= email %>)</h3>
            <a class="logout" href="logout.jsp">Logout</a>
        </div>

        <div class="cards">
            <div class="card">
                <h3>Total Bookings</h3>
                <p><%= totalBookings %></p>
            </div>
            <div>
            <a href="my_bookings.jsp" style="text-decoration: none;">
    <div class="card">
        <h3>Total Refund Requests</h3>
        <p><%= totalRefunds %></p>
    </div>
</a>
</div>

            <div class="card">
                <h3>Active Camp Sites</h3>
                <p><%= totalCamps %></p>
            </div>
        </div>

        <div class="actions">
            <h4>Quick Access</h4>
            <ul>
                <li><a href="view_bookings.jsp">&#128221; View All Bookings</a></li>
                <li><a href="manage_users.jsp">&#128101; Manage Users</a></li>
                <li><a href="manage_camps.jsp">&#127961; Manage Camp Packages</a></li>
                <li><a href="view_payments.jsp">&#128181; View Payments</a></li>
                <li><a href="generate_reports.jsp">&#128200; Generate Reports</a></li>
            </ul>
        </div>
    </div>

</body>
</html>
s