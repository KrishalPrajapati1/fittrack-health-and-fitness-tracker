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
import javax.servlet.http.HttpSession;

import model.User;
import util.DatabaseConnection;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");
        
        // Debug logging
        System.out.println("Login attempt - Email: " + email + ", UserType: " + userType);
        
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            // Check if admin login is requested
            if ("admin".equals(userType)) {
                // Check for admin in database with role = 'admin'
                String adminSql = "SELECT * FROM users WHERE email = ? AND password = ? AND role = 'admin'";
                pstmt = conn.prepareStatement(adminSql);
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                
                System.out.println("Executing admin query with email: " + email);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    // Admin login successful
                    HttpSession session = request.getSession();
                    session.setAttribute("userType", "admin");
                    session.setAttribute("role", "admin");
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("adminId", rs.getInt("user_id"));
                    session.setAttribute("email", rs.getString("email"));
                    
                    System.out.println("Admin login successful for: " + email);
                    System.out.println("Admin username: " + rs.getString("username"));
                    System.out.println("Admin role: " + rs.getString("role"));
                    
                    response.sendRedirect("admin/admin-dashboard.jsp");
                } else {
                    System.out.println("Admin login failed - no matching record found");
                    request.setAttribute("error", "Invalid admin credentials");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // Regular user login
                String userSql = "SELECT * FROM users WHERE email = ? AND password = ? AND role = 'user'";
                pstmt = conn.prepareStatement(userSql);
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                
                System.out.println("Executing user query with email: " + email);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    // Create User object
                    User user = createUserFromResultSet(rs);
                    
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("userType", "user");
                    session.setAttribute("role", "user");
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("userId", user.getUser_id());
                    
                    System.out.println("User login successful for: " + email);
                    System.out.println("User ID: " + user.getUser_id());
                    System.out.println("Username: " + user.getUsername());
                    
                    response.sendRedirect("user-dashboard.jsp");
                } else {
                    System.out.println("User login failed - no matching record found");
                    request.setAttribute("error", "Invalid email or password");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Database error during login: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            // Clean up resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private User createUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUser_id(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        
        // Handle nullable fields
        user.setGender(rs.getString("gender"));
        user.setAge(rs.getInt("age"));
        user.setWeight(rs.getDouble("weight"));
        user.setHeight(rs.getDouble("height"));
        
        return user;
    }
}
