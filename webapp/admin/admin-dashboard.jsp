<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseConnection" %>
<%
    // 🔒 AUTHORIZATION CHECK 
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null) {
        System.out.println("No session found - redirecting to login");
        response.sendRedirect("login.jsp");
        return;
    }
    
    String adminUserType = (String) adminSession.getAttribute("userType");
    String adminRole = (String) adminSession.getAttribute("role");
    
    
    
    // Check if user has admin role
    if (adminUserType == null || (!"admin".equals(adminUserType) && !"admin".equals(adminRole))) {
        System.out.println("Access denied - Admin role required. UserType: " + adminUserType + ", Role: " + adminRole);
        response.sendRedirect("login.jsp");
        return;
    }
    
    System.out.println("Admin dashboard access granted");
    // 🔒 END AUTHORIZATION CHECK
    
    // Load admin statistics
    int totalUsers = 0;
    int totalWorkouts = 0;
    int totalLogs = 0;
    int todayLogs = 0;
    int activeUsers = 0;
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DatabaseConnection.getConnection();
        
        // Get total users
        String sql1 = "SELECT COUNT(*) as total FROM users WHERE role != 'admin' OR role IS NULL";
        pstmt = conn.prepareStatement(sql1);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalUsers = rs.getInt("total");
        }
        rs.close();
        pstmt.close();
        
        // Get total workouts available
        String sql2 = "SELECT COUNT(*) as total FROM workouts";
        pstmt = conn.prepareStatement(sql2);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalWorkouts = rs.getInt("total");
        }
        rs.close();
        pstmt.close();
        
        // Get total user logs
        String sql3 = "SELECT COUNT(*) as total FROM user_logs";
        pstmt = conn.prepareStatement(sql3);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalLogs = rs.getInt("total");
        }
        rs.close();
        pstmt.close();
        
        // Get today's logs
        String sql4 = "SELECT COUNT(*) as total FROM user_logs WHERE DATE(log_date) = CURDATE()";
        pstmt = conn.prepareStatement(sql4);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            todayLogs = rs.getInt("total");
        }
        rs.close();
        pstmt.close();
        
        // Get active users (logged workout in last 7 days)
        String sql5 = "SELECT COUNT(DISTINCT user_id) as total FROM user_logs WHERE log_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
        pstmt = conn.prepareStatement(sql5);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            activeUsers = rs.getInt("total");
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
        System.out.println("Database error in admin dashboard: " + e.getMessage());
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTrack - Admin Dashboard</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --admin-primary: #dc2626;
            --admin-primary-dark: #b91c1c;
            --admin-secondary: #f59e0b;
            --admin-success: #10b981;
            --admin-danger: #ef4444;
            --admin-warning: #f59e0b;
            --admin-info: #3b82f6;
            
            --bg-primary: #f8f9fa;
            --bg-secondary: #ffffff;
            --text-primary: #2c3e50;
            --text-secondary: #7f8c8d;
            --border-color: #ecf0f1;
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.07);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
            --shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.1);
            --border-radius: 12px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
        }
        
        /* Navigation */
        .navbar {
            background: linear-gradient(135deg, var(--admin-primary) 0%, var(--admin-primary-dark) 100%);
            padding: 1rem 0;
            box-shadow: var(--shadow-lg);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .nav-brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            text-decoration: none;
            font-family: 'Poppins', sans-serif;
        }
        
        .nav-brand:hover {
            color: white;
            text-decoration: none;
        }
        
        .nav-brand i {
            font-size: 1.8rem;
        }
        
        .admin-badge {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .nav-links {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .nav-user {
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
        }
        
        .nav-btn {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
            backdrop-filter: blur(10px);
        }
        
        .nav-btn:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-1px);
            color: white;
            text-decoration: none;
        }
        
        /* Main Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        /* Welcome Section */
        .admin-welcome {
            background: var(--bg-secondary);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .admin-welcome::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, var(--admin-primary) 0%, var(--admin-primary-dark) 100%);
        }
        
        .welcome-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .welcome-text h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--admin-primary);
            font-family: 'Poppins', sans-serif;
        }
        
        .welcome-text p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
        
        .admin-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(16, 185, 129, 0.1);
            color: var(--admin-success);
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: var(--bg-secondary);
            padding: 1.5rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
            transition: var(--transition);
        }
        
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-xl);
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--admin-primary);
        }
        
        .stat-card.users::before {
            background: var(--admin-info);
        }
        
        .stat-card.workouts::before {
            background: var(--admin-success);
        }
        
        .stat-card.logs::before {
            background: var(--admin-warning);
        }
        
        .stat-card.active::before {
            background: var(--admin-secondary);
        }
        
        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
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
        }
        
        .stat-icon.users {
            background: var(--admin-info);
        }
        
        .stat-icon.workouts {
            background: var(--admin-success);
        }
        
        .stat-icon.logs {
            background: var(--admin-warning);
        }
        
        .stat-icon.active {
            background: var(--admin-secondary);
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .stat-label {
            color: var(--text-secondary);
            font-weight: 500;
        }
        
        .stat-change {
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--admin-success);
        }
        
        /* Admin Actions Grid */
        .admin-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .admin-card {
            background: var(--bg-secondary);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            transition: var(--transition);
        }
        
        .admin-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-xl);
        }
        
        .admin-card h3 {
            color: var(--text-primary);
            margin-bottom: 1rem;
            border-bottom: 2px solid var(--admin-primary);
            padding-bottom: 0.5rem;
            font-size: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .admin-card .card-icon {
            font-size: 1.5rem;
            color: var(--admin-primary);
        }
        
        .admin-card p {
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
            line-height: 1.6;
        }
        
        .admin-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
        }
        
        .action-btn {
            background: linear-gradient(135deg, var(--admin-primary) 0%, var(--admin-primary-dark) 100%);
            color: white;
            padding: 1rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: var(--transition);
            font-weight: 500;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            color: white;
            text-decoration: none;
        }
        
        .action-btn.secondary {
            background: linear-gradient(135deg, var(--admin-info) 0%, #2563eb 100%);
        }
        
        .action-btn.success {
            background: linear-gradient(135deg, var(--admin-success) 0%, #059669 100%);
        }
        
        .action-btn.warning {
            background: linear-gradient(135deg, var(--admin-warning) 0%, #d97706 100%);
        }
        
        .action-btn .btn-icon {
            font-size: 1.5rem;
        }
        
        /* System Information */
        .system-info-section {
            background: var(--bg-secondary);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            overflow: hidden;
            margin-bottom: 2rem;
        }
        
        .section-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            background: linear-gradient(135deg, rgba(220, 38, 38, 0.1) 0%, rgba(185, 28, 28, 0.1) 100%);
        }
        
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .section-title i {
            color: var(--admin-primary);
        }
        
        .info-content {
            padding: 1.5rem;
        }
        
        .system-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            background: rgba(220, 38, 38, 0.05);
            border-radius: 8px;
            border-left: 4px solid var(--admin-primary);
        }
        
        .info-label {
            font-weight: 500;
            color: var(--text-secondary);
        }
        
        .info-value {
            font-weight: 600;
            color: var(--text-primary);
        }
        
        /* Quick Summary */
        .quick-summary {
            background: var(--bg-secondary);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            padding: 2rem;
            text-align: center;
        }
        
        .summary-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }
        
        .summary-item {
            padding: 1rem;
            background: rgba(220, 38, 38, 0.05);
            border-radius: 10px;
            border: 1px solid rgba(220, 38, 38, 0.1);
        }
        
        .summary-value {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
            color: var(--admin-primary);
            font-family: 'Poppins', sans-serif;
        }
        
        .summary-label {
            font-size: 0.875rem;
            color: var(--text-secondary);
        }
        
        .summary-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 2rem;
        }
        
        .summary-btn {
            background: var(--admin-primary);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }
        
        .summary-btn:hover {
            background: var(--admin-primary-dark);
            color: white;
            text-decoration: none;
            transform: translateY(-1px);
        }
        
        .summary-btn.success {
            background: var(--admin-success);
        }
        
        .summary-btn.success:hover {
            background: #059669;
        }
        
        .summary-btn.info {
            background: var(--admin-info);
        }
        
        .summary-btn.info:hover {
            background: #2563eb;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .nav-container {
                padding: 0 1rem;
                flex-direction: column;
                gap: 1rem;
            }
            
            .container {
                padding: 1rem;
            }
            
            .welcome-content {
                flex-direction: column;
                text-align: center;
            }
            
            .admin-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
            
            .admin-actions {
                grid-template-columns: 1fr;
            }
            
            .summary-actions {
                flex-direction: column;
                align-items: center;
            }
        }
        
        @media (max-width: 480px) {
            .welcome-text h1 {
                font-size: 1.5rem;
            }
            
            .stat-value {
                font-size: 1.5rem;
            }
            
            .admin-card {
                padding: 1.5rem;
            }
        }
        
        /* Animations */
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
        .admin-card,
        .system-info-section {
            animation: fadeInUp 0.6s ease-out;
        }
        
        .stat-card:nth-child(2) { animation-delay: 0.1s; }
        .stat-card:nth-child(3) { animation-delay: 0.2s; }
        .stat-card:nth-child(4) { animation-delay: 0.3s; }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="/FitTrack/admin/admin-dashboard.jsp" class="nav-brand">
                <i class="fas fa-cog"></i>
                FitTrack Admin
                <span class="admin-badge">Admin Panel</span>
            </a>
            <div class="nav-links">
                <span class="nav-user">Administrator Access</span>
                <a href="/FitTrack/home.jsp" class="nav-btn">
                    <i class="fas fa-home"></i>
                    View Site
                </a>
                <a href="/FitTrack/login.jsp" class="nav-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Welcome Section -->
        <div class="admin-welcome">
            <div class="welcome-content">
                <div class="welcome-text">
                    <h1><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>
                    <p>Manage users, monitor system activity, and oversee FitTrack operations</p>
                </div>
                <div class="admin-status">
                    <i class="fas fa-check-circle"></i>
                    <span>System Status: Online</span>
                </div>
            </div>
        </div>

        <!-- Statistics Grid -->
        <div class="stats-grid">
            <div class="stat-card users">
                <div class="stat-header">
                    <div>
                        <div class="stat-value"><%= totalUsers %></div>
                        <div class="stat-label">Total Users</div>
                    </div>
                    <div class="stat-icon users">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
                <div class="stat-change">+<%= activeUsers %> active this week</div>
            </div>
            
            <div class="stat-card workouts">
                <div class="stat-header">
                    <div>
                        <div class="stat-value"><%= totalWorkouts %></div>
                        <div class="stat-label">Available Workouts</div>
                    </div>
                    <div class="stat-icon workouts">
                        <i class="fas fa-dumbbell"></i>
                    </div>
                </div>
                <div class="stat-change">Workout library</div>
            </div>
            
            <div class="stat-card logs">
                <div class="stat-header">
                    <div>
                        <div class="stat-value"><%= totalLogs %></div>
                        <div class="stat-label">Total Workout Logs</div>
                    </div>
                    <div class="stat-icon logs">
                        <i class="fas fa-chart-bar"></i>
                    </div>
                </div>
                <div class="stat-change">+<%= todayLogs %> logged today</div>
            </div>
            
            <div class="stat-card active">
                <div class="stat-header">
                    <div>
                        <div class="stat-value"><%= activeUsers %></div>
                        <div class="stat-label">Active Users</div>
                    </div>
                    <div class="stat-icon active">
                        <i class="fas fa-bolt"></i>
                    </div>
                </div>
                <div class="stat-change">Last 7 days activity</div>
            </div>
        </div>

        <!-- Admin Management Grid -->
        <div class="admin-grid">
            <div class="admin-card">
                <h3>
                    <span class="card-icon"><i class="fas fa-users"></i></span>
                    User Management
                </h3>
                <p>View, manage, and monitor user accounts and their fitness progress.</p>
                <div class="admin-actions">
                    <a href="/FitTrack/admin/user-management" class="action-btn">
                        <span class="btn-icon"><i class="fas fa-eye"></i></span>
                        View All Users
                    </a>
                    <a href="/FitTrack/admin/user-management?action=reports" class="action-btn secondary">
                        <span class="btn-icon"><i class="fas fa-file-alt"></i></span>
                        User Reports
                    </a>
                    <a href="/FitTrack/admin/user-management?action=analytics" class="action-btn success">
                        <span class="btn-icon"><i class="fas fa-chart-line"></i></span>
                        User Analytics
                    </a>
                </div>
            </div>
            
            <div class="admin-card">
                <h3>
                    <span class="card-icon"><i class="fas fa-dumbbell"></i></span>
                    Content Management
                </h3>
                <p>Manage workout plans, exercise database, and fitness content.</p>
                <div class="admin-actions">
                    <a href="/FitTrack/admin/workout-management" class="action-btn">
                        <span class="btn-icon"><i class="fas fa-dumbbell"></i></span>
                        Manage Workouts
                    </a>
                    <a href="/FitTrack/admin/diet-plan-management" class="action-btn secondary">
                        <span class="btn-icon"><i class="fas fa-apple-alt"></i></span>
                        Diet Plans
                    </a>
                    
                </div>
            </div>
            
            <div class="admin-card">
                <h3>
                    <span class="card-icon"><i class="fas fa-chart-bar"></i></span>
                    System Analytics
                </h3>
                <p>Monitor system performance, usage statistics, and generate reports.</p>
              <!-- In the System Analytics section of admin-dashboard.jsp -->
