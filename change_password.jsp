<%@ page import="java.sql.*" %>
<%@ page session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String errorMsg = "";
    String successMsg = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String currentPassword = request.getParameter("current_password");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            errorMsg = "All fields are required.";
        } else if (!newPassword.equals(confirmPassword)) {
            errorMsg = "New password and confirm password do not match.";
        } else {
            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                // Check if current password matches
                pst = con.prepareStatement("SELECT password FROM users WHERE email = ?");
                pst.setString(1, userEmail);
                rs = pst.executeQuery();

                if (rs.next()) {
                    String dbPassword = rs.getString("password");

                    if (!dbPassword.equals(currentPassword)) {
                        errorMsg = "Current password is incorrect.";
                    } else {
                        rs.close();
                        pst.close();

                        // Update to new password
                        pst = con.prepareStatement("UPDATE users SET password = ? WHERE email = ?");
                        pst.setString(1, newPassword);
                        pst.setString(2, userEmail);
                        int updated = pst.executeUpdate();

                        if (updated > 0) {
                            successMsg = "Password changed successfully.";
                        } else {
                            errorMsg = "Failed to change password.";
                        }
                    }
                } else {
                    errorMsg = "User not found.";
                }

            } catch (Exception e) {
                errorMsg = "Error: " + e.getMessage();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                try { if (pst != null) pst.close(); } catch (Exception ignored) {}
                try { if (con != null) con.close(); } catch (Exception ignored) {}
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Change Password | Pawna Lake Camping</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f7f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            width: 350px;
        }
        h2 {
            text-align: center;
            color: #2c974b;
            margin-bottom: 25px;
        }
        label {
            font-weight: bold;
            margin-top: 12px;
            display: block;
        }
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1.5px solid #ccc;
            border-radius: 6px;
        }
        input[type="submit"] {
            width: 100%;
            margin-top: 20px;
            padding: 12px;
            background: #2c974b;
            border: none;
            color: white;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background: #246a38;
        }
        .message {
            text-align: center;
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 6px;
        }
        .error {
            background: #f8d7da;
            color: #842029;
        }
        .success {
            background: #d1e7dd;
            color: #0f5132;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Change Password</h2>

    <% if (!errorMsg.isEmpty()) { %>
        <div class="message error"><%= errorMsg %></div>
    <% } %>

    <% if (!successMsg.isEmpty()) { %>
        <div class="message success"><%= successMsg %></div>
    <% } %>

    <form method="post" action="change_password.jsp">
        <label for="current_password">Current Password:</label>
        <input type="password" id="current_password" name="current_password" required>

        <label for="new_password">New Password:</label>
        <input type="password" id="new_password" name="new_password" required>

        <label for="confirm_password">Confirm New Password:</label>
        <input type="password" id="confirm_password" name="confirm_password" required>

        <input type="submit" value="Change Password">
    </form>
</div>

</body>
</html>
