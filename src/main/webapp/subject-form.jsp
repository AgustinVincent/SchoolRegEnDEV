<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:out value="${subject != null ? 'Edit Subject' : 'Add New Subject'}" /></title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%
        User user = (User) session.getAttribute("user");
        if (user == null || user.isStudent()) {
            response.sendRedirect("login");
            return;
        }
    %>

    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">School Regen</div>
            <ul class="nav-menu">


                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/list" class="nav-link">Students</a>
                    </li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/programs" class="nav-link">Programs</a></li>

                    
                    <c:choose>
                        <c:when test="${user.registrar or user.admin}">

                            <li class="nav-item"><a href="${pageContext.request.contextPath}/subjects" class="nav-link active">Subjects</a></li>
                            <li class="nav-item"><a href="#" class="nav-link disabled">Class Schedules (Soon)</a></li>
                            </c:when>
                            <c:otherwise>
                                
                            </c:otherwise>
                        </c:choose>

                    <li class="nav-item"><a href="#" class="nav-link disabled">Faculty & Staff (Soon)</a></li>
                </ul>
            <div class="logout-section">
                <p class="subtitle" style="font-size: 0.8em; color: #bdc3c7; text-align: center;">Logged in as: ${user.username}</p>
                <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
            </div>
        </aside>

        <main class="main-content">
            <div class="content-header">
                <h2>
                    <c:choose>
                        <c:when test="${subject != null}">Edit Subject: <c:out value="${subject.courseCode}"/></c:when>
                        <c:otherwise>Add New Subject</c:otherwise>
                    </c:choose>
                </h2>
            </div>

            <form action="${pageContext.request.contextPath}/subjects" method="post">
                <input type="hidden" name="action" value="${subject != null ? 'update' : 'insert'}">

                <div class="content-card">
                    <div class="card-header">Subject Details</div>
                    <div class="card-body">
                        <div class="profile-grid">
                            
                            <div class="profile-item">
                                <label for="courseCode">Course Code</label>
                                <input type="text" id="courseCode" name="courseCode" 
                                       value="<c:out value='${subject.courseCode}' />" 
                                       placeholder="Course Code." 
                                       required 
                                       ${subject != null ? 'readonly style="background-color:#e9ecef; cursor:not-allowed;"' : ''}>
                                
                            </div>

                            <div class="profile-item">
                                <label for="courseNumber">Course ID</label>
                                <input type="number" id="courseNumber" name="courseNumber" 
                                       value="<c:out value='${subject.courseNumber}' />" 
                                       placeholder="XXXX" required>
                            </div>

                            <div class="profile-item" style="grid-column: span 2;">
                                <label for="courseName">Course Title</label>
                                <input type="text" id="courseName" name="courseName" 
                                       value="<c:out value='${subject.courseName}' />" 
                                       placeholder="Title." required>
                            </div>

                            <div class="profile-item" style="grid-column: span 2;">
                                <label for="description">Course Name</label>
                                <input type="text" id="description" name="description" 
                                       value="<c:out value='${subject.description}' />" 
                                       placeholder="Course Name.">
                            </div>

                        </div>
                    </div>
                </div>

                <div class="action-bar">
                    <a href="${pageContext.request.contextPath}/subjects" class="cancel-btn">Cancel</a>
                    <button type="submit" class="btn-save" style="width: auto; margin: 0;">
                        <c:out value="${subject != null ? 'Save Changes' : 'Create Subject'}" />
                    </button>
                </div>
            </form>
        </main>
    </div>
</body>
</html>