<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseConnection" %>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    User user = (User) session.getAttribute("user");
    
    // Statistics variables
    int totalWorkouts = 0;
    int totalCalories = 0;
    int totalDuration = 0;
    int weekWorkouts = 0;
    int totalGoals = 0;
    
    // Recent workout logs
    List<Map<String, Object>> recentWorkouts = new ArrayList<>();
    List<Map<String, Object>> userGoals = new ArrayList<>();
    
    // Load dashboard data
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DatabaseConnection.getConnection();
        
        // Get total workouts
        String sql1 = "SELECT COUNT(*) as total_workouts FROM user_logs WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql1);
        pstmt.setInt(1, user.getUser_id());
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalWorkouts = rs.getInt("total_workouts");
        }
        rs.close();
        pstmt.close();
        
        // Get total calories and duration
        String sql2 = "SELECT SUM(w.calories_burned) as total_calories, SUM(w.duration) as total_duration " +
                     "FROM user_logs ul JOIN workouts w ON ul.workout_id = w.workout_id " +
                     "WHERE ul.user_id = ?";
        pstmt = conn.prepareStatement(sql2);
        pstmt.setInt(1, user.getUser_id());
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalCalories = rs.getInt("total_calories");
            totalDuration = rs.getInt("total_duration");
        }
        rs.close();
        pstmt.close();
        
        // Get this week's workouts
        String sql3 = "SELECT COUNT(*) as week_workouts FROM user_logs " +
                     "WHERE user_id = ? AND log_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
        pstmt = conn.prepareStatement(sql3);
        pstmt.setInt(1, user.getUser_id());
        rs = pstmt.executeQuery();
        if (rs.next()) {
            weekWorkouts = rs.getInt("week_workouts");
        }
        rs.close();
        pstmt.close();
        
        // Get total goals
        String sql4 = "SELECT COUNT(*) as total_goals FROM goals WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql4);
        pstmt.setInt(1, user.getUser_id());
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalGoals = rs.getInt("total_goals");
        }
        rs.close();
        pstmt.close();
        
        // Get recent workouts (last 5)
        String sql5 = "SELECT ul.log_date, w.name as workout_name, w.type, w.duration, w.calories_burned " +
                     "FROM user_logs ul JOIN workouts w ON ul.workout_id = w.workout_id " +
                     "WHERE ul.user_id = ? ORDER BY ul.log_date DESC, ul.log_id DESC LIMIT 5";
        pstmt = conn.prepareStatement(sql5);
        pstmt.setInt(1, user.getUser_id());
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> workout = new HashMap<>();
            workout.put("logDate", rs.getString("log_date"));
            workout.put("workoutName", rs.getString("workout_name"));
            workout.put("workoutType", rs.getString("type"));
            workout.put("duration", rs.getInt("duration"));
            workout.put("caloriesBurned", rs.getInt("calories_burned"));
            recentWorkouts.add(workout);
        }
        rs.close();
        pstmt.close();
        
        // Get user goals
        String sql6 = "SELECT goal_type, target_value, deadline FROM goals WHERE user_id = ? ORDER BY deadline ASC LIMIT 3";
        pstmt = conn.prepareStatement(sql6);
        pstmt.setInt(1, user.getUser_id());
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> goal = new HashMap<>();
            goal.put("goalType", rs.getString("goal_type"));
            goal.put("targetValue", rs.getDouble("target_value"));
            goal.put("deadline", rs.getString("deadline"));
            userGoals.add(goal);
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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTrack - Dashboard</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f8fafc;
            color: #1e293b;
            overflow-x: hidden;
            line-height: 1.6;
        }
        
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background: #1e293b;
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
            transition: transform 0.3s ease;
            box-shadow: 4px 0 15px rgba(0, 0, 0, 0.1);
        }
        
        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid #334155;
        }
        
        .logo {
            display: flex;
            align-items: center;
            font-family: 'Poppins', sans-serif;
            font-size: 1.5rem;
            font-weight: 700;
            color: #3b82f6;
            text-decoration: none;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        
        .logo:hover {
            color: #60a5fa;
        }
        
        .logo i {
            margin-right: 0.5rem;
            font-size: 1.8rem;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            background: rgba(59, 130, 246, 0.1);
            border-radius: 12px;
            border: 1px solid rgba(59, 130, 246, 0.2);
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            font-family: 'Poppins', sans-serif;
        }
        
        .user-details h4 {
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 0.125rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .user-details p {
            font-size: 0.75rem;
            color: #94a3b8;
        }
        
        .sidebar-nav {
            padding: 1rem;
        }
        
        .nav-section {
            margin-bottom: 2rem;
        }
        
        .nav-section-title {
            font-size: 0.75rem;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-bottom: 0.5rem;
            padding: 0 0.75rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            margin-bottom: 0.25rem;
            border-radius: 10px;
            color: #cbd5e1;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 0.875rem;
            font-weight: 500;
            position: relative;
        }
        
        .nav-item:hover {
            background: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            transform: translateX(2px);
        }
        
        .nav-item.active {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .nav-item.active::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 3px;
            height: 20px;
            background: white;
            border-radius: 0 2px 2px 0;
        }
        
        .nav-item i {
            margin-right: 0.75rem;
            font-size: 1rem;
            width: 20px;
            text-align: center;
        }
        
        .nav-item.logout {
            color: #ef4444;
            margin-top: 1rem;
            border-top: 1px solid #334155;
            padding-top: 1rem;
        }
        
        .nav-item.logout:hover {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 2rem;
            transition: margin-left 0.3s ease;
        }
        
        .page-header {
            margin-bottom: 2rem;
        }
        
        .page-title {
            font-family: 'Poppins', sans-serif;
            font-size: 2.25rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .page-title i {
            color: #3b82f6;
            font-size: 2rem;
        }
        
        .page-subtitle {
            color: #64748b;
            font-size: 1.1rem;
            font-weight: 400;
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--card-color);
        }
        
        .stat-card:hover {
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .stat-card.workouts {
            --card-color: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
        }
        
        .stat-card.calories {
            --card-color: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        }
        
        .stat-card.hours {
            --card-color: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        
        .stat-card.week {
            --card-color: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        }
        
        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            background: var(--card-color);
        }
        
        .stat-content h3 {
            font-family: 'Poppins', sans-serif;
            font-size: 2.25rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.25rem;
        }
        
        .stat-content p {
            color: #64748b;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        /* Content Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        
        .card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .card-title {
            font-family: 'Poppins', sans-serif;
            font-size: 1.125rem;
            font-weight: 600;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .card-title i {
            color: #3b82f6;
            font-size: 1rem;
        }
        
        .workout-item {
            padding: 1rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            margin-bottom: 0.75rem;
            transition: all 0.3s ease;
            background: #fafbfc;
        }
        
        .workout-item:hover {
            border-color: #3b82f6;
            background: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
        }
        
        .workout-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        
        .workout-name {
            font-weight: 600;
            color: #1e293b;
            font-size: 0.875rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .workout-date {
            color: #64748b;
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .workout-details {
            display: flex;
            gap: 1rem;
            font-size: 0.75rem;
            color: #64748b;
            align-items: center;
        }
        
        .workout-type {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.625rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .workout-type.cardio {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
        }
        
        .workout-type.strength {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
        }
        
        .workout-type.flexibility {
            background: rgba(245, 158, 11, 0.1);
            color: #d97706;
        }
        
        .workout-stat {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .goal-item {
            padding: 1rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            margin-bottom: 0.75rem;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            transition: all 0.3s ease;
        }
        
        .goal-item:hover {
            border-color: #10b981;
            background: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.1);
        }
        
        .goal-title {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.25rem;
            font-size: 0.875rem;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .goal-title::before {
            content: '';
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #10b981;
        }
        
        .goal-details {
            display: flex;
            justify-content: space-between;
            font-size: 0.75rem;
            color: #64748b;
            margin-left: 1rem;
        }
        
        .no-data {
            text-align: center;
            color: #64748b;
            padding: 3rem 2rem;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 12px;
            border: 2px dashed #e2e8f0;
        }
        
        .no-data i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }
        
        .no-data h4 {
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #475569;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 0.875rem;
            border: none;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(59, 130, 246, 0.4);
        }
        
        .btn-secondary {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
        }
        
        .btn-secondary:hover {
            background: #e2e8f0;
            border-color: #cbd5e1;
            transform: translateY(-1px);
        }
        
        /* Mobile Responsive */
        .mobile-menu-toggle {
            display: none;
            position: fixed;
            top: 1rem;
            left: 1rem;
            z-index: 1001;
            background: #1e293b;
            color: white;
            border: none;
            padding: 0.75rem;
            border-radius: 12px;
            font-size: 1.125rem;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        /* Custom Scrollbar */
        .sidebar::-webkit-scrollbar {
            width: 6px;
        }
        
        .sidebar::-webkit-scrollbar-track {
            background: #334155;
        }
        
        .sidebar::-webkit-scrollbar-thumb {
            background: #64748b;
            border-radius: 3px;
        }
        
        .sidebar::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }
        
        @media (max-width: 1024px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .mobile-menu-toggle {
                display: block;
            }
            
            .sidebar {
                transform: translateX(-100%);
            }
            
            .sidebar.open {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
                padding: 1rem;
                padding-top: 4rem;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1rem;
            }
            
            .page-title {
                font-size: 1.75rem;
            }
        }
        
        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .main-content {
                padding: 0.5rem;
                padding-top: 4rem;
            }
            
            .stat-card {
                padding: 1.25rem;
            }
            
            .card {
                padding: 1.25rem;
            }
        }
        
        /* Loading Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .stat-card,
        .card {
            animation: fadeInUp 0.6s ease forwards;
        }
        
        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Mobile Menu Toggle -->
        <button class="mobile-menu-toggle" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>
        
        <!-- Sidebar -->
        <nav class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <a href="user-dashboard.jsp" class="logo">
                    <i class="fas fa-dumbbell"></i>
                    FitTrack
                </a>
                
                <div class="user-info">
                    <div class="user-avatar">
                        <%= user.getUsername().substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="user-details">
                        <h4><%= user.getUsername() %></h4>
                        <p>Fitness Enthusiast</p>
                    </div>
                </div>
            </div>
            
            <div class="sidebar-nav">
                <div class="nav-section">
                    <div class="nav-section-title">Main</div>
                    <a href="user-dashboard.jsp" class="nav-item active">
                        <i class="fas fa-home"></i>
                        Dashboard
                    </a>
                    <a href="log-workout.jsp" class="nav-item">
                        <i class="fas fa-plus-circle"></i>
                        Log Workout
                    </a>
                    <a href="view-progress.jsp" class="nav-item">
                        <i class="fas fa-chart-line"></i>
                        View Progress
                    </a>
                </div>
                
                <div class="nav-section">
                    <div class="nav-section-title">Management</div>
                    <a href="workout-history" class="nav-item">
                        <i class="fas fa-history"></i>
                        Workout History
                    </a>
                    <a href="set-goals.jsp" class="nav-item">
                        <i class="fas fa-bullseye"></i>
                        Set Goals
                    </a>
                    <a href="update-profile.jsp" class="nav-item">
                        <i class="fas fa-user-edit"></i>
                        Update Profile
                    </a>
                </div>
                
                <a href="login.jsp" class="nav-item logout">
                    <i class="fas fa-sign-out-alt"></i>
                    Logout
                </a>
            </div>
        </nav>
        
        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-tachometer-alt"></i>
                    Dashboard
                </h1>
                <p class="page-subtitle">Welcome back, <%= user.getUsername() %>! Here's your fitness overview.</p>
            </div>
            
            <!-- Statistics Grid -->
            <div class="stats-grid">
                <div class="stat-card workouts">
                    <div class="stat-header">
                        <div class="stat-content">
                            <h3><%= totalWorkouts %></h3>
                            <p>Total Workouts</p>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-dumbbell"></i>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card calories">
                    <div class="stat-header">
                        <div class="stat-content">
                            <h3><%= totalCalories %></h3>
                            <p>Calories Burned</p>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-fire"></i>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card hours">
                    <div class="stat-header">
                        <div class="stat-content">
                            <h3><%= Math.round(totalDuration / 60.0 * 10.0) / 10.0 %></h3>
                            <p>Hours Exercised</p>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card week">
                    <div class="stat-header">
                        <div class="stat-content">
                            <h3><%= weekWorkouts %></h3>
                            <p>This Week</p>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-calendar-week"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Content Grid -->
            <div class="content-grid">
                <!-- Recent Workouts -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-running"></i>
                            Recent Workouts
                        </h3>
                        <a href="log-workout.jsp" class="btn btn-secondary">
                            <i class="fas fa-plus"></i>
                            Add Workout
                        </a>
                    </div>
                    
                    <% if (!recentWorkouts.isEmpty()) { %>
                        <% for (Map<String, Object> workout : recentWorkouts) { %>
                            <div class="workout-item">
                                <div class="workout-header">
                                    <div class="workout-name"><%= workout.get("workoutName") %></div>
                                    <div class="workout-date">
                                        <i class="fas fa-calendar-alt"></i>
                                        <%= workout.get("logDate") %>
                                    </div>
                                </div>
                                <div class="workout-details">
                                    <span class="workout-type <%= ((String)workout.get("workoutType")).toLowerCase() %>">
                                        <%= workout.get("workoutType") %>
                                    </span>
                                    <div class="workout-stat">
                                        <i class="fas fa-clock"></i>
                                        <%= workout.get("duration") %> min
                                    </div>
                                    <div class="workout-stat">
                                        <i class="fas fa-fire"></i>
                                        <%= workout.get("caloriesBurned") %> cal
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        
                        <div style="text-align: center; margin-top: 1rem;">
                            <a href="workout-history.jsp" class="btn btn-secondary">
                                <i class="fas fa-history"></i>
                                View All Workouts
                            </a>
                        </div>
                    <% } else { %>
                        <div class="no-data">
                            <i class="fas fa-dumbbell"></i>
                            <h4>No workouts yet</h4>
                            <p>Start logging your workouts to see them here!</p>
                            <a href="log-workout.jsp" class="btn btn-primary" style="margin-top: 1rem;">
                                <i class="fas fa-plus"></i>
                                Log First Workout
                            </a>
                        </div>
                    <% } %>
                </div>
                
                <!-- Goals -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-bullseye"></i>
                            Your Goals (<%= totalGoals %>)
                        </h3>
                        <a href="set-goals.jsp" class="btn btn-secondary">
                            <i class="fas fa-plus"></i>
                            Add Goal
                        </a>
                    </div>
                    
                    <% if (!userGoals.isEmpty()) { %>
                        <% for (Map<String, Object> goal : userGoals) { %>
                            <div class="goal-item">
                                <div class="goal-title">
                                    <%= goal.get("goalType") %>
                                </div>
                                <div class="goal-details">
                                    <span>
                                        <i class="fas fa-target"></i>
                                        Target: <%= goal.get("targetValue") %>
                                    </span>
                                    <span>
                                        <i class="fas fa-calendar"></i>
                                        Due: <%= goal.get("deadline") %>
                                    </span>
                                </div>
                            </div>
                        <% } %>
                        
                        <% if (userGoals.size() >= 3) { %>
                            <div style="text-align: center; margin-top: 1rem;">
                                <a href="set-goals.jsp" class="btn btn-secondary">
                                    <i class="fas fa-bullseye"></i>
                                    View All Goals
                                </a>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="no-data">
                            <i class="fas fa-bullseye"></i>
                            <h4>No goals set</h4>
                            <p>Set your first fitness goal!</p>
                            <a href="set-goals.jsp" class="btn btn-primary" style="margin-top: 1rem;">
                                <i class="fas fa-bullseye"></i>
                                Set First Goal
                            </a>
                        </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Quick Actions Section -->
            <div class="card" style="margin-bottom: 2rem;">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-bolt"></i>
                        Quick Actions
                    </h3>
                </div>
                
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                    <a href="log-workout.jsp" class="btn btn-primary" style="padding: 1rem; text-align: center; flex-direction: column; gap: 0.5rem;">
                        <i class="fas fa-plus-circle" style="font-size: 1.5rem;"></i>
                        <span>Log New Workout</span>
                    </a>
                    
                    <a href="set-goals.jsp" class="btn btn-secondary" style="padding: 1rem; text-align: center; flex-direction: column; gap: 0.5rem;">
                        <i class="fas fa-bullseye" style="font-size: 1.5rem;"></i>
                        <span>Set New Goal</span>
                    </a>
                    
                    <a href="view-progress.jsp" class="btn btn-secondary" style="padding: 1rem; text-align: center; flex-direction: column; gap: 0.5rem;">
                        <i class="fas fa-chart-line" style="font-size: 1.5rem;"></i>
                        <span>View Progress</span>
                    </a>
                    
                    <a href="update-profile.jsp" class="btn btn-secondary" style="padding: 1rem; text-align: center; flex-direction: column; gap: 0.5rem;">
                        <i class="fas fa-user-edit" style="font-size: 1.5rem;"></i>
                        <span>Update Profile</span>
                    </a>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('open');
        }
        
        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', function(event) {
            const sidebar = document.getElementById('sidebar');
            const toggleButton = document.querySelector('.mobile-menu-toggle');
            
            if (window.innerWidth <= 768 && 
                !sidebar.contains(event.target) && 
                !toggleButton.contains(event.target)) {
                sidebar.classList.remove('open');
            }
        });
        
        // Handle window resize
        window.addEventListener('resize', function() {
            const sidebar = document.getElementById('sidebar');
            if (window.innerWidth > 768) {
                sidebar.classList.remove('open');
            }
        });
        
        // Animate stats on load
        document.addEventListener('DOMContentLoaded', function() {
            const statValues = document.querySelectorAll('.stat-content h3');
            statValues.forEach((stat, index) => {
                const finalValue = parseFloat(stat.textContent);
                stat.textContent = '0';
                
                setTimeout(() => {
                    let current = 0;
                    const increment = finalValue / 30;
                    const timer = setInterval(() => {
                        current += increment;
                        if (current >= finalValue) {
                            stat.textContent = finalValue;
                            clearInterval(timer);
                        } else {
                            stat.textContent = Math.floor(current);
                        }
                    }, 50);
                }, index * 200);
            });
            
            // Add hover effects to navigation items
            const navItems = document.querySelectorAll('.nav-item');
            navItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    if (!this.classList.contains('active')) {
                        this.style.transform = 'translateX(4px)';
                    }
                });
                
                item.addEventListener('mouseleave', function() {
                    if (!this.classList.contains('active')) {
                        this.style.transform = 'translateX(0)';
                    }
                });
            });
            
            console.log('🎉 Dashboard loaded successfully!');
        });
        
        // Add smooth scroll behavior
        document.documentElement.style.scrollBehavior = 'smooth';
        
        // Add loading states for buttons
        document.querySelectorAll('.btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                if (this.href && !this.href.includes('#')) {
                    this.style.opacity = '0.7';
                    this.style.pointerEvents = 'none';
                    
                    setTimeout(() => {
                        this.style.opacity = '1';
                        this.style.pointerEvents = 'auto';
                    }, 2000);
                }
            });
        });
    </script>
</body>
</html>
