<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Camp Packages | Pawna Lake Camping</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .container {
            margin-left: 260px;
            padding: 20px;
        }
        h2 {
            color: #2c3e50;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }
        th {
            background-color: #1abc9c;
            color: white;
        }
        tr:hover {
            background-color: #ecf0f1;
        }
        .actions a {
            margin-right: 10px;
            color: #2980b9;
            text-decoration: none;
            font-weight: 500;
        }
        .btn-add {
            background-color: #16a085;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-bottom: 20px;
        }
        .btn-add:hover {
            background-color: #138d75;
        }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="container">
    <h2>Manage Camp Packages</h2>

    <a href="add_camp.jsp" class="btn-add">+ Add New Camp</a>

    <table>
        <tr>
            <th>ID</th>
            <th>Camp Name</th>
            <th>Location</th>
            <th>Price</th>
            <th>Capacity</th>
            <th>Actions</th>
        </tr>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT * FROM camp_packages");

        boolean hasRecords = false;

        while (rs.next()) {
            hasRecords = true;
            int id = rs.getInt("id");
%>
        <tr>
            <td><%= id %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("location") %></td>
            <td>₹<%= String.format("%.2f", rs.getDouble("price")) %></td>
            <td><%= rs.getInt("capacity") %> People</td>
            <td class="actions">
                <a href="edit_camp.jsp?id=<%= id %>">Edit</a>
                <a href="delete_camp.jsp?id=<%= id %>" onclick="return confirm('Are you sure you want to delete this camp?');">Delete</a>
            </td>
        </tr>
<%
        } // end while

        if (!hasRecords) {
%>
        <tr><td colspan="6">No camp packages found.</td></tr>
<%
        }
    } catch (Exception e) {
%>
        <tr><td colspan="6" style="color:red;">Error loading data: <%= e.getMessage() %></td></tr>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>
    </table>
</div>
</body>
</html>
