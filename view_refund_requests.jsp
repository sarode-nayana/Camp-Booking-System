<%@ page import="java.sql.*" %>
<%
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdbname", "root", "");
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM refund_requests WHERE status='Pending'");
%>

<h2>Refund Requests</h2>
<table border="1">
<tr>
    <th>Request ID</th>
    <th>User Email</th>
    <th>Booking ID</th>
    <th>Request Date</th>
    <th>Status</th>
    <th>Action</th>
</tr>
<%
while(rs.next()){
%>
<tr>
    <td><%=rs.getInt("request_id")%></td>
    <td><%=rs.getString("user_email")%></td>
    <td><%=rs.getInt("booking_id")%></td>
    <td><%=rs.getString("request_date")%></td>
    <td><%=rs.getString("status")%></td>
    <td>
        <form action="update_refund_status.jsp" method="post" style="display:inline;">
            <input type="hidden" name="request_id" value="<%=rs.getInt("request_id")%>">
            <input type="submit" name="action" value="Approve">
            <input type="submit" name="action" value="Reject">
        </form>
    </td>
</tr>
<% } %>
</table>
