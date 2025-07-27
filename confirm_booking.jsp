<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*, java.sql.Timestamp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String location = request.getParameter("location");
    String user_email = request.getParameter("user_email");
    String priceStr = request.getParameter("price");
    String cardno = request.getParameter("cardno");
    String cvv = request.getParameter("cvv");
    String checkInDateTimeStr = request.getParameter("check_in_datetime");
    String checkOutDateTimeStr = request.getParameter("check_out_datetime");
    String daysStr = request.getParameter("days");
    String personsStr = request.getParameter("persons");
    String paymentMethod = request.getParameter("payment_method");
    String mobile_No = request.getParameter("mobileno");

    Timestamp booking_date = new Timestamp(System.currentTimeMillis());

    boolean success = false;
    String message = "";
    int bookingId = 0;
    String bookingStatus = "Confirmed";
    Set<String> uniquePersonNames = new LinkedHashSet<>();
    double totalAmount = 0.0;
    String formattedDate = "";

    if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
        message = "Payment method is missing!";
    } else {
        try {
            int days = Integer.parseInt(daysStr != null ? daysStr : "1");
            int persons = Integer.parseInt(personsStr != null ? personsStr : "1");
            int pricePerPerson = Integer.parseInt(priceStr != null ? priceStr : "0");

            totalAmount = pricePerPerson * persons * days;

            SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            java.util.Date checkInDate = isoFormat.parse(checkInDateTimeStr);
            java.util.Date checkOutDate = isoFormat.parse(checkOutDateTimeStr);
            Timestamp checkInTimestamp = new Timestamp(checkInDate.getTime());
            Timestamp checkOutTimestamp = new Timestamp(checkOutDate.getTime());

            String checkInTimeStr = new SimpleDateFormat("HH:mm:ss").format(checkInDate);
            String checkOutTimeStr = new SimpleDateFormat("HH:mm:ss").format(checkOutDate);
            formattedDate = new SimpleDateFormat("yyyy-MM-dd").format(checkInDate);
            String createdAt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());

            for (int i = 1; i <= persons; i++) {
                String pname = request.getParameter("person_name_" + i);
                if (pname != null && !pname.trim().isEmpty()) {
                    uniquePersonNames.add(pname.trim());
                }
            }

            // fallback if no person names provided
            if (uniquePersonNames.isEmpty()) {
                uniquePersonNames.add("Unknown Person");
            }

            int distinctPersonsCount = uniquePersonNames.size();
            String person_names = String.join(", ", uniquePersonNames);

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root")) {
                String bookingSQL = "INSERT INTO bookings (location, user_email, mobileno, booking_date, total_persons, price_per_person, total_amount, booking_status, created_at, payment_status, refund_status, persons_name, check_in, check_out, check_in_time, check_out_time, days, camping_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement ps = con.prepareStatement(bookingSQL, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, location);
                    ps.setString(2, user_email);
                    ps.setString(3, mobile_No);
                    ps.setTimestamp(4, booking_date);
                    ps.setInt(5, distinctPersonsCount);
                    ps.setInt(6, pricePerPerson);
                    ps.setDouble(7, totalAmount);
                    ps.setString(8, bookingStatus);
                    ps.setString(9, createdAt);
                    ps.setString(10, paymentMethod);
                    ps.setString(11, "Not Refunded");
                    ps.setString(12, person_names);
                    ps.setTimestamp(13, checkInTimestamp);
                    ps.setTimestamp(14, checkOutTimestamp);
                    ps.setTime(15, Time.valueOf(checkInTimeStr));
                    ps.setTime(16, Time.valueOf(checkOutTimeStr));
                    ps.setInt(17, days);
                    ps.setString(18, formattedDate);

                    int rows = ps.executeUpdate();

                    if (rows > 0) {
                        try (ResultSet rs = ps.getGeneratedKeys()) {
                            if (rs.next()) {
                                bookingId = rs.getInt(1);
                            }
                        }

                        String paymentSQL = "INSERT INTO payments (booking_id, amount_paid, payment_mode, user_email, status, cardholder_name, card_number, cvv) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement ps2 = con.prepareStatement(paymentSQL)) {
                            ps2.setInt(1, bookingId);
                            ps2.setDouble(2, totalAmount);
                            ps2.setString(3, paymentMethod);
                            ps2.setString(4, user_email);
                            ps2.setString(5, "Success");
                            ps2.setString(6, user_email);
                            ps2.setString(7, cardno);
                            ps2.setString(8, cvv);

                            int rows2 = ps2.executeUpdate();
                            success = rows2 > 0;
                            message = success ? "Payment successful and booking confirmed!" : "Booking saved but payment failed.";
                        }
                    } else {
                        message = "Booking failed.";
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }

    StringBuilder ticketContent = new StringBuilder();
    if (success) {
        ticketContent.append("------ Camping Ticket ------\n")
                .append("Booking ID: ").append(bookingId).append("\n")
                .append("Location: ").append(location).append("\n")
                .append("Email: ").append(user_email).append("\n")
                .append("Mobile No: ").append(mobile_No).append("\n")
                .append("Booking Date: ").append(new SimpleDateFormat("yyyy-MM-dd").format(booking_date)).append("\n")
                .append("Check-in Time: ").append(checkInDateTimeStr.replace("T", " ")).append("\n")
                .append("Check-out Time: ").append(checkOutDateTimeStr.replace("T", " ")).append("\n")
                .append("Total Persons: ").append(uniquePersonNames.size()).append("\n");

        int idx = 1;
        for (String pname : uniquePersonNames) {
            ticketContent.append("Person ").append(idx++).append(": ").append(pname).append("\n");
        }

        ticketContent.append("Total Amount: ₹").append(totalAmount).append("\n")
                .append("Payment Mode: ").append(paymentMethod).append("\n")
                .append("Booking Status: ").append(bookingStatus).append("\n")
                .append("----------------------------\n");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Confirmation</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(to right, #fdfbfb, #ebedee);
            color: #2c3e50;
            padding: 40px 20px;
        }
        .container {
            max-width: 700px;
            margin: auto;
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.08);
        }
        h2 {
            text-align: center;
            font-size: 26px;
            color: <%= success ? "#2ecc71" : "#e74c3c" %>;
            margin-bottom: 20px;
        }
        .message {
            text-align: center;
            font-size: 16px;
            margin-bottom: 25px;
        }
        .ticket-box {
            background-color: #f8f9fa;
            padding: 20px;
            border-left: 5px solid #3498db;
            border-radius: 8px;
            font-family: 'Courier New', Courier, monospace;
            font-size: 15px;
            line-height: 1.6;
            white-space: pre-wrap;
        }
        .btn {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 24px;
            font-size: 15px;
            font-weight: 600;
            color: white;
            background-color: #2980b9;
            border-radius: 6px;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }
        .btn:hover {
            background-color: #1f6391;
        }
        .center {
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h2><%= success ? "Booking and Payment Successful!" : "Payment Failed!" %></h2>
    <p class="message"><%= message %></p>

    <% if (success) { %>
        <p>Your Camping Ticket:</p>
        <div class="ticket-box"><%= ticketContent.toString() %></div>
        <div class="center">
            <a class="btn" href="download_ticket.jsp?booking_id=<%= bookingId %>">Download Ticket</a>
        </div>
    <% } else { %>
        <div class="center">
            <a class="btn" href="payment.jsp">Try Again</a>
        </div>
    <% } %>
</div>
</body>
</html>
