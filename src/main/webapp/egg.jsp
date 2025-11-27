<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // 1. PREVENT BROWSER CACHING (The Fix)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    // 2. SECURITY CHECK
    // Explicitly check for the Boolean TRUE value
    if (session.getAttribute("egg_unlocked") == null || !((Boolean)session.getAttribute("egg_unlocked"))) {
        response.sendRedirect("login");
        return;
    }
%>
<html>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: 'Segoe UI', 'Roboto', Helvetica, Arial, sans-serif;
            height: 100vh;
            display: flex;
            overflow: hidden;
        }


        .login-sidebar {
            width: 400px;
            background-color: #ffffff;
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
            margin-bottom: 30px;
        }

        h2 {
            color: #333;
            margin-bottom: 10px;
            font-weight: 600;
        }
        p.subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 0.95em;
        }

        .input-group {
            margin-bottom: 20px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 15px;
            border: 1px solid #0072bc;
            border-radius: 6px;
            font-size: 16px;
            background-color: #f9f9f9;
            transition: 0.3s;
        }
        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #007bff;
            background-color: #fff;
            outline: none;
        }

        button {
            width: 100%;
            padding: 15px;
            background-color: #0072bc;
            color: #fff200;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }
        button:hover {
            background-color: #024d7d;
        }

        .error {
            color: #dc3545;
            background: #ffe6e6;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 0.9em;
        }

        .footer-ver {
            margin-top: auto;
            font-size: 12px;
            color: #aaa;
            text-align: center;
            padding-top: 20px;
        }

        .egg-modal {
            display: flex; 
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.70); 
            backdrop-filter: blur(5px);
            justify-content: center;
            align-items: center;
        }

        .egg-content {
            background: #1a1a1a; 
            color: #00ff00; 
            font-family: 'Courier New', Courier, monospace;
            padding: 40px;
            border-radius: 10px;
            border: 2px solid #00ff00;
            text-align: center;
            width: 500px;
            box-shadow: 0 0 20px #00ff00;
            animation: popIn 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
        }

        @keyframes popIn {
            from {
                transform: scale(0.5);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .egg-head {
            color: #00ff00;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 2px;
            border-bottom: 1px dashed #00ff00;
            padding-bottom: 10px;
        }
        .egg-content ul {
            list-style: none;
            padding: 0;
        }
        .egg-content li {
            font-size: 18px;
            margin: 10px 0;
        }
        .egg-close {
            margin-top: 20px;
            background: transparent;
            border: 1px solid #00ff00;
            color: #00ff00;
            padding: 10px 20px;
            cursor: pointer;
        }
        .egg-close:hover {
            background: #00ff00;
            color: black;
        }
    </style>
    <head>
        <title>School Login</title>

        <!-- TODO: Transfer all Styles in separate CSS file or folder -->

        <!--  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">  -->

    </head>
    <body class="login-layout">

        <div class="login-sidebar">
            <img src='images/school-logo.png' alt="School Logo" class="logo">

            <h2 class="login-title">Welcome Back</h2>
            <p class="subtitle">Please identify yourself to access the portal.</p>

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="">
                <div class="input-group">
                    <input class="inputus" type="disable" name="usernameOrId" placeholder="Username." required autofocus>
                </div>
                <button class="button-submit" type="submit">Continue</button>
            </form>

            <div class="footer-ver">SchoolRegEn v0.2</div>
        </div>

        <div class="background-panel">
            <div class="overlay"></div>
        </div>

        <div id="konamiModal" class="egg-modal">
            <div class="egg-content">
                <h1 class="egg-head">System Architects</h1>
                <p>Developed with ♡ and Java by:</p>
                <br>
                <ul class="egg-ul" id="devList">
                    <li class="egg li">Vincent Ian Agustin</li>
                    <li class="egg li">Daniela Dorego</li>
                    <li class="egg li">Rhesyl Arobo</li>
                    <li class="egg li">Tresia Kyle Barredo</li>

                </ul>
                <br>
                <p style="font-size: 12px; opacity: 0.7;">"It's not a bug, it's a feature."</p>
                <form action="login" method="get">
                    <button type="submit" class="egg-close">EXIT CONSOLE</button>
                </form>
            </div>
        </div>


    </body>

</html>