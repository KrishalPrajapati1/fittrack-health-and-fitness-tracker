<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="controller.WorkoutHistoryServlet.WorkoutHistoryItem" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    User user = (User) session.getAttribute("user");
    List<WorkoutHistoryItem> workoutHistory = (List<WorkoutHistoryItem>) request.getAttribute("workoutHistory");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTrack - Workout History</title>
    
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
        
        /* Sidebar Styles - Same as dashboard */
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
        
        .content-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .history-card {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 2rem;
        }
        
        .history-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .history-title {
            font-family: 'Poppins', sans-serif;
            font-size: 1.5rem;
            font-weight: 600;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .history-title i {
            color: #3b82f6;
        }
        
        .add-workout-btn {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-family: 'Inter', sans-serif;
        }
        
        .add-workout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.4);
        }
        
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.875rem;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            color: #15803d;
            border: 1px solid #bbf7d0;
        }
        
        .alert-error {
            background: linear-gradient(135deg, #fef2f2 0%, #fecaca 100%);
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        
        /* Filter Section */
        .filter-section {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            border: 1px solid #e2e8f0;
        }
        
        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }
        
        .filter-item {
            display: flex;
            flex-direction: column;
        }
        
        .filter-item label {
            font-size: 0.875rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .filter-item select,
        .filter-item input {
            padding: 0.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.875rem;
            background: white;
            transition: all 0.3s ease;
        }
        
        .filter-item select:focus,
        .filter-item input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .workout-grid {
            display: grid;
            gap: 1rem;
        }
        
        .workout-item {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 1rem;
            align-items: center;
        }
        
        .workout-item:hover {
            border-color: #3b82f6;
            background: #fafbfc;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
        }
        
        .workout-info {
            display: grid;
            gap: 0.5rem;
        }
        
        .workout-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        
        .workout-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1e293b;
            font-family: 'Poppins', sans-serif;
        }
        
        .workout-date {
            color: #64748b;
            font-size: 0.875rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .workout-details {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .workout-type {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
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
            color: #64748b;
            font-size: 0.875rem;
        }
        
        .workout-stat i {
            color: #3b82f6;
            font-size: 0.75rem;
        }
        
        .workout-notes {
            color: #64748b;
            font-style: italic;
            font-size: 0.875rem;
            margin-top: 0.5rem;
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.05) 0%, rgba(16, 185, 129, 0.05) 100%);
            padding: 0.75rem;
            border-radius: 8px;
            border-left: 3px solid #3b82f6;
        }
        
        .workout-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-small {
            padding: 0.5rem 0.75rem;
            border: none;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-family: 'Inter', sans-serif;
        }
        
        .btn-danger {
            background: #ef4444;
            color: white;
        }
        
        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-1px);
        }
        
        .no-workouts {
            text-align: center;
            color: #64748b;
            padding: 3rem;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 12px;
            border: 2px dashed #e2e8f0;
        }
        
        .no-workouts i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }
        
        .no-workouts h3 {
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
            
            .page-title {
                font-size: 1.75rem;
            }
            
            .history-header {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }
            
            .workout-item {
                grid-template-columns: 1fr;
                text-align: left;
            }
            
            .workout-actions {
                justify-content: flex-end;
            }
            
            .workout-details {
                justify-content: flex-start;
            }
            
            .filter-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 480px) {
            .main-content {
                padding: 0.5rem;
                padding-top: 4rem;
            }
            
            .history-card {
                padding: 1.5rem 1rem;
            }
            
            .workout-item {
                padding: 1rem;
            }
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
                    <a href="user-dashboard.jsp" class="nav-item">
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
                    <a href="workout-history.jsp" class="nav-item active">
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
                    <i class="fas fa-history"></i>
                    Workout History
                </h1>
                <p class="page-subtitle">Review and manage all your recorded fitness activities</p>
            </div>
            
            <div class="content-container">
                <div class="history-card">
                    <div class="history-header">
                        <h2 class="history-title">
                            <i class="fas fa-list"></i>
                            Your Workout Journey
                        </h2>
                        <a href="log-workout.jsp" class="add-workout-btn">
                            <i class="fas fa-plus"></i>
                            Add Workout
                        </a>
                    </div>
                    
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <%= request.getAttribute("success") %>
                        </div>
                    <% } %>
                    
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    
                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="filter-grid">
                            <div class="filter-item">
                                <label for="typeFilter">
                                    <i class="fas fa-filter"></i>
                                    Filter by Type
                                </label>
                                <select id="typeFilter" onchange="filterWorkouts()">
                                    <option value="">All Types</option>
                                    <option value="cardio">Cardio</option>
                                    <option value="strength">Strength</option>
                                    <option value="flexibility">Flexibility</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label for="dateFrom">
                                    <i class="fas fa-calendar-alt"></i>
                                    From Date
                                </label>
                                <input type="date" id="dateFrom" onchange="filterWorkouts()">
                            </div>
                            <div class="filter-item">
                                <label for="dateTo">
                                    <i class="fas fa-calendar-alt"></i>
                                    To Date
                                </label>
                                <input type="date" id="dateTo" onchange="filterWorkouts()">
                            </div>
                            <div class="filter-item">
                                <label>&nbsp;</label>
                                <button onclick="clearFilters()" class="btn btn-secondary">
                                    <i class="fas fa-times"></i>
                                    Clear Filters
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Workout History -->
                    <div class="workout-grid" id="workoutGrid">
                        <% if (workoutHistory != null && !workoutHistory.isEmpty()) { %>
                            <% for (WorkoutHistoryItem item : workoutHistory) { %>
                                <div class="workout-item" data-type="<%= item.getWorkoutType().toLowerCase() %>" data-date="<%= item.getLogDate() %>">
                                    <div class="workout-info">
                                        <div class="workout-header">
                                            <div class="workout-name"><%= item.getWorkoutName() %></div>
                                            <div class="workout-date">
                                                <i class="fas fa-calendar-alt"></i>
                                                <%= item.getLogDate() %>
                                            </div>
                                        </div>
                                        
                                        <div class="workout-details">
                                            <span class="workout-type <%= item.getWorkoutType().toLowerCase() %>">
                                                <%= item.getWorkoutType() %>
                                            </span>
                                            <div class="workout-stat">
                                                <i class="fas fa-clock"></i>
                                                <%= item.getDuration() %> min
                                            </div>
                                            <div class="workout-stat">
                                                <i class="fas fa-fire"></i>
                                                <%= item.getCaloriesBurned() %> cal
                                            </div>
                                        </div>
                                        
                                        <% if (item.getNotes() != null && !item.getNotes().trim().isEmpty()) { %>
                                            <div class="workout-notes">
                                                <i class="fas fa-sticky-note"></i>
                                                "<%= item.getNotes() %>"
                                            </div>
                                        <% } %>
                                    </div>
                                    
                                    <div class="workout-actions">
                                        <a href="workout-history?action=delete&logId=<%= item.getLogId() %>" 
                                           class="btn-small btn-danger"
                                           onclick="return confirm('Are you sure you want to delete this workout log?')">
                                            <i class="fas fa-trash"></i>
                                            Delete
                                        </a>
                                    </div>
                                </div>
                            <% } %>
                        <% } else { %>
                            <div class="no-workouts">
                                <i class="fas fa-dumbbell"></i>
                                <h3>No Workout History</h3>
                                <p>Start logging your workouts to build your fitness journey history!</p>
                                <a href="log-workout.jsp" class="btn btn-primary" style="margin-top: 1rem;">
                                    <i class="fas fa-plus"></i>
                                    Log Your First Workout
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="history-card">
                    <h3 style="margin-bottom: 1rem; color: #1e293b; font-family: 'Poppins', sans-serif;">
                        <i class="fas fa-bolt"></i>
                        Quick Actions
                    </h3>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                        <a href="log-workout.jsp" class="btn btn-primary">
                            <i class="fas fa-plus-circle"></i>
                            Log New Workout
                        </a>
                        <a href="view-progress.jsp" class="btn btn-secondary">
                            <i class="fas fa-chart-line"></i>
                            View Progress
                        </a>
                        <a href="set-goals.jsp" class="btn btn-secondary">
                            <i class="fas fa-bullseye"></i>
                            Set Goals
                        </a>
                        <a href="user-dashboard.jsp" class="btn btn-secondary">
                            <i class="fas fa-home"></i>
                            Back to Dashboard
                        </a>
                    </div>
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
        
        function filterWorkouts() {
            const typeFilter = document.getElementById('typeFilter').value.toLowerCase();
            const dateFrom = document.getElementById('dateFrom').value;
            const dateTo = document.getElementById('dateTo').value;
            const workoutItems = document.querySelectorAll('.workout-item');
            
            workoutItems.forEach(item => {
                const itemType = item.getAttribute('data-type');
                const itemDate = item.getAttribute('data-date');
                
                let showItem = true;
                
                // Filter by type
                if (typeFilter && itemType !== typeFilter) {
                    showItem = false;
                }
                
                // Filter by date range
                if (dateFrom && itemDate < dateFrom) {
                    showItem = false;
                }
                
                if (dateTo && itemDate > dateTo) {
                    showItem = false;
                }
                
                item.style.display = showItem ? 'grid' : 'none';
            });
        }
        
        function clearFilters() {
            document.getElementById('typeFilter').value = '';
            document.getElementById('dateFrom').value = '';
            document.getElementById('dateTo').value = '';
            filterWorkouts();
        }
        
        // Initialize date inputs
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('dateTo').max = today;
            
            console.log('💪 Workout history loaded successfully!');
        });
    </script>
</body>
</html>
