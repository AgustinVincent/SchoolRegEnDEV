<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    boolean isAdmin = (user != null && user.isAdmin());
    pageContext.setAttribute("isAdmin", isAdmin);
%>
<%
    if (user.isStudent()) {
        response.sendRedirect("view");
    }

%>


<!DOCTYPE html>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">

<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Student Management</title>

        <!-- TODO: Transfer all Styles in separate CSS file or folder -->


    </head>
    <body>



        <div class="dashboard-container">
            <aside class="sidebar">
                <div class="sidebar-header">School Registration</div>
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
                    <h2>Student Database</h2>
                    <c:if test="${user.admin or user.frontDesk}">
                        <a href="${pageContext.request.contextPath}/new" class="nav-link btn-add">
                            Add Student
                        </a>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/list" method="get" class="search-form">
                        <input type="text" name="searchQuery" class="search-input" 
                               placeholder="Search Bar..." 
                               value="${param.searchQuery}">

                        <button type="submit" class="btn-search">Search</button>

                        <c:if test="${not empty param.searchQuery}">
                            <a href="${pageContext.request.contextPath}/list" class="btn-reset">Reset</a>
                        </c:if>
                    </form>
                </div>



                <div class="table-card">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Email</th>
                                <th>Contact Number</th>
                                <th>Date of Birth</th>


                                <th></th>
                            </tr>
                        </thead>



                        <tbody>
                            <c:choose>
                                <c:when test="${not empty listStudent}">
                                    <c:forEach var="student" items="${listStudent}">
                                        <tr style="cursor: pointer;" onclick="window.location = '${pageContext.request.contextPath}/view?id=${student.id}'">
                                            <td><c:out value="${student.id}" /></td>
                                            <td><c:out value="${student.firstName}" /></td>
                                            <td><c:out value="${student.lastName}" /></td>
                                            <td><c:out value="${student.email}" /></td>
                                            <td><c:out value="${student.contactNumber}" /></td>
                                            <td><c:out value="${student.dateOfBirth}" /></td>

                                            <td>
                                                <a href="${pageContext.request.contextPath}/view?id=${student.id}" 
                                                   class="action-btn" 
                                                   style="background-color:#3498db;">
                                                    View Profile
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="no-students">
                                            No students found matching your criteria.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>


                    </table>


                    <c:if test="${noOfPages > 1}">
                        <div class="pagination-container">

                            
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/list?page=${currentPage - 1}" class="page-btn">
                                        &laquo; Previous
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <%-- Disabled button if on Page 1 --%>
                                    <span class="page-btn disabled">&laquo; Previous</span>
                                </c:otherwise>
                            </c:choose>

                            
                            <span class="page-info">
                                Page ${currentPage} of ${noOfPages}
                            </span>

                            
                            <c:choose>
                                <c:when test="${currentPage < noOfPages}">
                                    <a href="${pageContext.request.contextPath}/list?page=${currentPage + 1}" class="page-btn">
                                        Next &raquo;
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <%-- Disabled button if on Last Page --%>
                                    <span class="page-btn disabled">Next &raquo;</span>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </c:if>
                </div>
            </main>
        </div>







        <!-- TODO: Make script in separate scripts folder. this is just for easier debuging -->
        <script>
            var modal = document.getElementById("studentModal");
            var form = document.getElementById("studentForm");
            var modalTitle = document.getElementById("modalTitle");
            var saveBtn = document.getElementById("saveButton");

            function openAddModal() {
                modal.style.display = "block";
                modalTitle.innerText = "Add New Student";
                saveBtn.innerText = "Add Student";
                form.action = "${pageContext.request.contextPath}/insert";

                document.getElementById("studentId").value = "";
                document.getElementById("firstName").value = "";
                document.getElementById("lastName").value = "";
                document.getElementById("email").value = "";
                document.getElementById("contactNumber").value = "";
                document.getElementById("dateOfBirth").value = "";
            }

            function openEditModal(id, firstName, lastName, email, contact, dob, password) {
                modal.style.display = "block";
                modalTitle.innerText = "Edit Student (ID: " + id + ")";
                saveBtn.innerText = "Update Student";
                form.action = "${pageContext.request.contextPath}/update";

                document.getElementById("studentId").value = id;
                document.getElementById("firstName").value = firstName;
                document.getElementById("lastName").value = lastName;
                document.getElementById("email").value = email;
                document.getElementById("contactNumber").value = contact;
                document.getElementById("dateOfBirth").value = dob;

                let hiddenPwd = document.getElementById("hiddenPassword");
                if (!hiddenPwd) {
                    hiddenPwd = document.createElement("input");
                    hiddenPwd.type = "hidden";
                    hiddenPwd.id = "hiddenPassword";
                    hiddenPwd.name = "password";
                    form.appendChild(hiddenPwd);
                }
                hiddenPwd.value = password;
            }

            function closeModal() {
                modal.style.display = "none";
            }

            window.onclick = function (event) {
                if (event.target === modal) {
                    closeModal();
                }
            };
        </script>
    </body>
</html>