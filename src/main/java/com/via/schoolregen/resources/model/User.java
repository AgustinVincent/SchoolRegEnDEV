package com.via.schoolregen.resources.model;

public class User {
    private String username; // should be set "admin" or student ID
    private String role;     // Shoule be set "admin" or "student"

    public User(String username, String role) {
        this.username = username;
        this.role = role;
    }

    public String getUsername() {
        return username;
    }

    public String getRole() {
        return role;
    }

    public boolean isAdmin() {
        return "admin".equals(this.role);
    }
}
