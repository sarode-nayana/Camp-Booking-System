<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Our Services - Pawna Lake Camping</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: #e0f7fa;
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

        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: #023e8a;
            font-size: 32px;
            margin-bottom: 40px;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }

        .service-card {
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            transition: 0.3s;
            text-align: center;
        }

        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .service-card img {
            width: 80px;
            margin-bottom: 15px;
        }

        .service-card h3 {
            color: #0077b6;
            font-size: 22px;
            margin-bottom: 10px;
        }

        .service-card p {
            font-size: 15px;
            color: #333;
            line-height: 1.6;
        }

        footer {
            background-color: #006494;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: 60px;
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

            .container {
                margin: 20px;
                padding: 15px;
            }
        }
    </style>
</head>
<body>

<!-- Modern Navbar with Home, About, Services, Contact, Login -->
<div class="navbar">
    <div class="brand-title">PawnaLake</div>
    <ul class="nav-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="about.jsp">About</a></li>
        <li><a href="services.jsp">Services</a></li>
        <li><a href="contact.jsp">Contact</a></li>
        <li><a href="login.jsp">Login</a></li>
    </ul>
</div>

<!-- Services Section -->
<div class="container">
    <h2>Our Camping Services</h2>
    <div class="services-grid">
        <div class="service-card">
            <img src="images/lu.jpeg" alt="Tent Icon">
            <h3>Luxury Tent Stay</h3>
            <p>Spacious tents with comfortable bedding and cozy ambiance near the lakeside.</p>
        </div>
        <div class="service-card">
            <img src="images/bonfire.jpeg" alt="Bonfire Icon">
            <h3>Night Bonfire</h3>
            <p>Enjoy peaceful evenings with friends and family around a warm bonfire under the stars.</p>
        </div>
        
        <div class="service-card">
            <img src="images/bot.jpeg" alt="Boating Icon">
            <h3>Lake Boating</h3>
            <p>Boating experience on the calm waters of Pawna Lake with scenic views.</p>
        </div>
        <div class="service-card">
            <img src="images/dj.jpeg" alt="Music Icon">
            <h3>Live Music & DJ</h3>
            <p>Weekend entertainment with live music, open mic & DJ night to enhance the fun.</p>
        </div>
        <div class="service-card">
            <img src="images/track.jpeg" alt="Trekking Icon">
            <h3>Trekking Trails</h3>
            <p>Guided treks to nearby hills and forts like Tikona and Tung for nature lovers.</p>
        </div>
    </div>
</div>

<footer>
    &copy; 2025 Pawna Lake Camping. All Rights Reserved.
</footer>

</body>
</html>
