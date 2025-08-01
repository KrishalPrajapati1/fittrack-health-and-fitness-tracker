package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import util.DatabaseConnection;

@WebServlet("/set-goals")
public class SetGoalsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        loadUserGoals(request, user.getUser_id());
        request.getRequestDispatcher("set-goals.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addGoal(request, response, user.getUser_id());
        } else if ("delete".equals(action)) {
            deleteGoal(request, response);
        }
        
        loadUserGoals(request, user.getUser_id());
        request.getRequestDispatcher("set-goals.jsp").forward(request, response);
    }
    
    private void addGoal(HttpServletRequest request, HttpServletResponse response, int userId) {
        String goalType = request.getParameter("goalType");
        String targetValueStr = request.getParameter("targetValue");
        String deadline = request.getParameter("deadline");
        
        if (goalType == null || targetValueStr == null || deadline == null ||
            goalType.trim().isEmpty() || targetValueStr.trim().isEmpty() || deadline.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            return;
        }
        
        try {
            double targetValue = Double.parseDouble(targetValueStr);
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            
            try {
                conn = DatabaseConnection.getConnection();
                String sql = "INSERT INTO goals (user_id, goal_type, target_value, deadline) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                pstmt.setString(2, goalType);
                pstmt.setDouble(3, targetValue);
                pstmt.setString(4, deadline);
                
                int result = pstmt.executeUpdate();
                
                if (result > 0) {
                    request.setAttribute("success", "Goal added successfully!");
                } else {
                    request.setAttribute("error", "Failed to add goal. Please try again.");
                }
                
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error: " + e.getMessage());
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid target value");
        }
    }
    
    private void deleteGoal(HttpServletRequest request, HttpServletResponse response) {
        String goalIdStr = request.getParameter("goalId");
        
        if (goalIdStr != null && !goalIdStr.trim().isEmpty()) {
            try {
                int goalId = Integer.parseInt(goalIdStr);
                
                Connection conn = null;
                PreparedStatement pstmt = null;
                
                try {
                    conn = DatabaseConnection.getConnection();
                    String sql = "DELETE FROM goals WHERE goal_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, goalId);
                    
                    int result = pstmt.executeUpdate();
                    
                    if (result > 0) {
                        request.setAttribute("success", "Goal deleted successfully!");
                    } else {
                        request.setAttribute("error", "Failed to delete goal.");
                    }
                    
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Database error: " + e.getMessage());
                } finally {
                    try {
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid goal ID");
            }
        }
    }
    
    private void loadUserGoals(HttpServletRequest request, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Goal> goals = new ArrayList<>();
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT goal_id, goal_type, target_value, deadline FROM goals WHERE user_id = ? ORDER BY deadline ASC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Goal goal = new Goal();
                goal.setGoalId(rs.getInt("goal_id"));
                goal.setGoalType(rs.getString("goal_type"));
                goal.setTargetValue(rs.getDouble("target_value"));
                goal.setDeadline(rs.getString("deadline"));
                goals.add(goal);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("userGoals", goals);
    }
    
    // Inner class for Goal
    public static class Goal {
        private int goalId;
        private String goalType;
        private double targetValue;
        private String deadline;
        
        // Getters and setters
        public int getGoalId() { return goalId; }
        public void setGoalId(int goalId) { this.goalId = goalId; }
        
        public String getGoalType() { return goalType; }
        public void setGoalType(String goalType) { this.goalType = goalType; }
        
        public double getTargetValue() { return targetValue; }
        public void setTargetValue(double targetValue) { this.targetValue = targetValue; }
        
        public String getDeadline() { return deadline; }
        public void setDeadline(String deadline) { this.deadline = deadline; }
    }
}
