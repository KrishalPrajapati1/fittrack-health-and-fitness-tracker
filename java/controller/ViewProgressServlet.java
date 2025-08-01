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

@WebServlet("/view-progress")
public class ViewProgressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Load user's workout logs and statistics
        loadWorkoutLogs(request, user.getUser_id());
        loadProgressStats(request, user.getUser_id());
        
        request.getRequestDispatcher("view-progress.jsp").forward(request, response);
    }
    
    private void loadWorkoutLogs(HttpServletRequest request, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<WorkoutLog> workoutLogs = new ArrayList<>();
        
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
                WorkoutLog log = new WorkoutLog();
                log.setLogId(rs.getInt("log_id"));
                log.setLogDate(rs.getString("log_date"));
                log.setNotes(rs.getString("notes"));
                log.setWorkoutName(rs.getString("workout_name"));
                log.setWorkoutType(rs.getString("type"));
                log.setDuration(rs.getInt("duration"));
                log.setCaloriesBurned(rs.getInt("calories_burned"));
                workoutLogs.add(log);
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
        
        request.setAttribute("workoutLogs", workoutLogs);
    }
    
    private void loadProgressStats(HttpServletRequest request, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ProgressStats stats = new ProgressStats();
        
        try {
            conn = DatabaseConnection.getConnection();
            
            // Get total workouts and calories
            String sql = "SELECT COUNT(*) as total_workouts, " +
                        "SUM(w.calories_burned) as total_calories, " +
                        "SUM(w.duration) as total_minutes " +
                        "FROM user_logs ul " +
                        "JOIN workouts w ON ul.workout_id = w.workout_id " +
                        "WHERE ul.user_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                stats.setTotalWorkouts(rs.getInt("total_workouts"));
                stats.setTotalCalories(rs.getInt("total_calories"));
                stats.setTotalMinutes(rs.getInt("total_minutes"));
            }
            
            // Get workout counts by type
            rs.close();
            pstmt.close();
            
            sql = "SELECT w.type, COUNT(*) as count " +
                  "FROM user_logs ul " +
                  "JOIN workouts w ON ul.workout_id = w.workout_id " +
                  "WHERE ul.user_id = ? " +
                  "GROUP BY w.type " +
                  "ORDER BY count DESC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            List<WorkoutTypeCount> typeCounts = new ArrayList<>();
            while (rs.next()) {
                WorkoutTypeCount typeCount = new WorkoutTypeCount();
                typeCount.setType(rs.getString("type"));
                typeCount.setCount(rs.getInt("count"));
                typeCounts.add(typeCount);
            }
            stats.setWorkoutTypeCounts(typeCounts);
            
            // Get recent workout streak
            rs.close();
            pstmt.close();
            
            sql = "SELECT COUNT(DISTINCT ul.log_date) as streak_days " +
                  "FROM user_logs ul " +
                  "WHERE ul.user_id = ? " +
                  "AND ul.log_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                stats.setWeeklyStreak(rs.getInt("streak_days"));
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
        
        request.setAttribute("progressStats", stats);
    }
    
    // Inner classes for data structures
    public static class WorkoutLog {
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
    
    public static class ProgressStats {
        private int totalWorkouts;
        private int totalCalories;
        private int totalMinutes;
        private int weeklyStreak;
        private List<WorkoutTypeCount> workoutTypeCounts;
        
        // Getters and setters
        public int getTotalWorkouts() { return totalWorkouts; }
        public void setTotalWorkouts(int totalWorkouts) { this.totalWorkouts = totalWorkouts; }
        
        public int getTotalCalories() { return totalCalories; }
        public void setTotalCalories(int totalCalories) { this.totalCalories = totalCalories; }
        
        public int getTotalMinutes() { return totalMinutes; }
        public void setTotalMinutes(int totalMinutes) { this.totalMinutes = totalMinutes; }
        
        public int getWeeklyStreak() { return weeklyStreak; }
        public void setWeeklyStreak(int weeklyStreak) { this.weeklyStreak = weeklyStreak; }
        
        public List<WorkoutTypeCount> getWorkoutTypeCounts() { return workoutTypeCounts; }
        public void setWorkoutTypeCounts(List<WorkoutTypeCount> workoutTypeCounts) { this.workoutTypeCounts = workoutTypeCounts; }
    }
    
    public static class WorkoutTypeCount {
        private String type;
        private int count;
        
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        
        public int getCount() { return count; }
        public void setCount(int count) { this.count = count; }
    }
}