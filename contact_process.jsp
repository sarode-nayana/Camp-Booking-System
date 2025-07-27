<%@ page import="java.sql.*, java.io.*" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String message = request.getParameter("message");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pawna_lake_camping", "root", "root");

        PreparedStatement ps = con.prepareStatement("INSERT INTO contact_us (name, email, message) VALUES (?, ?, ?)");
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, message);

        int i = ps.executeUpdate();
        if (i > 0) {
%>
            <script>alert("Thank you for contacting us!"); window.location.href='contact.jsp';</script>
<%
        } else {
%>
            <script>alert("Failed to submit. Please try again."); window.location.href='contact.jsp';</script>
<%
        }
        con.close();
    } catch(Exception e) {
        out.println("Error: " + e);
    }
%>
