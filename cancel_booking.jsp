<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Cancel Booking - Pawna Lake Camping</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #e0f7fa;
            margin: 0;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 400px;
            max-width: 90vw;
        }
        h2 {
            margin-top: 0;
            text-align: center;
            color: #00796b;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #004d40;
        }
        input[type="email"], input[type="date"] {
            width: 100%;
            padding: 10px 14px;
            margin-bottom: 20px;
            border: 1.8px solid #00796b;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        input[type="email"]:focus, input[type="date"]:focus {
            outline: none;
            border-color: #004d40;
            box-shadow: 0 0 6px #004d40aa;
        }
        input[type="submit"] {
            background-color: #d32f2f;
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            font-size: 1.1rem;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-weight: 700;
        }
        input[type="submit"]:hover {
            background-color: #b71c1c;
        }
        .message {
            margin-top: 25px;
            font-weight: 600;
            text-align: center;
            padding: 10px;
            border-radius: 6px;
        }
        .success {
            color: #2e7d32;
            background-color: #c8e6c9;
            border: 1px solid #2e7d32;
        }
        .error {
            color: #c62828;
            background-color: #ffcdd2;
            border: 1px solid #c62828;
        }
    </style>

    <script>
        function confirmCancel() {
            return confirm("Are you sure you want to cancel and delete this booking permanently?");
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Cancel Booking</h2>
        <form method="post" onsubmit="return confirmCancel();">
            <label for="user_email">Email Address</label>
            <input type="email" id="user_email" name="user_email" required placeholder="Enter your email" />

            <label for="booking_date">Booking Date</label>
            <input type="date" id="booking_date" name="booking_date" required />

            <input type="submit" value="Cancel Booking" />
        </form>

        <%
            String email = request.getParameter("user_email");
            String bookingDate = request.getParameter("booking_date");

            if (email != null && bookingDate != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                    // DELETE instead of UPDATE
                    PreparedStatement ps = conn.prepareStatement(
                        "DELETE FROM bookings WHERE user_email=? AND booking_date=?"
                    );
                    ps.setString(1, email);
                    ps.setString(2, bookingDate);
                    int deleted = ps.executeUpdate();

                    if (deleted > 0) {
        %>
                        <p class="message success">✅ Booking successfully cancelled and deleted.</p>
        <%
                    } else {
        %>
                        <p class="message error">❌ No matching booking found.</p>
        <%
                    }

                    conn.close();
                } catch (Exception e) {
        %>
                    <p class="message error">Error: <%= e.getMessage() %></p>
        <%
                }
            }
        %>
    </div>
</body>
</html>
