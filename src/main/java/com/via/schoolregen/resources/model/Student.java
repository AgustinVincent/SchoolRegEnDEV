package com.via.schoolregen.resources.model;

import java.time.LocalDate;

public class Student {

    private long id;
    private String firstName;
    private String lastName;
    private String email;
    private String contactNumber;
    private LocalDate dateOfBirth;
    private String password;
    private String programCode; 
    private String programName; 

    public Student() {
    }

    public Student(long id, String firstName, String lastName, String email,
            String contactNumber, LocalDate dateOfBirth, String password,
            String programCode, String programName) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.contactNumber = contactNumber;
        this.dateOfBirth = dateOfBirth;
        this.password = password;
        this.programCode = programCode;
        this.programName = programName;
    }

    public Student(long id, String firstName, String lastName, String email,
            String contactNumber, LocalDate dateOfBirth, String password) {
        this(id, firstName, lastName, email, contactNumber, dateOfBirth, password, null, null);
    }

    //Getters and Setters
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getProgramCode() {
        return programCode;
    }

    public void setProgramCode(String programCode) {
        this.programCode = programCode;
    }

    public String getProgramName() {
        return programName;
    }

    public void setProgramName(String programName) {
        this.programName = programName;
    }
}

