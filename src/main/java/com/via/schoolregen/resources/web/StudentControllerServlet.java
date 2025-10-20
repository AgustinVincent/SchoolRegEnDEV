/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
import java.util.List;

@WebServlet(urlPatterns = {"/list", "/new", "/insert", "/delete", "/edit", "/update", "/view"})
public class StudentControllerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO; 

    public void init() {
        studentDAO = new StudentDAO();
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isUserLoggedIn(request, response)) return;
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isUserLoggedIn(request, response)) return;

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
                case "/list":
                default:
                    listStudent(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Student> listStudent = studentDAO.selectAllStudents();
        request.setAttribute("listStudent", listStudent);
        RequestDispatcher dispatcher = request.getRequestDispatcher("list-students.jsp");
        dispatcher.forward(request, response);
    }

    private void viewStudentDetails(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user.isAdmin()){
             response.sendRedirect(request.getContextPath() + "/list");
             return;
        }

        long studentId = Long.parseLong(user.getUsername());
        Student student = studentDAO.selectStudent(studentId);
        List<Course> courses = studentDAO.selectCoursesForStudent(studentId);

        request.setAttribute("student", student);
        request.setAttribute("courses", courses);
        RequestDispatcher dispatcher = request.getRequestDispatcher("student-view.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/list");
            return;
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("add-student-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/list");
            return;
        }
        long id = Long.parseLong(request.getParameter("id"));
        Student existingStudent = studentDAO.selectStudent(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("update-student-form.jsp");
        request.setAttribute("student", existingStudent);
        dispatcher.forward(request, response);
    }

    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/list");
            return;
        }
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String contactNumber = request.getParameter("contactNumber");
        String dateOfBirthStr = request.getParameter("dateOfBirth");

        LocalDate dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            dateOfBirth = LocalDate.parse(dateOfBirthStr);
        }

        Student newStudent = new Student(0, firstName, lastName, email, contactNumber, dateOfBirth);
        studentDAO.insertStudent(newStudent);
        response.sendRedirect(request.getContextPath() + "/list");
    }

    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/list");
            return;
        }
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

        Student student = new Student(id, firstName, lastName, email, contactNumber, dateOfBirth);
        studentDAO.updateStudent(student);
        response.sendRedirect(request.getContextPath() + "/list");
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/list");
            return;
        }
        long id = Long.parseLong(request.getParameter("id"));
        studentDAO.deleteStudent(id);
        response.sendRedirect(request.getContextPath() + "/list");
    }
}

