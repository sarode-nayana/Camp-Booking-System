<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Book Camping | Pawna Lake</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f0f8ff;
            margin: 0;
            padding: 20px;
        }

        .title {
            text-align: center;
            font-size: 32px;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        .container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 20px;
            max-width: 1200px;
            margin: auto;
        }

        .card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            transition: 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card img {
            width: 100%;
            height: 220px;
            object-fit: cover;
        }

        .card-content {
            padding: 16px;
        }

        .card-content h3 {
            margin: 0;
            font-size: 20px;
            color: #34495e;
        }

        .price {
            color: #16a085;
            font-size: 18px;
            font-weight: 600;
            margin: 8px 0;
        }

        .card-content a {
            display: inline-block;
            padding: 10px 18px;
            background-color: #16a085;
            color: #fff;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
        }

        .card-content a:hover {
            background-color: #138d75;
        }
    </style>
</head>
<body>
    <div class="title">Select a Camping Location</div>
<div class="container">



<!-- <div class="title">Select a Camping Location</div>

<div class="container"> -->

    <div class="card">
        <img src="images/lona1.jpeg" alt="Location I – Camping & Boating">
        <div class="card-content">
            <h3>Location Camping & Boating</h3>
            <div class="price">From ₹999.00</div>
            <a href="booking_form.jsp?location=Camping & Boating&price=999">Book Now</a>
        </div>
    </div>

    <div class="card">
        <img src="images/lona2.jpeg" alt="Luxury Camping – Couple & Family">
        <div class="card-content">
            <h3>Luxury Camping II – Couple & Family</h3>
            <div class="price">From ₹500.00</div>
            <a href="booking_form.jsp?location=Luxury Camping&price=500">Book Now</a>
        </div>
    </div>

    <div class="card">
        <img src="images/lona3.jpeg" alt="Location F – Pawna Lake Camps">
        <div class="card-content">
            <h3>Location F – Pawna Lake Camps</h3>
            <div class="price">From ₹1,000.00</div>
            <a href="booking_form.jsp?location=F&price=1000">Book Now</a>
        </div>
    </div>

    <div class="card">
        <img src="images/lona4.jpeg" alt="Location C – Pawna Lake Camps">
        <div class="card-content">
            <h3>Location C Pawna Lake in Family </h3>
            <div class="price">From ₹700.00</div>
            <a href="booking_form.jsp?location=C&price=700">Book Now</a>
        </div>
    </div>

    <div class="card">
        <img src="images/two.jpeg" alt="Location E – Pawna Lake Camps">
        <div class="card-content">
            <h3>Location Home– Pawna Lake Camps</h3>
            <div class="price">From ₹900.00</div>
            <a href="booking_form.jsp?location=Home&price=900">Book Now</a>
        </div>
    </div>

    <div class="card">
        <img src="images/lona6.webp" alt="Location D – Pawna River Camping">
        <div class="card-content">
            <h3>Location River Camping</h3>
            <div class="price">From ₹1,200.00</div>
            <a href="booking_form.jsp?location=River Camping&price=1200">Book Now</a>
        </div>
    </div>

     <div class="card">
        <img src="images/bonfire.jpeg" alt="Location E – Pawna Lake Camps">
        <div class="card-content">
            <h3>Location Bonfire Lake Camps</h3>
            <div class="price">From ₹1,400.00</div>
            <a href="booking_form.jsp?location=Bonfire&price=1400">Book Now</a>
        </div>
    </div>

     <div class="card">
        <img src="images/camp2.avif" alt="Location E – Pawna Lake Camps">
        <div class="card-content">
            <h3>Location H – Camps</h3>
            <div class="price">From ₹599.00</div>
            <a href="booking_form.jsp?location=H&price=599">Book Now</a>
        </div>
    </div>
  <%
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;


    // Images array to cycle through
    String[] images = {"images/one.jpeg", "images/two.jpeg", "images/three.jpeg", "images/boating.jpeg"};
    int imgIndex = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT * FROM camp_packages");

        while (rs.next()) {
            String name = rs.getString("name");
            double price = rs.getDouble("price");
            String encodedName = URLEncoder.encode(name, "UTF-8");

            String imagePath = images[imgIndex];
            imgIndex = (imgIndex + 1) % images.length;
%>
    <div class="card">
        <img src="<%= imagePath %>" alt="<%= name %>" class="thumbnail" />
        <div class="card-content">
            <h3><%= name %></h3>
            <div class="price">From ₹<%= String.format("%.2f", price) %></div>
            <a href="booking_form.jsp?location=<%= encodedName %>&price=<%= (int)price %>">Book Now</a>
        </div>
    </div>
<%
        }
    } catch (Exception e) {
%>
    <p style="color:red;">Failed to load camping packages. Error: <%= e.getMessage() %></p>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>


</div>



</body>
</html>
