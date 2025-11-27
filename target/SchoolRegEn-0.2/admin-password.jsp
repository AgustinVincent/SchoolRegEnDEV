<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- #Deprecated, used enter-password.jsp for dual auth# -->

<html>
    <head>
        <title>Admin Login</title>

        <!-- TODO: Transfer all Styles in separate CSS file or folder -->

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
        
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
