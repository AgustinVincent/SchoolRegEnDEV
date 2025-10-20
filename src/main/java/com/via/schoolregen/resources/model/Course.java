package com.via.schoolregen.resources.model;

public class Course {
    private int courseId;
    private long studentId;
    private String courseName;
    private String grade;


    public Course() {}

    public Course(int courseId, long studentId, String courseName, String grade) {
        this.courseId = courseId;
        this.studentId = studentId;
        this.courseName = courseName;
        this.grade = grade;
    }

    //Getters and Setters

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public long getStudentId() {
        return studentId;
    }

    public void setStudentId(long studentId) {
        this.studentId = studentId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }
}

