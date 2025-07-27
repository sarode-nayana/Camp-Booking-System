<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Request Refund</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        .btn { padding: 8px 15px; background: #e74c3c; color: white; border: none; cursor: pointer; border-radius: 5px; }
        .btn:hover { background: #c0392b; }
    </style>
</head>
<body>
    <h2>Your Bookings Eligible for Refund</h2>
    <form action="refund_booking.jsp" method="post">
        <table>
            <tr>
                <th>Select</th>
                <th>Booking ID</th>
                <th>Location</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Status</th>
                
            </tr>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root")) {
                        String sql = "SELECT booking_id, location, check_in, check_out, booking_status, refund_status FROM bookings WHERE user_email = ? AND booking_status = 'Confirmed' AND refund_status = 'Not Refunded'";
                        try (PreparedStatement ps = con.prepareStatement(sql)) {
                            ps.setString(1, userEmail);
                            try (ResultSet rs = ps.executeQuery()) {
                                boolean hasBookings = false;
                                while (rs.next()) {
                                    hasBookings = true;
            %>
            <tr>
                <td><input type="radio" name="booking_id" value="<%= rs.getInt("booking_id") %>" required></td>
                <td><%= rs.getInt("booking_id") %></td>
                <td><%= rs.getString("location") %></td>
                <td><%= rs.getTimestamp("check_in") %></td>
                <td><%= rs.getTimestamp("check_out") %></td>
                <td><%= rs.getString("booking_status") %></td>
                
            </tr>
            <%
                                }
                                if (!hasBookings) {
            %>
            <tr><td colspan="7">No bookings eligible for refund.</td></tr>
            <%
                                }
                            }
                        }
                    }
                } catch (Exception e) {
            %>
            <tr><td colspan="7" style="color:red;">Error loading bookings: <%= e.getMessage() %></td></tr>
            <%
                }
            %>
        </table>
        <br>
        <input type="submit" value="Request Refund" class="btn" />
    </form>
</body>
</html>
