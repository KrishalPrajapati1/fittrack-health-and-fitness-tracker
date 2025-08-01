package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import util.DatabaseConnection;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.getRequestDispatcher("update-profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String gender = request.getParameter("gender");
        String ageStr = request.getParameter("age");
        String weightStr = request.getParameter("weight");
        String heightStr = request.getParameter("height");
        
        // Validation
        if (username == null || email == null || username.trim().isEmpty() || email.trim().isEmpty()) {
            request.setAttribute("error", "Username and email are required");
            request.getRequestDispatcher("update-profile.jsp").forward(request, response);
            return;
        }
        
        // Email validation
        if (!email.contains("@") || !email.contains(".")) {
            request.setAttribute("error", "Please enter a valid email address");
            request.getRequestDispatcher("update-profile.jsp").forward(request, response);
            return;
        }
        
        // If password change is requested
        boolean passwordChange = false;
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                request.setAttribute("error", "Current password is required to change password");
                request.getRequestDispatcher("update-profile.jsp").forward(request, response);
                return;
            }
            
            if (!currentPassword.equals(user.getPassword())) {
                request.setAttribute("error", "Current password is incorrect");
                request.getRequestDispatcher("update-profile.jsp").forward(request, response);
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New passwords do not match");
                request.getRequestDispatcher("update-profile.jsp").forward(request, response);
                return;
            }
            
            if (newPassword.length() < 6) {
                request.setAttribute("error", "New password must be at least 6 characters long");
                request.getRequestDispatcher("update-profile.jsp").forward(request, response);
                return;
            }
            
            passwordChange = true;
        }
        
        int age = 0;
        double weight = 0.0;
        double height = 0.0;
        
        try {
            if (ageStr != null && !ageStr.trim().isEmpty()) {
                age = Integer.parseInt(ageStr);
                if (age < 13 || age > 120) {
                    request.setAttribute("error", "Age must be between 13 and 120");
                    request.getRequestDispatcher("update-profile.jsp").forward(request, response);
                    return;
                }
            }
            
            if (weightStr != null && !weightStr.trim().isEmpty()) {
                weight = Double.parseDouble(weightStr);
                if (weight < 20 || weight > 500) {
                    request.setAttribute("error", "Weight must be between 20kg and 500kg");
                    request.getRequestDispatcher("update-profile.jsp").forward(request, response);
                    return;
                }
            }
            
            if (heightStr != null && !heightStr.trim().isEmpty()) {
                height = Double.parseDouble(heightStr);
                if (height < 100 || height > 250) {
                    request.setAttribute("error", "Height must be between 100cm and 250cm");
                    request.getRequestDispatcher("update-profile.jsp").forward(request, response);
                    return;
                }
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter valid numbers for age, weight, and height");
            request.getRequestDispatcher("update-profile.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            String sql;
            if (passwordChange) {
                sql = "UPDATE users SET username = ?, email = ?, password = ?, gender = ?, age = ?, weight = ?, height = ? WHERE user_id = ?";
            } else {
                sql = "UPDATE users SET username = ?, email = ?, gender = ?, age = ?, weight = ?, height = ? WHERE user_id = ?";
            }
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            
            if (passwordChange) {
                pstmt.setString(3, newPassword);
                pstmt.setString(4, gender);
                pstmt.setInt(5, age);
                pstmt.setDouble(6, weight);
                pstmt.setDouble(7, height);
                pstmt.setInt(8, user.getUser_id());
            } else {
                pstmt.setString(3, gender);
                pstmt.setInt(4, age);
                pstmt.setDouble(5, weight);
                pstmt.setDouble(6, height);
                pstmt.setInt(7, user.getUser_id());
            }
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                // Update session user object
                user.setUsername(username);
                user.setEmail(email);
                if (passwordChange) {
                    user.setPassword(newPassword);
                }
                user.setGender(gender);
                user.setAge(age);
                user.setWeight(weight);
                user.setHeight(height);
                
                session.setAttribute("user", user);
                session.setAttribute("username", username);
                
                request.setAttribute("success", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update profile. Please try again.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("update-profile.jsp").forward(request, response);
    }
}
