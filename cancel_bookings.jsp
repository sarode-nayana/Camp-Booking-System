<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Cancel Bookings - Pawna Lake Camping</title>
    <style>
        /* Reset and base styling */
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; padding: 0;
            background: #f7f9fc;
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        header, footer {
            background-color: #2c974b;
            color: #fff;
            text-align: center;
            padding: 1.5rem 1rem;
            font-size: 1.6rem;
            font-weight: 700;
            box-shadow: 0 2px 5px rgba(44,151,75,0.4);
        }
        main {
            flex-grow: 1;
            padding: 2rem;
            max-width: 1000px;
            margin: 2rem auto;
            width: 90%;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .welcome-msg {
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
            color: #2c974b;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 1.5rem;
            font-size: 1rem;
        }
        thead tr {
            background-color: #2c974b;
            color: white;
        }
        th, td {
            padding: 0.8rem 1rem;
            border: 1px solid #ddd;
            text-align: center;
        }
        tbody tr:hover {
            background-color: #e9f4e9;
        }
        .cancel-button {
            background-color: #d9534f;
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            font-weight: 600;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-size: 1rem;
        }
        .cancel-button:hover, .cancel-button:focus {
            background-color: #c9302c;
            outline: none;
        }
        .no-bookings, .login-message {
            font-size: 1.2rem;
            text-align: center;
            margin-top: 3rem;
            color: #666;
        }
        .login-message a {
            color: #2c974b;
            font-weight: 600;
            text-decoration: none;
        }
        .login-message a:hover {
            text-decoration: underline;
        }
        /* Responsive */
        @media (max-width: 700px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }
            thead tr {
                display: none;
            }
            tbody tr {
                margin-bottom: 1.5rem;
                border: 1px solid #ccc;
                border-radius: 8px;
                padding: 1rem;
            }
            tbody td {
                border: none;
                padding: 0.4rem 0;
                position: relative;
                padding-left: 50%;
                text-align: left;
            }
            tbody td::before {
                content: attr(data-label);
                position: absolute;
                left: 1rem;
                font-weight: 600;
                color: #2c974b;
                white-space: nowrap;
            }
            .cancel-button {
                width: 100%;
                padding: 0.7rem;
                font-size: 1.1rem;
            }
        }
    </style>
    <script>
        function confirmCancel() {
            return confirm('Are you sure you want to cancel this booking?');
        }
    </script>
</head>
<body>
    <header>
        Pawna Lake Camping - Cancel Bookings
    </header>
    <main>
        <div class="welcome-msg">
            Welcome, <%= (userEmail != null) ? userEmail : "Guest" %>
        </div>

        <%
            if (userEmail == null) {
        %>
            <div class="login-message">
                You are not logged in. Please <a href="login.jsp">login here</a> to manage your bookings.
            </div>
        <%
            } else {
                Connection con = null;
                PreparedStatement pst = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

                    String sql = "SELECT booking_id, location, booking_date, price_per_person, total_amount, booking_status " +
                                 "FROM bookings WHERE user_email = ? AND booking_status = 'Confirmed' ORDER BY booking_date DESC";
                    pst = con.prepareStatement(sql);
                    pst.setString(1, userEmail);
                    rs = pst.executeQuery();

                    if (!rs.isBeforeFirst()) {
        %>
                        <p class="no-bookings">You have no confirmed bookings to cancel.</p>
        <%
                    } else {
        %>
                        <table aria-label="Confirmed bookings for cancellation">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Location</th>
                                    <th>Booking Date</th>
                                    <th>Price per Person</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Cancel Booking</th>
                                </tr>
                            </thead>
                            <tbody>
        <%
                        while (rs.next()) {
                            int bookingId = rs.getInt("booking_id");
                            String location = rs.getString("location");
                            Date bookingDate = rs.getDate("booking_date");
                            int pricePerPerson = rs.getInt("price_per_person");
                            int totalAmount = rs.getInt("total_amount");
                            String status = rs.getString("booking_status");
        %>
                                <tr>
                                    <td data-label="Booking ID"><%= bookingId %></td>
                                    <td data-label="Location"><%= location %></td>
                                    <td data-label="Booking Date"><%= bookingDate %></td>
                                    <td data-label="Price per Person">₹<%= pricePerPerson %></td>
                                    <td data-label="Total Amount">₹<%= totalAmount %></td>
                                    <td data-label="Status"><%= status %></td>
                                    <td data-label="Cancel Booking">
                                        <form action="cancelBooking.jsp" method="post" onsubmit="return confirmCancel();">
                                            <input type="hidden" name="booking_id" value="<%= bookingId %>"/>
                                            <button type="submit" class="cancel-button" aria-label="Cancel booking <%= bookingId %>">Cancel</button>
                                        </form>
                                    </td>
                                </tr>
        <%
                        }
        %>
                            </tbody>
                        </table>
        <%
                    }
                } catch(Exception e) {
                    out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                    if (pst != null) try { pst.close(); } catch (Exception ignored) {}
                    if (con != null) try { con.close(); } catch (Exception ignored) {}
                }
            }
        %>
    </main>
    <footer>
        &copy; <%= java.time.Year.now() %> Pawna Lake Camping. All rights reserved.
    </footer>
</body>
</html>
