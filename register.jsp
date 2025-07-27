<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            message = "❌ Passwords do not match!";
        } else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                PreparedStatement psCheck = con.prepareStatement("SELECT * FROM users WHERE email=?");
                psCheck.setString(1, email);
                ResultSet rs = psCheck.executeQuery();

                if (rs.next()) {
                    message = "❌ Email already registered!";
                } else {
                    PreparedStatement ps = con.prepareStatement("INSERT INTO users (name, email, password, phone) VALUES (?, ?, ?, ?)");
                    ps.setString(1, name);
                    ps.setString(2, email);
                    ps.setString(3, password);
                    ps.setString(4, phone);
                    ps.executeUpdate();
                    response.sendRedirect("login.jsp");
                    return;
                }

                rs.close();
                psCheck.close();
                con.close();
            } catch (Exception e) {
                message = "❌ Error: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Register - Pawna Lake Camping</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #56CCF2 0%, #2F80ED 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .registration-box {
            background: #fff;
            border-radius: 12px;
            width: 100%;
            max-width: 400px;
            padding: 40px 35px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
        }
        .registration-box:hover {
            transform: translateY(-5px);
        }

        h2 {
            margin-bottom: 30px;
            color: #1a1a1a;
            font-weight: 700;
            font-size: 28px;
            text-align: center;
            letter-spacing: 1px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
            font-size: 15px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: border-color 0.3s ease;
            outline: none;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            border-color: #2F80ED;
            box-shadow: 0 0 8px rgba(47, 128, 237, 0.5);
        }

        .register-btn {
            width: 100%;
            background: #2F80ED;
            color: #fff;
            font-size: 17px;
            font-weight: 700;
            border: none;
            border-radius: 8px;
            padding: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 10px;
            letter-spacing: 1px;
        }

        .register-btn:hover {
            background: #1c5dbf;
        }

        .error {
            background-color: #ffe6e6;
            border: 1px solid #ff4d4d;
            color: #b30000;
            font-weight: 600;
            padding: 10px 12px;
            border-radius: 6px;
            text-align: center;
            margin-bottom: 20px;
            user-select: none;
        }

        .footer-link {
            margin-top: 25px;
            text-align: center;
            font-size: 14px;
            color: #555;
        }

        .footer-link a {
            color: #2F80ED;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-link a:hover {
            text-decoration: underline;
            color: #1c5dbf;
        }

        @media (max-width: 480px) {
            .registration-box {
                padding: 30px 25px;
            }
            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <form class="registration-box" method="post" action="register.jsp">
        <h2>Create Your Account</h2>
        <% if (!message.isEmpty()) { %>
            <div class="error"><%= message %></div>
        <% } %>
        <div class="form-group">
            <label for="name">Full Name</label>
            <input id="name" type="text" name="name" placeholder="Enter your full name" required />
        </div>
        <div class="form-group">
            <label for="email">Email Address</label>
            <input id="email" type="email" name="email" placeholder="Enter your email" required />
        </div>
        <div class="form-group">
            <label for="phone">Mobile Number</label>
            <input id="phone" type="text" name="phone" placeholder="Enter your mobile number" required pattern="[0-9]{10}" />
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input id="password" type="password" name="password" placeholder="Enter your password" required />
        </div>
        <div class="form-group">
            <label for="confirmPassword">Confirm Password</label>
            <input id="confirmPassword" type="password" name="confirmPassword" placeholder="Re-enter your password" required />
        </div>
        <button type="submit" class="register-btn">Register</button>
        <div class="footer-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </form>
</body>
</html>
