<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseConnection" %>
<%
    if (session.getAttribute("userType") == null || !"user".equals(session.getAttribute("userType"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    User user = (User) session.getAttribute("user");
    
    // Handle form submission
    String successMessage = null;
    String errorMessage = null;
    
    if ("POST".equals(request.getMethod())) {
        String workoutIdStr = request.getParameter("workoutId");
        String notes = request.getParameter("notes");
        String logDate = request.getParameter("logDate");
        
        if (workoutIdStr != null && !workoutIdStr.trim().isEmpty()) {
            try {
                int workoutId = Integer.parseInt(workoutIdStr);
                
                Connection conn = null;
                PreparedStatement pstmt = null;
                
                try {
                    conn = DatabaseConnection.getConnection();
                    String sql = "INSERT INTO user_logs (user_id, workout_id, log_date, notes) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, user.getUser_id());
                    pstmt.setInt(2, workoutId);
                    pstmt.setString(3, logDate != null ? logDate : java.time.LocalDate.now().toString());
                    pstmt.setString(4, notes != null ? notes : "");
                    
                    int result = pstmt.executeUpdate();
                    
                    if (result > 0) {
                        successMessage = "Workout logged successfully! 🎉";
                    } else {
                        errorMessage = "Failed to log workout. Please try again.";
                    }
                    
                } catch (SQLException e) {
                    errorMessage = "Database error: " + e.getMessage();
                } finally {
                    try {
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                
            } catch (NumberFormatException e) {
                errorMessage = "Invalid workout selection";
            }
        } else {
            errorMessage = "Please select a workout";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTrack - Log Workout</title>
    
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
        
        /* Form Styles */
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .form-card {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 2rem;
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
        .form-select,
        .form-textarea {
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
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .workout-info {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            padding: 1rem;
            border-radius: 10px;
            margin-top: 0.5rem;
            border-left: 4px solid #3b82f6;
            display: none;
        }
        
        .workout-info.show {
            display: block;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .workout-details {
            display: flex;
            gap: 1rem;
            align-items: center;
            font-size: 0.875rem;
            color: #1e293b;
            font-weight: 500;
        }
        
        .workout-badge {
            background: #3b82f6;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
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
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            width: 100%;
            justify-content: center;
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
            
            .form-card {
                padding: 1.5rem;
            }
        }
        
        @media (max-width: 480px) {
            .main-content {
                padding: 0.5rem;
                padding-top: 4rem;
            }
            
            .form-card {
                padding: 1.25rem;
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
                    <a href="log-workout.jsp" class="nav-item active">
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
                    <i class="fas fa-plus-circle"></i>
                    Log Workout
                </h1>
                <p class="page-subtitle">Track your fitness activities and monitor your progress</p>
            </div>
            
            <div class="form-container">
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
                
                <div class="form-card">
                    <form method="post" id="workoutForm">
                        <div class="form-group">
                            <label for="workoutId" class="form-label">
                                <i class="fas fa-dumbbell"></i>
                                Choose Workout <span class="required">*</span>
                            </label>
                            <select name="workoutId" id="workoutId" class="form-select" required onchange="showWorkoutInfo(this)">
                                <option value="">-- Select a workout --</option>
                                <%
                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;
                                
                                try {
                                    conn = DatabaseConnection.getConnection();
                                    String sql = "SELECT workout_id, name, type, duration, calories_burned FROM workouts ORDER BY name";
                                    pstmt = conn.prepareStatement(sql);
                                    rs = pstmt.executeQuery();
                                    
                                    while (rs.next()) {
                                        int workoutId = rs.getInt("workout_id");
                                        String workoutName = rs.getString("name");
                                        String workoutType = rs.getString("type");
                                        int duration = rs.getInt("duration");
                                        int calories = rs.getInt("calories_burned");
                                %>
                                        <option value="<%= workoutId %>" 
                                                data-type="<%= workoutType %>"
                                                data-duration="<%= duration %>"
                                                data-calories="<%= calories %>">
                                            <%= workoutName %>
                                        </option>
                                <%
                                    }
                                } catch (SQLException e) {
                                    out.println("<option value=''>Error loading workouts</option>");
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
                            </select>
                            
                            <div id="workoutInfo" class="workout-info">
                                <div class="workout-details">
                                    <span class="workout-badge" id="workoutType"></span>
                                    <span><i class="fas fa-clock"></i> <span id="workoutDuration"></span> minutes</span>
                                    <span><i class="fas fa-fire"></i> <span id="workoutCalories"></span> calories</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="logDate" class="form-label">
                                <i class="fas fa-calendar"></i>
                                Workout Date
                            </label>
                            <input type="date" name="logDate" id="logDate" class="form-input" value="<%= java.time.LocalDate.now() %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="notes" class="form-label">
                                <i class="fas fa-sticky-note"></i>
                                Notes (Optional)
                            </label>
                            <textarea name="notes" id="notes" class="form-textarea" 
                                      placeholder="How did the workout go? Any observations or achievements..."></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <i class="fas fa-save"></i>
                            Log This Workout
                        </button>
                    </form>
                </div>
                
                <!-- Quick Actions -->
                <div class="form-card">
                    <h3 style="margin-bottom: 1rem; color: #1e293b; font-family: 'Poppins', sans-serif;">
                        <i class="fas fa-bolt"></i>
                        Quick Actions
                    </h3>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                        <a href="workout-history.jsp" class="btn btn-secondary">
                            <i class="fas fa-history"></i>
                            View History
                        </a>
                        <a href="view-progress.jsp" class="btn btn-secondary">
                            <i class="fas fa-chart-line"></i>
                            View Progress
                        </a>
                        <a href="set-goals.jsp" class="btn btn-secondary">
                            <i class="fas fa-bullseye"></i>
                            Set Goals
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
        
        function showWorkoutInfo(select) {
            const selectedOption = select.options[select.selectedIndex];
            const infoDiv = document.getElementById('workoutInfo');
            
            if (selectedOption.value && selectedOption.dataset.type) {
                const type = selectedOption.dataset.type;
                const duration = selectedOption.dataset.duration;
                const calories = selectedOption.dataset.calories;
                
                document.getElementById('workoutType').textContent = type;
                document.getElementById('workoutDuration').textContent = duration;
                document.getElementById('workoutCalories').textContent = calories;
                
                infoDiv.classList.add('show');
            } else {
                infoDiv.classList.remove('show');
            }
        }
        
        // Form submission handling
        document.getElementById('workoutForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const workoutSelect = document.getElementById('workoutId');
            
            if (!workoutSelect.value) {
                e.preventDefault();
                alert('Please select a workout');
                return;
            }
            
            // Add loading state
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Logging Workout...';
            submitBtn.disabled = true;
        });
        
        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            console.log('🏋️‍♂️ Log Workout page loaded successfully!');
        });
    </script>
</body>
</html>
