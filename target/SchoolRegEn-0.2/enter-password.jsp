<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Enter Password</title>

        <!-- TODO: Transfer all Styles in separate CSS file or folder -->

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">

    </head>
    <body class="login-layout">

        <div class="login-password">
            <img src='images/school-logo.png' alt="School Logo" class="logo">



            <h2 class="login-title">Welcome</h2>
            <p class="subtitle">Hello, <strong><c:out value="${greetingName}" default="User"/></strong></p>
            
            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth" method="post">
                <input type="hidden" name="targetUser" value="${targetUser}"> 
                <input type="hidden" name="studentId" value="${studentId}">
                <div class="input-group">
                    <input class="inputpw" type="password" name="password" placeholder="Password" required autofocus>

                </div>
                <button type="submit" class="button-unlock">Login</button>
            </form>

            <a href="${pageContext.request.contextPath}/login" class="back-link">← Not you? Switch User</a>

            <div class="footer-ver">SchoolRegEn v0.2</div>
        </div>




        <div class="background-panel">
            <div class="overlay"></div>
        </div>

    </body>
</html>