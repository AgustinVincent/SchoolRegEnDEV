package com.via.schoolregen.resources.web;

import com.via.schoolregen.resources.dao.UserDAO;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet(urlPatterns = {"/login", "/auth", "/setup-password", "/log-egg", "/check-egg"})
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    public void log(String message) {
        String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        System.out.println("[" + time + "] " + message);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ipAddress = request.getRemoteAddr();
        log("CONNECTION: Client with IP " + ipAddress + " connected to Login Page.");
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
    }

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
                case "/check-egg":
                    verifyKonamiCode(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleInitialCheck(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("usernameOrId");
        
        UserDAO.UserResult result = userDAO.authenticate(username, ""); 

        if (result.status == UserDAO.UserResult.Status.USER_NOT_FOUND) {
            request.setAttribute("error", "User ID or Username not found.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } 
        else if (result.status == UserDAO.UserResult.Status.SETUP_REQUIRED) {
            request.setAttribute("userId", result.userId);
            RequestDispatcher dispatcher = request.getRequestDispatcher("set-password.jsp");
            dispatcher.forward(request, response);
        } 
        else {
            request.setAttribute("targetUser", result.user.getUsername());
            request.setAttribute("greetingName", result.user.getFirstName());
            request.setAttribute("userId", result.user.getUserId());
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("enter-password.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void handleAuthentication(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("targetUser");
        String password = request.getParameter("password");
        
        UserDAO.UserResult result = userDAO.authenticate(username, password);

        if (result.status == UserDAO.UserResult.Status.SUCCESS) {
            HttpSession session = request.getSession();
            session.setAttribute("user", result.user);
            log("LOGIN: " + result.user.getRole() + " " + username + " logged in.");

            //route
            if (result.user.isStudent()) {
                response.sendRedirect(request.getContextPath() + "/view");
            } else {

                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } else {

            request.setAttribute("error", "Incorrect password.");
            request.setAttribute("targetUser", username);
            request.setAttribute("greetingName", result.user.getFirstName());
            request.setAttribute("userId", result.userId);
            
            request.getRequestDispatcher("enter-password.jsp").forward(request, response);
        }
    }


    private void handlePasswordSetup(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword != null && newPassword.equals(confirmPassword)) {
            userDAO.updatePassword(userId, newPassword);
            log("SETUP: User ID " + userId + " set a new password.");
            
            request.setAttribute("error", "Password set! Please log in.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("userId", userId);
            request.getRequestDispatcher("set-password.jsp").forward(request, response);
        }
    }

    
    
    //AI Generated Content
    // (Keep your verifyKonamiCode method here...)
    private void verifyKonamiCode(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userSequence = request.getParameter("seq");
        String correctSequence = "ArrowUpArrowUpArrowDownArrowDownArrowLeftArrowRightArrowLeftArrowRightba";
        if (userSequence != null && userSequence.endsWith(correctSequence)) {
            request.getSession().setAttribute("egg_unlocked", true);
            response.setStatus(HttpServletResponse.SC_OK); 
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }
    //end
}