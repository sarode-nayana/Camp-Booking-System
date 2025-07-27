<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ include file="sidebar.jsp" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";

    // Handle delete user
    String deleteId = request.getParameter("delete");
    if (deleteId != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=?");
            ps.setInt(1, Integer.parseInt(deleteId));
            int rows = ps.executeUpdate();

            if (rows > 0) {
                message = "✅ User deleted successfully.";
            } else {
                message = "❌ User not found or already deleted.";
            }

            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "❌ Error deleting user: " + e.getMessage();
        }
    }

    // Handle create user
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    String roleParam = request.getParameter("role");

    if (request.getParameter("createUser") != null && name != null && email != null && password != null && phone != null && roleParam != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

            PreparedStatement ps = con.prepareStatement("INSERT INTO users(name, email, password, phone, role) VALUES (?, ?, ?, ?, ?)");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, roleParam);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "✅ User created successfully.";
            } else {
                message = "❌ Failed to create user.";
            }

            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "❌ Error creating user: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f2f2f2;
        }
        .container {
            margin-left: 260px;
            padding: 30px;
        }
        h2 {
            color: #2c3e50;
        }
        .msg {
            color: green;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
        }
        th {
            background: #16a085;
            color: white;
        }
        tr:hover {
            background-color: #f9f9f9;
        }
        .btn-delete {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
        }
        .btn-delete:hover {
            background-color: #c0392b;
        }
        .add-form {
            background: #fff;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .add-form input, .add-form select {
            margin: 5px 10px 5px 0;
            padding: 8px;
        }
        .btn-add {
            background-color: #27ae60;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
        }
        .btn-add:hover {
            background-color: #1e8449;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Manage Users</h2>

    <% if (!message.equals("")) { %>
        <p class="msg"><%= message %></p>
    <% } %>

    <div class="add-form">
        <form method="post" action="manage_users.jsp">
            <input type="text" name="name" placeholder="Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="text" name="phone" placeholder="Phone" required>
            <select name="role" required>
                <option value="user">User</option>
                <option value="admin">Admin</option>
            </select>
            <button type="submit" name="createUser" class="btn-add">Add User</button>
        </form>
    </div>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Role</th>
            <th>Action</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM users");

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("role") %></td>
            <td>
                <form method="post" action="manage_users.jsp" style="margin:0;">
                    <input type="hidden" name="delete" value="<%= rs.getInt("id") %>">
                    <button type="submit" class="btn-delete">Delete</button>
                </form>
            </td>
        </tr>
        <%
                }

                rs.close();
                st.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
        %>
        <tr><td colspan="6" style="color:red;">❌ Error fetching data: <%= e.getMessage() %></td></tr>
        <%
            }
        %>
    </table>
</div>

</body>
</html>
