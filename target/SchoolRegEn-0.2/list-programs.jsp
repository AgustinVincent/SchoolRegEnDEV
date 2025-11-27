<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Degree Programs</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || user.isStudent()) {
            response.sendRedirect("login");
            return;
        }
        boolean canManage = user.isAdmin() || user.isRegistrar();
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
                <p class="subtitle" style="font-size: 0.8em; color: #bdc3c7; text-align: center;">Logged in as: ${user.username}</p>
                <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
            </div>
        </aside>

        <main class="main-content">
            <div class="content-header">
                <h2>Courses</h2>
                <c:if test="<%= canManage %>">
                    <a href="${pageContext.request.contextPath}/programs?action=new" class="nav-link btn-add" style="text-decoration:none; margin:0;">New Program</a>
                </c:if>
            </div>

            <c:if test="${not empty param.error}">
                <div style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border-radius: 4px; border: 1px solid #f5c6cb;">
                    <strong>Error:</strong> <c:out value="${param.error}"/>
                </div>
            </c:if>

            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>Code</th>
                            
                            <th>Program Name</th>
                            <th>Description</th>
                            <% if (canManage) { %> <th>Actions</th> <% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty listPrograms}">
                                <c:forEach var="prog" items="${listPrograms}">
                                    <tr>
                                        <td style="font-weight:bold; color:#2c3e50;"><c:out value="${prog.courseCode}" /></td>
                                        
                                        
                                        <td><c:out value="${prog.courseName}" /></td>
                                        <td style="color:#7f8c8d; font-size:0.9em;"><c:out value="${prog.description}" /></td>
                                        
                                        <% if (canManage) { %>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/programs?action=edit&code=<c:out value='${prog.courseCode}'/>" class="action-btn edit-btn">Edit</a>
                                                <a href="${pageContext.request.contextPath}/programs?action=delete&code=<c:out value='${prog.courseCode}'/>" class="action-btn delete-btn" onclick="return confirm('Delete this program? This will fail if students are enrolled.')">Delete</a>
                                            </td>
                                        <% } %>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="5" style="text-align:center; padding:30px; color:#999;">No programs found.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                        
                        <c:if test="${noOfPages > 1}">
                <div class="pagination-container">
                    
                    <%-- Previous --%>
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/programs?page=${currentPage - 1}" class="page-btn">&laquo; Previous</a>
                        </c:when>
                        <c:otherwise>
                            <span class="page-btn disabled">&laquo; Previous</span>
                        </c:otherwise>
                    </c:choose>

                    <%-- Indicator --%>
                    <span class="page-info">Page ${currentPage} of ${noOfPages}</span>

                    <%-- Next --%>
                    <c:choose>
                        <c:when test="${currentPage < noOfPages}">
                            <a href="${pageContext.request.contextPath}/programs?page=${currentPage + 1}" class="page-btn">Next &raquo;</a>
                        </c:when>
                        <c:otherwise>
                            <span class="page-btn disabled">Next &raquo;</span>
                        </c:otherwise>
                    </c:choose>
                    
                </div>
            </c:if>
            </div>
        </main>
    </div>
</body>
</html>