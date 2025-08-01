<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Authorization check
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || (!"admin".equals(adminSession.getAttribute("userType")) && !"admin".equals(adminSession.getAttribute("role")))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Retrieve system reports data
    List<Map<String, Object>> systemReports = (List<Map<String, Object>>) request.getAttribute("systemReports");
    if (systemReports == null) systemReports = new ArrayList<>();
    
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
    <title>FitTrack - System Reports</title>
    
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
        
        /* Reports Table */
        .reports-table-container {
            background: var(--bg-secondary);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            padding: 1.5rem;
            overflow-x: auto;
        }
        
        .reports-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 1rem;
        }
        
        .reports-table th,
        .reports-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        
        .reports-table th {
            background: rgba(220, 38, 38, 0.05);
            font-weight: 600;
            color: var(--text-primary);
            font-family: 'Poppins', sans-serif;
        }
        
        .reports-table tr:hover {
            background: rgba(220, 38, 38, 0.03);
        }
        
        .reports-table td {
            color: var(--text-secondary);
        }
        
        .action-btn {
            background: var(--admin-primary);
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
        
        .action-btn:hover {
            background: var(--admin-primary-dark);
            transform: translateY(-1px);
            color: white;
            text-decoration: none;
        }
        
        /* Report Form */
        .report-form {
            background: var(--bg-secondary);
            padding: 1.5rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            margin-bottom: 2rem;
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        .form-group label {
            display: block;
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }
        
        .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            color: var(--text-primary);
            background: var(--bg-secondary);
        }
        
        .form-group select:focus {
            outline: none;
            border-color: var(--admin-primary);
            box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.2);
        }
        
        .submit-btn {
            background: var(--admin-primary);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .submit-btn:hover {
            background: var(--admin-primary-dark);
            transform: translateY(-1px);
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
            
            .reports-table th,
            .reports-table td {
                padding: 0.75rem;
                font-size: 0.9rem;
            }
        }
        
        @media (max-width: 480px) {
            .reports-table th,
            .reports-table td {
                padding: 0.5rem;
                font-size: 0.85rem;
            }
            
            .action-btn, .back-btn, .submit-btn {
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
        
        .reports-table-container, .report-form {
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
                <a href="/FitTrack/admin/user-management?action=analytics" class="nav-btn">
                    <i class="fas fa-chart-line"></i>
                    User Analytics
                </a>
                <a href="/FitTrack/admin/user-management?action=reports" class="nav-btn">
                    <i class="fas fa-file-alt"></i>
                    User Reports
                </a>
                <a href="/FitTrack/admin/user-management?action=system-analytics" class="nav-btn">
                    <i class="fas fa-server"></i>
                    System Analytics
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
                    <h1><i class="fas fa-file-alt"></i> System Reports</h1>
                    <p>Generate and view reports on system performance and usage metrics.</p>
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

        <!-- Report Form -->
        <div class="report-form">
            <form action="/FitTrack/admin/user-management?action=system-reports" method="post">
                <div class="form-group">
                    <label for="reportPeriod">Select Report Period</label>
                    <select id="reportPeriod" name="reportPeriod">
                        <option value="last24hours">Last 24 Hours</option>
                        <option value="last7days">Last 7 Days</option>
                        <option value="last30days">Last 30 Days</option>
                    </select>
                </div>
                <button type="submit" class="submit-btn">Generate Report</button>
            </form>
        </div>

        <!-- Reports Table -->
        <div class="reports-table-container">
            <table class="reports-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Average CPU Usage (%)</th>
                        <th>Average Memory Usage (MB)</th>
                        <th>Total Requests</th>
                        <th>Average Response Time (ms)</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (systemReports.isEmpty()) { %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 2rem;">
                                No system reports available. Generate a report above.
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Map<String, Object> report : systemReports) { %>
                            <tr>
                                <td><%= report.get("date") %></td>
                                <td><%= String.format("%.1f", report.get("avgCpuUsage")) %></td>
                                <td><%= String.format("%.1f", report.get("avgMemoryUsage")) %></td>
                                <td><%= report.get("totalRequests") %></td>
                                <td><%= String.format("%.1f", report.get("avgResponseTime")) %></td>
                                <td>
                                    
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Add hover effects to action buttons and back button
        document.querySelectorAll('.action-btn, .back-btn, .submit-btn').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Log page load
        console.log('%c📊 System Reports Page Loaded', 'color: #dc2626; font-size: 16px; font-weight: bold;');
        console.log('Reports count:', <%= systemReports.size() %>);
    </script>
</body>
</html>
