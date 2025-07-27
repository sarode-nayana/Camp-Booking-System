<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reset Password - Pawna Lake Camping</title>
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
        .error {
            text-align: center;
            color: red;
            margin-top: 10px;
        }
        .success {
            text-align: center;
            color: green;
            margin-top: 10px;
        }
        input[type="password"] {
            width: 95%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<%
    String message = "";
    String error = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            error = "❌ Passwords do not match!";
        } else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                PreparedStatement ps = con.prepareStatement("UPDATE users SET password=? WHERE email=?");
                ps.setString(1, newPassword);
                ps.setString(2, email);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    message = "✅ Password successfully updated. <a href='login.jsp'>Login now</a>";
                } else {
                    error = "❌ Email not found.";
                }

                ps.close();
                con.close();
            } catch (Exception e) {
                error = "❌ Error: " + e.getMessage();
            }
        }
    }
%>

<div class="container">
    <h2>Reset Password</h2>
    <form method="post" action="reset_password.jsp">
        <input type="hidden" name="email" value="<%= request.getParameter("email") %>" />

        <input type="password" name="newPassword" placeholder="Enter new password" required />
        <input type="password" name="confirmPassword" placeholder="Confirm new password" required />
        <input type="submit" value="Reset Password" />
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="success"><%= message %></div>
    <% } else if (!error.isEmpty()) { %>
        <div class="error"><%= error %></div>
    <% } %>
</div>

</body>
</html>
