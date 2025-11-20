<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Student Management</title>

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
                overflow-y: auto;
            }
            .nav-item {
                margin-bottom: 10px;
            }
            .nav-link {
                display: block;
                padding: 12px 15px;
                color: #bdc3c7;
                text-decoration: none;
                border-radius: 4px;
                transition: all 0.3s;
                font-size: 15px;
            }
            .nav-link:hover, .nav-link.active {
                background-color: #34495e;
                color: #fff;
                transform: translateX(5px);
            }


            .nav-link.disabled {
                cursor: not-allowed;
                opacity: 0.7;
            }
            .nav-link.disabled:hover {
                transform: none;
                background-color: transparent;
                color: #bdc3c7;
            }


            .btn-add {
                background-color: #27ae60;
                color: white !important;
                font-weight: bold;
                margin-bottom: 20px;
                text-align: center;
                cursor: pointer;
            }
            .btn-add:hover {
                background-color: #2ecc71;
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
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .content-header h2 {
                color: #2c3e50;
                margin: 0;
            }


            .search-form {
                display: flex;
                gap: 10px;
                align-items: center;
            }
            .search-input {
                padding: 10px;
                border-radius: 4px;
                border: 1px solid #ddd;
                width: 300px;
            }
            .btn-search {
                padding: 10px 20px;
                background-color: #3498db;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            .btn-search:hover {
                background-color: #2980b9;
            }
            .btn-reset {
                padding: 10px 15px;
                background-color: #95a5a6;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-size: 13.3px;
                display: flex;
                align-items: center;
            }
            .btn-reset:hover {
                background-color: #7f8c8d;
            }


            .table-card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            thead {
                background-color: #3498db;
                color: white;
            }
            th, td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }
            tr:hover {
                background-color: #f8f9fa;
            }
            .action-btn {
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 14px;
                margin-right: 5px;
                cursor: pointer;
                border: none;
                color: white;
                text-decoration: none;
                display: inline-block;
            }
            .edit-btn {
                background-color: #f39c12;
            }
            .delete-btn {
                background-color: #e74c3c;
            }


            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0,0,0,0.5);
                backdrop-filter: blur(2px);
            }

            .modal-content {
                background-color: #fefefe;
                margin: 5% auto;
                padding: 30px;
                border: 1px solid #888;
                width: 500px;
                border-radius: 8px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.2);
                animation: slideDown 0.3s ease-out;
            }

            @keyframes slideDown {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
            }
            .close:hover {
                color: black;
            }

            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            .form-control {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }
            .btn-save {
                width: 100%;
                padding: 10px;
                background-color: #27ae60;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 16px;
                cursor: pointer;
                margin-top: 10px;
            }
            .btn-save:hover {
                background-color: #2ecc71;
            }
        </style>
    </head>
    <body>

        <%
            User user = (User) session.getAttribute("user");
            boolean isAdmin = (user != null && user.isAdmin());
            pageContext.setAttribute("isAdmin", isAdmin);
        %>

        <div class="dashboard-container">
            <aside class="sidebar">
                <div class="sidebar-header">School Registration</div>
                <ul class="nav-menu">
                    <c:if test="${isAdmin}">
                        <li class="nav-item">
                            <a href="#" onclick="openAddModal()" class="nav-link btn-add">+ Add Student</a>
                        </li>
                    </c:if>

                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/list" class="nav-link active">Dashboard</a>
                    </li>

                    <li class="nav-item">
                        <a href="#" class="nav-link">Courses (Soon)</a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">Rooms (Soon)</a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">Class Schedules (Soon)</a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">Grading (Soon)</a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">Faculty & Staff (Soon)</a>
                    </li>
                </ul>

                <div class="logout-section">
                    <p style="font-size: 0.8em; color: #bdc3c7; text-align: center;">Logged in as: ${user.username}</p>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
                </div>
            </aside>

            <main class="main-content">
                <div class="content-header">
                    <h2>Student Database</h2>

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
                                                    <button class="action-btn edit-btn"
                                                            onclick="openEditModal(
                                                                            '${student.id}',
                                                                            '${student.firstName}',
                                                                            '${student.lastName}',
                                                                            '${student.email}',
                                                                            '${student.contactNumber}',
                                                                            '${student.dateOfBirth}',
                                                                            '${student.password}'
                                                                            )">
                                                        Edit
                                                    </button>

                                                    <a href="${pageContext.request.contextPath}/delete?id=<c:out value='${student.id}'/>" 
                                                       class="action-btn delete-btn" 
                                                       onclick="return confirm('Are you sure you want to delete this student?')">
                                                        Delete
                                                    </a>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="${isAdmin ? '7' : '6'}" class="no-students">
                                            No students found matching your criteria.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <div id="studentModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h2 id="modalTitle">Add New Student</h2>

                <form id="studentForm" method="post" action="${pageContext.request.contextPath}/insert">
                    <input type="hidden" id="studentId" name="id" value="">
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email (Optional)</label>
                        <input type="email" id="email" name="email" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="contactNumber">Contact Number (Optional)</label>
                        <input type="text" id="contactNumber" name="contactNumber" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="dateOfBirth">Date of Birth (Optional)</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control">
                    </div>
                    <button type="submit" class="btn-save" id="saveButton">Save Student</button>
                </form>
            </div>
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