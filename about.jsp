<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>About Us - Pawna Lake Camping</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background-color: #f0f8ff;
            color: #333;
        }

        body {
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background: linear-gradient(to right, #16a085, #2c3e50);
            padding: 14px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
            margin: 0;
            padding: 0;
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

        .content {
            flex: 1;
            padding: 40px;
            max-width: 900px;
            margin: auto;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 10px;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        h2 {
            text-align: center;
            color: #1e90ff;
        }

        footer {
            background-color: #1e90ff;
            color: white;
            text-align: center;
            padding: 12px;
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

            .content {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<!-- Navbar -->
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

<!-- Page Content -->
<div class="content">
    <h2>About Us</h2>
    <p>
        Welcome to Pawna Lake Camping – your perfect getaway into nature! Nestled beside the serene Pawna Lake near Lonavala, our campsite offers a unique blend of natural beauty and comfortable camping.
    </p>
    <p>
        Whether you're looking for a weekend escape, a romantic evening under the stars, or a fun-filled adventure with friends and family – Pawna Lake Camping has something for everyone. We offer well-maintained tents, delicious food, bonfire nights, live music, and various adventure activities.
    </p>
    <p>
        Our mission is to provide safe, enjoyable, and unforgettable experiences in nature’s lap. Join us to make memories that last a lifetime.
    </p>
</div>

<!-- Footer -->
<footer>
    &copy; 2025 Pawna Lake Camping. All rights reserved.
</footer>

</body>
</html>
