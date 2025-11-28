package com.via.schoolregen.resources.dao;

import com.via.schoolregen.resources.model.Subject;
import com.via.schoolregen.resources.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    private static final String INSERT_SQL = "INSERT INTO degree_programs (program_code, program_name, program_description, program_id) VALUES (?, ?, ?, ?);";
    private static final String SELECT_ALL_SQL = "SELECT * FROM degree_programs;";
    private static final String SELECT_BY_CODE_SQL = "SELECT * FROM degree_programs WHERE program_code = ?;";
    private static final String DELETE_SQL = "DELETE FROM degree_programs WHERE program_code = ?;";
    private static final String UPDATE_SQL = "UPDATE degree_programs SET program_name = ?, program_description = ?, program_id = ? WHERE program_code = ?;";
    private static final String COUNT_COURSE = "SELECT COUNT(*) FROM degree_programs;";
    private static final String SELECT_SUBJECTS_PAGINATED = "SELECT * FROM degree_programs LIMIT ? OFFSET ?;";

    public void insertSubject(Subject subject) throws SQLException {
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, subject.getCourseCode());
            ps.setString(2, subject.getCourseName());
            ps.setString(3, subject.getDescription());
            ps.setInt(4, subject.getCourseNumber());
            ps.executeUpdate();
        }
    }

    public Subject selectSubject(String code) {
        Subject subject = null;
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_BY_CODE_SQL)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                subject = new Subject(
                        rs.getString("program_code"),
                        rs.getString("program_name"),
                        rs.getString("program_description"),
                        rs.getInt("course_id")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subject;
    }

    public List<Subject> selectAllSubjects() {
        List<Subject> subjects = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ALL_SQL)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                subjects.add(new Subject(
                        rs.getString("program_code"),
                        rs.getString("program_name"),
                        rs.getString("program_description"),
                        rs.getInt("program_id")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    public boolean deleteSubject(String code) throws SQLException {
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setString(1, code);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateSubject(Subject subject) throws SQLException {
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, subject.getCourseName());
            ps.setString(2, subject.getDescription());
            ps.setInt(3, subject.getCourseNumber());
            ps.setString(4, subject.getCourseCode());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Subject> selectSubjectsPaginated(int limit, int offset) {
        List<Subject> subjects = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_SUBJECTS_PAGINATED)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                subjects.add(new Subject(
                        rs.getString("program_code"),
                        rs.getString("program_name"),
                        rs.getString("program_description"),
                        rs.getInt("program_id")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    public int getNoOfcourse() {
        int count = 0;
        try (Connection connection = DBUtil.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(COUNT_COURSE)) {
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
}
