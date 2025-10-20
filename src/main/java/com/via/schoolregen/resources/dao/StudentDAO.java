/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.via.schoolregen.resources.dao;

import com.via.schoolregen.resources.model.Student;
import com.via.schoolregen.resources.util.DBUtil;
import com.via.schoolregen.resources.model.Course;


import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class StudentDAO {

    private static final String INSERT_STUDENT_SQL = "INSERT INTO students (id, first_name, last_name, email, contact_number, date_of_birth) VALUES (?, ?, ?, ?, ?, ?);";
    private static final String SELECT_STUDENT_BY_ID = "SELECT id, first_name, last_name, email, contact_number, date_of_birth FROM students WHERE id = ?;";
    private static final String SELECT_ALL_STUDENTS = "SELECT id, first_name, last_name, email, contact_number, date_of_birth FROM students;";
    private static final String DELETE_STUDENT_SQL = "DELETE FROM students WHERE id = ?;";
    private static final String UPDATE_STUDENT_SQL = "UPDATE students SET first_name = ?, last_name = ?, email = ?, contact_number = ?, date_of_birth = ? WHERE id = ?;";
    private static final String GET_MAX_ID_FOR_YEAR_SQL = "SELECT MAX(id) FROM students WHERE id >= ? AND id < ?;";
    private static final String SELECT_COURSES_BY_STUDENT_ID = "SELECT course_id, course_name, grade FROM courses WHERE student_id = ?;";


    public void insertStudent(Student student) throws SQLException {
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_STUDENT_SQL)) {
            
            long newId = generateNextStudentId();
            preparedStatement.setLong(1, newId);
            preparedStatement.setString(2, student.getFirstName());
            preparedStatement.setString(3, student.getLastName());
            preparedStatement.setString(4, student.getEmail());
            preparedStatement.setString(5, student.getContactNumber());
            preparedStatement.setObject(6, student.getDateOfBirth());
            preparedStatement.executeUpdate();
        }
    }

    public Student selectStudent(long id) {
        Student student = null;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_STUDENT_BY_ID)) {
            preparedStatement.setLong(1, id);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                String firstName = rs.getString("first_name");
                String lastName = rs.getString("last_name");
                String email = rs.getString("email");
                String contactNumber = rs.getString("contact_number");
                Date dobSql = rs.getDate("date_of_birth");
                LocalDate dateOfBirth = (dobSql != null) ? dobSql.toLocalDate() : null;
                student = new Student(id, firstName, lastName, email, contactNumber, dateOfBirth);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return student;
    }

    public List<Student> selectAllStudents() {
        List<Student> students = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_STUDENTS)) {
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                long id = rs.getLong("id");
                String firstName = rs.getString("first_name");
                String lastName = rs.getString("last_name");
                String email = rs.getString("email");
                String contactNumber = rs.getString("contact_number");
                Date dobSql = rs.getDate("date_of_birth");
                LocalDate dateOfBirth = (dobSql != null) ? dobSql.toLocalDate() : null;
                students.add(new Student(id, firstName, lastName, email, contactNumber, dateOfBirth));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public boolean deleteStudent(long id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_STUDENT_SQL)) {
            statement.setLong(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    public boolean updateStudent(Student student) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_STUDENT_SQL)) {
            preparedStatement.setString(1, student.getFirstName());
            preparedStatement.setString(2, student.getLastName());
            preparedStatement.setString(3, student.getEmail());
            preparedStatement.setString(4, student.getContactNumber());
            preparedStatement.setObject(5, student.getDateOfBirth());
            preparedStatement.setLong(6, student.getId());
            rowUpdated = preparedStatement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    private synchronized long generateNextStudentId() throws SQLException {
        int year = Calendar.getInstance().get(Calendar.YEAR);
        long startOfYearId = year * 10000L; // e.g., 20250000
        long endOfYearId = (year + 1) * 10000L; // e.g., 20260000

        long lastId = 0;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(GET_MAX_ID_FOR_YEAR_SQL)) {
            ps.setLong(1, startOfYearId);
            ps.setLong(2, endOfYearId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                lastId = rs.getLong(1);
            }
        }

        if (lastId == 0) {
            // No students yet this year, start with 0001
            return startOfYearId + 1;
        } else {
            // Increment the last ID found
            return lastId + 1;
        }
    }
     public List<Course> selectCoursesForStudent(long studentId) {
        List<Course> courses = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COURSES_BY_STUDENT_ID)) {
            preparedStatement.setLong(1, studentId);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                int courseId = rs.getInt("course_id");
                String courseName = rs.getString("course_name");
                String grade = rs.getString("grade");
                // Corrected this line to match the Course constructor
                courses.add(new Course(courseId, studentId, courseName, grade));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }
}

