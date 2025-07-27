<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%
    // Retrieve session attributes safely
    String userEmail = (String) session.getAttribute("userEmail");

    // Initialize variables for form submission
    String message = "";
    String msgClass = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");

        // Basic server-side validation
        if (email == null || email.trim().isEmpty() ||
            subject == null || subject.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {

            message = "Please fill in all required fields.";
            msgClass = "error";
        } else {
            // Placeholder: Save support request to DB or send email here

            message = "Thank you, " + (userEmail != null ? userEmail : email) + ". Your support request has been submitted.";
            msgClass = "success";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Contact Support | Pawna Lake Camping</title>

    <style>
        :root {
            --primary-color: #117a65;
            --primary-color-dark: #0e6651;
            --error-color-bg: #f8d7da;
            --error-color-text: #721c24;
            --error-color-border: #f5c6cb;
            --success-color-bg: #d4edda;
            --success-color-text: #155724;
            --success-color-border: #c3e6cb;
            --font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            --border-radius: 0.5rem;
            --transition-speed: 0.3s;
        }
        /* Reset and base */
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            font-family: var(--font-family);
            background-color: #f7fafc;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            padding: 3rem 1rem;
            color: #2c3e50;
        }

        main.contact-container {
            background-color: #fff;
            max-width: 480px;
            width: 100%;
            padding: 2.5rem 2rem;
            border-radius: var(--border-radius);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: box-shadow var(--transition-speed) ease;
        }
        main.contact-container:hover,
        main.contact-container:focus-within {
            box-shadow: 0 12px 35px rgba(0,0,0,0.15);
        }
        h1 {
            font-weight: 700;
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
            letter-spacing: 0.05em;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: 600;
            margin-bottom: 0.3rem;
            color: #34495e;
            user-select: none;
        }
        input[type="email"],
        input[type="text"],
        textarea {
            padding: 0.85rem 1rem;
            margin-bottom: 1.25rem;
            border: 2px solid #d1d5db;
            border-radius: var(--border-radius);
            font-size: 1rem;
            font-family: inherit;
            color: #2c3e50;
            transition: border-color var(--transition-speed) ease;
            resize: vertical;
        }
        input[type="email"]:focus,
        input[type="text"]:focus,
        textarea:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 5px var(--primary-color);
        }

        textarea {
            min-height: 120px;
            line-height: 1.5;
        }

        input[type="submit"] {
            padding: 1rem 0;
            background-color: var(--primary-color);
            color: #fff;
            font-weight: 700;
            font-size: 1.1rem;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            letter-spacing: 0.05em;
            transition: background-color var(--transition-speed) ease;
        }
        input[type="submit"]:hover,
        input[type="submit"]:focus {
            background-color: var(--primary-color-dark);
            outline: none;
        }

        .message {
            margin-bottom: 1.5rem;
            padding: 1rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            text-align: center;
            font-size: 1rem;
        }
        .success {
            background-color: var(--success-color-bg);
            color: var(--success-color-text);
            border: 2px solid var(--success-color-border);
        }
        .error {
            background-color: var(--error-color-bg);
            color: var(--error-color-text);
            border: 2px solid var(--error-color-border);
        }

        /* Responsive */
        @media (max-width: 500px) {
            main.contact-container {
                padding: 2rem 1.5rem;
            }
            h1 {
                font-size: 1.75rem;
            }
        }
    </style>
</head>
<body>
    <main class="contact-container" role="main" aria-labelledby="contactSupportTitle">
        <h1 id="contactSupportTitle">Contact Support</h1>

        <% if (!message.isEmpty()) { %>
            <div role="alert" class="message <%= msgClass %>"><%= message %></div>
        <% } %>

        <form method="post" action="contact_support.jsp" novalidate aria-describedby="formInstructions">
            <p id="formInstructions" class="sr-only">
                Fields marked with an asterisk (*) are required.
            </p>

            <label for="email">Email <span aria-hidden="true" style="color:#e74c3c;">*</span></label>
            <input
                type="email"
                id="email"
                name="email"
                value="<%= (userEmail != null) ? userEmail : "" %>"
                required
                autocomplete="email"
                aria-required="true"
                aria-describedby="emailHelp"
                placeholder="your.email@example.com"
            >
            <small id="emailHelp" class="sr-only">Enter your email address.</small>

            <label for="subject">Subject <span aria-hidden="true" style="color:#e74c3c;">*</span></label>
            <input
                type="text"
                id="subject"
                name="subject"
                required
                aria-required="true"
                maxlength="150"
                placeholder="Briefly describe your issue"
            >

            <label for="description">Description <span aria-hidden="true" style="color:#e74c3c;">*</span></label>
            <textarea
                id="description"
                name="description"
                required
                aria-required="true"
                maxlength="2000"
                placeholder="Provide detailed information about your issue or query..."
            ></textarea>

            <input type="submit" value="Submit">
        </form>
    </main>

    <style>
        /* Accessibility helper */
        .sr-only {
            position: absolute !important;
            width: 1px !important;
            height: 1px !important;
            padding: 0 !important;
            margin: -1px !important;
            overflow: hidden !important;
            clip: rect(0,0,0,0) !important;
            border: 0 !important;
        }
    </style>
</body>
</html>
