<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard | Pawna Lake Camping</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            padding: 40px;
        }

        .container {
            max-width: 800px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        .card {
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #ecf0f1;
            padding: 20px;
            border-radius: 8px;
            margin: 15px 0;
            transition: 0.3s ease;
        }

        .card:hover {
            background-color: #d0ece7;
        }

        a {
            text-decoration: none;
            color: #16a085;
            font-weight: 600;
            font-size: 18px;
        }

        .nav {
            text-align: center;
            margin-bottom: 20px;
        }

        .nav a {
            margin: 0 15px;
            color: #2980b9;
            text-decoration: none;
        }

        .nav a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Admin Dashboard</h2>

    <div class="nav">
        <a href="dashboard.jsp">Home</a>
        <a href="view_users.jsp">View Users</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="card">
        <a href="view_users.jsp">👥 View Registered Users</a>
    </div>

    <!-- You can add more dashboard cards below like Bookings, Payments, etc. -->
    <div class="card">
        <a href="view_bookings.jsp">🚌 View Bookings</a> <!-- Create this page later -->
    </div>

    <div class="card">
        <a href="manage_camps.jsp">🏕 Manage Camps</a> <!-- Optional future page -->
    </div>

</div>

</body>
</html>
