<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Program Details</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .action-bar { position: fixed; bottom: 0; right: 0; width: calc(100% - 260px); background-color: #ffffff; padding: 20px 40px; border-top: 1px solid #e0e0e0; display: flex; justify-content: flex-end; gap: 15px; z-index: 900; }
        .main-content { padding-bottom: 100px !important; }
        .cancel-btn { background-color: #95a5a6; color: white; padding: 10px 20px; border-radius: 4px; font-weight: bold; }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || user.isStudent()) { response.sendRedirect("login"); return; }
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
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/programs" class="nav-link active">Programs</a></li>

                    
                    <c:choose>
                        <c:when test="${user.registrar or user.admin}">

                            <li class="nav-item"><a href="${pageContext.request.contextPath}/subjects" class="nav-link">Subjects</a></li>
                            <li class="nav-item"><a href="#" class="nav-link disabled">Class Schedules (Soon)</a></li>
                            </c:when>
                            <c:otherwise>
                                
                            </c:otherwise>
                        </c:choose>

                    <li class="nav-item"><a href="#" class="nav-link disabled">Faculty & Staff (Soon)</a></li>
            </ul>
            <div class="logout-section">
                <p class="subtitle" style="font-size:0.8em; color:#bdc3c7; text-align:center;">Logged in as: ${user.username}</p>
                <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
            </div>
        </aside>

        <main class="main-content">
            <div class="content-header">
                <h2>${program != null ? 'Edit Program' : 'Add New Program'}</h2>
            </div>

            <form action="${pageContext.request.contextPath}/programs" method="post">
                <input type="hidden" name="action" value="${program != null ? 'update' : 'insert'}">

                <div class="content-card">
                    <div class="card-header">Program Details</div>
                    <div class="card-body">
                        <div class="profile-grid">
                            <div class="profile-item">
                                <label>Program Code</label>
                                <input type="text" name="courseCode" value="${program.courseCode}" placeholder="BSIT" required ${program != null ? 'readonly style="background-color:#e9ecef"' : ''}>
                            </div>
                            
                            <div class="profile-item" style="grid-column: span 2;">
                                <label>Program Name</label>
                                <input type="text" name="courseName" value="${program.courseName}" placeholder="Bachelor of Science..." required>
                            </div>
                            <div class="profile-item" style="grid-column: span 2;">
                                <label>Description</label>
                                <input type="text" name="description" value="${program.description}">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="action-bar">
                    <a href="${pageContext.request.contextPath}/programs" class="cancel-btn">Cancel</a>
                    <button type="submit" class="btn-save" style="width: auto; margin: 0;">Save</button>
                </div>
            </form>
        </main>
    </div>
</body>
</html>