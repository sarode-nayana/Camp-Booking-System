<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login - Pawna Lake Camping</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("background.jpg") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 360px;
            margin: 100px auto;
            padding: 25px;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 10px;
            box-shadow: 0 0 10px #333;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }
        input[type="email"], input[type="password"] {
            width: 95%;
            padding: 10px;
            margin: 8px 0;
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
        .footer-links {
            text-align: center;
            margin-top: 15px;
        }
        .footer-links a {
            color: #007bff;
            text-decoration: none;
            font-size: 14px;
        }
        .footer-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<%
    String error = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if ("admin123@gmail.com".equalsIgnoreCase(email) && "admin123".equals(password)) {
            session.setAttribute("userEmail", email);
            session.setAttribute("role", "admin");
            response.sendRedirect("admin_dashboard.jsp");
            return;
        } 
        else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
                ps.setString(1, email);
                ps.setString(2, password);

                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    session.setAttribute("userEmail", email);
                    session.setAttribute("role", rs.getString("role"));
                    response.sendRedirect("user_dashboard.jsp");
                    return;
                } else {
                    error = "❌ Invalid email or password!";
                }

                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
                error = "❌ Database Error: " + e.getMessage();
            }
        }
    }
%>

<div class="container">
    <h2>Login</h2>
    <form method="post" action="login.jsp">
        <input type="email" name="email" placeholder="Email" required /><br>
        <input type="password" name="password" placeholder="Password" required /><br>
        <input type="submit" value="Login" />
    </form>
    
    <div class="footer-links">
        <a href="forgot_password.jsp">Forgot Password?</a><br>
        <a href="register.jsp">Don't have an account? Register</a>
    </div>

    <div class="error"><%= error %></div>
</div>

</body>
</html>
