<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="controller.SetGoalsServlet.Goal" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    User user = (User) session.getAttribute("user");
    List<Goal> userGoals = (List<Goal>) request.getAttribute("userGoals");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTrack - Set Goals</title>
    
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
        
        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .card {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        
        .card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .card-title {
            font-family: 'Poppins', sans-serif;
            font-size: 1.25rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .card-title i {
            color: #3b82f6;
            font-size: 1.125rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 600;
            font-size: 0.875rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .required {
            color: #ef4444;
        }
        
        .form-input,
        .form-select {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            background: #fafbfc;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
        }
        
        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.875rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 1rem;
            border: none;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
            width: 100%;
            justify-content: center;
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
        
        .btn-danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
            width: auto;
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.4);
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
        
        .goals-list {
            display: grid;
            gap: 1rem;
        }
        
        .goal-item {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            padding: 1.25rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .goal-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        
        .goal-item:hover {
            background: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.1);
        }
        
        .goal-info h4 {
            color: #1e293b;
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
        }
        
        .goal-details {
            display: flex;
            gap: 1rem;
            font-size: 0.875rem;
            color: #64748b;
        }
        
        .goal-detail {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .goal-detail i {
            color: #10b981;
            font-size: 0.75rem;
        }
        
        .goal-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .no-goals {
            text-align: center;
            color: #64748b;
            padding: 3rem;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 12px;
            border: 2px dashed #e2e8f0;
        }
        
        .no-goals i {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }
        
        .no-goals h4 {
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #475569;
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
            
            .page-title {
                font-size: 1.75rem;
            }
            
            .goal-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .goal-actions {
                width: 100%;
                justify-content: flex-end;
            }
        }
        
        @media (max-width: 480px) {
            .main-content {
                padding: 0.5rem;
                padding-top: 4rem;
            }
            
            .card {
                padding: 1.5rem;
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
                    <a href="workout-history.jsp" class="nav-item">
                        <i class="fas fa-history"></i>
                        Workout History
                    </a>
                    <a href="set-goals.jsp" class="nav-item active">
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
                    <i class="fas fa-bullseye"></i>
                    Set Your Goals
                </h1>
                <p class="page-subtitle">Define your fitness objectives and track your progress towards achieving them</p>
            </div>
            
            <div class="content-container">
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
                
                <div class="content-grid">
                    <!-- Add New Goal -->
                    <div class="card">
                        <h2 class="card-title">
                            <i class="fas fa-plus-circle"></i>
                            Add New Goal
                        </h2>
                        
                        <form method="post" action="set-goals" id="goalForm">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="form-group">
                                <label for="goalType" class="form-label">
                                    Goal Type <span class="required">*</span>
                                </label>
                                <select name="goalType" id="goalType" class="form-select" required>
                                    <option value="">Select Goal Type</option>
                                    <option value="Weight Loss">Weight Loss (kg)</option>
                                    <option value="Weight Gain">Weight Gain (kg)</option>
                                    <option value="Run Distance">Run Distance (km)</option>
                                    <option value="Workout Sessions">Workout Sessions per week</option>
                                    <option value="Calories Burn">Calories to Burn</option>
                                    <option value="Exercise Duration">Exercise Duration (hours)</option>
                                    <option value="Strength Goal">Strength Goal (kg)</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="targetValue" class="form-label">
                                    Target Value <span class="required">*</span>
                                </label>
                                <input type="number" name="targetValue" id="targetValue" class="form-input"
                                       placeholder="Enter target value" required step="0.1" min="0.1">
                            </div>
                            
                            <div class="form-group">
                                <label for="deadline" class="form-label">
                                    Target Date <span class="required">*</span>
                                </label>
                                <input type="date" name="deadline" id="deadline" class="form-input" required 
                                       min="<%= java.time.LocalDate.now().toString() %>">
                            </div>
                            
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <i class="fas fa-bullseye"></i>
                                Set Goal
                            </button>
                        </form>
                    </div>
                    
                    <!-- Current Goals -->
                    <div class="card">
                        <h2 class="card-title">
                            <i class="fas fa-list"></i>
                            Your Current Goals
                        </h2>
                        
                        <div class="goals-list">
                            <% if (userGoals != null && !userGoals.isEmpty()) { %>
                                <% for (Goal goal : userGoals) { %>
                                    <div class="goal-item">
                                        <div class="goal-info">
                                            <h4><%= goal.getGoalType() %></h4>
                                            <div class="goal-details">
                                                <div class="goal-detail">
                                                    <i class="fas fa-target"></i>
                                                    Target: <%= goal.getTargetValue() %>
                                                </div>
                                                <div class="goal-detail">
                                                    <i class="fas fa-calendar"></i>
                                                    Due: <%= goal.getDeadline() %>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="goal-actions">
                                            <form method="post" action="set-goals" style="display: inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="goalId" value="<%= goal.getGoalId() %>">
                                                <button type="submit" class="btn btn-danger" 
                                                        onclick="return confirm('Are you sure you want to delete this goal?')">
                                                    <i class="fas fa-trash"></i>
                                                    Delete
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                <% } %>
                            <% } else { %>
                                <div class="no-goals">
                                    <i class="fas fa-bullseye"></i>
                                    <h4>No Goals Set Yet</h4>
                                    <p>Start by setting your first fitness goal!</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="card">
                    <h3 style="margin-bottom: 1rem; color: #1e293b; font-family: 'Poppins', sans-serif;">
                        <i class="fas fa-bolt"></i>
                        Quick Actions
                    </h3>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                        <a href="log-workout.jsp" class="btn btn-primary" style="width: auto;">
                            <i class="fas fa-plus-circle"></i>
                            Log Workout
                        </a>
                        <a href="view-progress.jsp" class="btn" style="background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; width: auto;">
                            <i class="fas fa-chart-line"></i>
                            View Progress
                        </a>
                        <a href="workout-history.jsp" class="btn" style="background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; width: auto;">
                            <i class="fas fa-history"></i>
                            Workout History
                        </a>
                        <a href="user-dashboard.jsp" class="btn" style="background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; width: auto;">
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
        
        // Set minimum date to today
        document.getElementById('deadline').min = new Date().toISOString().split('T')[0];
        
        // Form validation
        document.getElementById('goalForm').addEventListener('submit', function(e) {
            const goalType = document.getElementById('goalType').value;
            const targetValue = document.getElementById('targetValue').value;
            const deadline = document.getElementById('deadline').value;
            
            if (!goalType || !targetValue || !deadline) {
                e.preventDefault();
                alert('Please fill in all required fields');
                return;
            }
            
            if (parseFloat(targetValue) <= 0) {
                e.preventDefault();
                alert('Target value must be greater than 0');
                return;
            }
            
            const selectedDate = new Date(deadline);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (selectedDate <= today) {
                e.preventDefault();
                alert('Deadline must be in the future');
                return;
            }
            
            // Add loading state
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Setting Goal...';
            submitBtn.disabled = true;
        });
        
        // Auto-focus first input
        document.getElementById('goalType').focus();
        
        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            console.log('🎯 Set Goals page loaded successfully!');
        });
    </script>
</body>
</html>
