<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registered Users | Pawna Lake Camping</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #ecf0f1;
            padding: 40px;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        table th, table td {
            padding: 12px 15px;
            border: 1px solid #ccc;
            text-align: center;
        }

        table th {
            background-color: #16a085;
            color: #fff;
        }

        table tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            color: white;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            margin: 2px;
        }

        .edit-btn {
            background-color: #2980b9;
        }

        .delete-btn {
            background-color: #c0392b;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
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

<div class="container">
    <h2>Registered Users</h2>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Password</th>
            <th>Actions</th>
        </tr>

<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM users");

        while (rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            String email = rs.getString("email");
            String password = rs.getString("password");
%>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= email %></td>
            <td><%= password %></td>
            <td>
                <a href="edit_user.jsp?id=<%= id %>" class="action-btn edit-btn">Edit</a>
                

                <a href="delete_user.jsp?id=<%= id %>" class="action-btn delete-btn"
                   onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
            </td>
        </tr>
<%
        }
    } catch (Exception e) {
%>
        <tr>
            <td colspan="5" style="color: red;"><%= "Error: " + e.getMessage() %></td>
        </tr>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
    </table>

    <a class="back-link" href="dashboard.jsp">← Back to Dashboard</a>
</div>

</body>
</html>
