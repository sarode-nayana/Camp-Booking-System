<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*,javax.servlet.http.*" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String bookingIdStr = request.getParameter("booking_id");
    if (bookingIdStr == null || bookingIdStr.isEmpty()) {
%>
        <script>
            alert('Invalid booking ID');
            window.location = 'user_dashboard.jsp';
        </script>
<%
        return;
    }

    int bookingId = 0;
    try {
        bookingId = Integer.parseInt(bookingIdStr);
    } catch (NumberFormatException e) {
%>
        <script>
            alert('Invalid booking ID format');
            window.location = 'user_dashboard.jsp';
        </script>
<%
        return;
    }

    boolean refundProcessed = false;
    boolean isValidBooking = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

        // Check if booking exists and belongs to user
        PreparedStatement ps1 = con.prepareStatement(
            "SELECT payment_status FROM bookings WHERE booking_id = ? AND user_email = ?");
        ps1.setInt(1, bookingId);
        ps1.setString(2, userEmail);
        ResultSet rs = ps1.executeQuery();

        if (rs.next()) {
            isValidBooking = true;
            String paymentStatus = rs.getString("payment_status");

            if ("Refunded".equalsIgnoreCase(paymentStatus)) {
                out.println("<script>alert('This booking has already been refunded.'); window.location='user_dashboard.jsp';</script>");
                rs.close();
                ps1.close();
                con.close();
                return;
            } else if ("Paid".equalsIgnoreCase(paymentStatus)) {
                // Process refund
                PreparedStatement ps2 = con.prepareStatement(
                    "UPDATE bookings SET payment_status = 'Refunded' WHERE booking_id = ?");
                ps2.setInt(1, bookingId);
                int updated = ps2.executeUpdate();
                ps2.close();

                if (updated > 0) {
                    refundProcessed = true;
                }
            } else {
                // Not paid, so refund not allowed
                out.println("<script>alert('Refund not allowed. Booking payment is not completed yet.'); window.location='user_dashboard.jsp';</script>");
                rs.close();
                ps1.close();
                con.close();
                return;
            }
        }

        rs.close();
        ps1.close();
        con.close();

    } catch (Exception e) {
        out.println("<script>alert('Error occurred: " + e.getMessage() + "'); window.location='user_dashboard.jsp';</script>");
        return;
    }

    if (!isValidBooking) {
%>
        <script>
            alert("Invalid booking or unauthorized request.");
            window.location = "user_dashboard.jsp";
        </script>
<%
    } else if (refundProcessed) {
%>
        <script>
            alert("Refund processed successfully!");
            window.location = "user_dashboard.jsp";
        </script>
<%
    }
%>
