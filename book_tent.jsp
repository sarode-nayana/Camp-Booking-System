<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login_first.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book Tent - Pawna Lake Camping</title>
</head>
<body>
    <h2>Welcome, <%= user %>! Ready to book your tent?</h2>
    <!-- Booking form will go here -->
</body>
</html>
