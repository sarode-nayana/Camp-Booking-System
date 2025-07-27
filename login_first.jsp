<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Required | Pawna Lake</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .card {
            background-color: #ffffff;
            padding: 40px 30px;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 400px;
            width: 100%;
        }

        .card h2 {
            color: #e74c3c;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .card p {
            color: #555;
            font-size: 16px;
            margin-bottom: 30px;
        }

        .btn-group {
            display: flex;
            justify-content: space-between;
        }

        .btn {
            background-color: #16a085;
            color: white;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            transition: background-color 0.3s ease;
            flex: 1;
            margin: 0 8px;
            text-align: center;
        }

        .btn:hover {
            background-color: #138d75;
        }

        @media (max-width: 500px) {
            .btn-group {
                flex-direction: column;
            }

            .btn {
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>⚠️ Login or Register First</h2>
        <p>Ticket booking is only allowed for registered users.<br>
        Please login or create a new account to proceed.</p>
        <div class="btn-group">
            <a href="login.jsp" class="btn">Login</a>
            <a href="register.jsp" class="btn">Register</a>
        </div>
    </div>
</body>
</html>
