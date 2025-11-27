package com.via.schoolregen.resources.dao;

import com.via.schoolregen.resources.model.Program;
import com.via.schoolregen.resources.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProgramDAO {

    
    private static final String INSERT_SQL = "INSERT INTO Programs (course_code, course_name, course_description) VALUES (?, ?, ?);";
    private static final String SELECT_ALL_SQL = "SELECT * FROM Programs;";
    private static final String SELECT_BY_CODE = "SELECT * FROM Programs WHERE course_code = ?;";
    private static final String DELETE_SQL = "DELETE FROM Programs WHERE course_code = ?;";
    private static final String UPDATE_SQL = "UPDATE Programs SET course_name = ?, course_description = ? WHERE course_code = ?;";

    private static final String COUNT_PROGRAMS_SQL = "SELECT COUNT(*) FROM Programs;";
    private static final String SELECT_PROGRAMS_PAGINATED = "SELECT * FROM Programs LIMIT ? OFFSET ?;";

    public void insertProgram(Program prog) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, prog.getCourseCode());
            ps.setString(2, prog.getCourseName());
            ps.setString(3, prog.getDescription());
            ps.executeUpdate();
        }
    }

    public Program selectProgram(String code) {
        Program prog = null;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_CODE)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                prog = new Program(
                    rs.getString("course_code"),
                    rs.getString("course_name"),
                    rs.getString("course_description")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prog;
    }

    public List<Program> selectAllPrograms() {
        List<Program> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_SQL)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Program(
                    rs.getString("course_code"),
                    rs.getString("course_name"),
                    rs.getString("course_description")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteProgram(String code) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setString(1, code);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateProgram(Program prog) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, prog.getCourseName());
            ps.setString(2, prog.getDescription());
            ps.setString(3, prog.getCourseCode());
            return ps.executeUpdate() > 0;
        }
    }
    
    public int getProgramCount() {
        int count = 0;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_PROGRAMS_SQL)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public List<Program> selectProgramsPaginated(int limit, int offset) {
        List<Program> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_PROGRAMS_PAGINATED)) {
            
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Program(
                    rs.getString("course_code"),
                    rs.getString("course_name"),
                    rs.getString("course_description")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}