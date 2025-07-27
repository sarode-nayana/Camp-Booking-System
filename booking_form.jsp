<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Timestamp" %>

<%
    String location = request.getParameter("location");
    if (location == null || location.trim().isEmpty()) {
        location = "Pawna Lake";  // default location
    }

    String priceStr = request.getParameter("price");
    int price = 500; // default price
    try {
        price = Integer.parseInt(priceStr);
    } catch (Exception e) {
        // keep default
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Booking Form | Pawna Lake Camping</title>

    <!-- Google Fonts for professional look -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <!-- Font Awesome for icons (optional) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Poppins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #74ebd5, #ACB6E5);
            margin: 0; padding: 0; min-height: 100vh;
            display: flex; justify-content: center; align-items: center;
        }
        .form-container {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            width: 100%; max-width: 550px;
            color: #333;
        }
        h2 {
            margin-bottom: 24px;
            font-weight: 700;
            color: #0a74da;
            text-align: center;
            letter-spacing: 1px;
        }
        label {
            display: block;
            margin-top: 16px;
            font-weight: 600;
            font-size: 0.95rem;
            color: #444;
        }
        label i {
            margin-right: 8px;
            color: #0a74da;
        }
        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="number"],
        input[type="datetime-local"],
        select {
            padding: 10px 12px;
            margin-top: 6px;
            width: 100%;
            border: 1.8px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        input:focus, select:focus {
            border-color: #0a74da;
            outline: none;
            background: #f0f8ff;
        }
        input:invalid {
            border-color: red;
            background-color: #ffe6e6;
        }
        .readonly-text {
            background: #f7f9fc;
            padding: 10px 12px;
            margin-top: 6px;
            border-radius: 6px;
            font-weight: 600;
            color: #555;
            border: 1.5px solid #ddd;
        }
        #totalAmountDisplay {
            margin-top: 20px;
            font-size: 1.25rem;
            font-weight: 700;
            color: #0a74da;
            text-align: center;
        }
        input[type="submit"] {
            margin-top: 28px;
            width: 100%;
            background-color: #0a74da;
            color: white;
            font-weight: 700;
            font-size: 1.1rem;
            padding: 14px 0;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        input[type="submit"]:hover {
            background-color: #065bb5;
        }

        /* Responsive: group datetime inputs side by side on wide screens */
        .datetime-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        .datetime-group > div {
            flex: 1 1 48%;
            min-width: 140px;
        }

        /* Responsive for smaller devices */
        @media (max-width: 600px) {
            .form-container {
                padding: 20px;
                max-width: 90%;
            }
            h2 {
                font-size: 1.5rem;
            }
            input, select {
                font-size: 0.95rem;
            }
            .datetime-group {
                flex-direction: column;
            }
            .datetime-group > div {
                flex: 1 1 100%;
            }
        }
    </style>

    <script>
        const price = <%= price %>;

        function updateTotalAmount() {
            const persons = parseInt(document.getElementById("personsInput").value) || 1;
            const days = parseInt(document.getElementById("daysInput").value) || 1;
            const total = price * persons * days;

            document.getElementById("totalAmountDisplay").textContent = "Total Amount: ₹" + total;
            document.getElementById("totalPriceInput").value = total;

            generatePersonNameFields(persons);
        }

        function generatePersonNameFields(count) {
            const container = document.getElementById("personNamesContainer");
            container.innerHTML = "";
            for (let i = 1; i <= count; i++) {
                const label = document.createElement("label");
                label.textContent = "Person " + i + " Name:";
                const input = document.createElement("input");
                input.type = "text";
                input.name = "person_name_" + i;
                input.placeholder = "Enter name of person " + i;
                input.required = true;
                input.setAttribute("aria-label", "Person " + i + " Name");

                container.appendChild(label);
                container.appendChild(input);
            }
        }

        function updateDatetimeDisplays() {
            const checkIn = document.getElementById("checkInDatetime").value;
            const checkOut = document.getElementById("checkOutDatetime").value;

            document.getElementById("checkInDisplay").textContent = checkIn ? "Selected Check-in: " + checkIn.replace("T", " ") : "";
            document.getElementById("checkOutDisplay").textContent = checkOut ? "Selected Check-out: " + checkOut.replace("T", " ") : "";
        }

        function updateStayDuration() {
            const checkInStr = document.getElementById("checkInDatetime").value;
            const checkOutStr = document.getElementById("checkOutDatetime").value;
            const daysSelect = document.getElementById("daysInput");

            if (checkInStr && checkOutStr) {
                const checkIn = new Date(checkInStr);
                const checkOut = new Date(checkOutStr);
                if (checkOut > checkIn) {
                    const diffDays = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
                    daysSelect.value = diffDays > 7 ? 7 : diffDays;
                    updateTotalAmount();
                }
            }
        }

        function validateForm() {
            const persons = parseInt(document.getElementById("personsInput").value) || 1;
            for (let i = 1; i <= persons; i++) {
                const nameInput = document.forms["paymentForm"]["person_name_" + i];
                if (!nameInput.value.trim()) {
                    alert("Please enter name for person " + i);
                    nameInput.focus();
                    return false;
                }
            }

            const checkIn = document.getElementById("checkInDatetime").value;
            const checkOut = document.getElementById("checkOutDatetime").value;
            if (checkOut <= checkIn) {
                alert("Check-out must be after check-in.");
                return false;
            }

            return confirm("Do you want to proceed with the payment?");
        }

        window.onload = function () {
            const now = new Date();
            const isoStr = now.toISOString().slice(0, 16);
            document.getElementById("checkInDatetime").setAttribute("min", isoStr);
            document.getElementById("checkOutDatetime").setAttribute("min", isoStr);

            updateTotalAmount();
            updateDatetimeDisplays();

            document.getElementById("personsInput").addEventListener("input", updateTotalAmount);
            document.getElementById("daysInput").addEventListener("change", updateTotalAmount);
            document.getElementById("checkInDatetime").addEventListener("input", () => {
                updateDatetimeDisplays();
                updateStayDuration();
            });
            document.getElementById("checkOutDatetime").addEventListener("input", () => {
                updateDatetimeDisplays();
                updateStayDuration();
            });
        };
    </script>
</head>
<body>
    <div class="form-container" role="main" aria-label="Booking and Payment Form">
        <h2><i class="fa fa-campground"></i> Booking & Payment Details</h2>
        
        <form name="paymentForm" action="payment.jsp" method="post" onsubmit="return validateForm();" novalidate>
            <!-- Readonly Location -->
            <label for="location">Location:</label>
            <input type="text" id="location" name="location" value="<%= location %>" readonly aria-readonly="true" class="readonly-text" />

            <!-- Price per person per day (hidden but readable) -->
            <label>Price (per person per day):</label>
            <div class="readonly-text">₹<%= price %></div>
            <input type="hidden" name="price" value="<%= price %>" />

            <!-- Persons count -->
            <label for="personsInput"><i class="fa fa-users"></i> Number of Persons:</label>
            <input type="number" id="personsInput" name="persons" min="1" max="20" value="1" required aria-describedby="personsHelp" />

            <!-- Stay days -->
            <label for="daysInput"><i class="fa fa-calendar-day"></i> Number of Days:</label>
            <select id="daysInput" name="days" required aria-describedby="daysHelp">
                <option value="1" selected>1 day</option>
                <option value="2">2 days</option>
                <option value="3">3 days</option>
                <option value="4">4 days</option>
                <option value="5">5 days</option>
                <option value="6">6 days</option>
                <option value="7">7 days</option>
            </select>

            <!-- Camping Check-in and Check-out -->
            <div class="datetime-group" aria-label="Check-in and Check-out Date and Time">
                <div>
                    <label for="checkInDatetime"><i class="fa fa-sign-in-alt"></i> Check-in Date & Time:</label>
                    <input type="datetime-local" id="checkInDatetime" name="check_in_datetime" required />
                </div>
                <div>
                    <label for="checkOutDatetime"><i class="fa fa-sign-out-alt"></i> Check-out Date & Time:</label>
                    <input type="datetime-local" id="checkOutDatetime" name="check_out_datetime" required />
                </div>
            </div>

            <div aria-live="polite" style="font-size:0.9rem; color:#555; margin-top:4px;">
                <span id="checkInDisplay"></span><br/>
                <span id="checkOutDisplay"></span>
            </div>

            <!-- Dynamic person names -->
            <div id="personNamesContainer" aria-live="polite" aria-relevant="additions" style="margin-top: 20px;">
                <!-- JavaScript fills person name fields here -->
            </div>

            <!-- Total Amount -->
            <div id="totalAmountDisplay" aria-live="polite" aria-atomic="true">Total Amount: ₹<%= price %></div>
            <input type="hidden" id="totalPriceInput" name="total_price" value="<%= price %>" />

            <!-- Contact Details -->
            <label for="userName"><i class="fa fa-user"></i> Your Name:</label>
            <input type="text" id="userName" name="user_name" placeholder="Your full name" required aria-label="Your full name" />

            <label for="userEmail"><i class="fa fa-envelope"></i> Email:</label>
            <input type="email" id="userEmail" name="user_email" placeholder="you@example.com" required aria-label="Your email address" />

            <label for="userPhone"><i class="fa fa-phone"></i> Phone Number:</label>
            <input type="tel" id="userPhone" name="mobileno" placeholder="+91 9876543210" pattern="^\+?\d{10,15}$" required aria-label="Your phone number" />

            <input type="submit" value="Proceed to Payment" aria-label="Submit booking and proceed to payment" />
        </form>
    </div>
</body>
</html>
