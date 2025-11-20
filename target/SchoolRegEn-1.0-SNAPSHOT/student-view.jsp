<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Student Dashboard</title>

        <!-- TODO: Transfer all Styles in separate CSS file or folder -->

        <style>
            * {
                box-sizing: border-box;
            }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f4f9;
                color: #333;
                height: 100vh;
                overflow: hidden;
            }
            .dashboard-container {
                display: flex;
                height: 100vh;
                width: 100%;
            }

            .sidebar {
                width: 260px;
                background-color: #2c3e50;
                color: #ecf0f1;
                display: flex;
                flex-direction: column;
                padding: 20px;
                flex-shrink: 0;
            }
            .sidebar-header {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 40px;
                text-align: center;
                color: #fff;
                border-bottom: 1px solid #34495e;
                padding-bottom: 20px;
            }
            .nav-menu {
                list-style: none;
                padding: 0;
                margin: 0;
                flex-grow: 1;
            }
            .nav-item {
                margin-bottom: 15px;
            }
            .nav-link {
                display: block;
                padding: 12px 15px;
                color: #bdc3c7;
                text-decoration: none;
                border-radius: 4px;
                transition: all 0.3s;
                font-size: 16px;
            }
            .nav-link:hover, .nav-link.active {
                background-color: #34495e;
                color: #fff;
                transform: translateX(5px);
            }

            .logout-section {
                margin-top: auto;
                border-top: 1px solid #34495e;
                padding-top: 20px;
            }
            .logout-link {
                display: block;
                padding: 10px;
                background-color: #c0392b;
                color: white;
                text-align: center;
                text-decoration: none;
                border-radius: 4px;
                transition: background 0.3s;
            }
            .logout-link:hover {
                background-color: #e74c3c;
            }

            .main-content {
                flex: 1;
                padding: 30px;
                overflow-y: auto;
                background-color: #ecf0f1;
            }
            .content-header {
                margin-bottom: 25px;
            }
            .content-header h2 {
                color: #2c3e50;
                margin: 0;
                font-size: 28px;
            }
            .content-header p {
                color: #7f8c8d;
                margin-top: 5px;
            }

            .content-card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 30px;
            }
            .card-header {
                background-color: #3498db;
                color: white;
                padding: 15px 20px;
                font-size: 18px;
                font-weight: bold;
            }
            .card-body {
                padding: 20px;
            }

            .profile-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }
            .profile-item label {
                display: block;
                font-size: 12px;
                color: #7f8c8d;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 5px;
            }
            .profile-item span {
                display: block;
                font-size: 16px;
                font-weight: 600;
                color: #2c3e50;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }
            thead {
                background-color: #f8f9fa;
                border-bottom: 2px solid #e9ecef;
            }
            th {
                color: #495057;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 14px;
            }
            th, td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }
            tr:last-child td {
                border-bottom: none;
            }
            tr:hover {
                background-color: #f8f9fa;
            }

            .badge {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: bold;
            }
            .badge-pass {
                background-color: #d4edda;
                color: #155724;
            }
            .badge-neutral {
                background-color: #e2e3e5;
                color: #383d41;
            }

        </style>
    </head>
    <body>

        <%
            // Get User session for sidebar info
            User user = (User) session.getAttribute("user");
        %>

        <div class="dashboard-container">

            <aside class="sidebar">
                <div class="sidebar-header">Student Portal</div>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="#" class="nav-link active">My Profile</a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">Class Schedule (Soon)</a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">Grades (Soon)</a>
                    </li>
                </ul>
                <div class="logout-section">
                    <p style="font-size: 0.8em; color: #bdc3c7; text-align: center;">ID: ${user.username}</p>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
                </div>
            </aside>

            <main class="main-content">

                <c:if test="${student != null}">
                    <div class="content-header">
                        <h2>Welcome, <c:out value="${student.firstName}" />!</h2>
                        <p>Manage your profile and view your academic progress.</p>
                    </div>

                    <div class="content-card">
                        <div class="card-header">Personal Information</div>
                        <div class="card-body">
                            <div class="profile-grid">
                                <div class="profile-item">
                                    <label>Student ID</label>
                                    <span><c:out value="${student.id}" /></span>
                                </div>
                                <div class="profile-item">
                                    <label>Full Name</label>
                                    <span><c:out value="${student.firstName}" /> <c:out value="${student.lastName}" /></span>
                                </div>
                                <div class="profile-item">
                                    <label>Email Address</label>
                                    <span><c:out value="${student.email}" default="Not Provided"/></span>
                                </div>
                                <div class="profile-item">
                                    <label>Contact Number</label>
                                    <span><c:out value="${student.contactNumber}" default="Not Provided"/></span>
                                </div>
                                <div class="profile-item">
                                    <label>Date of Birth</label>
                                    <span><c:out value="${student.dateOfBirth}" default="Not Provided"/></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="content-card">
                        <div class="card-header">Academic Record</div>

                        <c:choose>
                            <c:when test="${not empty courses}">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Course Name</th>
                                            <th>Status / Grade</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="course" items="${courses}">
                                            <tr>
                                                <td><c:out value="${course.courseName}" /></td>
                                                <td>
                                                    <span class="badge ${course.grade != null ? 'badge-pass' : 'badge-neutral'}">
                                                        <c:out value="${course.grade}" default="In Progress" />
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="card-body" style="text-align: center; color: #7f8c8d; font-style: italic;">
                                    You are not currently enrolled in any courses.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </c:if>

                <c:if test="${student == null}">
                    <div class="content-card">
                        <div class="card-body" style="color: red; text-align: center;">
                            <h3>Error Retrieving Student Details</h3>
                            <p>Please try logging in again.</p>
                        </div>
                    </div>
                </c:if>

            </main>
        </div>
    </body>
</html>