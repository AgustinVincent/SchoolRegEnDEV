package com.via.schoolregen.resources.web;

import com.via.schoolregen.resources.dao.SubjectDAO;
import com.via.schoolregen.resources.model.Subject;
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
import java.util.List;

@WebServlet("/subjects")
public class SubjectControllerServlet extends HttpServlet {

    private SubjectDAO subjectDAO;

    @Override
    public void init() {
        subjectDAO = new SubjectDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || user.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "insert":
                    insertSubject(request, response);
                    break;
                case "delete":
                    deleteSubject(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "update":
                    updateSubject(request, response);
                    break;

                default:
                    listSubjects(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listSubjects(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
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
        
        List<Subject> listSubjects = subjectDAO.selectSubjectsPaginated(recordsPerPage, offset);
        int noOfRecords = subjectDAO.getNoOfcourse();
        int noOfPages = (int) Math.ceil(noOfRecords * 1.0 / recordsPerPage);

        request.setAttribute("listSubjects", listSubjects);
        request.setAttribute("noOfPages", noOfPages);
        request.setAttribute("currentPage", page);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("list-subjects.jsp");
        dispatcher.forward(request, response);
    }
    
    

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("subject-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String code = request.getParameter("code");
        Subject existingSubject = subjectDAO.selectSubject(code);
        RequestDispatcher dispatcher = request.getRequestDispatcher("subject-form.jsp");
        request.setAttribute("subject", existingSubject);
        dispatcher.forward(request, response);
    }

    private void insertSubject(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String code = request.getParameter("courseCode");
        String name = request.getParameter("courseName");
        String desc = request.getParameter("description");
        int num = Integer.parseInt(request.getParameter("courseNumber"));

        Subject newSubject = new Subject(code, name, desc, num);
        subjectDAO.insertSubject(newSubject);
        response.sendRedirect("subjects?action=list");
    }

    private void updateSubject(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String code = request.getParameter("courseCode");
        String name = request.getParameter("courseName");
        String desc = request.getParameter("description");
        int num = Integer.parseInt(request.getParameter("courseNumber"));

        Subject subject = new Subject(code, name, desc, num);
        subjectDAO.updateSubject(subject);
        response.sendRedirect("subjects?action=list");
    }

    private void deleteSubject(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String code = request.getParameter("code");
        subjectDAO.deleteSubject(code);
        response.sendRedirect("subjects?action=list");
    }

    
}
