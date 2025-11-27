package com.via.schoolregen.resources.model;

public class User {

    private int userId;
    private String username;
    private String role;
    private long linkedId;
    private String firstName;

    public User(int userId, String username, String role, long linkedId, String firstName) {
        this.userId = userId;
        this.username = username;
        this.role = role;
        this.linkedId = linkedId;
        this.firstName = firstName;
    }

    // Getters
    public int getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getRole() {
        return role;
    }

    public long getLinkedId() {
        return linkedId;
    }

    public String getFirstName() {
        return firstName;
    }

    //Perms
    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }

    public boolean isRegistrar() {
        return "REGISTRAR".equals(role);
    }

    public boolean isFrontDesk() {
        return "FRONT_DESK".equals(role);
    }

    public boolean isStudent() {
        return "STUDENT".equals(role);
    }
}
