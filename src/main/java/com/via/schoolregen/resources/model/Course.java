/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.via.schoolregen.resources.model;

public class Course {
    private int courseId;
    private long studentId;
    private String courseName;
    private String grade;

    // Default constructor
    public Course() {}

    /**
     * Constructor to create a Course object.
     * @param courseId The unique ID of the course.
     * @param studentId The ID of the student this course belongs to.
     * @param courseName The name of the course (e.g., "Mathematics").
     * @param grade The grade received in the course (e.g., "A+").
     */
    public Course(int courseId, long studentId, String courseName, String grade) {
        this.courseId = courseId;
        this.studentId = studentId;
        this.courseName = courseName;
        this.grade = grade;
    }

    // --- Getters and Setters ---

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

