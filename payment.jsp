<%@ page import="java.util.*, java.sql.*" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
%>
<%
String date = request.getParameter("date");
String check_in_time = request.getParameter("check_in_datetime");
String check_out_time = request.getParameter("check_out_datetime");
String mobileNo = request.getParameter("mobileno");

String daysStr = request.getParameter("days");
int days = 1;
try { days = Integer.parseInt(daysStr); } catch(Exception e) {}

String priceStr = request.getParameter("price");
int price = 500;
try { price = Integer.parseInt(priceStr); } catch(Exception e) {}

String personsStr = request.getParameter("persons");
int persons = 1;
try { persons = Integer.parseInt(personsStr); } catch(Exception e) {}

List<String> personNames = new ArrayList<>();
for (int i = 1; i <= persons; i++) {
    String pname = request.getParameter("person_name_" + i);
    if (pname != null && !pname.trim().isEmpty()) {
        personNames.add(pname);
    }
}

String location = request.getParameter("location");
String user_email = request.getParameter("user_email");

int totalAmount = price * persons * days;

String checkInDisplay = check_in_time;
if (check_in_time != null && check_in_time.contains("T")) {
    String[] parts = check_in_time.split("T");
    if (parts.length == 2) checkInDisplay = parts[0] + " at " + parts[1];
}
String checkOutDisplay = check_out_time;
if (check_out_time != null && check_out_time.contains("T")) {
    String[] parts = check_out_time.split("T");
    if (parts.length == 2) checkOutDisplay = parts[0] + " at " + parts[1];
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Booking Confirmation & Payment</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f7f9fc;
            margin: 0;
            padding: 20px;
        }
        .container {
            background: white;
            max-width: 750px;
            margin: auto;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #2E8B57;
            font-weight: 600;
            margin-bottom: 20px;
            text-align: center;
        }
        .details p {
            font-size: 16px;
            margin: 8px 0;
            color: #333;
        }
        .details strong {
            color: #2c3e50;
        }
        ul.person-list {
            padding-left: 20px;
            margin: 10px 0;
        }
        ul.person-list li {
            margin-bottom: 5px;
        }
        .payment-method {
            margin: 20px 0;
        }
        .payment-method label {
            display: block;
            font-size: 15px;
            margin-bottom: 8px;
            cursor: pointer;
        }
        .payment-method input {
            margin-right: 10px;
        }
        .btn {
            background: #2E8B57;
            color: white;
            padding: 12px 25px;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            display: block;
            width: 100%;
            margin-top: 20px;
            transition: background 0.3s ease;
        }
        .btn:hover {
            background: #256e46;
        }
        @media screen and (max-width: 600px) {
            .container {
                padding: 20px;
            }
            h2 {
                font-size: 20px;
            }
        }

        /* Loader overlay styles */
        #paymentLoader {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: rgba(255,255,255,0.9);
            z-index: 9999;
            display: none; /* hidden by default */
            flex-direction: column;
            justify-content: center; /* vertical center */
            align-items: center;     /* horizontal center */
            font-size: 1.5rem;
            color: #2E8B57;
            text-align: center;
            padding: 0 20px;
        }
        #paymentLoader img {
            width: 80px;
            margin-bottom: 20px;
        }

        /* Card No and Pin section styling */
        #cardDetailsSection, #walletPinSection {
            margin-top: 15px;
            display: none;
        }
        label {
            font-weight: 600;
            margin-bottom: 5px;
            display: block;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            box-sizing: border-box;
            font-size: 16px;
        }

        /* Payment status message */
        #paymentStatus {
            display: none;
            margin-bottom: 15px;
            padding: 10px;
            background: #d9f0e7;
            border: 1px solid #2E8B57;
            color: #2E8B57;
            font-weight: 600;
            border-radius: 6px;
        }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const paymentRadios = document.querySelectorAll('input[name="payment_method"]');
            const cardDetailsSection = document.getElementById("cardDetailsSection");
            const walletPinSection = document.getElementById("walletPinSection");
            const cardNoInput = document.getElementById("cardNo");
            const cardPinInput = document.getElementById("cardPin");
            const walletPinInput = document.getElementById("walletPin");

            paymentRadios.forEach(radio => {
                radio.addEventListener("change", () => {
                    if (radio.value === "Card" && radio.checked) {
                        cardDetailsSection.style.display = "block";
                        walletPinSection.style.display = "none";

                        cardNoInput.required = true;
                        cardPinInput.required = true;
                        walletPinInput.required = false;
                        walletPinInput.value = "";
                    } else if ((radio.value === "Google Pay" || radio.value === "PhonePe" || radio.value === "Paytm") && radio.checked) {
                        cardDetailsSection.style.display = "none";
                        walletPinSection.style.display = "block";

                        cardNoInput.required = false;
                        cardNoInput.value = "";

                        cardPinInput.required = false;
                        cardPinInput.value = "";

                        walletPinInput.required = true;
                    } else {
                        cardDetailsSection.style.display = "none";
                        walletPinSection.style.display = "none";

                        cardNoInput.required = false;
                        cardPinInput.required = false;
                        walletPinInput.required = false;

                        cardNoInput.value = "";
                        cardPinInput.value = "";
                        walletPinInput.value = "";
                    }
                });
            });
        });

        function showLoading() {
            const loader = document.getElementById("paymentLoader");
            loader.style.display = "flex";

            const paymentStatus = document.getElementById("paymentStatus");
            const paymentMethod = document.querySelector('input[name="payment_method"]:checked');
            if (paymentMethod) {
                paymentStatus.textContent = "Processing payment via " + paymentMethod.value + "...";
                paymentStatus.style.display = "block";
            }
        }

        function onPaymentSubmit(event) {
            event.preventDefault();

            const paymentMethod = document.querySelector('input[name="payment_method"]:checked');
            if (!paymentMethod) {
                alert("Please select a payment method.");
                return false;
            }

            if (paymentMethod.value === "Card") {
                const cardNo = document.getElementById("cardNo").value.trim();
                const cardPin = document.getElementById("cardPin").value.trim();
                if (!cardNo) {
                    alert("Please enter your Card Number.");
                    return false;
                }
                if (!cardPin) {
                    alert("Please enter your Card PIN / CVV.");
                    return false;
                }
                showLoading();
                event.target.submit();
                return true;
            } else if (paymentMethod.value === "Google Pay" || paymentMethod.value === "PhonePe" || paymentMethod.value === "Paytm") {
                const walletPin = document.getElementById("walletPin").value.trim();
                if (!walletPin) {
                    alert("Please enter your PIN for " + paymentMethod.value + ".");
                    return false;
                }
                showLoading();
                setTimeout(() => {
                    event.target.submit();
                }, 3000);
                return false;
            } else {
                showLoading();
                event.target.submit();
                return true;
            }
        }
    </script>
