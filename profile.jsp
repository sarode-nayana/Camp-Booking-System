<%@ page import="java.sql.*" %>
<%@ page session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Get logged-in user's email from session
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        // If no user in session, redirect to login
        response.sendRedirect("login.jsp");
        return;
    }

    String name = "";
    String phone = "";
    String errorMsg = "";
    String successMsg = "";

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

        // If form submitted, update name & phone
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String newName = request.getParameter("name");
            String newPhone = request.getParameter("phone");

            if (newName == null || newName.trim().isEmpty()) {
                errorMsg = "Name cannot be empty.";
            } else {
                pst = con.prepareStatement("UPDATE users SET name=?, phone=? WHERE email=?");
                pst.setString(1, newName);
                pst.setString(2, newPhone);
                pst.setString(3, userEmail);
                int updated = pst.executeUpdate();
                if (updated > 0) {
                    successMsg = "Profile updated successfully.";
                } else {
                    errorMsg = "Profile update failed.";
                }
                pst.close();
            }
        }

        // Fetch user info from DB to show in form
        pst = con.prepareStatement("SELECT name, phone FROM users WHERE email=?");
        pst.setString(1, userEmail);
        rs = pst.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            phone = rs.getString("phone");
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
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>My Profile | Pawna Lake Camping</title>
    <style>
        /* Simple styling, same as previous example */
        body { font-family: Arial, sans-serif; background:#f0f5f5; display:flex; justify-content:center; align-items:center; height:100vh; margin:0;}
        .container { background:#fff; padding:25px; border-radius:12px; box-shadow: 0 0 12px rgba(0,0,0,0.1); width:380px;}
        h2 { text-align:center; color:#2c974b; margin-bottom:20px; }
        label { font-weight:bold; margin-top:12px; display:block; }
        input[type="text"], input[type="email"], input[type="tel"] {
            width:100%; padding:10px; margin-top:6px; border:1.5px solid #ccc; border-radius:6px;
        }
        input[readonly] { background:#e9ecef; cursor:not-allowed; }
        input[type="submit"] {
            margin-top:18px; width:100%; padding:12px; background:#2c974b; color:#fff; border:none; border-radius:8px; cursor:pointer; font-weight:bold;
        }
        input[type="submit"]:hover { background:#246a38; }
        .message { padding:10px; margin-bottom:15px; border-radius:6px; text-align:center; }
        .error { background:#f8d7da; color:#842029; }
        .success { background:#d1e7dd; color:#0f5132; }
    </style>
</head>
<body>

<div class="container">
    <h2>My Profile</h2>

    <% if (!errorMsg.isEmpty()) { %>
        <div class="message error"><%= errorMsg %></div>
    <% } %>
    <% if (!successMsg.isEmpty()) { %>
        <div class="message success"><%= successMsg %></div>
    <% } %>

    <form method="post" action="profile.jsp">
        <label>Email</label>
        <input type="email" value="<%= userEmail %>" readonly>

        <label>Name</label>
        <input type="text" name="name" value="<%= name %>" required>

        <label>Phone</label>
        <input type="tel" name="phone" value="<%= phone != null ? phone : "" %>" placeholder="Enter phone number">

        <input type="submit" value="Update Profile">
    </form>
</div>

</body>
</html>
