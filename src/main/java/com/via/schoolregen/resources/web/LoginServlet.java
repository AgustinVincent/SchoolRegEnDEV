package com.via.schoolregen.resources.web;

import com.via.schoolregen.resources.dao.StudentDAO;
import com.via.schoolregen.resources.model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/auth"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;

    public void init() {
        studentDAO = new StudentDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String usernameOrId = request.getParameter("usernameOrId");
        String password = request.getParameter("password");

        if ("admin".equalsIgnoreCase(usernameOrId)) {
            // pwd check
            if ("admin".equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", new User("admin", "admin"));
                response.sendRedirect(request.getContextPath() + "/list");
            } else {
                request.setAttribute("error", "Invalid admin password.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("admin-password.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            // first check
            try {
                long studentId = Long.parseLong(usernameOrId);
                if (studentDAO.selectStudent(studentId) != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", new User(String.valueOf(studentId), "student"));
                    response.sendRedirect(request.getContextPath() + "/view"); 
                } else {
                    request.setAttribute("error", "Student ID not found.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                    dispatcher.forward(request, response);
                }
            } catch (NumberFormatException e) {
                 request.setAttribute("error", "Invalid Student ID format or username.");
                 RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                 dispatcher.forward(request, response);
            }
        }
    }

     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String usernameOrId = request.getParameter("usernameOrId");

        if ("admin".equalsIgnoreCase(usernameOrId)) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("admin-password.jsp");
            dispatcher.forward(request, response);
        } else if (usernameOrId != null && !usernameOrId.isEmpty()) {
            doPost(request, response);
        }
        else {
             RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
             dispatcher.forward(request, response);
        }
    }
}
