<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Setup Password</title>

        <!-- TODO: Transfer all Styles in separate CSS file or folder -->

        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Segoe UI', sans-serif;
                height: 100vh;
                display: flex;
                overflow: hidden;
            }

            .login-sidebar {
                width: 400px;
                background-color: #fff;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                padding: 60px;
                box-shadow: 5px 0 15px rgba(0,0,0,0.1);
                z-index: 2;
            }

            .background-panel {
                flex: 1;
                background-image: url('images/school-bg.jpg');
                background-size: cover;
                background-position: center;
                position: relative;
            }
            .overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(3px);
            }

            .logo {
                width: 80px;
                margin-bottom: 20px;
            }
            h2 {
                color: #333;
                margin-bottom: 10px;
            }
            p {
                color: #666;
                margin-bottom: 20px;
                font-size: 0.9em;
                line-height: 1.5;
            }

            input {
                width: 100%;
                padding: 12px;
                margin-bottom: 15px;
                border: 1px solid #ddd;
                border-radius: 6px;
                background-color: #f9f9f9;
            }
            button {
                width: 100%;
                padding: 15px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: bold;
                cursor: pointer;
            }
            button:hover {
                background-color: #0056b3;
            }
            .error {
                color: #dc3545;
                margin-bottom: 15px;
                font-size: 0.9em;
            }
        </style>
    </head>
    <body>

        <div class="login-sidebar">
            <img src='images/school-logo.png' alt="School Logo" class="logo">

            <h2>Account Setup</h2>
            <p>Welcome! As this is your first time logging in, please create a secure password for your account.</p>

            <c:if test="${not empty error}"><div class="error">${error}</div></c:if>

                <form action="${pageContext.request.contextPath}/setup-password" method="post">
                <input type="hidden" name="studentId" value="${studentId}">

                <input type="password" name="password" placeholder="New Password" required>
                <input type="password" name="confirmPassword" placeholder="Confirm Password" required>

                <button type="submit">Set Password & Login</button>
            </form>
        </div>

        <div class="background-panel">
            <div class="overlay"></div>
        </div>

    </body>
</html>