<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Student</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; margin: 0; padding: 20px; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .form-container { background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        .form-container h1 { color: #0056b3; margin-bottom: 20px; text-align: center; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        .form-control { width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc; box-sizing: border-box; }
        .button-group { display: flex; justify-content: space-between; margin-top: 20px; }
        .button { padding: 10px 20px; border: none; border-radius: 5px; color: white; cursor: pointer; text-decoration: none; text-align: center; display: inline-block; }
        .button-save { background-color: #28a745; }
        .button-cancel { background-color: #6c757d; }
    </style>
</head>
<body>
    <div class="form-container">
        <c:if test="${student != null}">
             <h1>Edit Student: <c:out value="${student.firstName}"/> <c:out value="${student.lastName}"/></h1>
        </c:if>
        <c:if test="${student == null}">
             <h1>Edit Student</h1>
        </c:if>

        <form action="${pageContext.request.contextPath}/update" method="post">
            <input type="hidden" name="id" value="<c:out value='${student.id}' />" />

            <div class="form-group">
                <label for="firstName">First Name</label>
                <input type="text" id="firstName" name="firstName" class="form-control" value="<c:out value='${student.firstName}' />" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name</label>
                <input type="text" id="lastName" name="lastName" class="form-control" value="<c:out value='${student.lastName}' />" required>
            </div>
            <div class="form-group">
                <label for="email">Email (Optional)</label>
                <input type="email" id="email" name="email" class="form-control" value="<c:out value='${student.email}' />">
            </div>
            <div class="form-group">
                <label for="contactNumber">Contact Number (Optional)</label>
                <input type="text" id="contactNumber" name="contactNumber" class="form-control" value="<c:out value='${student.contactNumber}' />">
            </div>
            <div class="form-group">
                <label for="dateOfBirth">Date of Birth (Optional)</label>
                <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control" value="<c:out value='${student.dateOfBirth}' />">
            </div>
            <div class="button-group">
                <button type="submit" class="button button-save">Update</button>
                <a href="${pageContext.request.contextPath}/list" class="button button-cancel">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>

