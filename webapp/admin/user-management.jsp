<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseConnection" %>
<%!
    public static String escapeJs(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
%>
<%
    System.out.println("JSP DEBUG: Starting user-management.jsp");
    
    // Authorization check
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String adminUserType = (String) adminSession.getAttribute("userType");
    String adminRole = (String) adminSession.getAttribute("role");
    
    System.out.println("JSP DEBUG: UserType=" + adminUserType + ", Role=" + adminRole);
    
    if (!"admin".equals(adminUserType) && !"admin".equals(adminRole)) {
        System.out.println("JSP DEBUG: Access denied - not admin");
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Get data from servlet
    List<Map<String, Object>> users = (List<Map<String, Object>>) request.getAttribute("users");
    Map<String, Integer> statistics = (Map<String, Integer>) request.getAttribute("statistics");
    
    System.out.println("JSP DEBUG: Users from request: " + (users != null ? users.size() : "null"));
    System.out.println("JSP DEBUG: Statistics from request: " + (statistics != null ? statistics.size() : "null"));
    
    if (users == null) {
        users = new ArrayList<>();
        System.out.println("JSP DEBUG: Users list was null, created empty list");
    }
    if (statistics == null) {
        statistics = new HashMap<>();
        statistics.put("total_users", 0);
        statistics.put("active_users", 0);
        statistics.put("new_users", 0);
        statistics.put("total_logs", 0);
        System.out.println("JSP DEBUG: Statistics was null, created empty map");
    }
    
    // Get session messages
    String successMessage = (String) session.getAttribute("success");
    String errorMessage = (String) session.getAttribute("error");
    
    // Clear session messages
    if (successMessage != null) session.removeAttribute("success");
    if (errorMessage != null) session.removeAttribute("error");
    
    System.out.println("JSP DEBUG: Ready to render page with " + users.size() + " users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - FitTrack Admin</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- External Admin Styles (if exists) -->
    <link rel="stylesheet" href="../css/admin/admin-style.css">
    
    <!-- Page Specific Styles -->
    <style>
        :root {
            --admin-primary: #dc2626;
            --admin-primary-dark: #b91c1c;
            --admin-success: #10b981;
            --admin-danger: #ef4444;
            --admin-info: #3b82f6;
            --admin-warning: #f59e0b;
            
            --color-white: #ffffff;
            --color-gray-50: #f9fafb;
            --color-gray-100: #f3f4f6;
            --color-gray-200: #e5e7eb;
            --color-gray-300: #d1d5db;
            --color-gray-400: #9ca3af;
            --color-gray-500: #6b7280;
            --color-gray-600: #4b5563;
            --color-gray-700: #374151;
            --color-gray-800: #1f2937;
            --color-gray-900: #111827;
            
            --spacing-xs: 0.25rem;
            --spacing-sm: 0.5rem;
            --spacing-md: 1rem;
            --spacing-lg: 1.5rem;
            --spacing-xl: 2rem;
            
            --radius-sm: 0.25rem;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            
            --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
            
            --transition-fast: all 0.2s ease;
            --transition-base: all 0.3s ease;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: var(--color-gray-50);
            color: var(--color-gray-900);
            line-height: 1.6;
        }
        
        .admin-layout {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        /* Header Styles */
        .admin-header {
            background: var(--admin-primary);
            color: var(--color-white);
            padding: var(--spacing-md) 0;
            box-shadow: var(--shadow-md);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .admin-header .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 var(--spacing-lg);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .admin-brand {
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
            text-decoration: none;
            color: var(--color-white);
            font-size: 1.25rem;
            font-weight: 700;
        }
        
        .admin-brand i { font-size: 1.5rem; }
        
        .admin-nav {
            display: flex;
            gap: var(--spacing-lg);
        }
        
        .admin-nav-link {
            display: flex;
            align-items: center;
            gap: var(--spacing-xs);
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--radius-md);
            transition: var(--transition-fast);
        }
        
        .admin-nav-link:hover,
        .admin-nav-link.active {
            background: rgba(255, 255, 255, 0.1);
            color: var(--color-white);
        }
        
        /* Main Content */
        .admin-main {
            flex: 1;
            padding: var(--spacing-xl) 0;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 var(--spacing-lg);
        }
        
        /* Alert Messages */
        .alert {
            padding: var(--spacing-md) var(--spacing-lg);
            border-radius: var(--radius-md);
            margin-bottom: var(--spacing-lg);
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
            animation: slideIn 0.3s ease;
        }
        
        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--admin-success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        
        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            color: var(--admin-danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
        
        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-xl);
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-gray-900);
            display: flex;
            align-items: center;
            gap: var(--spacing-md);
        }
        
        /* Statistics Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-xl);
        }
        
        .stat-card {
            background: var(--color-white);
            padding: var(--spacing-lg);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            transition: var(--transition-base);
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .stat-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        
        .stat-content h3 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-gray-900);
            margin-bottom: var(--spacing-xs);
        }
        
        .stat-content p {
            color: var(--color-gray-600);
            font-size: 0.875rem;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            background: rgba(220, 38, 38, 0.1);
            color: var(--admin-primary);
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }
        
        /* Content Card */
        .content-card {
            background: var(--color-white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
        }
        
        .card-header {
            padding: var(--spacing-lg);
            border-bottom: 1px solid var(--color-gray-200);
        }
        
        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--color-gray-900);
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
        }
        
        .card-content {
            padding: var(--spacing-lg);
        }
        
        /* Table Container - IMPORTANT FOR RESPONSIVENESS */
        .table-container {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            position: relative;
        }
        
        /* Table Styles */
        .admin-table {
            width: 100%;
            min-width: 1000px; /* Ensures all columns are visible */
            border-collapse: collapse;
            font-size: 0.875rem;
        }
        
        .admin-table th,
        .admin-table td {
            text-align: left;
            padding: var(--spacing-md);
            border-bottom: 1px solid var(--color-gray-200);
        }
        
        .admin-table th {
            background: var(--color-gray-50);
            font-weight: 600;
            color: var(--color-gray-700);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        
        .admin-table tr:hover {
            background: var(--color-gray-50);
        }
        
        /* User Info Cell */
        .user-info {
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--admin-primary);
            color: var(--color-white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            flex-shrink: 0;
        }
        
        .user-details h4 {
            font-weight: 600;
            color: var(--color-gray-900);
            margin-bottom: 0.125rem;
        }
        
        .user-details p {
            color: var(--color-gray-600);
            font-size: 0.75rem;
        }
        
        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .status-badge i {
            font-size: 0.5rem;
        }
        
        .status-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--admin-success);
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
        }
        
        .action-btn {
            width: 32px;
            height: 32px;
            border: none;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition-fast);
            font-size: 0.875rem;
        }
        
        .action-btn.view {
            background: rgba(59, 130, 246, 0.1);
            color: var(--admin-info);
        }
        
        .action-btn.view:hover {
            background: rgba(59, 130, 246, 0.2);
        }
        
        .action-btn.edit {
            background: rgba(245, 158, 11, 0.1);
            color: var(--admin-warning);
        }
        
        .action-btn.edit:hover {
            background: rgba(245, 158, 11, 0.2);
        }
        
        .action-btn.delete {
            background: rgba(239, 68, 68, 0.1);
            color: var(--admin-danger);
        }
        
        .action-btn.delete:hover {
            background: rgba(239, 68, 68, 0.2);
        }
        
        /* Button Styles */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: var(--radius-md);
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition-fast);
            font-size: 0.875rem;
        }
        
        .btn-secondary {
            background: var(--color-gray-200);
            color: var(--color-gray-700);
        }
        
        .btn-secondary:hover {
            background: var(--color-gray-300);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--color-gray-500);
        }
        
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
            color: var(--color-gray-700);
        }
        
        /* Scroll Indicator */
        .scroll-indicator {
            position: absolute;
            bottom: 0;
            right: 0;
            background: var(--admin-primary);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: var(--radius-md) 0 0 0;
            font-size: 0.75rem;
            opacity: 0;
            transition: opacity 0.3s;
        }
        
        .table-container:hover .scroll-indicator {
            opacity: 1;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .admin-header .container {
                flex-direction: column;
                gap: 1rem;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .admin-table {
                font-size: 0.75rem;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 0.5rem;
            }
        }
        
        /* Animations */
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <!-- Admin Header -->
        <header class="admin-header">
            <div class="container">
                <a href="/FitTrack/admin/admin-dashboard.jsp" class="admin-brand">
                    <i class="fas fa-dumbbell"></i>
                    FitTrack Admin
                </a>
                
                <nav class="admin-nav">
                    <a href="/FitTrack/admin/admin-dashboard.jsp" class="admin-nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        Dashboard
                    </a>
                    <a href="/FitTrack/admin/user-management" class="admin-nav-link active">
                        <i class="fas fa-users"></i>
                        Users
                    </a>
                    <a href="/FitTrack/admin/workout-management" class="admin-nav-link"><i class="fas fa-dumbbell"></i> Workouts</a>
                    <a href="#" class="admin-nav-link"><i class="fas fa-chart-bar"></i> Reports</a>
                    <a href="/FitTrack/login.jsp" class="admin-nav-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </nav>
            </div>
        </header>

        <!-- Main Content -->
        <main class="admin-main">
            <div class="container">
                <!-- Success/Error Messages -->
                <% if (successMessage != null) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <%= successMessage %>
                    </div>
                <% } %>
                
                <% if (errorMessage != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= errorMessage %>
                    </div>
                <% } %>
                
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <!-- Page Header -->
                <div class="page-header">
                    <h1 class="page-title">
                        <i class="fas fa-users"></i>
                        User Management
                    </h1>
                    <div class="page-actions">
                        <button class="btn btn-secondary" onclick="exportUsers()">
                            <i class="fas fa-download"></i>
                            Export Users
                        </button>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-content">
                                <h3><%= statistics.getOrDefault("total_users", 0) %></h3>
                                <p>Total Users</p>
                            </div>
                            <div class="stat-icon">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-content">
                                <h3><%= statistics.getOrDefault("active_users", 0) %></h3>
                                <p>Active Users</p>
                            </div>
                            <div class="stat-icon">
                                <i class="fas fa-user-check"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-content">
                                <h3><%= statistics.getOrDefault("new_users", 0) %></h3>
                                <p>New This Month</p>
                            </div>
                            <div class="stat-icon">
                                <i class="fas fa-user-plus"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-content">
                                <h3><%= statistics.getOrDefault("total_logs", 0) %></h3>
                                <p>Workout Logs</p>
                            </div>
                            <div class="stat-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Users Table Card -->
                <div class="content-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-table"></i>
                            All Users (<%= users.size() %>)
                        </h2>
                    </div>

                    <div class="card-content">
                        <% if (users.isEmpty()) { %>
                            <div class="empty-state">
                                <i class="fas fa-users"></i>
                                <h3>No Users Found</h3>
                                <p>There are no registered users in the system yet.</p>
                                <% if (request.getAttribute("error") != null) { %>
                                    <br>
                                    <p style="color: var(--admin-danger); font-weight: 500;">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        Database Error: Please check your database connection and table structure.
                                    </p>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="table-container">
                                <table class="admin-table" id="usersTable">
                                    <thead>
                                        <tr>
                                            <th>User</th>
                                            <th>Contact</th>
                                            <th>Physical Info</th>
                                            <th>Status</th>
                                            <th>Activity Stats</th>
                                            <th>Joined</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        System.out.println("JSP DEBUG: Rendering " + users.size() + " users");
                                        for (int i = 0; i < users.size(); i++) { 
                                            Map<String, Object> user = users.get(i);
                                            System.out.println("JSP DEBUG: Rendering user " + i + ": " + user.get("username"));
                                        %>
                                            <tr data-user-id="<%= user.get("user_id") %>">
                                                <td>
                                                    <div class="user-info">
                                                        <div class="user-avatar">
                                                            <%= user.get("username") != null ? 
                                                                ((String)user.get("username")).substring(0, 1).toUpperCase() : "?" %>
                                                        </div>
                                                        <div class="user-details">
                                                            <h4><%= user.get("username") != null ? user.get("username") : "Unknown" %></h4>
                                                            <p>ID: #<%= user.get("user_id") %></p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="user-details">
                                                        <h4><%= user.get("email") != null ? user.get("email") : "No email" %></h4>
                                                        <p><%= user.get("gender") != null ? user.get("gender") : "Not specified" %></p>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="user-details">
                                                        <h4><%= user.get("age") != null && (int)user.get("age") > 0 ? user.get("age") + " years old" : "Age not specified" %></h4>
                                                        <p>
                                                            <%= user.get("weight") != null && (double)user.get("weight") > 0 ? user.get("weight") + "kg" : "Weight: N/A" %> • 
                                                            <%= user.get("height") != null && (double)user.get("height") > 0 ? user.get("height") + "cm" : "Height: N/A" %>
                                                        </p>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-active">
                                                        <i class="fas fa-circle"></i>
                                                        Active
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="user-details">
                                                        <h4><%= user.get("total_workouts") != null ? user.get("total_workouts") : "0" %> workouts</h4>
                                                        <p><%= user.get("total_calories") != null ? user.get("total_calories") : "0" %> cal burned</p>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="user-details">
                                                        <h4>
                                                            <%= user.get("created_at") != null ? 
                                                                ((String)user.get("created_at")).substring(0, 10) : "Unknown" %>
                                                        </h4>
                                                        <p>
                                                            Last activity: 
                                                            <%= user.get("last_workout_date") != null && !"Never".equals(user.get("last_workout_date")) ? 
                                                                user.get("last_workout_date") : "Never" %>
                                                        </p>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <button class="action-btn view" data-user-id="<%= user.get("user_id") %>" onclick="viewUser(this.getAttribute('data-user-id'))" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <a class="action-btn edit" href="/FitTrack/admin/user-management?action=edit&userId=<%= user.get("user_id") %>" title="Edit User">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button class="action-btn delete" data-user-id="<%= user.get("user_id") %>" data-username="<%= escapeJs((String)user.get("username")) %>" onclick="deleteUser(this.getAttribute('data-user-id'), this.getAttribute('data-username'))" title="Delete User">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                                <div class="scroll-indicator">
                                    <i class="fas fa-arrow-right"></i> Scroll for more
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Debug Information (remove in production) -->
                <% if (request.getParameter("debug") != null) { %>
                    <div class="content-card" style="margin-top: 2rem;">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-bug"></i>
                                Debug Information
                            </h2>
                        </div>
                        <div class="card-content">
                            <p><strong>Users List Size:</strong> <%= users.size() %></p>
                            <p><strong>Statistics Map:</strong> <%= statistics %></p>
                            <p><strong>Request Attributes:</strong></p>
                            <ul>
                                <li>users: <%= request.getAttribute("users") != null ? "Present" : "NULL" %></li>
                                <li>statistics: <%= request.getAttribute("statistics") != null ? "Present" : "NULL" %></li>
                                <li>error: <%= request.getAttribute("error") %></li>
                            </ul>
                            <p><strong>Session Info:</strong></p>
                            <ul>
                                <li>userType: <%= adminUserType %></li>
                                <li>role: <%= adminRole %></li>
                            </ul>
                        </div>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <script>
        function viewUser(userId) {
            window.location.href = '/FitTrack/admin/user-management?action=view&userId=' + userId;
        }

        function editUser(userId) {
            alert('Edit functionality will be implemented in the next phase.');
        }

        function deleteUser(userId, username) {
            if (confirm('Are you sure you want to delete user "' + username + '"?\n\nThis action cannot be undone and will remove all user data including workout logs and goals.')) {
                window.location.href = '/FitTrack/admin/user-management?action=delete&userId=' + userId;
            }
        }

        function exportUsers() {
            console.log('Exporting users...');
            const table = document.getElementById('usersTable');
            if (!table) {
                alert('No users to export');
                return;
            }
            const rows = table.querySelectorAll('tr');
            let csv = '';
            // Header
            csv += 'Username,Email,Gender,Age,Weight,Height,Total Workouts,Total Calories,Join Date\n';
            // Data rows
            rows.forEach((row, index) => {
                if (index === 0) return; // Skip header
                const cells = row.querySelectorAll('td');
                if (cells.length > 1) {
                    try {
                        const username = cells[0].querySelector('.user-details h4').textContent || 'N/A';
                        const email = cells[1].querySelector('.user-details h4').textContent || 'N/A';
                        const gender = cells[1].querySelector('.user-details p').textContent || 'N/A';
                        const age = cells[2].querySelector('.user-details h4').textContent || 'N/A';
                        const physical = cells[2].querySelector('.user-details p').textContent || 'N/A';
                        const workouts = cells[4].querySelector('.user-details h4').textContent || '0 workouts';
                        const calories = cells[4].querySelector('.user-details p').textContent || '0 calories';
                        const joinDate = cells[5].querySelector('.user-details h4').textContent || 'N/A';
                        csv += '"' + username + '","' + email + '","' + gender + '","' + age + '","' + physical + '","' + workouts + '","' + calories + '","' + joinDate + '"\n';
                    } catch (e) {
                        console.error('Error processing row:', e);
                    }
                }
            });
            // Download CSV
            const blob = new Blob([csv], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'fittrack-users-' + new Date().toISOString().slice(0, 10) + '.csv';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        }

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transition = 'opacity 0.3s ease';
                    setTimeout(() => {
                        if (alert.parentNode) {
                            alert.remove();
                        }
                    }, 300);
                }, 5000);
            });
            console.log('👥 User Management page loaded successfully!');
        });
    </script>
</body>
</html>

