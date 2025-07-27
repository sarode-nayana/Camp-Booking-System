<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ include file="sidebar.jsp" %> <!-- Optional admin sidebar -->

<%
    // Check admin role
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    String campId = request.getParameter("id");

    if (campId == null || campId.trim().isEmpty()) {
        response.sendRedirect("manage_camps.jsp"); // redirect if no id provided
        return;
    }

    // Declare variables to hold camp data
    String campName = "";
    String location = "";
    String availability = "";
    String description = "";
    double price = 0.0;

    // Load JDBC driver once
    Class.forName("com.mysql.cj.jdbc.Driver");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // --------- POST: Update the camp ---------
        String newId = request.getParameter("camp_id"); // Hidden field for id
        String newName = request.getParameter("camp_name");
        String newLocation = request.getParameter("location");
        String newAvailability = request.getParameter("availability");  // Not used yet
        String newDescription = request.getParameter("description");    // Not used yet
        String newPriceStr = request.getParameter("price");

        if (newId != null && newName != null && newLocation != null && newPriceStr != null
            && !newId.trim().isEmpty() && !newName.trim().isEmpty() && !newLocation.trim().isEmpty() && !newPriceStr.trim().isEmpty()) {
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root")) {
                double newPrice = Double.parseDouble(newPriceStr);

                PreparedStatement pstUpdate = con.prepareStatement(
                    "UPDATE camp_packages SET name=?, location=?, price=? WHERE id=?"
                );

                pstUpdate.setString(1, newName);
                pstUpdate.setString(2, newLocation);
                pstUpdate.setDouble(3, newPrice);
                pstUpdate.setInt(4, Integer.parseInt(newId));

                int updated = pstUpdate.executeUpdate();
                if (updated > 0) {
                    message = "Camp updated successfully.";
                    // Update variables for form display after POST
                    campId = newId;
                    campName = newName;
                    location = newLocation;
                    price = newPrice;
                } else {
                    message = "Update failed.";
                }
                pstUpdate.close();
            } catch (Exception e) {
                message = "Error during update: " + e.getMessage();
            }
        } else {
            message = "All fields are required.";
        }
    }

    // --------- GET or After POST: Fetch current camp details ---------
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root")) {
        PreparedStatement pst = con.prepareStatement("SELECT * FROM camp_packages WHERE id = ?");
        pst.setInt(1, Integer.parseInt(campId));
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            campName = rs.getString("name");
            location = rs.getString("location");
            price = rs.getDouble("price");
            // You can also fetch availability, description if your DB has those columns
        } else {
            message = "Camp not found.";
        }
        rs.close();
        pst.close();
    } catch (Exception e) {
        message = "Error fetching camp details: " + e.getMessage();
    }

    // Set campId as request attribute for use in form action
    request.setAttribute("campId", campId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Camp | Pawna Lake Camping</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #eef2f3;
        }

        .container {
            max-width: 600px;
            background: #fff;
            margin: 40px auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
        }

        label {
            display: block;
            margin: 15px 0 5px;
            font-weight: 600;
        }

        input[type="text"], input[type="number"], textarea, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        textarea {
            resize: vertical;
        }

        .submit-btn {
            margin-top: 20px;
            background-color: #16a085;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            width: 100%;
            cursor: pointer;
        }

        .submit-btn:hover {
            background-color: #138d75;
        }

        .message {
            text-align: center;
            margin-top: 20px;
            font-weight: bold;
            color: green;
        }

        .error {
            color: red;
        }

        .back-btn {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #2980b9;
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Edit Camp</h2>

    <div class="message <%= message.toLowerCase().contains("error") || message.toLowerCase().contains("failed") || message.toLowerCase().contains("not found") ? "error" : "" %>">
        <%= message %>
    </div>

    <form method="post" action="edit_camp.jsp?id=<%= campId %>">
        <input type="hidden" name="camp_id" value="<%= campId %>" />

        <label for="camp_name">Camp Name *</label>
        <input type="text" id="camp_name" name="camp_name" value="<%= campName %>" required />

        <label for="location">Location *</label>
        <input type="text" id="location" name="location" value="<%= location %>" required />

        <label for="price">Price (₹) *</label>
        <input type="number" step="0.01" id="price" name="price" value="<%= price %>" required />

        <button type="submit" class="submit-btn">Update Camp</button>
    </form>

    <a href="manage_camps.jsp" class="back-btn">← Back to Camps</a>
</div>

</body>
</html>
