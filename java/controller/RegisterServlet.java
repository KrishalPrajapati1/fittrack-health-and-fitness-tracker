package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DatabaseConnection;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String gender = request.getParameter("gender");
        String ageStr = request.getParameter("age");
        String weightStr = request.getParameter("weight");
        String heightStr = request.getParameter("height");
        
        // Validation
        if (username == null || email == null || password == null || 
            username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Email validation
        if (!email.contains("@") || !email.contains(".")) {
            request.setAttribute("error", "Please enter a valid email address");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        int age = 0;
        double weight = 0.0;
        double height = 0.0;
        
        try {
            age = Integer.parseInt(ageStr);
            weight = Double.parseDouble(weightStr);
            height = Double.parseDouble(heightStr);
            
            if (age < 13 || age > 120) {
                request.setAttribute("error", "Age must be between 13 and 120");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (weight < 20 || weight > 500) {
                request.setAttribute("error", "Weight must be between 20kg and 500kg");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (height < 100 || height > 250) {
                request.setAttribute("error", "Height must be between 100cm and 250cm");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter valid numbers for age, weight, and height");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            // Check if email already exists
            String checkSql = "SELECT email FROM users WHERE email = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("error", "Email already exists. Please use a different email.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Insert new user
            String insertSql = "INSERT INTO users (username, email, password, gender, age, weight, height) VALUES (?, ?, ?, ?, ?, ?, ?)";
            insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, username);
            insertStmt.setString(2, email);
            insertStmt.setString(3, password);
            insertStmt.setString(4, gender);
            insertStmt.setInt(5, age);
            insertStmt.setDouble(6, weight);
            insertStmt.setDouble(7, height);
            
            int result = insertStmt.executeUpdate();
            
            if (result > 0) {
                request.setAttribute("success", "Registration successful! Please login with your credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}