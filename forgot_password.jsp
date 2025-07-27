<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - Pawna Lake Camping</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("background.jpg") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 400px;
            margin: 100px auto;
            padding: 25px;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 10px;
            box-shadow: 0 0 10px #444;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        input[type="email"] {
            width: 95%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .info {
            text-align: center;
            color: green;
            margin-top: 15px;
        }
        .error {
            text-align: center;
            color: red;
            margin-top: 15px;
        }
    </style>
</head>
<body>

<%
    String message = "";
    String error = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email = ?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // 👉 Simulate sending email / redirect to reset_password.jsp
                response.sendRedirect("reset_password.jsp?email=" + email);
                return;
            } else {
                error = "❌ Email not found!";
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            error = "❌ Error: " + e.getMessage();
        }
    }
%>

<div class="container">
    <h2>Forgot Password</h2>
    <form method="post" action="forgot_password.jsp">
        <input type="email" name="email" placeholder="Enter your registered email" required />
        <input type="submit" value="Continue" />
    </form>
    <% if (!message.isEmpty()) { %>
        <div class="info"><%= message %></div>
    <% } else if (!error.isEmpty()) { %>
        <div class="error"><%= error %></div>
    <% } %>
</div>

</body>
</html>
