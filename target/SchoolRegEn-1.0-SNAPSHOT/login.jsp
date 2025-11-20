<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>School Login</title>
    
    <!-- TODO: Transfer all Styles in separate CSS file or folder -->
    
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
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
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.3); 
            backdrop-filter: blur(3px); 
        }

        
        .logo {
            width: 80px; 
            margin-bottom: 30px;
        }
        
        h2 { color: #333; margin-bottom: 10px; font-weight: 600; }
        p.subtitle { color: #666; margin-bottom: 30px; font-size: 0.95em; }

        .input-group { margin-bottom: 20px; }
        
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
        button:hover { background-color: #024d7d; }

        .error { color: #dc3545; background: #ffe6e6; padding: 10px; border-radius: 4px; margin-bottom: 20px; font-size: 0.9em; }
        
        .footer-ver {
            margin-top: auto;
            font-size: 12px;
            color: #aaa;
            text-align: center;
            padding-top: 20px;
        }
    </style>
</head>
<body>
    
    <div class="login-sidebar">
        <img src='images/school-logo.png' alt="School Logo" class="logo">
        
        <h2>Welcome Back</h2>
        <p class="subtitle">Please identify yourself to access the portal.</p>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="input-group">
                <input type="text" name="usernameOrId" placeholder="Username." required autofocus>
            </div>
            <button type="submit">Continue</button>
        </form>

        <div class="footer-ver">SchoolRegEn v0.2</div>
    </div>

    <div class="background-panel">
        <div class="overlay"></div>
    </div>

</body>
</html>