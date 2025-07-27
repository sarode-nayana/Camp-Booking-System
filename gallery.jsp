<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gallery | Pawna Lake Camping</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            margin: auto;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #2980b9;
            margin-bottom: 20px;
        }

        .gallery {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 20px;
        }

        .gallery img {
            width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .gallery img:hover {
            transform: scale(1.1);
        }

        .gallery a {
            text-decoration: none;
            color: inherit;
        }

        .back-link {
            text-align: center;
            margin-top: 30px;
        }

        .back-link a {
            text-decoration: none;
            color: #2980b9;
            font-weight: 600;
            font-size: 18px;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .gallery {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .gallery {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Explore Our Gallery</h1>

    <div class="gallery">
        <!-- Image 1 -->
        <a href="images/lona5.jpeg" target="_blank">
            <img src="images/lona1.jpeg" alt="Campground View 1">
        </a>
        
        <!-- Image 2 -->
        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/lona2.jpeg" alt="Campground View 2">
        </a>

        <!-- Image 3 -->
        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/photo5.jpg" alt="Campground View 3">
        </a>

        <!-- Image 4 -->
        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/lona4.jpeg" alt="Campground View 4">
        </a>

        <!-- Image 5 -->
        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/lona5.jpeg" alt="Campground View 5">
        </a>

     
        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/lona6.webp" alt="Campground View 6">
        </a>
        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/photo1.jpg" alt="Campground View 5">
        </a>

        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/photo2.jpg" alt="Campground View 6">
        </a>
        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/photo3.jpg" alt="Campground View 5">
        </a>

    
        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/photo4.jpg" alt="Campground View 6">
        </a>


        <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/bonfire.jpeg" alt="Campground View 6">
        </a> 

         <a href="https://via.placeholder.com/800x600" target="_blank">
            <img src="images/camp.jpeg" alt="Campground View 6">
        </a> 

    </div>

    <!-- Back to Home link -->
    <div class="back-link">
        <a href="index.jsp">← Back to Home</a>
    </div>
</div>

</body>
</html>
