<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>
<%@ page import="com.via.schoolregen.resources.model.Subject" %>

<!DOCTYPE html>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<html>

    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>

    </head>
    <body>

        <%
            User user = (User) session.getAttribute("user");

            //Check for admin or student
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
                        <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/list" class="nav-link">Students</a>
                    </li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/programs" class="nav-link">Programs</a></li>

                    <%-- REGISTRAR SPECIFIC LINKS (Active for Registrar, Disabled for others) --%>
                    <c:choose>
                        <c:when test="${user.registrar or user.admin}">

                            <li class="nav-item"><a href="${pageContext.request.contextPath}/subjects" class="nav-link">Subjects</a></li>
                            <li class="nav-item"><a href="#" class="nav-link disabled">Class Schedules (Soon)</a></li>
                            </c:when>
                            <c:otherwise>
                                <%-- Hide these from Front Desk to keep it clean --%>
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
                    <div>
                        <h2>System Overview</h2>
                        <p style="margin: 5px 0 0; color: #7f8c8d; font-size: 14px;">Welcome back, Administrator.</p>
                    </div>
                    <div class="live-clock">
                        <div class="clock-time" id="clock">00:00:00</div>
                        <div class="clock-date" id="date">Loading date...</div>
                    </div>
                </div>

                <div class="stats-grid">

                    <div class="stat-card green">
                        <div class="stat-title">Total Students</div>
                        <div class="stat-value"><c:out value="${studentCount}"/></div>
                        <div class="stat-desc">Enrolled in database</div>
                    </div>

                    <div class="stat-card orange">
                        <div class="stat-title">Total Subjects</div>
                        <div class="stat-value"><c:out value="${subjectCount}"/></div>
                        <div class="stat-desc">Active Subjects Available</div>
                    </div>

                    <div class="stat-card purple">
                        <div class="stat-title">Courses</div>

                        <div class="stat-value">
                            <c:out value="${programCount}"/>
                        </div>

                        <div class="stat-desc">Active Courses Available</div>
                    </div>

                </div>
            </main>
        </div>

        <script>
            function updateClock() {
                const now = new Date();
                const timeString = now.toLocaleTimeString();
                const dateString = now.toLocaleDateString(undefined, {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'});

                document.getElementById('clock').textContent = timeString;
                document.getElementById('date').textContent = dateString;
            }
            setInterval(updateClock, 1000);
            updateClock();
        </script>
    </body>
</html>