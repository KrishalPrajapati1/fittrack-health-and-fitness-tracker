<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Authorization check
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || (!"admin".equals(adminSession.getAttribute("userType")) && !"admin".equals(adminSession.getAttribute("role")))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Retrieve analytics data
    Map<String, Integer> statistics = (Map<String, Integer>) request.getAttribute("statistics");
    if (statistics == null) statistics = new HashMap<>();
    
    Map<String, Object> workoutAnalytics = (Map<String, Object>) request.getAttribute("workoutAnalytics");
    if (workoutAnalytics == null) workoutAnalytics = new HashMap<>();
    
    List<Map<String, Object>> growthData = (List<Map<String, Object>>) request.getAttribute("growthData");
    if (growthData == null) growthData = new ArrayList<>();
    
    List<Map<String, Object>> popularWorkouts = (List<Map<String, Object>>) workoutAnalytics.getOrDefault("popularWorkouts", new ArrayList<>());
    Double avgDuration = (Double) workoutAnalytics.getOrDefault("avgDuration", 0.0);

    // Retrieve any error or success messages
    String error = (String) request.getSession().getAttribute("error");
    String success = (String) request.getSession().getAttribute("success");
    if (error != null) {
        request.getSession().removeAttribute("error");
    }
    if (success != null) {
        request.getSession().removeAttribute("success");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTrack - User Analytics</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        :root {
            --admin-primary: #dc2626;
            --admin-primary-dark: #b91c1c;
            --admin-secondary: #f59e0b;
            --admin-success: #10b981;
            --admin-info: #3b82f6;
            --admin-danger: #ef4444;
            --bg-primary: #f8f9fa;
            --bg-secondary: #ffffff;
            --text-primary: #2c3e50;
            --text-secondary: #7f8c8d;
            --border-color: #ecf0f1;
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.07);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
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
        
        /* Header Section */
        .header-section {
            background: var(--bg-secondary);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .header-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, var(--admin-primary) 0%, var(--admin-primary-dark) 100%);
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .header-section h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--admin-primary);
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .header-section p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
        
        .back-btn {
            background: var(--admin-info);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .back-btn:hover {
            background: #2563eb;
            transform: translateY(-1px);
            color: white;
            text-decoration: none;
        }
        
        /* Alerts */
        .alert {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--admin-success);
        }
        
        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            color: var(--admin-danger);
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
            box-shadow: var(--shadow-lg);
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
        
        /* Analytics Sections */
        .analytics-section {
            background: var(--bg-secondary);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .section-title i {
            color: var(--admin-primary);
        }
        
        /* Workouts Table */
        .workouts-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 1rem;
        }
        
        .workouts-table th,
        .workouts-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        
        .workouts-table th {
            background: rgba(220, 38, 38, 0.05);
            font-weight: 600;
            color: var(--text-primary);
            font-family: 'Poppins', sans-serif;
        }
        
        .workouts-table tr:hover {
            background: rgba(220, 38, 38, 0.03);
        }
        
        .workouts-table td {
            color: var(--text-secondary);
        }
        
        /* Chart Container */
        .chart-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 1rem;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                gap: 1rem;
                padding: 0 1rem;
            }
            
            .container {
                padding: 1rem;
            }
            
            .header-content {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .header-section h1 {
                font-size: 1.5rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .workouts-table th,
            .workouts-table td {
                padding: 0.75rem;
                font-size: 0.9rem;
            }
            
            .chart-container {
                padding: 0.5rem;
            }
        }
        
        @media (max-width: 480px) {
            .workouts-table th,
            .workouts-table td {
                padding: 0.5rem;
                font-size: 0.85rem;
            }
            
            .stat-value {
                font-size: 1.5rem;
            }
            
            .back-btn {
                padding: 0.4rem 0.8rem;
                font-size: 0.85rem;
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
        
        .stats-grid,
        .analytics-section {
            animation: fadeInUp 0.6s ease-out;
        }
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
                <a href="/FitTrack/admin/user-management" class="nav-btn">
                    <i class="fas fa-users"></i>
                    Manage Users
                </a>
                <a href="/FitTrack/admin/user-management?action=reports" class="nav-btn">
                    <i class="fas fa-file-alt"></i>
                    User Reports
                </a>
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
        <!-- Header Section -->
        <div class="header-section">
            <div class="header-content">
                <div>
                    <h1><i class="fas fa-chart-line"></i> User Analytics</h1>
                    <p>Analyze user engagement, workout trends, and platform growth.</p>
                </div>
                <a href="/FitTrack/admin/admin-dashboard.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= success %>
            </div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= error %>
            </div>
        <% } %>

        <!-- Statistics Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= statistics.getOrDefault("total_users", 0) %></div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= statistics.getOrDefault("active_users", 0) %></div>
                <div class="stat-label">Active Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= statistics.getOrDefault("new_users", 0) %></div>
                <div class="stat-label">New Users (30 days)</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= statistics.getOrDefault("total_logs", 0) %></div>
                <div class="stat-label">Total Workout Logs</div>
            </div>
        </div>

        <!-- Workout Analytics -->
        <div class="analytics-section">
            <h2 class="section-title"><i class="fas fa-dumbbell"></i> Workout Analytics</h2>
            <p>Average Workout Duration: <%= String.format("%.1f", avgDuration) %> minutes</p>
            <table class="workouts-table">
                <thead>
                    <tr>
                        <th>Workout Name</th>
                        <th>Type</th>
                        <th>Log Count</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (popularWorkouts.isEmpty()) { %>
                        <tr>
                            <td colspan="3" style="text-align: center; padding: 2rem;">
                                No workout data available.
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Map<String, Object> workout : popularWorkouts) { %>
                            <tr>
                                <td><%= workout.get("name") %></td>
                                <td><%= workout.get("type") %></td>
                                <td><%= workout.get("log_count") %></td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- User Growth Chart -->
        <div class="analytics-section">
            <h2 class="section-title"><i class="fas fa-chart-line"></i> User Growth (Last 12 Months)</h2>
            <div class="chart-container">
                <canvas id="userGrowthChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        // Chart.js User Growth Chart
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('userGrowthChart').getContext('2d');
            const months = [<% for (Map<String, Object> data : growthData) { %>
                '<%= data.get("month") %>',
            <% } %>];
            const userCounts = [<% for (Map<String, Object> data : growthData) { %>
                <%= data.get("user_count") %>,
            <% } %>];

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: months,
                    datasets: [{
                        label: 'New Users',
                        data: userCounts,
                        borderColor: '#dc2626',
                        backgroundColor: 'rgba(220, 38, 38, 0.1)',
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Number of Users'
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Month'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        }
                    }
                }
            });
        });

        // Add hover effects to nav buttons and back button
        document.querySelectorAll('.nav-btn, .back-btn').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Log page load
        console.log('%c📈 User Analytics Page Loaded', 'color: #dc2626; font-size: 16px; font-weight: bold;');
        console.log('Statistics:', <%= statistics %>);
        console.log('Workout Analytics:', <%= workoutAnalytics %>);
        console.log('Growth Data:', <%= growthData %>);
    </script>
</body>
</html>
