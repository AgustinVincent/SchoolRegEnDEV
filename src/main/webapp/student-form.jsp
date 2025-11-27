<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:out value="${student != null ? 'Edit Student' : 'Add New Student'}" /></title>
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
                        <a href="${pageContext.request.contextPath}/list" class="nav-link active">Students</a>
                    </li>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/programs" class="nav-link">Programs</a></li>

                    
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
                <h2>
                    <c:choose>
                        <c:when test="${student != null}">Edit Student: <c:out value="${student.firstName}"/></c:when>
                        <c:otherwise>Add New Student</c:otherwise>
                    </c:choose>
                </h2>
            </div>

            <form action="${pageContext.request.contextPath}/${student != null ? 'update' : 'insert'}" method="post">
                
                <c:if test="${student != null}">
                    <input type="hidden" name="id" value="<c:out value='${student.id}' />" />
                    <input type="hidden" name="password" value="<c:out value='${student.password}' />" /> 
                </c:if>

                <div class="content-card">
                    <div class="card-header">Student Information</div>
                    <div class="card-body">
                        
                        <div class="profile-grid">
                            <div class="profile-item">
                                <label for="firstName">First Name</label>
                                <input type="text" id="firstName" name="firstName" value="<c:out value='${student.firstName}' />" required>
                            </div>
                            
                            <div class="profile-item">
                                <label for="lastName">Last Name</label>
                                <input type="text" id="lastName" name="lastName" value="<c:out value='${student.lastName}' />" required>
                            </div>

                            <div class="profile-item">
                                <label for="email">Email Address</label>
                                <input type="email" id="email" name="email" value="<c:out value='${student.email}' />">
                            </div>

                            <div class="profile-item">
                                <label for="contactNumber">Contact Number</label>
                                <input type="text" id="contactNumber" name="contactNumber" value="<c:out value='${student.contactNumber}' />">
                            </div>

                            <div class="profile-item">
                                <label for="dateOfBirth">Date of Birth</label>
                                <input type="date" id="dateOfBirth" name="dateOfBirth" value="<c:out value='${student.dateOfBirth}' />" required>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="action-bar">
                    <a href="${student != null ? pageContext.request.contextPath += '/view?id=' += student.id : pageContext.request.contextPath += '/list'}" class="cancel-btn">Cancel</a>
                    
                    <button type="submit" class="btn-save" style="width: auto; margin: 0;">
                        <c:out value="${student != null ? 'Save Changes' : 'Create Student'}" />
                    </button>
                </div>

            </form>
        </main>
    </div>
</body>
</html>