<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%@ include file="sidebar.jsp" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String bookingId = request.getParameter("booking_id");
        String userEmail = request.getParameter("user_email");
        String amount = request.getParameter("amount");
        String method = request.getParameter("payment_method");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");
            PreparedStatement ps = con.prepareStatement("INSERT INTO payments (booking_id, user_email, amount, payment_method) VALUES (?, ?, ?, ?)");
            ps.setInt(1, Integer.parseInt(bookingId));
            ps.setString(2, userEmail);
            ps.setDouble(3, Double.parseDouble(amount));
            ps.setString(4, method);

            int status = ps.executeUpdate();
            if (status > 0) {
                message = "Payment successfully recorded!";
            } else {
                message = "Failed to add payment.";
            }
            con.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Payment | Pawna Lake Camping</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 50%;
            margin: 40px auto;
            background: #ffffff;
            padding: 25px 30px;
            border-radius: 8px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #2c3e50;
        }
        form {
            margin-top: 20px;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"], select {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn {
            margin-top: 20px;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border: none;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            width: 100%;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .message {
            margin-top: 15px;
            font-weight: bold;
            color: green;
            text-align: center;
        }
        .error {
            color: red;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 25px;
            color: #2980b9;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Add Payment</h2>

    <form method="post">
        <label for="booking_id">Booking ID:</label>
        <input type="number" name="booking_id" id="booking_id" required>

        <label for="user_email">User Email:</label>
        <input type="text" name="user_email" id="user_email" required>

        <label for="amount">Amount (₹):</label>
        <input type="number" step="0.01" name="amount" id="amount" required>

        <label for="payment_method">Payment Method:</label>
        <select name="payment_method" id="payment_method" required>
            <option value="">-- Select Method --</option>
            <option value="UPI">UPI</option>
            <option value="Credit Card">Credit Card</option>
            <option value="Net Banking">Net Banking</option>
            <option value="Cash">Cash</option>
        </select>

        <button type="submit" class="btn">Add Payment</button>
    </form>

    <div class="message">
        <%= message %>
    </div>

    <a href="payments.jsp" class="back-link">← Back to Payments</a>
</div>

</body>
</html>
