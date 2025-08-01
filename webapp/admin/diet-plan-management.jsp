<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Plan Management - FitTrack Admin</title>
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css'>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
            min-height: 100vh;
        }

        .admin-header {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 1rem 2rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            list-style: none;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: background 0.3s ease;
        }

        .nav-links a:hover,
        .nav-links a.active {
            background: rgba(255, 255, 255, 0.2);
        }

        .admin-info {
            color: white;
            font-weight: 500;
        }

        .main-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.1rem;
        }

        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .overview-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1.5rem;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .overview-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .overview-label {
            color: #666;
            font-weight: 500;
        }

        .actions-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 1rem 1.5rem;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .add-plan-btn {
            background: linear-gradient(135deg, #dc2626, #991b1b);
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(220, 38, 38, 0.3);
        }

        .add-plan-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(220, 38, 38, 0.4);
        }

        .diet-plan-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }

        .diet-plan-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }

        .diet-plan-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }

        .plan-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .plan-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
            margin: 0;
        }

        .plan-type {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: capitalize;
        }

        .plan-type.weight_loss { 
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            color: white;
        }
        .plan-type.weight_gain { 
            background: linear-gradient(135deg, #4ecdc4, #44a08d);
            color: white;
        }
        .plan-type.muscle_building { 
            background: linear-gradient(135deg, #45b7d1, #96c93d);
            color: white;
        }
        .plan-type.maintenance { 
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: white;
        }
        .plan-type.keto { 
            background: linear-gradient(135deg, #ffecd2, #fcb69f);
            color: #333;
        }
        .plan-type.vegan { 
            background: linear-gradient(135deg, #a8edea, #fed6e3);
            color: #333;
        }

        .plan-description {
            color: #666;
            margin-bottom: 1rem;
            line-height: 1.5;
        }

        .plan-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .stat-item {
            text-align: center;
            padding: 0.75rem;
            background: rgba(220, 38, 38, 0.1);
            border-radius: 8px;
        }

        .stat-value {
            font-size: 1.2rem;
            font-weight: 600;
            color: #dc2626;
        }

        .stat-label {
            font-size: 0.8rem;
            color: #666;
            margin-top: 2px;
        }

        .plan-actions {
            display: flex;
            gap: 0.5rem;
            justify-content: flex-end;
        }

        .btn-small {
            padding: 8px 12px;
            font-size: 0.8rem;
            border-radius: 6px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .btn-view {
            background: #dc2626;
            color: white;
        }

        .btn-edit {
            background: #ffc107;
            color: #333;
        }

        .btn-delete {
            background: #dc3545;
            color: white;
        }

        .btn-small:hover {
            transform: translateY(-2px);
            opacity: 0.9;
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
            background-color: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background: white;
            margin: 3% auto;
            padding: 0;
            border-radius: 16px;
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease-out;
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .modal-header {
            background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
            color: white;
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .close {
            font-size: 2rem;
            font-weight: bold;
            cursor: pointer;
            background: none;
            border: none;
            color: white;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background 0.3s ease;
        }

        .close:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .modal-body {
            padding: 2rem;
            max-height: 60vh;
            overflow-y: auto;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #333;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #dc2626;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            padding: 1.5rem;
            background: #f8f9fa;
            border-top: 1px solid #e1e5e9;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #dc2626, #991b1b);
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: rgba(255, 255, 255, 0.8);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            font-size: 1rem;
            opacity: 0.8;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            font-weight: 500;
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

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                padding: 1rem;
            }

            .page-title {
                font-size: 2rem;
            }

            .diet-plan-grid {
                grid-template-columns: 1fr;
            }

            .modal-content {
                width: 95%;
                margin: 5% auto;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .actions-bar {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="admin-header">
        <div class="header-content">
            <a href="admin-dashboard.jsp" class="logo">FitTrack Admin</a>
            <nav>
                <ul class="nav-links">
                    <li><a href="admin-dashboard.jsp">Dashboard</a></li>
                    <li><a href="user-management">Users</a></li>
                    <li><a href="workout-management">Workouts</a></li>
                    <li><a href="diet-plan-management" class="active">Diet Plans</a></li>
                </ul>
            </nav>
            <div class="admin-info">Admin</div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-container">
        <!-- Show CRUD success/error messages -->
        <% 
            String success = (String) session.getAttribute("success");
            String error = (String) session.getAttribute("error");
            if (success != null) { session.removeAttribute("success"); }
            if (error != null) { session.removeAttribute("error"); }
        %>
        <% if (success != null) { %>
            <div class="alert alert-success"><%= success %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>
        <div class="page-header">
            <h1 class="page-title">Diet Plan Management</h1>
            <p class="page-subtitle">Create and manage nutrition programs for your users</p>
        </div>

        <!-- Statistics Overview -->
        <div class="stats-overview">
            <div class="overview-card">
                <div class="overview-value">1</div>
                <div class="overview-label">Active Plans</div>
            </div>
            <div class="overview-card">
                <div class="overview-value">0</div>
                <div class="overview-label">Total Meals</div>
            </div>
            <div class="overview-card">
                <div class="overview-value">0</div>
                <div class="overview-label">Users Following</div>
            </div>
        </div>

        <!-- Actions Bar -->
        <div class="actions-bar">
            <div>
                <span style="color: rgba(255,255,255,0.8); font-weight: 500;">Manage your diet plans and nutrition programs</span>
            </div>
            <button onclick="openAddPlanModal()" class="add-plan-btn">
                <i class="fi fi-rr-plus"></i>
                Add New Diet Plan
            </button>
        </div>

        <!-- Diet Plans Grid -->
        <div class="diet-plan-grid">
            <!-- Sample Diet Plan Card -->
            <div class="diet-plan-card">
                <div class="plan-header">
                    <h3 class="plan-title">Sample Weight Loss Plan</h3>
                    <span class="plan-type weight_loss">Weight Loss</span>
                </div>
                <p class="plan-description">A comprehensive plan designed for sustainable weight loss with balanced nutrition.</p>
                
                <div class="plan-stats">
                    <div class="stat-item">
                        <div class="stat-value">1500</div>
                        <div class="stat-label">Calories</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">7</div>
                        <div class="stat-label">Days</div>
                    </div>
                </div>

                <div class="plan-actions">
                    <a href="diet-plan-management?action=view&planId=1" class="btn-small btn-view">
                        <i class="fi fi-rr-eye"></i> View
                    </a>
                    <a href="diet-plan-management?action=edit&planId=1" class="btn-small btn-edit">
                        <i class="fi fi-rr-edit"></i> Edit
                    </a>
                    <button class="btn-small btn-delete" onclick="deletePlan(1, 'Sample Weight Loss Plan')">
                        <i class="fi fi-rr-trash"></i> Delete
                    </button>
                </div>
            </div>
        </div>

        <!-- Empty State (show when no plans exist) -->
        <!-- <div class="empty-state">
            <i class="fi fi-rr-plate-wheat"></i>
            <h3>No Diet Plans Yet</h3>
            <p>Create your first diet plan to get started with nutrition management</p>
        </div> -->
    </div>

    <!-- Add Diet Plan Modal -->
    <div id="addPlanModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Add New Diet Plan</h2>
                <span class="close" onclick="closeAddPlanModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="addPlanForm" method="post" action="diet-plan-management">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="form-group">
                        <label for="plan_name">Plan Name <span style="color: #dc3545;">*</span></label>
                        <input type="text" id="plan_name" name="plan_name" required placeholder="Enter plan name">
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" 
                                  placeholder="Brief description of the diet plan..."></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="plan_type">Plan Type <span style="color: #dc3545;">*</span></label>
                            <select id="plan_type" name="plan_type" required>
                                <option value="">Select plan type</option>
                                <option value="weight_loss">Weight Loss</option>
                                <option value="weight_gain">Weight Gain</option>
                                <option value="muscle_building">Muscle Building</option>
                                <option value="maintenance">Maintenance</option>
                                <option value="keto">Keto</option>
                                <option value="vegan">Vegan</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="difficulty_level">Difficulty Level <span style="color: #dc3545;">*</span></label>
                            <select id="difficulty_level" name="difficulty_level" required>
                                <option value="">Select difficulty</option>
                                <option value="beginner">Beginner</option>
                                <option value="intermediate">Intermediate</option>
                                <option value="advanced">Advanced</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="total_calories">Total Calories <span style="color: #dc3545;">*</span></label>
                            <input type="number" id="total_calories" name="total_calories" 
                                   min="0" step="1" required placeholder="e.g., 2000">
                        </div>

                        <div class="form-group">
                            <label for="duration_days">Duration (Days) <span style="color: #dc3545;">*</span></label>
                            <input type="number" id="duration_days" name="duration_days" 
                                   min="1" step="1" required placeholder="e.g., 7">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="total_protein">Protein (g) <span style="color: #dc3545;">*</span></label>
                            <input type="number" id="total_protein" name="total_protein" 
                                   min="0" step="0.1" required placeholder="e.g., 150">
                        </div>

                        <div class="form-group">
                            <label for="total_carbs">Carbs (g) <span style="color: #dc3545;">*</span></label>
                            <input type="number" id="total_carbs" name="total_carbs" 
                                   min="0" step="0.1" required placeholder="e.g., 200">
                        </div>

                        <div class="form-group">
                            <label for="total_fat">Fat (g) <span style="color: #dc3545;">*</span></label>
                            <input type="number" id="total_fat" name="total_fat" 
                                   min="0" step="0.1" required placeholder="e.g., 65">
                        </div>
                    </div>
                </form>
            </div>
            <div class="form-actions">
                <button type="button" onclick="closeAddPlanModal()" class="btn btn-secondary">Cancel</button>
                <button type="submit" form="addPlanForm" class="btn btn-primary">
                    <i class="fi fi-rr-plus"></i>
                    Add Diet Plan
                </button>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Confirm Delete</h2>
                <span class="close" onclick="closeDeleteModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete the diet plan "<span id="deletePlanName"></span>"?</p>
                <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 1rem; margin-top: 1rem;">
                    <p style="color: #856404; margin: 0; font-size: 0.9rem;">
                        <i class="fi fi-rr-exclamation-triangle"></i>
                        This action cannot be undone and will also delete all associated meals.
                    </p>
                </div>
            </div>
            <div class="form-actions">
                <button type="button" onclick="closeDeleteModal()" class="btn btn-secondary">Cancel</button>
                <form method="post" action="diet-plan-management" style="display: inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="diet_plan_id" id="deletePlanId">
                    <button type="submit" class="btn btn-danger">
                        <i class="fi fi-rr-trash"></i>
                        Delete Diet Plan
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Modal Functions
        function openAddPlanModal() {
            document.getElementById('addPlanModal').style.display = 'block';
            document.body.style.overflow = 'hidden'; // Prevent background scrolling
        }

        function closeAddPlanModal() {
            document.getElementById('addPlanModal').style.display = 'none';
            document.body.style.overflow = 'auto'; // Restore scrolling
        }

        function deletePlan(planId, planName) {
            document.getElementById('deletePlanId').value = planId;
            document.getElementById('deletePlanName').textContent = planName;
            document.getElementById('deleteModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            const addModal = document.getElementById('addPlanModal');
            const deleteModal = document.getElementById('deleteModal');
            
            if (event.target === addModal) {
                closeAddPlanModal();
            }
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
        }

        // Form validation for macronutrients
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('#addPlanModal form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const calories = parseInt(document.getElementById('total_calories').value) || 0;
                    const protein = parseFloat(document.getElementById('total_protein').value) || 0;
                    const carbs = parseFloat(document.getElementById('total_carbs').value) || 0;
                    const fat = parseFloat(document.getElementById('total_fat').value) || 0;
                    
                    // Calculate calories from macronutrients
                    const macroCalories = (protein * 4) + (carbs * 4) + (fat * 9);
                    const difference = Math.abs(calories - macroCalories);
                    
                    // Allow 10% difference
                    if (difference > calories * 0.1) {
                        if (!confirm("Warning: The total calories (" + calories + ") don't match the macronutrient breakdown (" + Math.round(macroCalories) + " calories). Continue anyway?")) {
                            e.preventDefault();
                        }
                    }
                });
            }
        });

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 300);
            });
        }, 5000);
    </script>
</body>
</html>
