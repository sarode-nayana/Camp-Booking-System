<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User | Pawna Lake Camping</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #16a085, #1abc9c);
            padding: 50px;
            margin: 0;
        }

        .container {
            max-width: 500px;
            margin: auto;
            background: #ffffff;
            padding: 35px 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 14px;
            margin: 12px 0 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            transition: all 0.3s ease-in-out;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            border-color: #16a085;
            outline: none;
            box-shadow: 0 0 5px rgba(22, 160, 133, 0.3);
        }

        input[type="submit"] {
            width: 100%;
            background-color: #16a085;
            color: #fff;
            border: none;
            padding: 14px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #138d75;
        }

        .msg {
            text-align: center;
            margin-top: 15px;
            font-weight: 500;
            font-size: 15px;
        }

        .success {
            color: green;
        }

        .error {
            color: red;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 25px;
            text-decoration: none;
            color: #16a085;
            font-weight: 500;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<%
    int userId = 0;
    String name = "", email = "", password = "";

    String idParam = request.getParameter("id");

    if (idParam != null) {
        userId = Integer.parseInt(idParam);

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            name = request.getParameter("name");
            email = request.getParameter("email");
            password = request.getParameter("password");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                PreparedStatement ps = conn.prepareStatement("UPDATE users SET name=?, email=?, password=? WHERE id=?");
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setInt(4, userId);

                int updated = ps.executeUpdate();
%>
                <div class="msg success">✅ User updated successfully! <a href="view_users.jsp">View All</a></div>
<%
                ps.close();
                conn.close();
            } catch (Exception e) {
%>
                <div class="msg error">❌ Error updating user: <%= e.getMessage() %></div>
<%
            }
        } else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    name = rs.getString("name");
                    email = rs.getString("email");
                    password = rs.getString("password");
                } else {
%>
                    <div class="msg error">❌ User not found!</div>
<%
                }

                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
%>
                <div class="msg error">❌ Error loading user: <%= e.getMessage() %></div>
<%
            }
        }
    } else {
%>
    <div class="msg error">❌ Invalid user ID.</div>
<%
    }
%>

<% if (userId > 0 && !"POST".equalsIgnoreCase(request.getMethod())) { %>
<div class="container">
    <h2>Edit User</h2>
    <form method="post">
        <input type="text" name="name" placeholder="Full Name" value="<%= name %>" required />
        <input type="email" name="email" placeholder="Email Address" value="<%= email %>" required />
        <input type="password" name="password" placeholder="Password" value="<%= password %>" required />
        <input type="submit" value="Update User" />
    </form>
    <a class="back-link" href="view_users.jsp">← Back to Users</a>
</div>
<% } %>

</body>
</html>
