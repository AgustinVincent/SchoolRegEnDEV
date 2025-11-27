<%-- Redirect to /login --%>
<%-- response.sendRedirect("login"); --%>


<%--
ChangeLog:
-Updated to Modern View
-Added Search bar
-Added Student First time Authentication
-Added student Password

--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<html>
    <head>
        <title>Welcome - SchoolRegEn</title>
        
    </head>
    <body class="landing-body">

        <div class="overlay"></div>

        <div class="disclaimer-card">

            <h1 class="header1">SchoolRegEn Access Notice</h1>

            <div class="warning-box">
                <strong>WARNING!</strong><br>
                This system is a functional prototype created for academic purposes. 
                Do not submit any real or sensitive personal information (e.g., actual government-issued IDs, financial details, or confidential records).
            </div>

            <p class="subtitle">
                By continuing, you acknowledge that this platform is intended solely for demonstration and testing. 
                All information entered is stored locally and may be deleted at any time. 
                This system is not intended for use in real registration or enrollment processes.
            </p>

            <a href="login" class="btn-agree">Proceed</a>

            <div class="footer-ver">
                SchoolRegEn v0.2
            </div>
        </div>

    </body>
</html>