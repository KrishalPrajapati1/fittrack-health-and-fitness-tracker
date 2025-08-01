<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.DietPlan" %>
<%@ page import="model.Meal" %>
<%@ page import="java.util.List" %>
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
    List<Meal> meals = (List<Meal>) request.getAttribute("meals");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    
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
    <title><%= dietPlan != null ? dietPlan.getPlanName() : "Diet Plan" %> - FitTrack Admin</title>
    <link rel="stylesheet" href="../css/admin/admin-style.css">
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css'>
    <style>
        .details-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .plan-overview {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .plan-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
        }

        .plan-title-section h1 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 2.5rem;
        }

        .plan-type-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            text-transform: capitalize;
            font-size: 0.9rem;
        }

        .plan-type-badge.weight_loss { background: #ffe6e6; color: #d63384; }
        .plan-type-badge.weight_gain { background: #e6f3ff; color: #0066cc; }
        .plan-type-badge.muscle_building { background: #e6ffe6; color: #198754; }
        .plan-type-badge.keto { background: #fff3e6; color: #fd7e14; }
        .plan-type-badge.vegan { background: #f0e6ff; color: #6f42c1; }
        .plan-type-badge.maintenance { background: #e6f9ff; color: #20c997; }

        .plan-description {
            color: #666;
            line-height: 1.8;
            margin-bottom: 30px;
            font-size: 1.1rem;
        }

        .plan-stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            transition: transform 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .stat-icon {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #007bff;
        }

        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #666;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .nutrition-breakdown {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .nutrition-title {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .macro-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
        }

        .macro-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            border: 2px solid #e9ecef;
        }

        .macro-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .macro-card.protein .macro-value { color: #28a745; }
        .macro-card.carbs .macro-value { color: #ffc107; }
        .macro-card.fat .macro-value { color: #17a2b8; }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-2px);
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-success:hover {
            background: #218838;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .meals-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
        }

        .section-header h2 {
            margin: 0;
            color: #333;
            font-size: 1.8rem;
        }

        .meals-grid {
            display: grid;
            gap: 20px;
        }

        .meal-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            transition: all 0.3s;
            border: 2px solid transparent;
        }

        .meal-card:hover {
            border-color: #007bff;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .meal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .meal-name {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
        }

        .meal-type {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: capitalize;
        }

        .meal-type.breakfast { background: #fff3cd; color: #856404; }
        .meal-type.lunch { background: #d1ecf1; color: #0c5460; }
        .meal-type.dinner { background: #d4edda; color: #155724; }
        .meal-type.snack { background: #f8d7da; color: #721c24; }

        .meal-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }

        .meal-detail {
            text-align: center;
        }

        .detail-value {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
        }

        .detail-label {
            font-size: 0.85rem;
            color: #666;
            text-transform: uppercase;
        }

        .meal-time {
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 10px;
        }

        .meal-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-small {
            padding: 8px 16px;
            font-size: 0.9rem;
        }

        .empty-meals {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-meals i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }

        .empty-meals h3 {
            color: #495057;
            margin-bottom: 10px;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
        }

        .modal-content {
            background: white;
            margin: 5% auto;
            padding: 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 600px;
            position: relative;
        }

        .modal-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
        }

        .modal-header h2 {
            margin: 0;
            color: #333;
        }

        .close {
            position: absolute;
            right: 30px;
            top: 30px;
            font-size: 28px;
            font-weight: bold;
            color: #999;
            cursor: pointer;
            transition: color 0.3s;
        }

        .close:hover {
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #007bff;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        @media (max-width: 768px) {
            .plan-header {
                flex-direction: column;
                gap: 20px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .meal-header {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
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
        <div class="details-container">
            <!-- Breadcrumb -->
            <nav class="breadcrumb">
                <a href="diet-plan-management">Diet Plans</a>
                <span>/</span>
                <span><%= dietPlan.getPlanName() %></span>
            </nav>

            <!-- Alert Messages -->
            <% if (success != null) { %>
                <div class="alert alert-success">
                    <i class="fi fi-rr-check-circle"></i>
                    <%= success %>
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <i class="fi fi-rr-cross-circle"></i>
                    <%= error %>
                </div>
            <% } %>

            <!-- Plan Overview -->
            <div class="plan-overview">
                <div class="plan-header">
                    <div class="plan-title-section">
                        <h1><%= dietPlan.getPlanName() %></h1>
                        <span class="plan-type-badge <%= dietPlan.getPlanType() %>">
                            <%= dietPlan.getPlanType().replace("_", " ") %>
                        </span>
                    </div>
                    <div class="plan-actions">
                        <span style="color: #666;">Difficulty: <strong style="text-transform: capitalize;"><%= dietPlan.getDifficultyLevel() %></strong></span>
                    </div>
                </div>

                <% if (dietPlan.getDescription() != null && !dietPlan.getDescription().isEmpty()) { %>
                    <p class="plan-description"><%= dietPlan.getDescription() %></p>
                <% } %>

                <!-- Plan Statistics -->
                <div class="plan-stats-grid">
                    <div class="stat-card">
                        <i class="fi fi-rr-flame stat-icon"></i>
                        <div class="stat-value"><%= dietPlan.getTotalCalories() %></div>
                        <div class="stat-label">Total Calories</div>
                    </div>
                    <div class="stat-card">
                        <i class="fi fi-rr-calendar stat-icon"></i>
                        <div class="stat-value"><%= dietPlan.getDurationDays() %></div>
                        <div class="stat-label">Duration (Days)</div>
                    </div>
                    <div class="stat-card">
                        <i class="fi fi-rr-apple stat-icon"></i>
                        <div class="stat-value"><%= meals != null ? meals.size() : 0 %></div>
                        <div class="stat-label">Total Meals</div>
                    </div>
                </div>

                <!-- Nutrition Breakdown -->
                <div class="nutrition-breakdown">
                    <h3 class="nutrition-title">
                        <i class="fi fi-rr-chart-pie"></i>
                        Macronutrient Breakdown
                    </h3>
                    <div class="macro-grid">
                        <div class="macro-card protein">
                            <div class="macro-value"><%= Math.round(dietPlan.getTotalProtein()) %>g</div>
                            <div class="stat-label">Protein</div>
                        </div>
                        <div class="macro-card carbs">
                            <div class="macro-value"><%= Math.round(dietPlan.getTotalCarbs()) %>g</div>
                            <div class="stat-label">Carbohydrates</div>
                        </div>
                        <div class="macro-card fat">
                            <div class="macro-value"><%= Math.round(dietPlan.getTotalFat()) %>g</div>
                            <div class="stat-label">Fat</div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="diet-plan-management?action=edit&planId=<%= dietPlan.getDietPlanId() %>" 
                       class="btn btn-primary">
                        <i class="fi fi-rr-edit"></i>
                        Edit Plan
                    </a>
                    <button onclick="openAddMealModal()" class="btn btn-success">
                        <i class="fi fi-rr-plus"></i>
                        Add Meal
                    </button>
                    <a href="diet-plan-management" class="btn btn-secondary">
                        <i class="fi fi-rr-arrow-left"></i>
                        Back to Plans
                    </a>
                </div>
            </div>

            <!-- Meals Section -->
            <div class="meals-section">
                <div class="section-header">
                    <h2>Meals & Nutrition</h2>
                    <button onclick="openAddMealModal()" class="btn btn-success">
                        <i class="fi fi-rr-plus"></i>
                        Add Meal
                    </button>
                </div>

                <% if (meals != null && !meals.isEmpty()) { %>
                    <div class="meals-grid">
                        <% for (Meal meal : meals) { %>
                            <div class="meal-card">
                                <div class="meal-header">
                                    <h3 class="meal-name"><%= meal.getMealName() %></h3>
                                    <span class="meal-type <%= meal.getMealType().toLowerCase() %>">
                                        <%= meal.getMealType() %>
                                    </span>
                                </div>

                                <% if (meal.getMealTime() != null) { %>
                                    <p class="meal-time">
                                        <i class="fi fi-rr-clock"></i> <%= meal.getMealTime() %>
                                    </p>
                                <% } %>

                                <div class="meal-details">
                                    <div class="meal-detail">
                                        <div class="detail-value"><%= meal.getCalories() %></div>
                                        <div class="detail-label">Calories</div>
                                    </div>
                                    <div class="meal-detail">
                                        <div class="detail-value"><%= Math.round(meal.getProtein()) %>g</div>
                                        <div class="detail-label">Protein</div>
                                    </div>
                                    <div class="meal-detail">
                                        <div class="detail-value"><%= Math.round(meal.getCarbs()) %>g</div>
                                        <div class="detail-label">Carbs</div>
                                    </div>
                                    <div class="meal-detail">
                                        <div class="detail-value"><%= Math.round(meal.getFat()) %>g</div>
                                        <div class="detail-label">Fat</div>
                                    </div>
                                </div>

                                <div class="meal-actions">
                                    <button onclick="editMeal(<%= meal.getMealId() %>)" class="btn btn-small btn-primary">
                                        <i class="fi fi-rr-edit"></i> Edit
                                    </button>
                                    <button onclick="deleteMeal(<%= meal.getMealId() %>, '<%= meal.getMealName() %>')" 
                                            class="btn btn-small btn-secondary">
                                        <i class="fi fi-rr-trash"></i> Delete
                                    </button>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-meals">
                        <i class="fi fi-rr-apple"></i>
                        <h3>No Meals Added Yet</h3>
                        <p>Start building this diet plan by adding meals</p>
                        <button onclick="openAddMealModal()" class="btn btn-success">
                            <i class="fi fi-rr-plus"></i>
                            Add Your First Meal
                        </button>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <!-- Add Meal Modal -->
    <div id="addMealModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeAddMealModal()">&times;</span>
            <div class="modal-header">
                <h2>Add New Meal</h2>
            </div>
            <form method="post" action="diet-plan-management">
                <input type="hidden" name="action" value="add_meal">
                <input type="hidden" name="diet_plan_id" value="<%= dietPlan.getDietPlanId() %>">
                
                <div class="form-group">
                    <label for="meal_name">Meal Name <span style="color: #dc3545;">*</span></label>
                    <input type="text" id="meal_name" name="meal_name" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="meal_type">Meal Type <span style="color: #dc3545;">*</span></label>
                        <select id="meal_type" name="meal_type" required>
                            <option value="breakfast">Breakfast</option>
                            <option value="lunch">Lunch</option>
                            <option value="dinner">Dinner</option>
                            <option value="snack">Snack</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="meal_time">Meal Time</label>
                        <input type="text" id="meal_time" name="meal_time" placeholder="e.g., 7:00 AM">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="calories">Calories <span style="color: #dc3545;">*</span></label>
                        <input type="number" id="calories" name="calories" required min="0">
                    </div>

                    <div class="form-group">
                        <label for="serving_size">Serving Size</label>
                        <input type="text" id="serving_size" name="serving_size" placeholder="e.g., 1 cup">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="protein">Protein (g) <span style="color: #dc3545;">*</span></label>
                        <input type="number" id="protein" name="protein" required min="0" step="0.1">
                    </div>

                    <div class="form-group">
                        <label for="carbs">Carbs (g) <span style="color: #dc3545;">*</span></label>
                        <input type="number" id="carbs" name="carbs" required min="0" step="0.1">
                    </div>

                    <div class="form-group">
                        <label for="fat">Fat (g) <span style="color: #dc3545;">*</span></label>
                        <input type="number" id="fat" name="fat" required min="0" step="0.1">
                    </div>
                </div>

                <div class="form-group">
                    <label for="ingredients">Ingredients</label>
                    <textarea id="ingredients" name="ingredients" rows="3" 
                              placeholder="List the ingredients..."></textarea>
                </div>

                <div class="form-group">
                    <label for="instructions">Preparation Instructions</label>
                    <textarea id="instructions" name="instructions" rows="3" 
                              placeholder="How to prepare this meal..."></textarea>
                </div>

                <div class="form-group">
                    <label for="preparation_time">Preparation Time (minutes)</label>
                    <input type="number" id="preparation_time" name="preparation_time" min="0">
                </div>

                <div class="action-buttons">
                    <button type="submit" class="btn btn-success">
                        <i class="fi fi-rr-check"></i> Add Meal
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="closeAddMealModal()">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Modal functions
        function openAddMealModal() {
            document.getElementById('addMealModal').style.display = 'block';
        }

        function closeAddMealModal() {
            document.getElementById('addMealModal').style.display = 'none';
        }

        // Delete meal function
        function deleteMeal(mealId, mealName) {
            if (confirm('Are you sure you want to delete "' + mealName + '"?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'diet-plan-management';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete_meal';
                
                const mealIdInput = document.createElement('input');
                mealIdInput.type = 'hidden';
                mealIdInput.name = 'meal_id';
                mealIdInput.value = mealId;
                
                const planIdInput = document.createElement('input');
                planIdInput.type = 'hidden';
                planIdInput.name = 'diet_plan_id';
                planIdInput.value = '<%= dietPlan.getDietPlanId() %>';
                
                form.appendChild(actionInput);
                form.appendChild(mealIdInput);
                form.appendChild(planIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Edit meal function
        function editMeal(mealId) {
            // Redirect to edit meal page or open edit modal
            alert('Edit meal functionality to be implemented');
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('addMealModal');
            if (event.target == modal) {
                closeAddMealModal();
            }
        }
    </script>
</body>
</html>
	