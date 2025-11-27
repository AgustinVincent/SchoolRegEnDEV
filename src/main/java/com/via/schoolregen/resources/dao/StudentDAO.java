package com.via.schoolregen.resources.dao;

import com.via.schoolregen.resources.model.Student;
import com.via.schoolregen.resources.util.DBUtil;
import com.via.schoolregen.resources.model.Course;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;

public class StudentDAO {

    
    private static final String INSERT_STUDENT_SQL = "INSERT INTO students (id, first_name, last_name, email, contact_number, date_of_birth) VALUES (?, ?, ?, ?, ?, ?);";
    private static final String INSERT_USER_SQL = "INSERT INTO system_users (username, password, role_id, student_id, is_active) VALUES (?, NULL, (SELECT role_id FROM user_roles WHERE role_name = 'STUDENT'), ?, 1);";
    private static final String SELECT_STUDENT_BY_ID = 
        "SELECT s.id, s.first_name, s.last_name, s.email, s.contact_number, s.date_of_birth, " +
        "       s.current_program, p.course_name " +
        "FROM students s " +
        "LEFT JOIN Programs p ON s.current_program = p.course_code " +
        "WHERE s.id = ?;";
    private static final String SELECT_ALL_STUDENTS = "SELECT id, first_name, last_name, email, contact_number, date_of_birth FROM students;";
    private static final String DELETE_STUDENT_SQL = "DELETE FROM students WHERE id = ?;";
    private static final String UPDATE_STUDENT_SQL = "UPDATE students SET first_name = ?, last_name = ?, email = ?, contact_number = ?, date_of_birth = ? WHERE id = ?;";
    private static final String GET_MAX_ID_FOR_YEAR_SQL = "SELECT MAX(id) FROM students WHERE id >= ? AND id < ?;";
    private static final String SELECT_COURSES_BY_STUDENT_ID
            = "SELECT e.enrollment_id, e.program_code, e.grade, dp.program_name "
            + "FROM student_enrollments e "
            + "LEFT JOIN degree_programs dp ON e.program_code = dp.program_code "
            + "WHERE e.student_id = ?;";
    private static final String SELECT_STUDENTS_PAGINATED = "SELECT id, first_name, last_name, email, contact_number, date_of_birth FROM students LIMIT ? OFFSET ?;";
    private static final String COUNT_STUDENTS = "SELECT COUNT(*) FROM students;";
    private static final String ENROLL_STUDENT_SQL = "INSERT INTO student_enrollments (student_id, program_code) VALUES (?, ?);";
    private static final String CHECK_ENROLLMENT_SQL = "SELECT 1 FROM student_enrollments WHERE student_id = ? AND program_code = ?;";
    private static final String ASSIGN_PROGRAM_SQL = "UPDATE students SET current_program = ? WHERE id = ?;";
    private static final String ADD_SUBJECT_SQL = "INSERT INTO student_enrollments (student_id, program_code) VALUES (?, ?);";

    
    public void insertStudent(Student student) throws SQLException {
        Connection connection = null;
        PreparedStatement psStudent = null;
        PreparedStatement psUser = null;

        try {
            connection = DBUtil.getConnection();

            
            connection.setAutoCommit(false);

            
            long newId = generateNextStudentId(connection); 

            psStudent = connection.prepareStatement(INSERT_STUDENT_SQL);
            psStudent.setLong(1, newId);
            psStudent.setString(2, student.getFirstName());
            psStudent.setString(3, student.getLastName());

            if (student.getEmail() != null && !student.getEmail().trim().isEmpty()) {
                psStudent.setString(4, student.getEmail());
            } else {
                psStudent.setNull(4, java.sql.Types.VARCHAR);
            }

            if (student.getContactNumber() != null && !student.getContactNumber().trim().isEmpty()) {
                psStudent.setString(5, student.getContactNumber());
            } else {
                psStudent.setNull(5, java.sql.Types.VARCHAR);
            }

            psStudent.setObject(6, student.getDateOfBirth());
            psStudent.executeUpdate();

            psUser = connection.prepareStatement(INSERT_USER_SQL);
            psUser.setString(1, String.valueOf(newId));
            psUser.setLong(2, newId);
            psUser.executeUpdate();


            connection.commit();

        } catch (SQLException e) {

            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e;
        } finally {

            if (psStudent != null) {
                psStudent.close();
            }
            if (psUser != null) {
                psUser.close();
            }
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }


    private synchronized long generateNextStudentId(Connection connection) throws SQLException {
        int year = Calendar.getInstance().get(Calendar.YEAR);
        long startOfYearId = year * 10000L;
        long endOfYearId = (year + 1) * 10000L;

        long lastId = 0;

        try (PreparedStatement ps = connection.prepareStatement(GET_MAX_ID_FOR_YEAR_SQL)) {
            ps.setLong(1, startOfYearId);
            ps.setLong(2, endOfYearId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                lastId = rs.getLong(1);
            }
        }

        if (lastId == 0) {
            return startOfYearId + 1;
        } else {
            return lastId + 1;
        }
    }


    private synchronized long generateNextStudentId() throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            return generateNextStudentId(conn);
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
                

                String programCode = rs.getString("current_program");
                String programName = rs.getString("course_name");


                student = new Student(id, firstName, lastName, email, contactNumber, dateOfBirth, null, programCode, programName);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return student;
    }

