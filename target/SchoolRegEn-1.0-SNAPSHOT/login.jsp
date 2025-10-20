<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Login</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f4f4f4; }
        .login-container { padding: 2em; background: #fff; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .error { color: red; margin-bottom: 1em; }
        input[type=text] { width: 100%; padding: 10px; margin-bottom: 1em; border: 1px solid #ccc; border-radius: 4px; }
        input[type=submit] { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>
    
   <div class="login-container">
        <h2>School Enrollment System</h2>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <form action="login" method="get">
            <label for="usernameOrId">Enter Username or Student ID:</label>
            <input type="text" id="usernameOrId" name="usernameOrId" required>
            <input type="submit" value="Continue">
        </form>
        <p align="left"; style="font-size:10px";>Development Build: 0.0.1</p> 
    </div>
</body>
</html>
