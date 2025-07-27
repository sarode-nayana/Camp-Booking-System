<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int bookingId = 0;
    try {
        bookingId = Integer.parseInt(request.getParameter("booking_id"));

        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root")) {

            // Verify booking ownership
            try (PreparedStatement checkOwner = con.prepareStatement("SELECT * FROM bookings WHERE booking_id = ? AND user_email = ?")) {
                checkOwner.setInt(1, bookingId);
                checkOwner.setString(2, userEmail);
                try (ResultSet ownerRs = checkOwner.executeQuery()) {
                    if (!ownerRs.next()) {
%>
                        <script>
                            alert("Invalid booking or you are not authorized.");
                            window.location = "my_bookings.jsp";
                        </script>
<%
                        return;
                    }
                }
            }

            // Check if refund request already submitted
            try (PreparedStatement check = con.prepareStatement("SELECT * FROM refund_requests WHERE booking_id = ?")) {
                check.setInt(1, bookingId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
%>
                        <script>
                            alert("Refund request already submitted for this booking.");
                            window.location = "my_bookings.jsp";
                        </script>
<%
                        return;
                    }
                }
            }

            // Insert refund request
            try (PreparedStatement ps = con.prepareStatement("INSERT INTO refund_requests (user_email, booking_id, request_date, status) VALUES (?, ?, NOW(), 'Pending')")) {
                ps.setString(1, userEmail);
                ps.setInt(2, bookingId);
                ps.executeUpdate();
            }
%>
            <script>
                alert("Refund request sent successfully!");
                window.location = "my_bookings.jsp";
            </script>
<%
        }
    } catch (Exception e) {
%>
    <p style="color:red;">Error: <%= e.getMessage() %></p>
<%
    }
%>
