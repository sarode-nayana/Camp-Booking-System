<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pawna Lake Camping | Nature Meets Comfort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f9f9;
            color: #333;
        }

        .navbar {
            background: linear-gradient(to right, #16a085, #2c3e50);
            padding: 14px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .brand-title {
            color: white;
            font-size: 24px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .nav-links {
            list-style: none;
            display: flex;
            gap: 20px;
        }

        .nav-links li {
            display: inline-block;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 6px;
            transition: background 0.3s ease;
        }

        .nav-links a:hover {
            background-color: rgba(255,255,255,0.2);
        }

        .auth-btn {
            background-color: blue;
            color: #16a085;
            padding: 6px 14px;
            border-radius: 5px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .auth-btn:hover {
            background-color: #16a085;
            color: white;
        }

        .banner {
            background: url('images/camp1.avif') center/cover no-repeat;
            height: 480px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            font-size: 42px;
            font-weight: 700;
            text-shadow: 3px 3px 10px rgba(0,0,0,0.7);
        }

        .section {
            padding: 60px 80px;
            background-color: white;
        }

        .section h2 {
            font-size: 36px;
            color: #16a085;
            text-align: center;
            margin-bottom: 20px;
        }

        .section p {
            font-size: 18px;
            max-width: 900px;
            margin: 0 auto;
            color: #555;
            text-align: center;
        }

        .services {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 40px;
            gap: 30px;
        }

        .service-box {
            width: 280px;
            background-color: #ecf0f1;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 6px 14px rgba(0,0,0,0.08);
        }

        .service-box:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 22px rgba(0,0,0,0.15);
        }

        .service-box img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 50%;
            margin-bottom: 15px;
            border: 2px solid #16a085;
            padding: 5px;
        }

        .service-box h3 {
            margin: 10px 0 8px;
            font-size: 20px;
            color: #2c3e50;
        }

        .service-box p {
            font-size: 15px;
            color: #666;
        }

        .footer {
            background-color: #2c3e50;
            color: white;
            text-align: center;
            padding: 20px 10px;
            font-size: 14px;
        }

        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .nav-links {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }

            .banner {
                font-size: 28px;
                padding: 0 10px;
                height: 300px;
            }

            .section {
                padding: 40px 20px;
            }

            .services {
                flex-direction: column;
                align-items: center;
            }

            .service-box {
                width: 90%;
            }
        }
    </style>
</head>
<body>

<%
    String user = (String) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role"); // Assuming role is saved in session
%>

<!-- Navigation Bar -->
<div class="navbar">
    <div class="brand-title">PawnaLake</div>
    <ul class="nav-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="book_tent.jsp">Book Tent</a></li>
        <li><a href="gallery.jsp">Gallery</a></li>
        <li><a href="contact.jsp">Contact</a></li>
        <li><a href="about.jsp">About</a></li>
        
        <div>
        <%
            if (user == null) {
        %>
            <a href="register.jsp" class="auth-btn">Register</a>
            <a href="login.jsp" class="auth-btn">Login</a>
        <%
            } else {
        %>
            <span style="color:white; margin-right: 10px;">Welcome, <%= user %></span>
            <a href="logout.jsp" class="auth-btn">Logout</a>

            <% 
            if ("admin".equals(userRole)) { // Admin Role Check
            %>
                <a href="admin_dashboard.jsp" class="auth-btn">Admin Dashboard</a>
                <a href="manage_bookings.jsp" class="auth-btn">Manage Bookings</a>
            <% 
            } 
            %>
        <%
            }
        %>
        </div>
    </ul>
</div>

<!-- Banner -->
<div class="banner">
    Pawna Lake Camping <br> Reconnect with Nature
</div>

<!-- About Section -->
<div class="section">
    <h2>About Pawna Lake Camping</h2>
    <p>
        Located near the pristine Pawna Lake in Lonavala, our campsite offers an unforgettable lakeside camping experience.
        Whether you're a couple, family, or a group of friends, we offer the perfect retreat with serene views, luxury tents, adventure activities,
        bonfire nights, live music, and mouthwatering food.
    </p>
</div>

<!-- Services Section -->
<div class="section">
    <h2>Our Services</h2>
    <div class="services">
        <div class="service-box">
            <img src="images/luxery.avif" alt="Luxury Tent">
            <h3>Luxury Tents</h3>
            <p>Spacious, clean, and comfortable tents with private amenities and stunning lake views.</p>
        </div>
        <div class="service-box">
            <img src="images/advan.webp" alt="Adventure Activities">
            <h3>Adventure Fun</h3>
            <p>Enjoy kayaking, boating, archery, cricket, and thrilling activities for all age groups.</p>
        </div>
        <div class="service-box">
            <img src="images/bonfire.jpeg" alt="Bonfire & BBQ">
            <h3>Bonfire & BBQ</h3>
            <p>Evening bonfire with live music, DJ, BBQ dinner and stargazing around the lake.</p>
        </div>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    &copy; 2025 Pawna Lake Camping | Designed by Team Final Project | All rights reserved.
</div>

</body>
</html>
