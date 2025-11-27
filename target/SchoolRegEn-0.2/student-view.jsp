<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>


<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Student Dashboard</title>

        <!-- TODO: Transfer all Styles in separate CSS file or folder -->

        
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
                <p class="subtitle" style="font-size: 0.8em; color: #bdc3c7; text-align: center;">Logged in as: ${user.username}</p>
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
                                <div class="profile-item" style="grid-column: span 2; background: #f8f9fa; padding: 10px; border-radius: 4px; border-left: 4px solid #3498db;">
                                <label>Enrolled Program</label>
                                <span style="color: #2c3e50; font-weight: bold; display: flex; justify-content: space-between; align-items: center;">
                                    <c:choose>
                                        <c:when test="${not empty student.programCode}">
                                            <c:out value="${student.programCode}"/> - <c:out value="${student.programName}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #e74c3c;">Not Enrolled in any Program</span>
                                        </c:otherwise>
                                    </c:choose>

                                    
                                    <c:if test="${user.admin or user.registrar}">
                                        <button onclick="openProgramModal()" class="action-btn edit-btn" style="font-size: 12px; margin: 0;">
                                            ${empty student.programCode ? 'Assign Program' : 'Change Program'}
                                        </button>
                                    </c:if>
                                </span>
                            </div>
                            </div>
                        </div>
                    </div>

                    <div class="content-header">

                    
                        <h2>Academic Records</h2>
                    
                </div>





                <div class="content-header">



                    <table>
                        <thead>
                            <tr>
                                <th>Course Name</th>
                                <th>Status / Grade</th>
                                    
                                    <c:if test="${user.admin or user.registrar}">
                                    <th><button onclick="openEnrollModal()" class="btn-add" style="margin:0; padding:5px 15px; font-size:13px;">
                                            + Enroll Subject
                                        </button></th>
                                    </c:if>
                            </tr>
                        </thead>
                        <c:choose>
                            <c:when test="${not empty courses}">

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

                            </c:when>
                            <c:otherwise>
                                <div class="card-body" style="text-align: center; color: #7f8c8d; font-style: italic;">
                                    You are not currently enrolled in any subjects.
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