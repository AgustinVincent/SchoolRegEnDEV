package com.via.schoolregen.resources.web;

import com.via.schoolregen.resources.dao.StudentDAO;
import com.via.schoolregen.resources.model.Student;
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

@WebServlet(urlPatterns = {"/login", "/auth", "/setup-password"})
public class LoginServlet extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/login":
                    handleInitialCheck(request, response);
                    break;
                case "/auth":
                    handleAuthentication(request, response);
                    break;
                case "/setup-password":
                    handlePasswordSetup(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleInitialCheck(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String usernameOrId = request.getParameter("usernameOrId");

        if ("admin".equalsIgnoreCase(usernameOrId)) {

            request.setAttribute("targetUser", "admin");
            RequestDispatcher dispatcher = request.getRequestDispatcher("enter-password.jsp");
            dispatcher.forward(request, response);
        } else {

            try {
                long studentId = Long.parseLong(usernameOrId);
                Student student = studentDAO.selectStudent(studentId);

                if (student != null) {
                    request.setAttribute("studentId", studentId);

                    request.setAttribute("studentName", student.getFirstName());

                    if (student.getPassword() == null || student.getPassword().trim().isEmpty()) {
                        RequestDispatcher dispatcher = request.getRequestDispatcher("set-password.jsp");
                        dispatcher.forward(request, response);
                    } else {

                        request.setAttribute("targetUser", "student");
                        RequestDispatcher dispatcher = request.getRequestDispatcher("enter-password.jsp");
                        dispatcher.forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Student ID not found.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid ID format.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }

    private void handleAuthentication(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userType = request.getParameter("targetUser"); // "admin" or "student"
        String password = request.getParameter("password");

        HttpSession session = request.getSession();
        //Admin Auth
        if ("admin".equals(userType)) {
            if ("admin".equals(password)) {
                session.setAttribute("user", new User("admin", "admin"));
                response.sendRedirect(request.getContextPath() + "/list");
            } else {
                request.setAttribute("error", "Invalid admin password.");
                request.setAttribute("targetUser", "admin"); // Keep state
                request.getRequestDispatcher("enter-password.jsp").forward(request, response);
            }
        } else {
            // Student Auth
            long studentId = Long.parseLong(request.getParameter("studentId"));
            Student student = studentDAO.selectStudent(studentId);

            if (student != null && password.equals(student.getPassword())) {
                session.setAttribute("user", new User(String.valueOf(studentId), "student"));
                response.sendRedirect(request.getContextPath() + "/view");
            } else {
                request.setAttribute("error", "Incorrect password.");
                request.setAttribute("studentId", studentId);
                request.setAttribute("targetUser", "student");

                if (student != null) {
                    request.setAttribute("studentName", student.getFirstName());
                }

                request.getRequestDispatcher("enter-password.jsp").forward(request, response);
            }
        }
    }

    private void handlePasswordSetup(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        long studentId = Long.parseLong(request.getParameter("studentId"));
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword != null && newPassword.equals(confirmPassword)) {

            studentDAO.updatePassword(studentId, newPassword);

            HttpSession session = request.getSession();
            session.setAttribute("user", new User(String.valueOf(studentId), "student"));
            response.sendRedirect(request.getContextPath() + "/view");
        } else {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("studentId", studentId);
            request.getRequestDispatcher("set-password.jsp").forward(request, response);
        }
    }
}
