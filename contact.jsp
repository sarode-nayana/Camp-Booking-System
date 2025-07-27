<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us - Pawna Lake Camping</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background: #e6f2ff;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Modern Navbar */
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

        .container {
            max-width: 900px;
            margin: 40px auto;
            background: #ffffff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            flex: 1;
        }

        h2 {
            text-align: center;
            color: #023e8a;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        input[type="text"],
        input[type="email"],
        textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        textarea {
            height: 120px;
            resize: vertical;
        }

        button {
            background-color: #0077b6;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            display: block;
            margin: 0 auto;
            transition: 0.3s ease;
        }

        button:hover {
            background-color: #023e8a;
        }

        .contact-info {
            margin-top: 40px;
            font-size: 16px;
            background: #f0f0f0;
            padding: 20px;
            border-radius: 8px;
        }

        .contact-info strong {
            display: block;
            color: #023e8a;
            margin-bottom: 8px;
        }

        footer {
            background-color: #0077b6;
            color: white;
            text-align: center;
            padding: 15px;
        }

        @media (max-width: 768px) {
            .container {
                margin: 20px;
                padding: 25px;
            }

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
        }
    </style>
</head>
<body>

<!-- Modern Navbar -->
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

<!-- Contact Form -->
<div class="container">
    <h2>Contact Us</h2>
    <form action="contact_process.jsp" method="post">
        <div class="form-group">
            <label for="name">Full Name *</label>
            <input type="text" id="name" name="name" required />
        </div>

        <div class="form-group">
            <label for="email">Email Address *</label>
            <input type="email" id="email" name="email" required />
        </div>

        <div class="form-group">
            <label for="message">Your Message *</label>
            <textarea id="message" name="message" required></textarea>
        </div>

        <button type="submit">Send Message</button>
    </form>

    <div class="contact-info">
        <p><strong>Office Address:</strong> Near Pawna Lake, Lonavala, Pune, Maharashtra - 410406</p>
        <p><strong>Email:</strong> pawna.camping@support.com</p>
        <p><strong>Phone:</strong> +91 9765432109</p>
        <p><strong>Timing:</strong> Mon - Sun: 9:00 AM - 9:00 PM</p>
    </div>
</div>

<!-- Footer -->
<footer>
    &copy; 2025 Pawna Lake Camping. All rights reserved.
</footer>

</body>
</html>
