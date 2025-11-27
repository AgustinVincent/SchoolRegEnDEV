package com.via.schoolregen.resources.web;

import com.via.schoolregen.resources.dao.ProgramDAO;
import com.via.schoolregen.resources.model.Program;
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


@WebServlet("/programs")
public class ProgramControllerServlet extends HttpServlet {

    private ProgramDAO programDAO;

    @Override
    public void init() {
        programDAO = new ProgramDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || user.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "insert":
                    insertProgram(request, response);
                    break;
                case "delete":
                    deleteProgram(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "update":
                    updateProgram(request, response);
                    break;
                default:
                    listPrograms(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listPrograms(HttpServletRequest request, HttpServletResponse response)
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
        

        List<Program> listPrograms = programDAO.selectProgramsPaginated(recordsPerPage, offset);
        int noOfRecords = programDAO.getProgramCount();
        int noOfPages = (int) Math.ceil(noOfRecords * 1.0 / recordsPerPage);

        request.setAttribute("listPrograms", listPrograms);
        request.setAttribute("noOfPages", noOfPages);
        request.setAttribute("currentPage", page);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("list-programs.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("program-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String code = request.getParameter("code");
        Program existingProgram = programDAO.selectProgram(code);
        RequestDispatcher dispatcher = request.getRequestDispatcher("program-form.jsp");
        request.setAttribute("program", existingProgram);
        dispatcher.forward(request, response);
    }

    private void insertProgram(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String code = request.getParameter("courseCode");
        String name = request.getParameter("courseName");
        String desc = request.getParameter("description");
        //int num = Integer.parseInt(request.getParameter("courseNumber"));

        Program newProgram = new Program(code, name, desc);
        programDAO.insertProgram(newProgram);
        response.sendRedirect("programs?action=list");
    }

    private void updateProgram(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String code = request.getParameter("courseCode");
        String name = request.getParameter("courseName");
        String desc = request.getParameter("description");
        //int num = Integer.parseInt(request.getParameter("courseNumber"));

        Program program = new Program(code, name, desc);
        programDAO.updateProgram(program);
        response.sendRedirect("programs?action=list");
    }

    private void deleteProgram(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String code = request.getParameter("code");
        try {
            programDAO.deleteProgram(code);
            response.sendRedirect("programs?action=list");
        } catch (SQLException e) {

            if (e.getErrorCode() == 1451) {
                String error = "Cannot delete " + code + ": Students are enrolled in this program.";
                response.sendRedirect("programs?action=list&error=" + java.net.URLEncoder.encode(error, "UTF-8"));
            } else {
                throw e;
            }
        }
    }
}