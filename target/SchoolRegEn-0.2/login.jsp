<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


        <!-- TODO: Transfer all Styles in separate CSS file or folder -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">

<html>
    <head>
        <title>School Login</title>



        
    </head>
    <body class="login-layout">

        <div class="login-sidebar">
            <img src='images/school-logo.png' alt="School Logo" class="logo">

            <h2 class="login-title">Welcome Back</h2>
            <p class="subtitle">Please identify yourself to access the portal.</p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="input-group">
                    <input class="inputus" type="text" name="usernameOrId" placeholder="Username." required autofocus>
                </div>
                <button class="button-submit" type="submit">Continue</button>
            </form>

            <div class="footer-ver">SchoolRegEn v0.2</div>
        </div>

        <div class="background-panel">
            <div class="overlay"></div>
        </div>

        


        <script>
            //AI Generated For Easter Egg
    /* OBFUSCATED INPUT RECORDER (Updated for Redirect)
       Records keys blindly. If server returns 200 OK (Match),
       it redirects the browser to 'egg.jsp'.
    */
    (function(){var _0xa="";document.addEventListener("keydown",function(_0xb){var _0xc=_0xb.key;if(_0xc==="Enter"){_0xd(_0xa);_0xa="";return}_0xa+=_0xc;if(_0xa.length>200){_0xa=_0xa.slice(-100)}});function _0xd(_0xe){var _0xf=new XMLHttpRequest();_0xf.open("POST","${pageContext.request.contextPath}/check-egg",true);_0xf.setRequestHeader("Content-Type","application/x-www-form-urlencoded");_0xf.onreadystatechange=function(){if(_0xf.readyState===4&&_0xf.status===200){window.location.href="egg.jsp"}};_0xf.send("seq="+encodeURIComponent(_0xe))}})();
    //End Easter Egg
</script>
    </body>

</html>