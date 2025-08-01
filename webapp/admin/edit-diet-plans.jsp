<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.DietPlan" %>
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

    DietPlan dietPlan = (DietPlan) request.getAttribute("dietPlan");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    
    // Also check URL parameters for messages
    if (error == null) {
        error = request.getParameter("error");
    }
    if (success == null) {
        success = request.getParameter("success");
    }
    
    if (dietPlan == null) {
        response.sendRedirect("diet-plan-management");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Diet Plan - <%= dietPlan.getPlanName() %> - FitTrack Admin</title>
    <link rel="stylesheet" href="../css/admin/admin-style.css">
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css'>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            min-height: 100vh;
            color: #333;
        }

        .admin-layout {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Enhanced Header */
        .admin-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .admin-header .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 70px;
        }

        .admin-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.5rem;
            font-weight: 700;
            color: #dc3545;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .admin-brand:hover {
            transform: translateY(-1px);
        }

        .admin-brand i {
            font-size: 1.8rem;
        }

        .admin-nav {
            display: flex;
            gap: 8px;
        }

        .admin-nav a {
            padding: 12px 20px;
            border-radius: 25px;
            text-decoration: none;
            color: #666;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .admin-nav a:hover,
        .admin-nav a.active {
            color: #dc3545;
            background: rgba(220, 53, 69, 0.1);
            transform: translateY(-1px);
        }

        .admin-user {
            display: flex;
            align-items: center;
            gap: 16px;
            color: #666;
            font-weight: 500;
        }

        .logout-link {
            padding: 10px;
            border-radius: 50%;
            color: #dc3545;
            text-decoration: none;
            transition: all 0.3s ease;
            background: rgba(220, 53, 69, 0.1);
        }

        .logout-link:hover {
            background: rgba(220, 53, 69, 0.2);
            transform: rotate(10deg);
        }

        /* Main Content */
        .admin-main {
            flex: 1;
            padding: 40px 0;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
        }

        /* Enhanced Breadcrumb */
        .breadcrumb {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            padding: 16px 24px;
            border-radius: 15px;
            margin-bottom: 32px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .breadcrumb a {
            color: #dc3545;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .breadcrumb a:hover {
            color: #c82333;
        }

        .breadcrumb span {
            color: #999;
            margin: 0 12px;
        }

        /* Enhanced Alert Messages */
        .alert {
            padding: 20px 24px;
            border-radius: 15px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            border: none;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(20px);
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(248, 215, 218, 0.9), rgba(245, 198, 203, 0.9));
            color: #721c24;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(212, 237, 218, 0.9), rgba(195, 230, 203, 0.9));
            color: #155724;
        }

        .alert i {
            font-size: 1.3rem;
        }

        /* Enhanced Form Container */
        .edit-form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
        }

        .edit-form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #dc3545, #e74c3c, #c0392b);
        }

        /* Enhanced Form Header */
        .form-header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 24px;
            border-bottom: 2px solid rgba(233, 236, 239, 0.5);
            position: relative;
        }

        .form-header h1 {
            color: #333;
            margin-bottom: 12px;
            font-size: 2.5rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 16px;
        }

        .form-header h1 i {
            color: #dc3545;
            font-size: 2.2rem;
        }

        .form-header p {
            color: #666;
            font-size: 1.2rem;
            font-weight: 400;
        }

        /* Enhanced Current Values Display */
        .current-values {
            background: linear-gradient(135deg, rgba(248, 249, 250, 0.9), rgba(233, 236, 239, 0.5));
            border-radius: 20px;
            padding: 32px;
            margin-bottom: 40px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            position: relative;
            overflow: hidden;
        }

        .current-values::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: linear-gradient(180deg, #dc3545, #e74c3c);
        }

        .current-values h3 {
            margin: 0 0 24px 0;
            color: #333;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.4rem;
            font-weight: 600;
        }

        .current-values h3 i {
            color: #007bff;
        }

        .current-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 20px;
        }

        .current-stat {
            text-align: center;
            background: rgba(255, 255, 255, 0.9);
            padding: 24px 16px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .current-stat::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #007bff, #667eea);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .current-stat:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .current-stat:hover::before {
            transform: scaleX(1);
        }

        .current-stat-value {
            font-size: 1.8rem;
            font-weight: 700;
            color: #007bff;
            margin-bottom: 8px;
        }

        .current-stat-label {
            font-size: 0.9rem;
            color: #666;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Enhanced Type Indicators */
        .type-indicator {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: capitalize;
            display: inline-block;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .type-indicator.weight_loss { 
            background: linear-gradient(135deg, #ffe6e6, #ffcccc); 
            color: #d63384; 
            border-color: rgba(214, 51, 132, 0.2);
        }
        .type-indicator.weight_gain { 
            background: linear-gradient(135deg, #e6f3ff, #cce7ff); 
            color: #0066cc; 
            border-color: rgba(0, 102, 204, 0.2);
        }
        .type-indicator.muscle_building { 
            background: linear-gradient(135deg, #e6ffe6, #ccffcc); 
            color: #198754; 
            border-color: rgba(25, 135, 84, 0.2);
        }
        .type-indicator.keto { 
            background: linear-gradient(135deg, #fff3e6, #ffe6cc); 
            color: #fd7e14; 
            border-color: rgba(253, 126, 20, 0.2);
        }
        .type-indicator.vegan { 
            background: linear-gradient(135deg, #f0e6ff, #e6ccff); 
            color: #6f42c1; 
            border-color: rgba(111, 66, 193, 0.2);
        }
        .type-indicator.maintenance { 
            background: linear-gradient(135deg, #e6f9ff, #ccf2ff); 
            color: #20c997; 
            border-color: rgba(32, 201, 151, 0.2);
        }

        /* Enhanced Form Sections */
        .form-section {
            margin-bottom: 48px;
        }

        .section-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 2px solid rgba(233, 236, 239, 0.5);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: #007bff;
            font-size: 1.2rem;
        }

        /* Enhanced Form Groups */
        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #333;
            font-size: 1rem;
        }

        .form-group label .required {
            color: #dc3545;
            margin-left: 4px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid rgba(233, 236, 239, 0.8);
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 4px rgba(0, 123, 255, 0.1);
            transform: translateY(-1px);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 140px;
            font-family: inherit;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
        }

        .nutrition-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 24px;
        }

        .nutrition-group {
            position: relative;
        }

        .nutrition-group input {
            padding-right: 60px;
        }

        .nutrition-unit {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #007bff;
            font-weight: 600;
            pointer-events: none;
            background: rgba(0, 123, 255, 0.1);
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 0.85rem;
        }

        .input-help {
            font-size: 0.85rem;
            color: #666;
            margin-top: 6px;
            font-style: italic;
        }

        /* Enhanced Buttons */
        .form-actions {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 48px;
            padding-top: 32px;
            border-top: 2px solid rgba(233, 236, 239, 0.5);
        }

        .btn {
            padding: 16px 32px;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            min-width: 180px;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #545b62);
            color: white;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.4);
        }

        /* Enhanced Validation Messages */
        .validation-message {
            background: linear-gradient(135deg, rgba(255, 243, 205, 0.9), rgba(255, 234, 167, 0.9));
            border: 1px solid rgba(255, 193, 7, 0.3);
            color: #856404;
            padding: 16px 20px;
            border-radius: 12px;
            margin-top: 16px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            backdrop-filter: blur(10px);
        }

        .validation-message i {
            color: #ffc107;
            font-size: 1.2rem;
            margin-top: 2px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 0 16px;
            }

            .edit-form-container {
                margin: 16px;
                padding: 24px;
                border-radius: 16px;
            }
            
            .form-header h1 {
                font-size: 2rem;
                flex-direction: column;
                gap: 8px;
            }
            
            .nutrition-grid,
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .current-stats {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .form-actions {
                flex-direction: column;
            }

            .admin-nav {
                display: none;
            }

            .admin-header .container {
                padding: 0 16px;
            }
        }

        @media (max-width: 480px) {
            .form-header h1 {
                font-size: 1.6rem;
            }
            
            .current-stats {
                grid-template-columns: 1fr;
            }

            .btn {
                min-width: 100%;
            }
        }

        /* Loading Animation */
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .fi-rr-spinner {
            animation: spin 1s linear infinite;
        }

        /* Smooth Transitions */
        * {
            transition: color 0.3s ease, background-color 0.3s ease, border-color 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
        }

        /* Focus States for Accessibility */
        .btn:focus,
        input:focus,
        select:focus,
        textarea:focus {
            outline: 2px solid #007bff;
            outline-offset: 2px;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <!-- Header -->
        <header class="admin-header">
            <div class="container">
                <a href="admin-dashboard.jsp" class="admin-brand">
                    <i class="fi fi-rr-dumbbell"></i>
                    FitTrack Admin
                </a>
                <nav class="admin-nav">
                    <a href="admin-dashboard.jsp">Dashboard</a>
                    <a href="user-management">Users</a>
                    <a href="workout-management">Workouts</a>
                    <a href="diet-plan-management" class="active">Diet Plans</a>
                </nav>
                <div class="admin-user">
                    <span>Admin</span>
                    <a href="../logout" class="logout-link">
                        <i class="fi fi-rr-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="admin-main">
            <div class="container">
                <!-- Breadcrumb -->
                <nav class="breadcrumb">
                    <a href="diet-plan-management">Diet Plans</a>
                    <span>/</span>
                    <a href="diet-plan-management?action=view&planId=<%= dietPlan.getDietPlanId() %>">
                        <%= dietPlan.getPlanName() %>
                    </a>
                    <span>/</span>
                    <span>Edit</span>
                </nav>

                <!-- Alert Messages -->
                <% if (error != null) { %>
                    <div class="alert alert-error">
                        <i class="fi fi-rr-cross-circle"></i>
                        <%= error %>
                    </div>
                <% } %>

                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <i class="fi fi-rr-check-circle"></i>
                        <%= success %>
                    </div>
                <% } %>

                <!-- Edit Form -->
                <div class="edit-form-container">
                    <div class="form-header">
                        <h1>
                            <i class="fi fi-rr-edit"></i> 
                            Edit Diet Plan
                        </h1>
                        <p>Update the details and nutrition information for your diet plan</p>
                    </div>

                    <!-- Current Values Display -->
                    <div class="current-values">
                        <h3>
                            <i class="fi fi-rr-info"></i> 
                            Current Plan Overview
                        </h3>
                        <div class="current-stats">
                            <div class="current-stat">
                                <div class="current-stat-value"><%= dietPlan.getTotalCalories() %></div>
                                <div class="current-stat-label">Calories</div>
                            </div>
                            <div class="current-stat">
                                <div class="current-stat-value"><%= Math.round(dietPlan.getTotalProtein()) %>g</div>
                                <div class="current-stat-label">Protein</div>
                            </div>
                            <div class="current-stat">
                                <div class="current-stat-value"><%= Math.round(dietPlan.getTotalCarbs()) %>g</div>
                                <div class="current-stat-label">Carbs</div>
                            </div>
                            <div class="current-stat">
                                <div class="current-stat-value"><%= Math.round(dietPlan.getTotalFat()) %>g</div>
                                <div class="current-stat-label">Fat</div>
                            </div>
                            <div class="current-stat">
                                <div class="current-stat-value"><%= dietPlan.getDurationDays() %></div>
                                <div class="current-stat-label">Days</div>
                            </div>
                            <div class="current-stat">
                                <div class="current-stat-value">
                                    <span class="type-indicator <%= dietPlan.getPlanType() %>">
                                        <%= dietPlan.getPlanType().replace("_", " ") %>
                                    </span>
                                </div>
                                <div class="current-stat-label">Type</div>
                            </div>
                        </div>
                    </div>

                    <form method="post" action="diet-plan-management" id="editPlanForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="diet_plan_id" value="<%= dietPlan.getDietPlanId() %>">
                        
                        <!-- Basic Information Section -->
                        <div class="form-section">
                            <h2 class="section-title">
                                <i class="fi fi-rr-document"></i>
                                Basic Information
                            </h2>
                            
                            <div class="form-group">
                                <label for="plan_name">
                                    Plan Name <span class="required">*</span>
                                </label>
                                <input type="text" id="plan_name" name="plan_name" 
                                       value="<%= dietPlan.getPlanName() %>" 
                                       placeholder="Enter a descriptive name for the diet plan"
                                       required>
                                <div class="input-help">Choose a clear, descriptive name that users will easily understand</div>
                            </div>

                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea id="description" name="description" 
                                          placeholder="Provide a detailed description of this diet plan, its goals, and who it's designed for..."><%= dietPlan.getDescription() != null ? dietPlan.getDescription() : "" %></textarea>
                                <div class="input-help">Explain the purpose and benefits of this diet plan</div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="plan_type">
                                        Plan Type <span class="required">*</span>
                                    </label>
                                    <select id="plan_type" name="plan_type" required>
                                        <option value="">Select Plan Type</option>
                                        <option value="weight_loss" <%= "weight_loss".equals(dietPlan.getPlanType()) ? "selected" : "" %>>Weight Loss</option>
                                        <option value="weight_gain" <%= "weight_gain".equals(dietPlan.getPlanType()) ? "selected" : "" %>>Weight Gain</option>
                                        <option value="muscle_building" <%= "muscle_building".equals(dietPlan.getPlanType()) ? "selected" : "" %>>Muscle Building</option>
                                        <option value="keto" <%= "keto".equals(dietPlan.getPlanType()) ? "selected" : "" %>>Keto</option>
                                        <option value="vegan" <%= "vegan".equals(dietPlan.getPlanType()) ? "selected" : "" %>>Vegan</option>
                                        <option value="maintenance" <%= "maintenance".equals(dietPlan.getPlanType()) ? "selected" : "" %>>Maintenance</option>
                                    </select>
                                    <div class="input-help">Choose the primary goal of this diet plan</div>
                                </div>

                                <div class="form-group">
                                    <label for="difficulty_level">
                                        Difficulty Level <span class="required">*</span>
                                    </label>
                                    <select id="difficulty_level" name="difficulty_level" required>
                                        <option value="">Select Difficulty</option>
                                        <option value="beginner" <%= "beginner".equals(dietPlan.getDifficultyLevel()) ? "selected" : "" %>>Beginner</option>
                                        <option value="intermediate" <%= "intermediate".equals(dietPlan.getDifficultyLevel()) ? "selected" : "" %>>Intermediate</option>
                                        <option value="advanced" <%= "advanced".equals(dietPlan.getDifficultyLevel()) ? "selected" : "" %>>Advanced</option>
                                    </select>
                                    <div class="input-help">How challenging is this plan to follow?</div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="duration_days">
                                    Duration (Days) <span class="required">*</span>
                                </label>
                                <input type="number" id="duration_days" name="duration_days" 
                                       min="1" max="365" value="<%= dietPlan.getDurationDays() %>" 
                                       placeholder="30" required>
                                <div class="input-help">How many days should this plan be followed?</div>
                            </div>
                        </div>

                        <!-- Nutrition Information Section -->
                        <div class="form-section">
                            <h2 class="section-title">
                                <i class="fi fi-rr-apple-whole"></i>
                                Nutrition Targets
                            </h2>
                            
                            <div class="form-group">
                                <label for="total_calories">
                                    Daily Calories <span class="required">*</span>
                                </label>
                                <div class="nutrition-group">
                                    <input type="number" id="total_calories" name="total_calories" 
                                           min="500" max="5000" value="<%= dietPlan.getTotalCalories() %>" 
                                           placeholder="2000" required>
                                    <span class="nutrition-unit">kcal</span>
                                </div>
                                <div class="input-help">Target daily caloric intake</div>
                            </div>

                            <div class="nutrition-grid">
                                <div class="form-group">
                                    <label for="total_protein">
                                        Protein (g) <span class="required">*</span>
                                    </label>
                                    <div class="nutrition-group">
                                        <input type="number" id="total_protein" name="total_protein" 
                                               min="0" step="0.1" value="<%= dietPlan.getTotalProtein() %>" 
                                               placeholder="150.0" required>
                                        <span class="nutrition-unit">g</span>
                                    </div>
                                    <div class="input-help">Daily protein target in grams</div>
                                </div>

                                <div class="form-group">
                                    <label for="total_carbs">
                                        Carbs (g) <span class="required">*</span>
                                    </label>
                                    <div class="nutrition-group">
                                        <input type="number" id="total_carbs" name="total_carbs" 
                                               min="0" step="0.1" value="<%= dietPlan.getTotalCarbs() %>" 
                                               placeholder="200.0" required>
                                        <span class="nutrition-unit">g</span>
                                    </div>
                                    <div class="input-help">Daily carbohydrate target in grams</div>
                                </div>

                                <div class="form-group">
                                    <label for="total_fat">
                                        Fat (g) <span class="required">*</span>
                                    </label>
                                    <div class="nutrition-group">
                                        <input type="number" id="total_fat" name="total_fat" 
                                               min="0" step="0.1" value="<%= dietPlan.getTotalFat() %>" 
                                               placeholder="65.0" required>
                                        <span class="nutrition-unit">g</span>
                                    </div>
                                    <div class="input-help">Daily fat target in grams</div>
                                </div>
                            </div>

                            <!-- Macro validation message will appear here -->
                            <div id="macro-validation-container"></div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <a href="diet-plan-management?action=view&planId=<%= dietPlan.getDietPlanId() %>" 
                               class="btn btn-secondary">
                                <i class="fi fi-rr-cross"></i>
                                Cancel Changes
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fi fi-rr-disk"></i>
                                Update Diet Plan
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Form change tracking
        let formChanged = false;
        let originalFormData = {};

        // Store original form data
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('editPlanForm');
            const formData = new FormData(form);
            for (let [key, value] of formData.entries()) {
                originalFormData[key] = value;
            }
            
            // Track form changes
            const inputs = form.querySelectorAll('input, select, textarea');
            inputs.forEach(input => {
                input.addEventListener('change', function() {
                    formChanged = true;
                    validateNutrition();
                });
                
                if (input.type !== 'submit' && input.type !== 'hidden') {
                    input.addEventListener('input', function() {
                        formChanged = true;
                        validateNutrition();
                    });
                }
            });
        });

        // Warn before leaving with unsaved changes
        window.addEventListener('beforeunload', function(e) {
            if (formChanged) {
                const message = 'You have unsaved changes. Are you sure you want to leave?';
                e.returnValue = message;
                return message;
            }
        });

        // Enhanced nutrition validation
        function validateNutrition() {
            clearTimeout(window.nutritionValidationTimer);
            window.nutritionValidationTimer = setTimeout(() => {
                const calories = parseInt(document.getElementById('total_calories').value) || 0;
                const protein = parseFloat(document.getElementById('total_protein').value) || 0;
                const carbs = parseFloat(document.getElementById('total_carbs').value) || 0;
                const fat = parseFloat(document.getElementById('total_fat').value) || 0;
                
                const container = document.getElementById('macro-validation-container');
                container.innerHTML = '';
                
                // Calculate calories from macros (Protein: 4 cal/g, Carbs: 4 cal/g, Fat: 9 cal/g)
                const macroCalories = (protein * 4) + (carbs * 4) + (fat * 9);
                const calorieDifference = Math.abs(calories - macroCalories);
                const percentageDiff = calories > 0 ? (calorieDifference / calories) * 100 : 0;
                
                const warnings = [];
                
                if (percentageDiff > 10) {
                    warnings.push(`Macro calories (${Math.round(macroCalories)}) don't match target calories (${calories}). Difference: ${Math.round(calorieDifference)} calories.`);
                }
                
                if (protein < 0.8) {
                    warnings.push('Protein seems very low. Consider at least 0.8g per kg of body weight.');
                }
                
                if (fat < 20) {
                    warnings.push('Fat intake seems low. Consider at least 20-25% of total calories from healthy fats.');
                }
                
                if (warnings.length > 0) {
                    warnings.forEach(warning => {
                        const warningMsg = document.createElement('div');
                        warningMsg.className = 'validation-message';
                        warningMsg.innerHTML = `
                            <i class="fi fi-rr-exclamation-triangle"></i>
                            <div><strong>Nutrition Warning:</strong> ${warning}</div>
                        `;
                        container.appendChild(warningMsg);
                    });
                }
            }, 500); // Debounce validation
        }

        // Enhanced form validation on submit
        document.getElementById('editPlanForm').addEventListener('submit', function(e) {
            const calories = parseInt(document.getElementById('total_calories').value);
            const protein = parseFloat(document.getElementById('total_protein').value);
            const carbs = parseFloat(document.getElementById('total_carbs').value);
            const fat = parseFloat(document.getElementById('total_fat').value);
            const planName = document.getElementById('plan_name').value.trim();
            
            // Basic validation
            if (!planName) {
                alert('Please enter a plan name');
                document.getElementById('plan_name').focus();
                e.preventDefault();
                return;
            }
            
            if (calories < 500 || calories > 5000) {
                alert('Calories should be between 500 and 5000');
                document.getElementById('total_calories').focus();
                e.preventDefault();
                return;
            }
            
            // Calculate macro calories
            const macroCalories = (protein * 4) + (carbs * 4) + (fat * 9);
            const calorieDifference = Math.abs(calories - macroCalories);
            const percentageDiff = (calorieDifference / calories) * 100;
            
            // Warn about significant macro/calorie mismatch
            if (percentageDiff > 15) {
                if (!confirm(`The macro breakdown (${Math.round(macroCalories)} calories) differs significantly from your target calories (${calories}). Are you sure this is correct?`)) {
                    e.preventDefault();
                    return;
                }
            }
            
            // Show enhanced loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalContent = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fi fi-rr-spinner"></i> Updating Plan...';
            
            // Add loading animation to button
            submitBtn.style.background = 'linear-gradient(135deg, #6c757d, #545b62)';
            
            // Mark form as not changed (successful submission)
            formChanged = false;
            
            
            setTimeout(() => {
                if (submitBtn.disabled) {
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalContent;
                    submitBtn.style.background = '';
                }
            }, 10000);
        });

        // Enhanced auto-save draft functionality
        function saveDraft() {
            const formData = {
                plan_name: document.getElementById('plan_name').value,
                description: document.getElementById('description').value,
                plan_type: document.getElementById('plan_type').value,
                difficulty_level: document.getElementById('difficulty_level').value,
                duration_days: document.getElementById('duration_days').value,
                total_calories: document.getElementById('total_calories').value,
                total_protein: document.getElementById('total_protein').value,
                total_carbs: document.getElementById('total_carbs').value,
                total_fat: document.getElementById('total_fat').value,
                timestamp: Date.now()
            };
            
            try {
                sessionStorage.setItem('dietPlanDraft_<%= dietPlan.getDietPlanId() %>', JSON.stringify(formData));
                
                // Show subtle save indicator
                const saveIndicator = document.createElement('div');
                saveIndicator.innerHTML = '✓ Draft saved';
                saveIndicator.style.cssText = `
                    position: fixed;
                    top: 100px;
                    right: 20px;
                    background: linear-gradient(135deg, #28a745, #20c997);
                    color: white;
                    padding: 8px 16px;
                    border-radius: 20px;
                    font-size: 0.9rem;
                    font-weight: 500;
                    z-index: 1000;
                    opacity: 0;
                    transform: translateX(100px);
                    transition: all 0.3s ease;
                `;
                
                document.body.appendChild(saveIndicator);
                
                // Animate in
                setTimeout(() => {
                    saveIndicator.style.opacity = '1';
                    saveIndicator.style.transform = 'translateX(0)';
                }, 100);
                
                // Animate out and remove
                setTimeout(() => {
                    saveIndicator.style.opacity = '0';
                    saveIndicator.style.transform = 'translateX(100px)';
                    setTimeout(() => {
                        document.body.removeChild(saveIndicator);
                    }, 300);
                }, 2000);
                
            } catch (e) {
                console.warn('Could not save draft:', e);
            }
        }

        // Auto-save every 30 seconds if form has changes
        setInterval(() => {
            if (formChanged) {
                saveDraft();
            }
        }, 30000);

        // Initial nutrition validation
        document.addEventListener('DOMContentLoaded', function() {
            validateNutrition();
            
            // Add smooth animations to form elements
            const formGroups = document.querySelectorAll('.form-group');
            formGroups.forEach((group, index) => {
                group.style.opacity = '0';
                group.style.transform = 'translateY(20px)';
                group.style.animation = `slideInUp 0.6s ease forwards ${index * 0.1}s`;
            });
            
            // Add keyframe animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes slideInUp {
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
            `;
            document.head.appendChild(style);
        });

        // Enhanced input animations
        document.querySelectorAll('input, select, textarea').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentNode.classList.add('focused');
            });
            
            input.addEventListener('blur', function() {
                this.parentNode.classList.remove('focused');
            });
        });

        // Add smooth scroll behavior for validation errors
        function scrollToError(elementId) {
            const element = document.getElementById(elementId);
            if (element) {
                element.scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });
                element.focus();
            }
        }
    </script>
</body>
</html>
