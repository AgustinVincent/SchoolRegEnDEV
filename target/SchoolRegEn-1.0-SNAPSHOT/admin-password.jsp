<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- #Deprecated, used enter-password.jsp for dual auth# -->

<html>
    <head>
        <title>Admin Login</title>

        <!-- TODO: Transfer all Styles in separate CSS file or folder -->

        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #f4f4f4;
            }
            .login-container {
                padding: 2em;
                background: #fff;
                border-radius: 5px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .error {
                color: red;
                margin-bottom: 1em;
            }
            input[type=password] {
                width: 100%;
                padding: 10px;
                margin-bottom: 1em;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            input[type=submit] {
                width: 100%;
                padding: 10px;
                background-color: #dc3545;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <h2>Admin Password</h2>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
            <form action="auth" method="post">
                <input type="hidden" name="usernameOrId" value="admin">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required autofocus>
                <input type="submit" value="Login as Admin">
            </form>
        </div>
    </body>
</html>
