<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Camping Package</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #e0f7fa;
            padding: 20px;
        }
        h2 {
            color: #00796b;
        }
        form {
            background: white;
            padding: 20px;
            max-width: 400px;
            border-radius: 8px;
            box-shadow: 0 0 10px #aaa;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #004d40;
        }
        input[type=text], input[type=number] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
            border: 1px solid #004d40;
            border-radius: 4px;
        }
        input[type=submit] {
            margin-top: 20px;
            background: #00796b;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        input[type=submit]:hover {
            background: #004d40;
        }
        .message {
            margin-top: 20px;
            padding: 10px;
            max-width: 400px;
            border-radius: 5px;
        }
        .success {
            background-color: #a5d6a7;
            color: #2e7d32;
        }
        .error {
            background-color: #ef9a9a;
            color: #c62828;
        }
    </style>
</head>
<body>

<h2>Add New Camping Package</h2>

<form method="post" action="add_camp.jsp">
    <label for="campName">Camp Name:</label>
    <input type="text" id="campName" name="campName" required />

    <label for="location">Location:</label>
    <input type="text" id="location" name="location" required />

    <label for="price">Price per Person (₹):</label>
    <input type="number" id="price" name="price" min="0" step="0.01" required />

    <label for="capacity">Capacity:</label>
    <input type="number" id="capacity" name="capacity" min="1" required />

    <input type="submit" value="Add Package" />
</form>

<%
    // Process form submission
    String campName = request.getParameter("campName");
    String location = request.getParameter("location");
    String priceStr = request.getParameter("price");
    String capacityStr = request.getParameter("capacity");

    if (campName != null && location != null && priceStr != null && capacityStr != null) {
        campName = campName.trim();
        location = location.trim();

        double price = 0;
        int capacity = 0;

        try {
            price = Double.parseDouble(priceStr);
            capacity = Integer.parseInt(capacityStr);

            if (campName.isEmpty() || location.isEmpty() || price <= 0 || capacity <= 0) {
%>
                <div class="message error">Please enter valid and positive values for all fields.</div>
<%
            } else {
                // DB connection variables (adjust according to your setup)
                String dbURL = "jdbc:mysql://localhost:3306/pawna_lake_camping";
                String dbUser = "root";
                String dbPass = "root";

                Connection conn = null;
                PreparedStatement ps = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                    String sql = "INSERT INTO camp_packages (name, location, price, capacity) VALUES (?, ?, ?, ?)";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, campName);
                    ps.setString(2, location);
                    ps.setDouble(3, price);
                    ps.setInt(4, capacity);

                    int inserted = ps.executeUpdate();
                    if (inserted > 0) {
%>
                        <div class="message success">Camping package "<%= campName %>" added successfully!</div>
<%
                    } else {
%>
                        <div class="message error">Failed to add camping package. Please try again.</div>
<%
                    }
                } catch (Exception e) {
%>
                    <div class="message error">Error: <%= e.getMessage() %></div>
<%
                } finally {
                    if (ps != null) try { ps.close(); } catch (Exception e) {}
                    if (conn != null) try { conn.close(); } catch (Exception e) {}
                }
            }
        } catch (NumberFormatException e) {
%>
            <div class="message error">Price and Capacity must be valid numbers.</div>
<%
        }
    }
%>

</body>
</html>
