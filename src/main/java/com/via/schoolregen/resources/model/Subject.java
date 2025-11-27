package com.via.schoolregen.resources.model;

public class Subject {

    private String courseCode;
    private String courseName;
    private String description;
    private int courseNumber;

    public Subject() {
    }

    public Subject(String courseCode, String courseName, String description, int courseNumber) {
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.description = description;
        this.courseNumber = courseNumber;
    }

    // Getters and Setters
    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCourseNumber() {
        return courseNumber;
    }

    public void setCourseNumber(int courseNumber) {
        this.courseNumber = courseNumber;
    }
}
