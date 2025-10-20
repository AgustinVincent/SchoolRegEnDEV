<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Details</title>
<style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f9; margin: 0; padding: 20px; color: #333; }
    .container { max-width: 800px; margin: auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #0056b3; padding-bottom: 10px; margin-bottom: 20px; }
    header h1 { margin: 0; color: #0056b3; }
    .logout-link { background-color: #dc3545; color: white; padding: 8px 15px; text-decoration: none; border-radius: 5px; }
    .student-details, .courses-section { margin-bottom: 20px; }
    h2 { color: #0056b3; border-bottom: 1px solid #eee; padding-bottom: 5px; }
    .detail-item { padding: 8px 0; display: flex; }
    .detail-item strong { min-width: 150px; color: #555; }
    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
    thead { background-color: #0056b3; color: white; }
    tr:nth-child(even) { background-color: #f2f2f2; }
</style>
</head>
<body>
    <div class="container">
        <header>
             <h1>Student Dashboard</h1>
             <a href="${pageContext.request.contextPath}/logout" class="logout-link">Logout</a>
        </header>

        <main>
             <c:if test="${student != null}">
                <section class="student-details">
                    <h2>Personal Information</h2>
                    <div class="detail-item">
                        <strong>Student ID:</strong>
                        <span><c:out value="${student.id}" /></span>
                    </div>
                    <div class="detail-item">
                        <strong>Full Name:</strong>
                        <span><c:out value="${student.firstName}" /> <c:out value="${student.lastName}" /></span>
                    </div>
                    <div class="detail-item">
                        <strong>Email:</strong>
                        <span><c:out value="${student.email}" /></span>
                    </div>
                    <div class="detail-item">
                        <strong>Contact Number:</strong>
                        <span><c:out value="${student.contactNumber}" /></span>
                    </div>
                     <div class="detail-item">
                        <strong>Date of Birth:</strong>
                        <span><c:out value="${student.dateOfBirth}" /></span>
                    </div>
                </section>

                <section class="courses-section">
                    <h2>Enrolled Courses</h2>
                    <c:choose>
                        <c:when test="${not empty courses}">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Course Name</th>
                                        <th>Grade</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="course" items="${courses}">
                                        <tr>
                                            <td><c:out value="${course.courseName}" /></td>
                                            <td><c:out value="${course.grade}" /></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p>No courses found for this student.</p>
                        </c:otherwise>
                    </c:choose>
                </section>
             </c:if>
             <c:if test="${student == null}">
                 <p>Could not retrieve student details.</p>
             </c:if>
        </main>
    </div>
</body>
</html>

