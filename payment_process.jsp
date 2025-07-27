<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Status - Pawna Lake Camping</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            color: #fff;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
            margin: 80px auto;
            background-color: #ffffff10;
            backdrop-filter: blur(8px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            text-align: center;
        }

        h2 {
            font-size: 28px;
            margin-bottom: 20px;
        }

        p {
            font-size: 18px;
            margin: 15px 0;
        }

        a.button {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 24px;
            background-color: #fff;
            color: #0072ff;
            text-decoration: none;
            font-weight: bold;
            border-radius: 8px;
            transition: background-color 0.3s;
        }

        a.button:hover {
            background-color: #e0e0e0;
        }

        .error {
            color: #ffcccc;
        }
    </style>
</head>
<body>
<%
    String dbURL = "jdbc:mysql://localhost:3306/pawna_lake_camping";
    String dbUser = "root";
    String dbPass = "root";

    String location = request.getParameter("location");
    String user_email = request.getParameter("user_email");
    String date = request.getParameter("date");
    String priceStr = request.getParameter("price");
    String personsStr = request.getParameter("persons");
    String payment_method = request.getParameter("payment_method");
    String cardno = request.getParameter("cardno");
    
    String cvv = request.getParameter("cvv");
    if (cvv != null) {
        cvv = cvv.trim();
        if (cvv.length() > 4) {
            cvv = cvv.substring(0, 4);
        }
    }

    int price = Integer.parseInt(priceStr);
    int persons = Integer.parseInt(personsStr);
    double totalAmount = price * persons;

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        int booking_id = 0; // Update this logic based on actual booking flow

        String sql = "INSERT INTO payments (booking_id, amount_paid, payment_mode, user_email, status, cardholder_name, card_number, cvv) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);

        pstmt.setInt(1, booking_id);
        pstmt.setDouble(2, totalAmount);
        pstmt.setString(3, payment_method);
        pstmt.setString(4, user_email);
        pstmt.setString(5, "Success");
        pstmt.setString(6, user_email);
        pstmt.setString(7, cardno);
        pstmt.setString(8, cvv);

        int rowsInserted = pstmt.executeUpdate();

        if (rowsInserted > 0) {
%>
    <div class="container">
        <h2>✅ Payment Successful!</h2>
        <p>Thank you for your payment of <strong>₹<%= totalAmount %></strong>.</p>
        <p>Your booking for <strong><%= location %></strong> on <strong><%= date %></strong> is confirmed.</p>
        <p>A confirmation has been sent to: <strong><%= user_email %></strong>.</p>
        <a href="index.jsp" class="button">🏕️ Go to Home</a>
    </div>
<%
        } else {
%>
    <div class="container">
        <h2>❌ Payment Failed</h2>
        <p class="error">There was an error processing your payment. Please try again.</p>
        <a href="payment.jsp" class="button">🔁 Back to Payment</a>
    </div>
<%
        }
    } catch (Exception e) {
%>
    <div class="container">
        <h2 class="error">❌ Error</h2>
        <p class="error"><%= e.getMessage() %></p>
        <a href="payment.jsp" class="button">🔁 Back to Payment</a>
    </div>
<%
        e.printStackTrace();
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch(Exception e) {}
        try { if (conn != null) conn.close(); } catch(Exception e) {}
    }
%>
</body>
</html>
