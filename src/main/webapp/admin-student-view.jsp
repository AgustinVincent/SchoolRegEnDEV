<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.via.schoolregen.resources.model.User" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Student Profile - Admin View</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">


    </head>
    <body>

        <%
            User user = (User) session.getAttribute("user");
            if (user == null || user.isStudent()) {
                response.sendRedirect("login");
                return;
            }
            pageContext.setAttribute("canEdit", user.isAdmin() || user.isFrontDesk());
            pageContext.setAttribute("canDelete", user.isAdmin());
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
                    <h2>Student Profile</h2>
                    <p style="color:#7f8c8d; margin-top:5px;">View and manage student records.</p>
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
                                <th>Subject Name</th>
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

                                <tbody>
                                <th>
                                    <div class="card-body" style="text-align: center; color: #7f8c8d; font-style: italic;">
                                        Student is not currently enrolled in any Subjects.
                                    </div>
                                </th>
                                </tbody>

                            </c:otherwise>
                        </c:choose>
                    </table>
                </div>

                <div class="action-bar">
                    <a href="${pageContext.request.contextPath}/list" class="back-btn">← Back to List</a>

                    <c:if test="${canEdit}">
                        <button class="btn-add" style="background-color:#f39c12; margin:0;"
                                onclick="openEditModal(
                                                '${student.id}',
                                                '${student.firstName}',
                                                '${student.lastName}',
                                                '${student.email}',
                                                '${student.contactNumber}',
                                                '${student.dateOfBirth}',
                                                '${student.password}' // Passwords are usually hidden, consider removing this
                                                )">
                            <a href="${pageContext.request.contextPath}/edit?id=<c:out value='${student.id}'/>" 
                               class="btn-save" style="background-color:#f39c12; text-decoration:none; padding:10px 20px; width:auto;">
                                Edit Profile
                            </a>
                        </button>
                    </c:if>

                    <c:if test="${canDelete}">
                        <a href="${pageContext.request.contextPath}/delete?id=<c:out value='${student.id}'/>" 
                           class="delete-btn" style="padding:10px 20px;"
                           onclick="return confirm('Are you sure you want to permanently delete this student? This action cannot be undone.')">
                            Delete Record
                        </a>
                    </c:if>
                </div>

            </main>
        </div>

        <div id="enrollModal" class="modal">
            <div class="modal-content" style="width: 400px;">
                <span class="close" onclick="closeEnrollModal()">&times;</span>
                <h2 style="margin-top:0;">Enroll Student</h2>
                <p>Assign a subject to <strong><c:out value="${student.firstName}"/></strong>.</p>

                <form action="${pageContext.request.contextPath}/enroll" method="post">
                    <input type="hidden" name="studentId" value="${student.id}">
                    <input type="hidden" name="actionType" value="subject"> 

                    <div class="form-group">
                        <label>Select Subject</label>
                        <select name="courseCode" class="form-control" required>
                            <option value="" disabled selected>-- Choose a Subject --</option>
                            <c:forEach var="sub" items="${allSubjects}">
                                <option value="${sub.courseCode}">
                                    <c:out value="${sub.courseCode}"/> - <c:out value="${sub.courseName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit" class="btn-save">Enroll</button>
                </form>


            </div>
        </div>

        <div id="programModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeProgramModal()">&times;</span>
                <h2 style="margin-top:0;">Select Degree Program</h2>
                <p>Assign a program to <strong><c:out value="${student.firstName}"/></strong>.</p>

                <form action="${pageContext.request.contextPath}/enroll" method="post">
                    <input type="hidden" name="studentId" value="${student.id}">
                    <input type="hidden" name="actionType" value="program">

                    <div class="form-group">
                        <label>Available Programs</label>
                        <select name="programCode" class="form-control" required>
                            <option value="" disabled selected>-- Select Program --</option>
                            <c:forEach var="prog" items="${programList}">
                                <option value="${prog.courseCode}" ${student.programCode eq prog.courseCode ? 'selected' : ''}>
                                    <c:out value="${prog.courseCode}"/> - <c:out value="${prog.courseName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit" class="btn-save">Save Assignment</button>
                </form>



            </div>
        </div>

        <script>
            var modal = document.getElementById("studentModal");
            var form = document.getElementById("studentForm");

            function openEditModal(id, fName, lName, email, contact, dob) {
                modal.style.display = "block";
                document.getElementById("studentId").value = id;
                document.getElementById("firstName").value = fName;
                document.getElementById("lastName").value = lName;
                document.getElementById("email").value = email;
                document.getElementById("contactNumber").value = contact;
                document.getElementById("dateOfBirth").value = dob;
            }

            function closeModal() {
                modal.style.display = "none";
            }
            window.onclick = function (e) {
                if (e.target == modal)
                    closeModal();
            }

            var enrollModal = document.getElementById("enrollModal");

            function openEnrollModal() {
                enrollModal.style.display = "block";
            }

            function closeEnrollModal() {
                enrollModal.style.display = "none";
            }

            // Update window click to close both modals
            window.onclick = function (e) {
                if (e.target == modal)
                    closeModal();
                if (e.target == enrollModal)
                    closeEnrollModal();
            }

            var progModal = document.getElementById("programModal");
            function openProgramModal() {
                progModal.style.display = "block";
            }
            function closeProgramModal() {
                progModal.style.display = "none";
            }

            window.onclick = function (e) {
                if (e.target == progModal)
                    closeProgramModal();
            }
        </script>

    </body>
</html>