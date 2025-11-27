package com.via.schoolregen.resources.web;

import com.via.schoolregen.resources.dao.StudentDAO;
import com.via.schoolregen.resources.model.Student;
import com.via.schoolregen.resources.model.Course;
import com.via.schoolregen.resources.model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(urlPatterns = {"/list", "/new", "/insert", "/delete", "/edit", "/update", "/view", "/dashboard", "/enroll"})
public class StudentControllerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;
    private com.via.schoolregen.resources.dao.SubjectDAO subjectDAO;
    private com.via.schoolregen.resources.dao.ProgramDAO programDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
        subjectDAO = new com.via.schoolregen.resources.dao.SubjectDAO();
        programDAO = new com.via.schoolregen.resources.dao.ProgramDAO();
    }

    @Override
    public void log(String message) {
        String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        System.out.println("[" + time + "] " + message);
    }

    private boolean isUserLoggedIn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            return user != null && user.isAdmin();
        }
        return false;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isUserLoggedIn(request, response)) {
            return;
        }
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertStudent(request, response);
                    break;
                case "/delete":
                    deleteStudent(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateStudent(request, response);
                    break;
                case "/view":
                    viewStudentDetails(request, response);
                    break;
                case "/dashboard":
                    showDashboard(request, response);
                    break;

                case "/enroll":
                    enrollStudent(request, response);
                    break;
                case "/list":
                default:
                    listStudent(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || user.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/view");
            return;
        }


        int studentCount = studentDAO.getNoOfRecords();
        int subjectCount = subjectDAO.getNoOfcourse();
        int programCount = programDAO.getProgramCount();

        request.setAttribute("studentCount", studentCount);
        request.setAttribute("subjectCount", subjectCount);
        request.setAttribute("programCount", programCount);

        RequestDispatcher dispatcher = request.getRequestDispatcher("admin-dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private void listStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

        String searchQuery = request.getParameter("searchQuery");
        List<Student> listStudent;

 
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            listStudent = studentDAO.searchStudents(searchQuery);
            request.setAttribute("listStudent", listStudent);

            request.setAttribute("currentPage", 1);
            request.setAttribute("noOfPages", 1);
        } 
        else {
            int page = 1;
            int recordsPerPage = 10;

            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            int offset = (page - 1) * recordsPerPage;

            listStudent = studentDAO.selectStudentsPaginated(recordsPerPage, offset);
            int noOfRecords = studentDAO.getNoOfRecords();
            int noOfPages = (int) Math.ceil(noOfRecords * 1.0 / recordsPerPage);

            request.setAttribute("listStudent", listStudent);
            request.setAttribute("noOfPages", noOfPages);
            request.setAttribute("currentPage", page);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("list-students.jsp");
        dispatcher.forward(request, response);
    }

    private void viewStudentDetails(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        long studentIdToView = 0;

 
        if (!user.isStudent() && request.getParameter("id") != null) {
            studentIdToView = Long.parseLong(request.getParameter("id"));
        } else if (user.isStudent()) {
            studentIdToView = Long.parseLong(user.getUsername());
        } else {
            response.sendRedirect(request.getContextPath() + "/list");
            return;
        }

        Student student = studentDAO.selectStudent(studentIdToView);
        List<Course> courses = studentDAO.selectCoursesForStudent(studentIdToView);


        List<com.via.schoolregen.resources.model.Subject> allSubjects = subjectDAO.selectAllSubjects();
        request.setAttribute("allSubjects", allSubjects);

        request.setAttribute("student", student);
        request.setAttribute("courses", courses);

        List<com.via.schoolregen.resources.model.Program> programList = programDAO.selectAllPrograms();
        request.setAttribute("programList", programList);

        request.setAttribute("student", student);

        if (user.isStudent()) {
            request.getRequestDispatcher("student-view.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("admin-student-view.jsp").forward(request, response);
        }


        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || (!user.isAdmin() && !user.isFrontDesk())) {
            response.sendRedirect(request.getContextPath() + "/list");
            return;
        }


        RequestDispatcher dispatcher = request.getRequestDispatcher("student-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {


        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || (!user.isAdmin() && !user.isFrontDesk())) {
            response.sendRedirect(request.getContextPath() + "/list");
            return;
        }

        long id = Long.parseLong(request.getParameter("id"));
        Student existingStudent = studentDAO.selectStudent(id);

        RequestDispatcher dispatcher = request.getRequestDispatcher("student-form.jsp");
        request.setAttribute("student", existingStudent);
        dispatcher.forward(request, response);
    }

    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || (!user.isAdmin() && !user.isFrontDesk())) {
            response.sendRedirect(request.getContextPath() + "/list?error=Unauthorized");
            return;
        }

        /**
         * if (!isAdmin(request)) {
         * response.sendRedirect(request.getContextPath() + "/list"); return; }
        *
         */
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String contactNumber = request.getParameter("contactNumber");
        String dateOfBirthStr = request.getParameter("dateOfBirth");

        LocalDate dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            dateOfBirth = LocalDate.parse(dateOfBirthStr);
        }


        Student newStudent = new Student(0, firstName, lastName, email, contactNumber, dateOfBirth, null);
        studentDAO.insertStudent(newStudent);
        response.sendRedirect(request.getContextPath() + "/list");

        log("ACTION: Admin (IP " + request.getRemoteAddr() + ") ADDED new student: " + firstName + " " + lastName);
    }

    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || (!user.isAdmin() && !user.isFrontDesk())) {
            response.sendRedirect(request.getContextPath() + "/list?error=Unauthorized");
            return;
        }

        /**
         * if (!isAdmin(request)) {
         * response.sendRedirect(request.getContextPath() + "/list"); return; }
        *
         */
        String password = request.getParameter("password");
        long id = Long.parseLong(request.getParameter("id"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String contactNumber = request.getParameter("contactNumber");
        String dateOfBirthStr = request.getParameter("dateOfBirth");

        LocalDate dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            dateOfBirth = LocalDate.parse(dateOfBirthStr);
        }

        Student student = new Student(id, firstName, lastName, email, contactNumber, dateOfBirth, password);
        studentDAO.updateStudent(student);
        response.sendRedirect(request.getContextPath() + "/view?id=" + id);

        log("ACTION: Admin (IP " + request.getRemoteAddr() + ") UPDATED student ID: " + id);
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;


        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/list?error=Unauthorized");
            return;
        }
        /**
         * if (!isAdmin(request)) {
         * response.sendRedirect(request.getContextPath() + "/list"); return; }
        *
         */

        long id = Long.parseLong(request.getParameter("id"));
        studentDAO.deleteStudent(id);
        response.sendRedirect(request.getContextPath() + "/list");

        log("ACTION: Admin (IP " + request.getRemoteAddr() + ") DELETED student ID: " + id);
    }

    private void enrollStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || (!user.isAdmin() && !user.isRegistrar())) {
            response.sendRedirect("login");
            return;
        }

        long studentId = Long.parseLong(request.getParameter("studentId"));
        String type = request.getParameter("actionType");

        if ("program".equals(type)) {

            String programCode = request.getParameter("programCode");
            studentDAO.assignProgram(studentId, programCode);

        } else if ("subject".equals(type)) {

            String courseCode = request.getParameter("courseCode");
            studentDAO.addSubjectToStudent(studentId, courseCode);
        }

        response.sendRedirect(request.getContextPath() + "/view?id=" + studentId);
    }

}
