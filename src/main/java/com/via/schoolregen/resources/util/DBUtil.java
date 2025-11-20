
package com.via.schoolregen.resources.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * This utility class manages the database connection.
 * IMPORTANT: Update the database URL, user, and password to match MySQL setup.
 */
public class DBUtil {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/school_db?useSSL=false";
    
    //MariaDB
    private static final String JDBC_USER = "school_user"; 
    private static final String JDBC_PASSWORD = "!s3cur3School"; 
    
    //MySQL
    //private static final String JDBC_USER = "root"; 
    //private static final String JDBC_PASSWORD = "!S4f3d4t4b4s3"; 
     

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL JDBC driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }
}
