package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
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

@WebServlet("/log-workout")
public class LogWorkoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Load available workouts for the dropdown
        loadWorkouts(request);
        request.getRequestDispatcher("log-workout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String workoutIdStr = request.getParameter("workoutId");
        String notes = request.getParameter("notes");
        String logDate = request.getParameter("logDate");
        
        // Validation
        if (workoutIdStr == null || workoutIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Please select a workout");
            loadWorkouts(request);
            request.getRequestDispatcher("log-workout.jsp").forward(request, response);
            return;
        }
        
        if (logDate == null || logDate.trim().isEmpty()) {
            logDate = LocalDate.now().toString(); // Use today's date if not provided
        }
        
        try {
            int workoutId = Integer.parseInt(workoutIdStr);
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            
            try {
                conn = DatabaseConnection.getConnection();
                
                // Insert workout log
                String sql = "INSERT INTO user_logs (user_id, workout_id, log_date, notes) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, user.getUser_id());
                pstmt.setInt(2, workoutId);
                pstmt.setString(3, logDate);
                pstmt.setString(4, notes != null ? notes : "");
                
                int result = pstmt.executeUpdate();
                
                if (result > 0) {
                    request.setAttribute("success", "Workout logged successfully!");
                } else {
                    request.setAttribute("error", "Failed to log workout. Please try again.");
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
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid workout selection");
        }
        
        loadWorkouts(request);
        request.getRequestDispatcher("log-workout.jsp").forward(request, response);
    }
    
    private void loadWorkouts(HttpServletRequest request) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<WorkoutInfo> workouts = new ArrayList<>();
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT workout_id, name, type, duration, calories_burned FROM workouts ORDER BY name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                WorkoutInfo workout = new WorkoutInfo();
                workout.setWorkoutId(rs.getInt("workout_id"));
                workout.setName(rs.getString("name"));
                workout.setType(rs.getString("type"));
                workout.setDuration(rs.getInt("duration"));
                workout.setCaloriesBurned(rs.getInt("calories_burned"));
                workouts.add(workout);
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
        
        request.setAttribute("workouts", workouts);
    }
    
    // Inner class for workout information
    public static class WorkoutInfo {
        private int workoutId;
        private String name;
        private String type;
        private int duration;
        private int caloriesBurned;
        
        // Getters and setters
        public int getWorkoutId() { return workoutId; }
        public void setWorkoutId(int workoutId) { this.workoutId = workoutId; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        
        public int getDuration() { return duration; }
        public void setDuration(int duration) { this.duration = duration; }
        
        public int getCaloriesBurned() { return caloriesBurned; }
        public void setCaloriesBurned(int caloriesBurned) { this.caloriesBurned = caloriesBurned; }
    }
}