    public List<Student> selectAllStudents() {
        List<Student> students = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_STUDENTS)) {
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                long id = rs.getLong("id");
                String firstName = rs.getString("first_name");
                String lastName = rs.getString("last_name");
                String email = rs.getString("email");
                String contactNumber = rs.getString("contact_number");
                Date dobSql = rs.getDate("date_of_birth");
                LocalDate dateOfBirth = (dobSql != null) ? dobSql.toLocalDate() : null;
                students.add(new Student(id, firstName, lastName, email, contactNumber, dateOfBirth, null));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public boolean deleteStudent(long id) throws SQLException {
        boolean rowDeleted;
        
        try (Connection connection = DBUtil.getConnection(); PreparedStatement statement = connection.prepareStatement(DELETE_STUDENT_SQL)) {
            statement.setLong(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    public boolean updateStudent(Student student) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = DBUtil.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_STUDENT_SQL)) {
            preparedStatement.setString(1, student.getFirstName());
            preparedStatement.setString(2, student.getLastName());

            if (student.getEmail() != null && !student.getEmail().trim().isEmpty()) {
                preparedStatement.setString(3, student.getEmail());
            } else {
                preparedStatement.setNull(3, java.sql.Types.VARCHAR);
            }

            if (student.getContactNumber() != null && !student.getContactNumber().trim().isEmpty()) {
                preparedStatement.setString(4, student.getContactNumber());
            } else {
                preparedStatement.setNull(4, java.sql.Types.VARCHAR);
            }

            preparedStatement.setObject(5, student.getDateOfBirth());
            preparedStatement.setLong(6, student.getId());
            rowUpdated = preparedStatement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    public List<Student> selectStudentsPaginated(int limit, int offset) {
        List<Student> students = new ArrayList<>();

        try (Connection connection = DBUtil.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(SELECT_STUDENTS_PAGINATED)) {

            preparedStatement.setInt(1, limit);
            preparedStatement.setInt(2, offset);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                long id = rs.getLong("id");
                String firstName = rs.getString("first_name");
                String lastName = rs.getString("last_name");
                String email = rs.getString("email");
                String contactNumber = rs.getString("contact_number");
                Date dobSql = rs.getDate("date_of_birth");
                LocalDate dateOfBirth = (dobSql != null) ? dobSql.toLocalDate() : null;
                students.add(new Student(id, firstName, lastName, email, contactNumber, dateOfBirth, null));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public int getNoOfRecords() {
        int count = 0;
        try (Connection connection = DBUtil.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(COUNT_STUDENTS)) {
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Student> searchStudents(String query) {
        List<Student> students = new ArrayList<>();
        
        String sql = "SELECT id, first_name, last_name, email, contact_number, date_of_birth "
                + "FROM students "
                + "WHERE first_name LIKE ? OR last_name LIKE ? OR CAST(id AS CHAR) LIKE ?;";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            String searchPattern = "%" + query + "%";
            preparedStatement.setString(1, searchPattern);
            preparedStatement.setString(2, searchPattern);
            preparedStatement.setString(3, searchPattern);

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                long id = rs.getLong("id");
                String firstName = rs.getString("first_name");
                String lastName = rs.getString("last_name");
                String email = rs.getString("email");
                String contactNumber = rs.getString("contact_number");
                Date dobSql = rs.getDate("date_of_birth");
                LocalDate dateOfBirth = (dobSql != null) ? dobSql.toLocalDate() : null;
                students.add(new Student(id, firstName, lastName, email, contactNumber, dateOfBirth, null));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

  
    public List<Course> selectCoursesForStudent(long studentId) {
        List<Course> courses = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COURSES_BY_STUDENT_ID)) {

            preparedStatement.setLong(1, studentId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int courseId = rs.getInt("enrollment_id");
                String code = rs.getString("program_code"); 
                String grade = rs.getString("grade");
                String programName = rs.getString("program_name");


                String displayName = (programName != null) ? programName : code;

                courses.add(new Course(courseId, studentId, displayName, grade));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public boolean enrollStudent(long studentId, String courseCode) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {


            try (PreparedStatement checkPs = conn.prepareStatement(CHECK_ENROLLMENT_SQL)) {
                checkPs.setLong(1, studentId);
                checkPs.setString(2, courseCode); 
                ResultSet rs = checkPs.executeQuery();
                if (rs.next()) {
                    return false; 
                }
            }


            try (PreparedStatement ps = conn.prepareStatement(ENROLL_STUDENT_SQL)) {
                ps.setLong(1, studentId);
                ps.setString(2, courseCode);
                return ps.executeUpdate() > 0;
            }
        }

    }
    public boolean assignProgram(long studentId, String programCode) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(ASSIGN_PROGRAM_SQL)) {
            ps.setString(1, programCode);
            ps.setLong(2, studentId);
            return ps.executeUpdate() > 0;
        }
    }
    
    public boolean addSubjectToStudent(long studentId, String courseCode) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(ADD_SUBJECT_SQL)) {
            ps.setLong(1, studentId);
            ps.setString(2, courseCode);
            return ps.executeUpdate() > 0;
        }
    }
}
