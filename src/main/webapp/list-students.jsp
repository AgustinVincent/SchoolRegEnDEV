<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Management</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; margin: 0; padding: 20px; color: #333; }
        .container { max-width: 1200px; margin: auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #0056b3; padding-bottom: 10px; margin-bottom: 20px; }
        header h1 { margin: 0; color: #0056b3; }
        .header-links .logout-link { background-color: #dc3545; color: white; padding: 8px 15px; text-decoration: none; border-radius: 5px; }
        .add-student-section { margin-bottom: 20px; }
        .button { background-color: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; border: none; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        thead { background-color: #0056b3; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .edit-link, .delete-link { color: #007bff; text-decoration: none; }
        .delete-link { color: #dc3545; }
        .no-students { text-align: center; padding: 20px; font-style: italic; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Student Management</h1>
            <div class="header-links">
                <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
            </div>
        </header>

        <%
            User user = (User) session.getAttribute("user");
            boolean isAdmin = (user != null && user.isAdmin());
            pageContext.setAttribute("isAdmin", isAdmin);
        %>

        <c:if test="${isAdmin}">
            <div class="add-student-section">
                <a href="${pageContext.request.contextPath}/new" class="button">Add New Student</a>
            </div>
        </c:if>

        <main>
            <h2>List of Students</h2>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Email</th>
                            <th>Contact Number</th>
                            <th>Date of Birth</th>
                            <c:if test="${isAdmin}">
                                <th>Actions</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty listStudent}">
                                <c:forEach var="student" items="${listStudent}">
                                    <tr>
                                        <td><c:out value="${student.id}" /></td>
                                        <td><c:out value="${student.firstName}" /></td>
                                        <td><c:out value="${student.lastName}" /></td>
                                        <td><c:out value="${student.email}" /></td>
                                        <td><c:out value="${student.contactNumber}" /></td>
                                        <td><c:out value="${student.dateOfBirth}" /></td>
                                        <c:if test="${isAdmin}">
                                            <td>
                                                <a href="${pageContext.request.contextPath}/edit?id=<c:out value='${student.id}'/>" class="edit-link">Edit</a>
                                                &nbsp;&nbsp;
                                                <a href="${pageContext.request.contextPath}/delete?id=<c:out value='${student.id}'/>" class="delete-link" onclick="return confirm('Are you sure you want to delete this student?')">Delete</a>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="${isAdmin ? '7' : '6'}" class="no-students">No students found in the system.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>

