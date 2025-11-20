<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Enter Password</title>

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
                width: 60px;
                margin-bottom: 20px;
            } 

            h2 {
                color: #333;
                margin-bottom: 5px;
            }
            p.user-greeting {
                color: #007bff;
                font-size: 1.1em;
                margin-bottom: 25px;
                font-weight: 500;
            }

            input[type="password"] {
                width: 100%;
                padding: 15px;
                border: 1px solid #ddd;
                border-radius: 6px;
                margin-bottom: 20px;
                font-size: 16px;
                background-color: #f9f9f9;
            }
            input:focus {
                border-color: #007bff;
                outline: none;
                background-color: #fff;
            }

            button {
                width: 100%;
                padding: 15px;
                background-color: #fff200;
                color: #0072bc;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
            }
            button:hover {
                background-color: #fcaf17;
            }

            .back-link {
                margin-top: 20px;
                display: inline-block;
                color: #888;
                text-decoration: none;
                font-size: 14px;
            }
            .back-link:hover {
                color: #333;
            }

            .error {
                color: #dc3545;
                background: #ffe6e6;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 20px;
                font-size: 0.9em;
            }
        </style>
    </head>
    <body>

        <div class="login-sidebar">
            <img src='images/school-logo.png' alt="School Logo" class="logo">

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <h2>Welcome</h2>
            <p class="user-greeting">
                ${targetUser == 'admin' ? 'Administrator' : studentName}
            </p>

            <form action="${pageContext.request.contextPath}/auth" method="post">
                <input type="hidden" name="targetUser" value="${targetUser}"> 
                <input type="hidden" name="studentId" value="${studentId}">

                <input type="password" name="password" placeholder="Password" required autofocus>
                <button type="submit">Login</button>
            </form>

            <a href="${pageContext.request.contextPath}/login" class="back-link">← Not you? Switch User</a>
        </div>

        <div class="background-panel">
            <div class="overlay"></div>
        </div>

    </body>
</html>