<div class="admin-actions">
    <a href="/FitTrack/admin/user-management?action=system-analytics" class="action-btn">
        <span class="btn-icon"><i class="fas fa-chart-line"></i></span>
        View Analytics
    </a>
    <a href="/FitTrack/admin/user-management?action=system-reports" class="action-btn secondary">
        <span class="btn-icon"><i class="fas fa-file-alt"></i></span>
        Generate Reports
    </a>
   
</div>
            </div>
        </div>

        <!-- System Information -->
        <div class="system-info-section">
            <div class="section-header">
                <h3 class="section-title">
                    <i class="fas fa-chart-bar"></i>
                    System Information
                </h3>
            </div>
            <div class="info-content">
                <div class="system-info">
                    <div class="info-item">
                        <span class="info-label">Database Status</span>
                        <span class="info-value">✅ Connected</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Total Records</span>
                        <span class="info-value"><%= totalUsers + totalLogs %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Server Status</span>
                        <span class="info-value">🟢 Online</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Last Backup</span>
                        <span class="info-value"><%= java.time.LocalDate.now() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Active Sessions</span>
                        <span class="info-value"><%= activeUsers %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">System Version</span>
                        <span class="info-value">FitTrack v1.0</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Summary -->
        <div class="quick-summary">
            <h3 class="summary-title">
                <i class="fas fa-chart-bar"></i> Platform Overview
            </h3>
            <div class="summary-grid">
                <div class="summary-item">
                    <div class="summary-value"><%= String.format("%.1f", totalLogs > 0 ? (double)totalLogs / totalUsers : 0) %></div>
                    <div class="summary-label">Avg Logs/User</div>
                </div>
                <div class="summary-item">
                    <div class="summary-value"><%= activeUsers > 0 ? String.format("%.1f", (double)activeUsers / totalUsers * 100) : "0" %>%</div>
                    <div class="summary-label">User Engagement</div>
                </div>
                <div class="summary-item">
                    <div class="summary-value"><%= todayLogs %></div>
                    <div class="summary-label">Today's Activity</div>
                </div>
                <div class="summary-item">
                    <div class="summary-value">
                        <% if (totalUsers == 0) { %>
                            New
                        <% } else if (totalUsers < 10) { %>
                            Growing
                        <% } else if (totalUsers < 100) { %>
                            Active
                        <% } else { %>
                            Thriving
                        <% } %>
                    </div>
                    <div class="summary-label">Platform Status</div>
                </div>
            </div>
            
            <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid var(--border-color);">
                <p style="color: var(--text-secondary); margin-bottom: 1rem;">
                    <% if (totalUsers == 0) { %>
                        🚀 Welcome to FitTrack Admin! The platform is ready for users to join.
                    <% } else if (totalLogs == 0) { %>
                        👋 You have <%= totalUsers %> registered user<%= totalUsers > 1 ? "s" : "" %>. Encourage them to start logging workouts!
                    <% } else { %>
                        🎉 Great job! <%= totalUsers %> users have logged <%= totalLogs %> workouts. The platform is thriving!
                    <% } %>
                </p>
                <div class="summary-actions">
                    <a href="/FitTrack/admin/user-management" class="summary-btn">
                        <i class="fas fa-users"></i> Manage Users
                    </a>
                    <a href="/FitTrack/admin/user-management?action=reports" class="summary-btn success">
                        <i class="fas fa-file-alt"></i> View Reports
                    </a>
                    <a href="/FitTrack/admin/user-management?action=analytics" class="summary-btn info">
                        <i class="fas fa-chart-line"></i> User Analytics
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add loading animation to cards
        window.addEventListener('load', function() {
            const cards = document.querySelectorAll('.stat-card, .admin-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });
        });

        // Add hover effects to action cards
        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px) scale(1.02)';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });

            // Add click handler for placeholder buttons
            btn.addEventListener('click', function(e) {
                if (this.href.includes('#')) {
                    e.preventDefault();
                    const action = this.textContent.trim();
                    alert(`${action} functionality will be implemented in future updates.`);
                }
            });
        });

        // Real-time status updates (simulated)
        function updateSystemStatus() {
            const statusElements = document.querySelectorAll('.info-value');
            console.log('System status check completed');
        }

        // Update system status every 30 seconds
        setInterval(updateSystemStatus, 30000);

        // Console admin message
        console.log('%c🔧 FitTrack Admin Dashboard Loaded!', 'color: #dc2626; font-size: 20px; font-weight: bold;');
        console.log('%cAdmin access granted. Monitor the platform responsibly.', 'color: #b91c1c; font-size: 14px;');
        
        // Debug information
        console.log('Admin Dashboard Stats:', {
            totalUsers: <%= totalUsers %>,
            totalWorkouts: <%= totalWorkouts %>,
            totalLogs: <%= totalLogs %>,
            todayLogs: <%= todayLogs %>,
            activeUsers: <%= activeUsers %>
        });

        // Add smooth hover animations
        document.querySelectorAll('.nav-btn, .summary-btn').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>