</head>
<body>

<div class="container">
    <h2>Confirm Your Booking & Payment</h2>

    <div class="details">
        <p><strong>Check-in:</strong> <%= checkInDisplay %></p>
        <p><strong>Check-out:</strong> <%= checkOutDisplay %></p>
        <p><strong>Location:</strong> <%= location != null ? location : "N/A" %></p>
        <p><strong>Days:</strong> <%= days %></p>
        <p><strong>Persons:</strong> <%= persons %></p>
        <p><strong>Price/Person:</strong> ₹<%= price %></p>
        <p><strong>Total Amount:</strong> ₹<%= totalAmount %></p>
        <p><strong>Email:</strong> <%= user_email %></p>
        <p><strong>Mobile No.:</strong> <%= mobileNo %></p>
        <p><strong>Person Names:</strong></p>
        <ul class="person-list">
            <% for (String name : personNames) { %>
                <li><%= name %></li>
            <% } %>
        </ul>
    </div>

    <form method="post" action="confirm_booking.jsp" onsubmit="return onPaymentSubmit(event);">
        <div class="payment-method">
            <label><input type="radio" name="payment_method" value="Card" /> Card</label>
            <label><input type="radio" name="payment_method" value="Google Pay" /> Google Pay</label>
            <label><input type="radio" name="payment_method" value="PhonePe" /> PhonePe</label>
            <label><input type="radio" name="payment_method" value="Paytm" /> Paytm</label>
        </div>

        <div id="cardDetailsSection">
            <label for="cardNo">Card Number:</label>
            <input type="text" id="cardNo" name="cardNo" maxlength="16" pattern="\d{16}" placeholder="16-digit card number" />

            <label for="cardPin">Card PIN / CVV:</label>
            <input type="password" id="cardPin" name="cardPin" maxlength="4" pattern="\d{3,4}" placeholder="3 or 4 digit CVV" />
        </div>

        <div id="walletPinSection">
            <label for="walletPin">Wallet PIN:</label>
            <input type="password" id="walletPin" name="walletPin" maxlength="6" placeholder="Enter your wallet PIN" />
        </div>

        <!-- Hidden fields to pass booking data to confirm_booking.jsp -->
        <input type="hidden" name="date" value="<%= date %>" />
        <input type="hidden" name="check_in_datetime" value="<%= check_in_time %>" />
        <input type="hidden" name="check_out_datetime" value="<%= check_out_time %>" />
        <input type="hidden" name="mobileno" value="<%= mobileNo %>" />
        <input type="hidden" name="days" value="<%= days %>" />
        <input type="hidden" name="price" value="<%= price %>" />
        <input type="hidden" name="persons" value="<%= persons %>" />
        <input type="hidden" name="location" value="<%= location %>" />
        <input type="hidden" name="user_email" value="<%= user_email %>" />
        <% for (int i = 0; i < personNames.size(); i++) { %>
            <input type="hidden" name="person_name_<%= (i+1) %>" value="<%= personNames.get(i) %>" />
        <% } %>

        <button type="submit" class="btn">Pay ₹<%= totalAmount %></button>
    </form>
</div>

<!-- Loading Overlay -->
<div id="paymentLoader">
    <img src="https://i.gifer.com/ZZ5H.gif" alt="Loading..." />
    <div id="paymentStatus">Processing payment...</div>
</div>

</body>
</html>
