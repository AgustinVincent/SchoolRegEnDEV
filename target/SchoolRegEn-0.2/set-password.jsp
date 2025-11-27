<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- TODO: Transfer all Styles in separate CSS file or folder -->

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<html>
    <head>
        <title>Setup Password</title>

        

       
    </head>
    <body class="login-layout">

        <div class="login-sidebar">
            <img src='images/school-logo.png' alt="School Logo" class="logo">

            <h2 class="login-title">Account Setup</h2>
            <p class="subtitle">Welcome! As this is your first time logging in, please create a secure password for your account.</p>

            <c:if test="${not empty error}"><div class="error-msg">${error}</div></c:if>

                <form action="${pageContext.request.contextPath}/setup-password" method="post">
                <input class="inputsp" type="hidden" name="userId" value="${userId}">

                <div class="input-groups">
                <input class="inputsp" type="password" name="password" placeholder="New Password" required>
                <input class="inputsp" type="password" name="confirmPassword" placeholder="Confirm Password" required>
                </div>
                <button class="button-submit" type="submit">Set Password & Login</button>
            </form>
                
                <div class="footer-ver">SchoolRegEn v0.2</div>
        </div>

        <div class="background-panel">
            <div class="overlay"></div>
        </div>

    </body>
</html>