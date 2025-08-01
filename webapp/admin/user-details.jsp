<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Authorization check
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String adminUserType = (String) adminSession.getAttribute("userType");
    String adminRole = (String) adminSession.getAttribute("role");
    
    if (!"admin".equals(adminUserType) && !"admin".equals(adminRole)) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Get user details from servlet
    Map<String, Object> userDetails = (Map<String, Object>) request.getAttribute("userDetails");
    
    if (userDetails == null) {
        response.sendRedirect("user-management");
        return;
    }
%>
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details - <%= userDetails.get("username") %> - FitTrack Admin</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Admin Styles -->
    <link rel="stylesheet" href="../css/admin/admin-style.css">
    
    <style>
        .user-profile-header {
            background: linear-gradient(135deg, var(--admin-primary) 0%, var(--admin-primary-dark) 100%);
            color: var(--color-white);
            padding: var(--spacing-2xl);
            border-radius: var(--radius-xl) var(--radius-xl) 0 0;
            margin: calc(-1 * var(--spacing-xl)) calc(-1 * var(--spacing-xl)) var(--spacing-xl) calc(-1 * var(--spacing-xl));
        }
        
        .profile-info {
            display: flex;
            align-items: center;
            gap: var(--spacing-xl);
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--color-white);
            border: 4px solid rgba(255, 255, 255, 0.3);
        }
        
        .profile-details h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: var(--spacing-sm);
            font-family: var(--font-family-heading);
        }
        
        .profile-meta {
            display: flex;
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-md);
            flex-wrap: wrap;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
            font-size: 0.875rem;
            opacity: 0.9;
        }
        
        .profile-actions {
            display: flex;
            gap: var(--spacing-md);
            margin-top: var(--spacing-lg);
        }
        
        .profile-btn {
            background: rgba(255, 255, 255, 0.2);
            color: var(--color-white);
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: var(--spacing-sm) var(--spacing-lg);
            border-radius: var(--radius-md);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition-fast);
            display: inline-flex;
            align-items: center;
            gap: var(--spacing-sm);
        }
        
        .profile-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
            color: var(--color-white);
        }
        
        .profile-btn.danger {
            background: rgba(239, 68, 68, 0.2);
            border-color: rgba(239, 68, 68, 0.3);
        }
        
        .profile-btn.danger:hover {
            background: rgba(239, 68, 68, 0.3);
            border-color: rgba(239, 68, 68, 0.5);
        }
        
        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--spacing-xl);
            margin-bottom: var(--spacing-xl);
        }
        
        .detail-card {
            background: var(--color-white);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow-md);
            border: 1px solid var(--color-gray-200);
            overflow: hidden;
        }
        
        .detail-header {
            background: var(--color-gray-50);
            padding: var(--spacing-lg);
            border-bottom: 1px solid var(--color-gray-200);
        }
        
        .detail-title {
            font-family: var(--font-family-heading);
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--color-gray-900);
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
        }
        
        .detail-title i {
            color: var(--admin-primary);
        }
        
        .detail-content {
            padding: var(--spacing-lg);
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--spacing-sm) 0;
            border-bottom: 1px solid var(--color-gray-100);
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: var(--color-gray-600);
            font-weight: 500;
            font-size: 0.875rem;
        }
        
        .info-value {
            color: var(--color-gray-900);
            font-weight: 600;
        }
        
        .activity-timeline {
            max-height: 400px;
            overflow-y: auto;
        }
        
        .timeline-item {
            display: flex;
            gap: var(--spacing-md);
            padding: var(--spacing-md) 0;
            border-bottom: 1px solid var(--color-gray-100);
        }
        
        .timeline-item:last-child {
            border-bottom: none;
        }
        
        .timeline-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--admin-primary);
            color: var(--color-white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
            flex-shrink: 0;
        }
        
        .timeline-content h4 {
            color: var(--color-gray-900);
            font-weight: 600;
            margin-bottom: var(--spacing-xs);
        }
        
        .timeline-content p {
            color: var(--color-gray-600);
            font-size: 0.875rem;
            margin-bottom: var(--spacing-xs);
        }
        
        .timeline-date {
            color: var(--color-gray-500);
            font-size: 0.75rem;
        }
        
        @media (max-width: 768px) {
            .details-grid {
                grid-template-columns: 1fr;
            }
            
            .profile-info {
                flex-direction: column;
                text-align: center;
            }
            
            .profile-meta {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <!-- Admin Header -->
        <header class="admin-header">
            <div class="container">
                <a href="../admin-dashboard.jsp" class="admin-brand">
                    <i class="fas fa-dumbbell"></i>
                    FitTrack Admin
                </a>
                
                <nav class="admin-nav">
                    <a href="../admin-dashboard.jsp" class="admin-nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        Dashboard
                    </a>
                    <a href="user-management" class="admin-nav-link active">
                        <i class="fas fa-users"></i>
                        Users
                    </a>
                    <a href="#" class="admin-nav-link">
                        <i class="fas fa-dumbbell"></i>
                        Workouts
                    </a>
                    <a href="#" class="admin-nav-link">
                        <i class="fas fa-chart-bar"></i>
                        Reports
                    </a>
                    <a href="../login.jsp" class="admin-nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        Logout
                    </a>
                </nav>
            </div>
        </header>

        <!-- Main Content -->
        <main class="admin-main">
            <div class="container">
                <!-- Back Button -->
                <div style="margin-bottom: var(--spacing-lg);">
                    <a href="user-management" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Back to Users
                    </a>
                </div>

                <!-- User Profile Card -->
                <div class="content-card">
                    <div class="user-profile-header">
                        <div class="profile-info">
                            <div class="profile-avatar">
                                <%= ((String)userDetails.get("username")).substring(0, 1).toUpperCase() %>
                            </div>
                            <div class="profile-details">
                                <h1><%= userDetails.get("username") %></h1>
                                <div class="profile-meta">
                                    <div class="meta-item">
                                        <i class="fas fa-envelope"></i>
                                        <%= userDetails.get("email") %>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-calendar-alt"></i>
                                        Joined <%= userDetails.get("created_at") != null ? 
                                            ((String)userDetails.get("created_at")).substring(0, 10) : "N/A" %>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-user"></i>
                                        <%= userDetails.get("gender") != null ? userDetails.get("gender") : "Not specified" %>
                                    </div>
                                </div>
                                <div class="profile-actions">
                                    <a href="edit-user.jsp?userId=<%= userDetails.get("user_id") %>" class="profile-btn">
                                        <i class="fas fa-edit"></i>
                                        Edit User
                                    </a>
                                    <a href="#" class="profile-btn danger" data-user-id="<%= userDetails.get("user_id") %>" data-username="<%= escapeJs((String)userDetails.get("username")) %>" onclick="deleteUser(this.getAttribute('data-user-id'), this.getAttribute('data-username'))">
                                        <i class="fas fa-trash"></i>
                                        Delete User
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- User Details Grid -->
                    <div class="card-content">
                        <div class="details-grid">
                            <!-- Personal Information -->
                            <div class="detail-card">
                                <div class="detail-header">
                                    <h3 class="detail-title">
                                        <i class="fas fa-user"></i>
                                        Personal Information
                                    </h3>
                                </div>
                                <div class="detail-content">
                                    <div class="info-row">
                                        <span class="info-label">Full Name</span>
                                        <span class="info-value"><%= userDetails.get("username") %></span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Email Address</span>
                                        <span class="info-value"><%= userDetails.get("email") %></span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Gender</span>
                                        <span class="info-value">
                                            <%= userDetails.get("gender") != null ? userDetails.get("gender") : "Not specified" %>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Age</span>
                                        <span class="info-value">
                                            <%= (Integer)userDetails.get("age") > 0 ? userDetails.get("age") + " years" : "Not specified" %>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Weight</span>
                                        <span class="info-value">
                                            <%= (Double)userDetails.get("weight") > 0 ? userDetails.get("weight") + " kg" : "Not specified" %>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Height</span>
                                        <span class="info-value">
                                            <%= (Double)userDetails.get("height") > 0 ? userDetails.get("height") + " cm" : "Not specified" %>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">BMI</span>
                                        <span class="info-value">
                                            <%
                                                Double weight = (Double)userDetails.get("weight");
                                                Double height = (Double)userDetails.get("height");
                                                if (weight > 0 && height > 0) {
                                                    double heightInM = height / 100.0;
                                                    double bmi = weight / (heightInM * heightInM);
                                                    out.print(String.format("%.1f", bmi));
                                                    
                                                    String bmiCategory = "";
                                                    if (bmi < 18.5) bmiCategory = " (Underweight)";
                                                    else if (bmi < 25) bmiCategory = " (Normal)";
                                                    else if (bmi < 30) bmiCategory = " (Overweight)";
                                                    else bmiCategory = " (Obese)";
                                                    out.print(bmiCategory);
                                                } else {
                                                    out.print("Not calculated");
                                                }
                                            %>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Fitness Statistics -->
                            <div class="detail-card">
                                <div class="detail-header">
                                    <h3 class="detail-title">
                                        <i class="fas fa-chart-line"></i>
                                        Fitness Statistics
                                    </h3>
                                </div>
                                <div class="detail-content">
                                    <div class="info-row">
                                        <span class="info-label">Total Workouts</span>
                                        <span class="info-value"><%= userDetails.get("total_workouts") %></span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Total Calories Burned</span>
                                        <span class="info-value"><%= userDetails.get("total_calories") %> kcal</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Total Exercise Time</span>
                                        <span class="info-value">
                                            <%= Math.round(((Integer)userDetails.get("total_duration")) / 60.0) %> hours
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Total Goals Set</span>
                                        <span class="info-value"><%= userDetails.get("total_goals") %></span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Average Workout Duration</span>
                                        <span class="info-value">
                                            <%
                                                int totalWorkouts = (Integer)userDetails.get("total_workouts");
                                                int totalDuration = (Integer)userDetails.get("total_duration");
                                                if (totalWorkouts > 0) {
                                                    out.print(Math.round(totalDuration / (double)totalWorkouts) + " minutes");
                                                } else {
                                                    out.print("No workouts yet");
                                                }
                                            %>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Calories per Workout</span>
                                        <span class="info-value">
                                            <%
                                                int totalWorkouts2 = (Integer)userDetails.get("total_workouts");
                                                int totalCalories = (Integer)userDetails.get("total_calories");
                                                if (totalWorkouts2 > 0) {
                                                    out.print(Math.round(totalCalories / (double)totalWorkouts2) + " kcal");
                                                } else {
                                                    out.print("No data");
                                                }
                                            %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Account Information -->
                        <div class="detail-card" style="margin-bottom: var(--spacing-xl);">
                            <div class="detail-header">
                                <h3 class="detail-title">
                                    <i class="fas fa-cog"></i>
                                    Account Information
                                </h3>
                            </div>
                            <div class="detail-content">
                                <div class="details-grid">
                                    <div>
                                        <div class="info-row">
                                            <span class="info-label">User ID</span>
                                            <span class="info-value">#<%= userDetails.get("user_id") %></span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Account Status</span>
                                            <span class="info-value">
                                                <span class="status-badge active">
                                                    <i class="fas fa-circle"></i>
                                                    Active
                                                </span>
                                            </span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Registration Date</span>
                                            <span class="info-value">
                                                <%= userDetails.get("created_at") != null ? 
                                                    ((String)userDetails.get("created_at")).substring(0, 10) : "N/A" %>
                                            </span>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="info-row">
                                            <span class="info-label">Last Login</span>
                                            <span class="info-value">Not tracked</span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Role</span>
                                            <span class="info-value">Regular User</span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Data Privacy</span>
                                            <span class="info-value">
                                                <i class="fas fa-shield-alt" style="color: var(--admin-success);"></i>
                                                Protected
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Activity Timeline -->
                        <div class="detail-card">
                            <div class="detail-header">
                                <h3 class="detail-title">
                                    <i class="fas fa-history"></i>
                                    Recent Activity
                                </h3>
                            </div>
                            <div class="detail-content">
                                <div class="activity-timeline">
                                    <!-- Sample timeline items - in a real app, you'd load this from database -->
                                    <div class="timeline-item">
                                        <div class="timeline-icon">
                                            <i class="fas fa-user-plus"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <h4>Account Created</h4>
                                            <p>User registered and created their FitTrack account</p>
                                            <div class="timeline-date">
                                                <%= userDetails.get("created_at") != null ? 
                                                    ((String)userDetails.get("created_at")).substring(0, 10) : "N/A" %>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <% if ((Integer)userDetails.get("total_workouts") > 0) { %>
                                    <div class="timeline-item">
                                        <div class="timeline-icon">
                                            <i class="fas fa-dumbbell"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <h4>Started Workout Logging</h4>
                                            <p>User began tracking their fitness activities</p>
                                            <div class="timeline-date">Activity data available</div>
                                        </div>
                                    </div>
                                    <% } %>
                                    
                                    <% if ((Integer)userDetails.get("total_goals") > 0) { %>
                                    <div class="timeline-item">
                                        <div class="timeline-icon">
                                            <i class="fas fa-bullseye"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <h4>Set Fitness Goals</h4>
                                            <p>User created <%= userDetails.get("total_goals") %> fitness goal(s)</p>
                                            <div class="timeline-date">Goals active</div>
                                        </div>
                                    </div>
                                    <% } %>
                                    
                                    <% if ((Integer)userDetails.get("total_workouts") == 0) { %>
                                    <div class="timeline-item">
                                        <div class="timeline-icon" style="background: var(--color-gray-400);">
                                            <i class="fas fa-clock"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <h4>Waiting for First Workout</h4>
                                            <p>User hasn't logged any workouts yet</p>
                                            <div class="timeline-date">Encourage them to start!</div>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div style="display: flex; gap: var(--spacing-md); justify-content: center; margin-top: var(--spacing-xl);">
                            <button class="btn btn-danger" data-user-id="<%= userDetails.get("user_id") %>" data-username="<%= escapeJs((String)userDetails.get("username")) %>" onclick="deleteUser(this.getAttribute('data-user-id'), this.getAttribute('data-username'))">
                                <i class="fas fa-trash"></i>
                                Delete User
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
    function deleteUser(userId, username) {
        if (confirm('Are you sure you want to delete user "' + username + '"? This action cannot be undone.')) {
            window.location.href = '/FitTrack/admin/user-management?action=delete&userId=' + userId;
        }
    }

    // Auto-hide alerts after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                setTimeout(() => {
                    alert.remove();
                }, 300);
            }, 5000);
        });
    });
    </script>
</body>
</html>

