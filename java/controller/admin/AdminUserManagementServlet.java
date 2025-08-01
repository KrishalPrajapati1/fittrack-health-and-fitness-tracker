package controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.DatabaseConnection;

@WebServlet("/admin/user-management")
public class AdminUserManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!checkAdminAuth(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            loadAllUsers(request, response);
        } else {
            switch (action) {
                case "view":
                    viewUserDetails(request, response);
                    break;      
                case "edit":
                    editUserPage(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                case "toggleStatus":
                    toggleUserStatus(request, response);
                    break;
                case "bulkDelete":
                    bulkDeleteUsers(request, response);
                    break;
                case "analytics":
                    loadAnalytics(request, response);
                    break;
                case "reports":
                    loadReports(request, response);
                    break;
                case "system-analytics":
                    loadSystemAnalytics(request, response);
                    break;
                case "system-reports":
                    loadSystemReports(request, response);
                    break;
                default:
                    loadAllUsers(request, response);
                    break;
            }
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            editUser(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    private boolean checkAdminAuth(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        String role = (String) session.getAttribute("role");
        
        if (!"admin".equals(userType) && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        
        return true;
    }
    
    private void loadAllUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("DEBUG: loadAllUsers method called");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> users = new ArrayList<>();
        Map<String, Integer> statistics = new HashMap<>();
        
        // Initialize statistics with default values
        statistics.put("total_users", 0);
        statistics.put("active_users", 0);
        statistics.put("new_users", 0);
        statistics.put("total_logs", 0);
        
        try {
            conn = DatabaseConnection.getConnection();
            System.out.println("DEBUG: Database connection established successfully");
            
            // Check if users table exists
            try {
                String testSql = "SELECT 1 FROM users LIMIT 1";
                pstmt = conn.prepareStatement(testSql);
                rs = pstmt.executeQuery();
                rs.close();
                pstmt.close();
            } catch (SQLException e) {
                System.err.println("DEBUG: Users table might not exist: " + e.getMessage());
                request.setAttribute("error", "Database table 'users' not found. Please run the database setup script.");
                request.setAttribute("users", users);
                request.setAttribute("statistics", statistics);
                request.getRequestDispatcher("/admin/user-management.jsp").forward(request, response);
                return;
            }
            
            // Load users
            String usersSql = "SELECT user_id, username, email, " +
                             "COALESCE(gender, 'Not specified') as gender, " +
                             "COALESCE(age, 0) as age, " +
                             "COALESCE(weight, 0.0) as weight, " +
                             "COALESCE(height, 0.0) as height, " +
                             "COALESCE(created_at, NOW()) as created_at, " +
                             "COALESCE(role, 'user') as role " +
                             "FROM users " +
                             "WHERE role != 'admin' OR role IS NULL " +
                             "ORDER BY user_id DESC";
            
            System.out.println("DEBUG: Executing users query");
            pstmt = conn.prepareStatement(usersSql);
            rs = pstmt.executeQuery();
            
            int userCount = 0;
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("user_id", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("gender", rs.getString("gender"));
                user.put("age", rs.getInt("age"));
                user.put("weight", rs.getDouble("weight"));
                user.put("height", rs.getDouble("height"));
                user.put("created_at", rs.getString("created_at"));
                user.put("role", rs.getString("role"));
                
                // Set default workout statistics
                user.put("total_workouts", 0);
                user.put("total_calories", 0);
                user.put("total_duration", 0);
                user.put("total_goals", 0);
                user.put("last_workout_date", "Never");
                user.put("status", "active");
                
                users.add(user);
                userCount++;
            }
            
            System.out.println("DEBUG: Found " + userCount + " users");
            rs.close();
            pstmt.close();
            
            // Load workout statistics for each user
            for (Map<String, Object> user : users) {
                int userId = (int) user.get("user_id");
                loadUserWorkoutStats(conn, user, userId);
            }
            
            // Load overall statistics
            loadStatistics(conn, statistics, users.size());
            
            System.out.println("DEBUG: Final statistics: " + statistics);
            System.out.println("DEBUG: Final users count: " + users.size());
            
        } catch (SQLException e) {
            System.err.println("DEBUG: SQL Error in loadAllUsers: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("users", users);
        request.setAttribute("statistics", statistics);
        request.getRequestDispatcher("/admin/user-management.jsp").forward(request, response);
    }
    
    private void loadUserWorkoutStats(Connection conn, Map<String, Object> user, int userId) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            String statsSql = "SELECT COUNT(*) as total_workouts, " +
                             "COALESCE(SUM(w.calories_burned), 0) as total_calories, " +
                             "COALESCE(SUM(w.duration), 0) as total_duration, " +
                             "MAX(ul.log_date) as last_workout_date " +
                             "FROM user_logs ul " +
                             "JOIN workouts w ON ul.workout_id = w.workout_id " +
                             "WHERE ul.user_id = ?";
            
            pstmt = conn.prepareStatement(statsSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user.put("total_workouts", rs.getInt("total_workouts"));
                user.put("total_calories", rs.getInt("total_calories"));
                user.put("total_duration", rs.getInt("total_duration"));
                String lastWorkout = rs.getString("last_workout_date");
                user.put("last_workout_date", lastWorkout != null ? lastWorkout : "Never");
            }
            
            rs.close();
            pstmt.close();
            
            String goalsSql = "SELECT COUNT(*) as total_goals FROM goals WHERE user_id = ?";
            pstmt = conn.prepareStatement(goalsSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user.put("total_goals", rs.getInt("total_goals"));
            }
            
        } catch (SQLException e) {
            System.out.println("DEBUG: Workout tables might not exist for user " + userId);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void loadStatistics(Connection conn, Map<String, Integer> statistics, int totalUsers) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        statistics.put("total_users", totalUsers);
        statistics.put("active_users", totalUsers);
        
        try {
            String newUsersSql = "SELECT COUNT(*) as new_users FROM users " +
                                "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
                                "AND (role != 'admin' OR role IS NULL)";
            pstmt = conn.prepareStatement(newUsersSql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                statistics.put("new_users", rs.getInt("new_users"));
            }
            rs.close();
            pstmt.close();
            
            String logsSql = "SELECT COUNT(*) as total_logs FROM user_logs";
            pstmt = conn.prepareStatement(logsSql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                statistics.put("total_logs", rs.getInt("total_logs"));
            }
            rs.close();
            pstmt.close();
            
            String activeSql = "SELECT COUNT(DISTINCT user_id) as active_users " +
                              "FROM user_logs WHERE log_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
            pstmt = conn.prepareStatement(activeSql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                statistics.put("active_users", rs.getInt("active_users"));
            }
            
        } catch (SQLException e) {
            System.out.println("DEBUG: Error loading statistics: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void loadAnalytics(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Integer> statistics = new HashMap<>();
        Map<String, Object> workoutAnalytics = new HashMap<>();
        List<Map<String, Object>> growthData = new ArrayList<>();
        
        try {
            conn = DatabaseConnection.getConnection();
            
            // Load statistics
            String statsSql = "SELECT " +
                             "(SELECT COUNT(*) FROM users WHERE role != 'admin' OR role IS NULL) as total_users, " +
                             "(SELECT COUNT(DISTINCT user_id) FROM user_logs WHERE log_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)) as active_users, " +
                             "(SELECT COUNT(*) FROM users WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND (role != 'admin' OR role IS NULL)) as new_users, " +
                             "(SELECT COUNT(*) FROM user_logs) as total_logs";
            pstmt = conn.prepareStatement(statsSql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                statistics.put("total_users", rs.getInt("total_users"));
                statistics.put("active_users", rs.getInt("active_users"));
                statistics.put("new_users", rs.getInt("new_users"));
                statistics.put("total_logs", rs.getInt("total_logs"));
            }
            rs.close();
            pstmt.close();
            
            // Load user growth data (last 12 months)
            String growthSql = "SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as user_count " +
                             "FROM users WHERE role != 'admin' OR role IS NULL " +
                             "GROUP BY DATE_FORMAT(created_at, '%Y-%m') " +
                             "ORDER BY month DESC LIMIT 12";
            pstmt = conn.prepareStatement(growthSql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("month", rs.getString("month"));
                data.put("user_count", rs.getInt("user_count"));
                growthData.add(data);
            }
            rs.close();
            pstmt.close();
            
            // Load workout analytics
            List<Map<String, Object>> popularWorkouts = new ArrayList<>();
            String popularWorkoutsSql = "SELECT w.name, w.type, COUNT(ul.workout_id) as log_count " +
                                      "FROM user_logs ul JOIN workouts w ON ul.workout_id = w.workout_id " +
                                      "GROUP BY w.workout_id, w.name, w.type " +
                                      "ORDER BY log_count DESC LIMIT 5";
            pstmt = conn.prepareStatement(popularWorkoutsSql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> workout = new HashMap<>();
                workout.put("name", rs.getString("name"));
                workout.put("type", rs.getString("type"));
                workout.put("log_count", rs.getInt("log_count"));
                popularWorkouts.add(workout);
            }
            rs.close();
            pstmt.close();
            
            String avgDurationSql = "SELECT AVG(w.duration) as avg_duration FROM user_logs ul " +
                                  "JOIN workouts w ON ul.workout_id = w.workout_id";
            pstmt = conn.prepareStatement(avgDurationSql);
            rs = pstmt.executeQuery();
            double avgDuration = 0.0;
            if (rs.next()) {
                avgDuration = rs.getDouble("avg_duration");
            }
            rs.close();
            pstmt.close();
            
            workoutAnalytics.put("popularWorkouts", popularWorkouts);
            workoutAnalytics.put("avgDuration", avgDuration);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("statistics", statistics);
        request.setAttribute("workoutAnalytics", workoutAnalytics);
        request.setAttribute("growthData", growthData);
        request.getRequestDispatcher("/admin/user-analytics.jsp").forward(request, response);
    }
    
    private void loadReports(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> userReports = new ArrayList<>();
        
        try {
            conn = DatabaseConnection.getConnection();
            
            String reportSql = "SELECT u.user_id, u.username, u.email, " +
                             "COUNT(ul.workout_id) as total_workouts, " +
                             "COALESCE(SUM(w.calories_burned), 0) as total_calories, " +
                             "COALESCE(SUM(w.duration), 0) as total_duration, " +
                             "MAX(ul.log_date) as last_workout_date " +
                             "FROM users u " +
                             "LEFT JOIN user_logs ul ON u.user_id = ul.user_id " +
                             "LEFT JOIN workouts w ON ul.workout_id = w.workout_id " +
                             "WHERE u.role != 'admin' OR u.role IS NULL " +
                             "GROUP BY u.user_id, u.username, u.email " +
                             "ORDER BY total_workouts DESC";
            
            pstmt = conn.prepareStatement(reportSql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> report = new HashMap<>();
                report.put("user_id", rs.getInt("user_id"));
                report.put("username", rs.getString("username"));
                report.put("email", rs.getString("email"));
                report.put("total_workouts", rs.getInt("total_workouts"));
                report.put("total_calories", rs.getInt("total_calories"));
                report.put("total_duration", rs.getInt("total_duration"));
                String lastWorkout = rs.getString("last_workout_date");
                report.put("last_workout_date", lastWorkout != null ? lastWorkout : "Never");
                userReports.add(report);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("userReports", userReports);
        request.getRequestDispatcher("/admin/user-reports.jsp").forward(request, response);
    }
    
    private void loadSystemAnalytics(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Object> systemMetrics = new HashMap<>();
        Map<String, Object> usageStats = new HashMap<>();
        try {
            conn = DatabaseConnection.getConnection();

            // Fetch current system metrics (latest record from system_metrics)
            String metricsSql = "SELECT cpu_usage, memory_usage, response_time, request_count " +
                               "FROM system_metrics ORDER BY recorded_at DESC LIMIT 1";
            pstmt = conn.prepareStatement(metricsSql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                systemMetrics.put("cpuUsage", rs.getDouble("cpu_usage"));
                systemMetrics.put("memoryUsage", rs.getDouble("memory_usage"));
                systemMetrics.put("avgResponseTime", rs.getDouble("response_time"));
                // No active_sessions column, so set to 0
                systemMetrics.put("activeSessions", 0);
            } else {
                // Fallback data if no metrics are available
                systemMetrics.put("cpuUsage", 0.0);
                systemMetrics.put("memoryUsage", 0.0);
                systemMetrics.put("avgResponseTime", 0.0);
                systemMetrics.put("activeSessions", 0);
            }
            rs.close();
            pstmt.close();

            // Fetch usage stats (request counts per hour from system_metrics)
            List<String> hours = new ArrayList<>();
            List<Integer> requestCounts = new ArrayList<>();
            String usageSql = "SELECT DATE_FORMAT(recorded_at, '%H:00') as hour, SUM(request_count) as request_count " +
                              "FROM system_metrics WHERE recorded_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR) " +
                              "GROUP BY DATE_FORMAT(recorded_at, '%H:00') ORDER BY hour";
            pstmt = conn.prepareStatement(usageSql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                hours.add(rs.getString("hour"));
                requestCounts.add(rs.getInt("request_count"));
            }
            if (hours.isEmpty()) {
                // Fallback data if no logs are available
                hours.addAll(Arrays.asList("00:00", "01:00", "02:00", "03:00"));
                requestCounts.addAll(Arrays.asList(0, 0, 0, 0));
            }
            usageStats.put("hours", hours);
            usageStats.put("requestCounts", requestCounts);
            rs.close();
            pstmt.close();

            request.setAttribute("systemMetrics", systemMetrics);
            request.setAttribute("usageStats", usageStats);
            request.getRequestDispatcher("/admin/system-analytics.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/system-analytics.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void loadSystemReports(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> systemReports = new ArrayList<>();
        try {
            conn = DatabaseConnection.getConnection();

            // Fetch system reports (daily aggregates for the last 30 days)
            String reportSql = "SELECT DATE(recorded_at) as date, " +
                              "AVG(cpu_usage) as avgCpuUsage, " +
                              "AVG(memory_usage) as avgMemoryUsage, " +
                              "SUM(request_count) as totalRequests, " +
                              "AVG(response_time) as avgResponseTime " +
                              "FROM system_metrics WHERE recorded_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                              "GROUP BY DATE(recorded_at) ORDER BY date DESC";
            pstmt = conn.prepareStatement(reportSql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> report = new HashMap<>();
                report.put("date", rs.getString("date"));
                report.put("avgCpuUsage", rs.getDouble("avgCpuUsage"));
                report.put("avgMemoryUsage", rs.getDouble("avgMemoryUsage"));
                report.put("totalRequests", rs.getInt("totalRequests"));
                report.put("avgResponseTime", rs.getDouble("avgResponseTime"));
                systemReports.add(report);
            }
            if (systemReports.isEmpty()) {
                // Fallback data if no reports are available
                Map<String, Object> report = new HashMap<>();
                report.put("date", "2025-07-30");
                report.put("avgCpuUsage", 0.0);
                report.put("avgMemoryUsage", 0.0);
                report.put("totalRequests", 0);
                report.put("avgResponseTime", 0.0);
                systemReports.add(report);
            }
            rs.close();
            pstmt.close();

            request.setAttribute("systemReports", systemReports);
            request.getRequestDispatcher("/admin/system-reports.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/system-reports.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void viewUserDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null) {
            response.sendRedirect("user-management");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            int userId = Integer.parseInt(userIdStr);
            conn = DatabaseConnection.getConnection();
            
            Map<String, Object> userDetails = new HashMap<>();
            String userSql = "SELECT user_id, username, email, " +
                            "COALESCE(gender, 'Not specified') as gender, " +
                            "COALESCE(age, 0) as age, " +
                            "COALESCE(weight, 0.0) as weight, " +
                            "COALESCE(height, 0.0) as height, " +
                            "COALESCE(created_at, NOW()) as created_at " +
                            "FROM users WHERE user_id = ?";
            
            pstmt = conn.prepareStatement(userSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                userDetails.put("user_id", rs.getInt("user_id"));
                userDetails.put("username", rs.getString("username"));
                userDetails.put("email", rs.getString("email"));
                userDetails.put("gender", rs.getString("gender"));
                userDetails.put("age", rs.getInt("age"));
                userDetails.put("weight", rs.getDouble("weight"));
                userDetails.put("height", rs.getDouble("height"));
                userDetails.put("created_at", rs.getString("created_at"));
                
                rs.close();
                pstmt.close();
                
                String statsSql = "SELECT COUNT(*) as total_workouts, " +
                                 "COALESCE(SUM(w.calories_burned), 0) as total_calories, " +
                                 "COALESCE(SUM(w.duration), 0) as total_duration, " +
                                 "MAX(ul.log_date) as last_workout_date " +
                                 "FROM user_logs ul " +
                                 "LEFT JOIN workouts w ON ul.workout_id = w.workout_id " +
                                 "WHERE ul.user_id = ?";
                
                pstmt = conn.prepareStatement(statsSql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    userDetails.put("total_workouts", rs.getInt("total_workouts"));
                    userDetails.put("total_calories", rs.getInt("total_calories"));
                    userDetails.put("total_duration", rs.getInt("total_duration"));
                    String lastWorkout = rs.getString("last_workout_date");
                    userDetails.put("last_workout_date", lastWorkout != null ? lastWorkout : "Never");
                } else {
                    userDetails.put("total_workouts", 0);
                    userDetails.put("total_calories", 0);
                    userDetails.put("total_duration", 0);
                    userDetails.put("last_workout_date", "Never");
                }
                
                rs.close();
                pstmt.close();
                
                String goalsSql = "SELECT COUNT(*) as total_goals FROM goals WHERE user_id = ?";
                pstmt = conn.prepareStatement(goalsSql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    userDetails.put("total_goals", rs.getInt("total_goals"));
                } else {
                    userDetails.put("total_goals", 0);
                }
                
                rs.close();
                pstmt.close();
                
                List<Map<String, Object>> recentWorkouts = new ArrayList<>();
                String recentSql = "SELECT ul.log_date, w.name as workout_name, w.type, " +
                                  "w.duration, w.calories_burned, ul.notes " +
                                  "FROM user_logs ul " +
                                  "LEFT JOIN workouts w ON ul.workout_id = w.workout_id " +
                                  "WHERE ul.user_id = ? " +
                                  "ORDER BY ul.log_date DESC LIMIT 5";
                
                pstmt = conn.prepareStatement(recentSql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    Map<String, Object> workout = new HashMap<>();
                    workout.put("log_date", rs.getString("log_date"));
                    workout.put("workout_name", rs.getString("workout_name"));
                    workout.put("type", rs.getString("type"));
                    workout.put("duration", rs.getInt("duration"));
                    workout.put("calories_burned", rs.getInt("calories_burned"));
                    workout.put("notes", rs.getString("notes"));
                    recentWorkouts.add(workout);
                }
                
                userDetails.put("recent_workouts", recentWorkouts);
                
                request.setAttribute("userDetails", userDetails);
                request.getRequestDispatcher("/admin/user-details.jsp").forward(request, response);
                
            } else {
                request.getSession().setAttribute("error", "User not found");
                response.sendRedirect("user-management");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid user ID");
            response.sendRedirect("user-management");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect("user-management");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null) {
            request.getSession().setAttribute("error", "User ID is required");
            response.sendRedirect("user-management");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            int userId = Integer.parseInt(userIdStr);
            conn = DatabaseConnection.getConnection();
            
            String[] deleteSqls = {
                "DELETE FROM user_logs WHERE user_id = ?",
                "DELETE FROM goals WHERE user_id = ?",
                "DELETE FROM users WHERE user_id = ?"
            };
            
            for (String sql : deleteSqls) {
                try {
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, userId);
                    pstmt.executeUpdate();
                    pstmt.close();
                } catch (SQLException e) {
                    // Table might not exist, continue
                }
            }
            
            request.getSession().setAttribute("success", "User deleted successfully");
            
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Failed to delete user: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("user-management");
    }
    
    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String status = request.getParameter("status");
        
        if (userIdStr == null || status == null) {
            request.getSession().setAttribute("error", "Missing parameters");
            response.sendRedirect("user-management");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            int userId = Integer.parseInt(userIdStr);
            conn = DatabaseConnection.getConnection();
            String sql = "UPDATE users SET status = ? WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, userId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                request.getSession().setAttribute("success", "User status updated successfully");
            } else {
                request.getSession().setAttribute("error", "User not found");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid user ID");
        } catch (SQLException e) {
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("user-management");
    }
    
    private void bulkDeleteUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String[] userIds = request.getParameterValues("userIds");
        if (userIds == null) {
            userIds = request.getParameterValues("selectedUsers");
        }
        
        if (userIds == null || userIds.length == 0) {
            request.getSession().setAttribute("error", "No users selected");
            response.sendRedirect("user-management");
            return;
        }
        
        int deletedCount = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            for (String userIdStr : userIds) {
                try {
                    int userId = Integer.parseInt(userIdStr);
                    
                    String[] deleteSqls = {
                        "DELETE FROM user_logs WHERE user_id = ?",
                        "DELETE FROM goals WHERE user_id = ?",
                        "DELETE FROM users WHERE user_id = ?"
                    };
                    
                    for (String sql : deleteSqls) {
                        try {
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setInt(1, userId);
                            pstmt.executeUpdate();
                            pstmt.close();
                        } catch (SQLException e) {
                            // Table might not exist
                        }
                    }
                    
                    deletedCount++;
                    
                } catch (NumberFormatException e) {
                    // Skip invalid IDs
                }
            }
            
            request.getSession().setAttribute("success", deletedCount + " users deleted successfully");
            
        } catch (SQLException e) {
            request.getSession().setAttribute("error", "Failed to delete users: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("user-management");
    }

    private void editUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String gender = request.getParameter("gender");
        String ageStr = request.getParameter("age");
        String weightStr = request.getParameter("weight");
        String heightStr = request.getParameter("height");

        if (userIdStr == null || username == null || email == null) {
            request.getSession().setAttribute("error", "Missing required fields.");
            response.sendRedirect("user-management");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            int age = ageStr != null && !ageStr.isEmpty() ? Integer.parseInt(ageStr) : 0;
            double weight = weightStr != null && !weightStr.isEmpty() ? Double.parseDouble(weightStr) : 0.0;
            double height = heightStr != null && !heightStr.isEmpty() ? Double.parseDouble(heightStr) : 0.0;

            Connection conn = DatabaseConnection.getConnection();
            String sql = "UPDATE users SET username=?, email=?, gender=?, age=?, weight=?, height=? WHERE user_id=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, gender);
            pstmt.setInt(4, age);
            pstmt.setDouble(5, weight);
            pstmt.setDouble(6, height);
            pstmt.setInt(7, userId);

            int updated = pstmt.executeUpdate();
            pstmt.close();
            conn.close();

            if (updated > 0) {
                request.getSession().setAttribute("success", "User updated successfully.");
            } else {
                request.getSession().setAttribute("error", "User not found or not updated.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Failed to update user: " + e.getMessage());
        }
        response.sendRedirect("user-management?action=view&userId=" + userIdStr);
    }

    private void editUserPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null) {
            response.sendRedirect("user-management");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            int userId = Integer.parseInt(userIdStr);
            conn = DatabaseConnection.getConnection();

            Map<String, Object> userDetails = new HashMap<>();
            String userSql = "SELECT user_id, username, email, " +
                             "COALESCE(gender, 'Not specified') as gender, " +
                             "COALESCE(age, 0) as age, " +
                             "COALESCE(weight, 0.0) as weight, " +
                             "COALESCE(height, 0.0) as height, " +
                             "COALESCE(created_at, NOW()) as created_at " +
                             "FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(userSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                userDetails.put("user_id", rs.getInt("user_id"));
                userDetails.put("username", rs.getString("username"));
                userDetails.put("email", rs.getString("email"));
                userDetails.put("gender", rs.getString("gender"));
                userDetails.put("age", rs.getInt("age"));
                userDetails.put("weight", rs.getDouble("weight"));
                userDetails.put("height", rs.getDouble("height"));
                userDetails.put("created_at", rs.getString("created_at"));
            } else {
                request.getSession().setAttribute("error", "User not found");
                response.sendRedirect("user-management");
                return;
            }

            rs.close();
            pstmt.close();
            conn.close();

            request.setAttribute("userDetails", userDetails);
            request.getRequestDispatcher("/admin/edit-user.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to load user for edit: " + e.getMessage());
            response.sendRedirect("user-management");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
