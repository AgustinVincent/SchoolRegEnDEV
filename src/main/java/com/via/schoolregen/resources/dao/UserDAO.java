package com.via.schoolregen.resources.dao;

import com.via.schoolregen.resources.model.User;
import com.via.schoolregen.resources.util.DBUtil;
import java.sql.*;

public class UserDAO {


    private static final String AUTH_SQL = 
        "SELECT u.user_id, u.username, u.password, r.role_name, " +
        "       u.student_id, u.staff_id, " +
        "       s.first_name AS student_name, st.first_name AS staff_name " +
        "FROM system_users u " +
        "JOIN user_roles r ON u.role_id = r.role_id " +
        "LEFT JOIN students s ON u.student_id = s.id " +
        "LEFT JOIN staff st ON u.staff_id = st.staff_id " +
        "WHERE u.username = ? AND u.is_active = 1;";

    private static final String UPDATE_PASSWORD_SQL = "UPDATE system_users SET password = ? WHERE user_id = ?;";

    public UserResult authenticate(String username, String password) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(AUTH_SQL)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbPass = rs.getString("password");
                
                // 1. Check password NULL
                if (dbPass == null) {
                    return new UserResult(null, UserResult.Status.SETUP_REQUIRED, rs.getInt("user_id"));
                }
                
                // 2. Check password match
                if (dbPass.equals(password)) {
                    
                    int userId = rs.getInt("user_id");
                    String role = rs.getString("role_name");
                    long linkedId = 0;
                    String name = "";

                    if ("STUDENT".equals(role)) {
                        linkedId = rs.getLong("student_id");
                        name = rs.getString("student_name");
                    } else {
                        linkedId = rs.getLong("staff_id");
                        name = rs.getString("staff_name");
                    }

                    User user = new User(userId, username, role, linkedId, name);
                    return new UserResult(user, UserResult.Status.SUCCESS, 0);
                } else {
                    
                    int userId = rs.getInt("user_id");
                    String role = rs.getString("role_name");
                    String name = "STUDENT".equals(role) ? rs.getString("student_name") : rs.getString("staff_name");
                    
                    User partialUser = new User(userId, username, role, 0, name);
                    return new UserResult(partialUser, UserResult.Status.WRONG_PASSWORD, userId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new UserResult(null, UserResult.Status.USER_NOT_FOUND, 0);
    }

    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PASSWORD_SQL)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }


    public static class UserResult {
        public enum Status { SUCCESS, WRONG_PASSWORD, SETUP_REQUIRED, USER_NOT_FOUND }
        public User user;
        public Status status;
        public int userId;

        public UserResult(User user, Status status, int userId) {
            this.user = user;
            this.status = status;
            this.userId = userId;
        }
    }
}