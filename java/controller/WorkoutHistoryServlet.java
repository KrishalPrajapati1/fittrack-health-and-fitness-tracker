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

@WebServlet("/workout-history")
public class WorkoutHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deleteWorkoutLog(request, response);
        }
        
        loadWorkoutHistory(request, user.getUser_id());
        request.getRequestDispatcher("workout-history.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void deleteWorkoutLog(HttpServletRequest request, HttpServletResponse response) {
        String logIdStr = request.getParameter("logId");
        
        if (logIdStr != null && !logIdStr.trim().isEmpty()) {
            try {
                int logId = Integer.parseInt(logIdStr);
                
                Connection conn = null;
                PreparedStatement pstmt = null;
                
                try {
                    conn = DatabaseConnection.getConnection();
                    String sql = "DELETE FROM user_logs WHERE log_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, logId);
                    
                    int result = pstmt.executeUpdate();
                    
                    if (result > 0) {
                        request.setAttribute("success", "Workout log deleted successfully!");
                    } else {
                        request.setAttribute("error", "Failed to delete workout log.");
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
                request.setAttribute("error", "Invalid log ID");
            }
        }
    }
    
    private void loadWorkoutHistory(HttpServletRequest request, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<WorkoutHistoryItem> workoutHistory = new ArrayList<>();
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT ul.log_id, ul.log_date, ul.notes, w.name as workout_name, " +
                        "w.type, w.duration, w.calories_burned " +
                        "FROM user_logs ul " +
                        "JOIN workouts w ON ul.workout_id = w.workout_id " +
                        "WHERE ul.user_id = ? " +
                        "ORDER BY ul.log_date DESC, ul.log_id DESC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                WorkoutHistoryItem item = new WorkoutHistoryItem();
                item.setLogId(rs.getInt("log_id"));
                item.setLogDate(rs.getString("log_date"));
                item.setNotes(rs.getString("notes"));
                item.setWorkoutName(rs.getString("workout_name"));
                
                // Standardize workout type
                String type = standardizeWorkoutType(rs.getString("type"));
                item.setWorkoutType(type);
                
                item.setDuration(rs.getInt("duration"));
                item.setCaloriesBurned(rs.getInt("calories_burned"));
                workoutHistory.add(item);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading workout history: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("workoutHistory", workoutHistory);
    }
    
    private String standardizeWorkoutType(String rawType) {
        if (rawType == null) return "unknown";
        
        String lowerType = rawType.toLowerCase();
        if (lowerType.contains("cardio")) return "cardio";
        if (lowerType.contains("flex")) return "flexibility";
        if (lowerType.contains("strength")) return "strength";
        return lowerType; // Return lowercase version if not matched
    }
    
    public static class WorkoutHistoryItem {
        private int logId;
        private String logDate;
        private String notes;
        private String workoutName;
        private String workoutType;
        private int duration;
        private int caloriesBurned;
        
        // Getters and setters
        public int getLogId() { return logId; }
        public void setLogId(int logId) { this.logId = logId; }
        
        public String getLogDate() { return logDate; }
        public void setLogDate(String logDate) { this.logDate = logDate; }
        
        public String getNotes() { return notes; }
        public void setNotes(String notes) { this.notes = notes; }
        
        public String getWorkoutName() { return workoutName; }
        public void setWorkoutName(String workoutName) { this.workoutName = workoutName; }
        
        public String getWorkoutType() { return workoutType; }
        public void setWorkoutType(String workoutType) { this.workoutType = workoutType; }
        
        public int getDuration() { return duration; }
        public void setDuration(int duration) { this.duration = duration; }
        
        public int getCaloriesBurned() { return caloriesBurned; }
        public void setCaloriesBurned(int caloriesBurned) { this.caloriesBurned = caloriesBurned; }
    }
}
