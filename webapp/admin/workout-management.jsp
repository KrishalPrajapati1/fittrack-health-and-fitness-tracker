<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || (!"admin".equals(adminSession.getAttribute("userType")) && !"admin".equals(adminSession.getAttribute("role")))) {
        response.sendRedirect("../login.jsp");
        return;
    }
    List<Map<String, Object>> workouts = (List<Map<String, Object>>) request.getAttribute("workouts");
    if (workouts == null) workouts = new ArrayList<>();
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<%! 
    public static String escapeJs(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("'", "\\'");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Workout Management - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
            color: #333;
        }

        .admin-layout {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .admin-header {
            background: #dc3545;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .admin-header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-brand {
            font-size: 1.5rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .admin-nav {
            display: flex;
            gap: 1rem;
        }

        .admin-nav-link {
            padding: 0.75rem 1rem;
            text-decoration: none;
            color: rgba(255, 255, 255, 0.8);
            border-radius: 8px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .admin-nav-link:hover,
        .admin-nav-link.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            transform: translateY(-2px);
        }

        .admin-main {
            flex: 1;
            padding: 2rem 0;
        }

        h2 {
            color: #333;
            margin-bottom: 2rem;
            font-size: 2rem;
            text-align: center;
        }

        .alert {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            font-weight: 500;
        }

        .alert-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        .alert-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-primary {
            background: #dc3545;
            color: white;
        }

        .btn-primary:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
        }

        .admin-table {
            width: 100%;
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-top: 1rem;
        }

        .admin-table thead {
            background: #dc3545;
            color: white;
        }

        .admin-table th,
        .admin-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        .admin-table tbody tr:hover {
            background: rgba(220, 53, 69, 0.1);
            transform: scale(1.01);
            transition: all 0.3s ease;
        }

        .action-btn {
            padding: 0.5rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            margin: 0 0.25rem;
            transition: all 0.3s ease;
            color: white;
        }

        .action-btn.edit {
            background: linear-gradient(135deg, #f59e0b, #d97706);
        }

        .action-btn.delete {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }

        /* Modern Modal Styles */
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
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 2rem;
            border-radius: 20px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalAppear 0.3s ease-out;
        }

        @keyframes modalAppear {
            from {
                opacity: 0;
                transform: translate(-50%, -60%);
            }
            to {
                opacity: 1;
                transform: translate(-50%, -50%);
            }
        }

        .close {
            position: absolute;
            right: 1rem;
            top: 1rem;
            font-size: 2rem;
            font-weight: bold;
            cursor: pointer;
            color: #aaa;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .close:hover {
            color: #dc3545;
            background: #f0f0f0;
        }

        .modal h3 {
            margin-bottom: 1.5rem;
            color: #333;
            font-size: 1.5rem;
            text-align: center;
            padding-right: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #555;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #dc3545;
            background: white;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        @media (max-width: 768px) {
            .admin-nav {
                flex-wrap: wrap;
            }
            
            .admin-table {
                font-size: 0.9rem;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 0.5rem;
            }
            
            .modal-content {
                width: 95%;
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
<div class="admin-layout">
    <header class="admin-header">
        <div class="container">
            <a href="/FitTrack/admin/admin-dashboard.jsp" class="admin-brand"><i class="fas fa-dumbbell"></i> FitTrack Admin</a>
            <nav class="admin-nav">
                <a href="/FitTrack/admin/admin-dashboard.jsp" class="admin-nav-link"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="/FitTrack/admin/user-management" class="admin-nav-link"><i class="fas fa-users"></i> Users</a>
                <a href="/FitTrack/admin/workout-management" class="admin-nav-link active"><i class="fas fa-dumbbell"></i> Workouts</a>
                <a href="#" class="admin-nav-link"><i class="fas fa-chart-bar"></i> Reports</a>
                <a href="/FitTrack/login.jsp" class="admin-nav-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </nav>
            <!-- Delete Confirmation Modal -->
            <div id="deleteModal" class="modal">
                <div class="modal-content" style="max-width: 400px;">
                    <span class="close" onclick="closeDeleteModal()">&times;</span>
                    <h3 style="color: #dc3545;"><i class="fas fa-exclamation-triangle"></i> Confirm Delete</h3>
                    <div style="text-align: center; margin: 2rem 0;">
                        <p style="margin-bottom: 1rem; color: #666;">Are you sure you want to delete this workout?</p>
                        <p style="font-weight: bold; color: #333; background: #f8f9fa; padding: 0.5rem; border-radius: 8px;" id="deleteWorkoutName"></p>
                        <p style="font-size: 0.9rem; color: #666; margin-top: 1rem;">This action cannot be undone.</p>
                    </div>
                    <div style="display: flex; gap: 1rem; justify-content: center;">
                        <button type="button" class="btn" style="background: #6c757d; color: white;" onclick="closeDeleteModal()">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <form id="deleteForm" action="workout-management" method="POST" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="workout_id" id="delete_workout_id">
                            <button type="submit" class="btn" style="background: #dc3545; color: white;">
                                <i class="fas fa-trash"></i> Delete Workout
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <main class="admin-main">
        <div class="container">
            <h2>Workout Management</h2>
            <% if (error != null) { %>
                <div class="alert alert-danger"><%= error %></div>
            <% } %>
            <% if (success != null) { %>
                <div class="alert alert-success"><%= success %></div>
            <% } %>
            <button class="btn btn-primary" onclick="showAddModal()"><i class="fas fa-plus"></i> Add Workout</button>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Duration (min)</th>
                        <th>Calories</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> workout : workouts) { %>
                    <tr>
                        <td><%= workout.get("name") %></td>
                        <td><%= workout.get("type") %></td>
                        <td><%= workout.get("duration") %></td>
                        <td><%= workout.get("calories_burned") %></td>
                        <td><%= workout.get("description") %></td>
                        <td>
                            <button class="action-btn edit" onclick="showEditModal(
                                <%= workout.get("workout_id") %>,
                                '<%= escapeJs((String)workout.get("name")) %>',
                                '<%= escapeJs((String)workout.get("type")) %>',
                                <%= workout.get("duration") %>,
                                <%= workout.get("calories_burned") %>,
                                '<%= escapeJs((String)workout.get("description")) %>'
                            )" title="Edit"><i class="fas fa-edit"></i></button>
                            <button class="action-btn delete" onclick="showDeleteModal(<%= workout.get("workout_id") %>, '<%= escapeJs((String)workout.get("name")) %>')" title="Delete"><i class="fas fa-trash"></i></button>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            
            <!-- Add Modal -->
            <div id="addModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeAddModal()">&times;</span>
                    <h3><i class="fas fa-plus"></i> Add New Workout</h3>
                    <form action="workout-management" method="POST">
                        <input type="hidden" name="action" value="add">
                        <div class="form-group">
                            <label><i class="fas fa-tag"></i> Workout Name</label>
                            <input type="text" name="name" placeholder="Enter workout name" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-dumbbell"></i> Workout Type</label>
                            <input type="text" name="type" placeholder="e.g., Cardio, Strength, Yoga" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-clock"></i> Duration (minutes)</label>
                            <input type="number" name="duration" placeholder="Duration in minutes" min="1" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-fire"></i> Calories Burned</label>
                            <input type="number" name="calories_burned" placeholder="Estimated calories burned" min="0" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-align-left"></i> Description</label>
                            <textarea name="description" placeholder="Brief description of the workout"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            <i class="fas fa-save"></i> Add Workout
                        </button>
                    </form>
                </div>
            </div>
            
            <!-- Edit Modal -->
            <div id="editModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeEditModal()">&times;</span>
                    <h3><i class="fas fa-edit"></i> Edit Workout</h3>
                    <form id="editForm" action="workout-management" method="POST">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="workout_id" id="edit_workout_id">
                        <div class="form-group">
                            <label><i class="fas fa-tag"></i> Workout Name</label>
                            <input type="text" name="name" id="edit_name" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-dumbbell"></i> Workout Type</label>
                            <input type="text" name="type" id="edit_type" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-clock"></i> Duration (minutes)</label>
                            <input type="number" name="duration" id="edit_duration" min="1" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-fire"></i> Calories Burned</label>
                            <input type="number" name="calories_burned" id="edit_calories_burned" min="0" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-align-left"></i> Description</label>
                            <textarea name="description" id="edit_description"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
function showDeleteModal(id, name) {
    document.getElementById('delete_workout_id').value = id;
    document.getElementById('deleteWorkoutName').textContent = name;
    document.getElementById('deleteModal').style.display = 'block';
    document.body.style.overflow = 'hidden';
}

function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
    document.body.style.overflow = 'auto';
}

function showAddModal() {
    document.getElementById('addModal').style.display = 'block';
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
}

function closeAddModal() {
    document.getElementById('addModal').style.display = 'none';
    document.body.style.overflow = 'auto'; // Restore scrolling
}

function showEditModal(id, name, type, duration, calories, desc) {
    document.getElementById('edit_workout_id').value = id;
    document.getElementById('edit_name').value = name;
    document.getElementById('edit_type').value = type;
    document.getElementById('edit_duration').value = duration;
    document.getElementById('edit_calories_burned').value = calories;
    document.getElementById('edit_description').value = desc;
    document.getElementById('editModal').style.display = 'block';
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
}

function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
    document.body.style.overflow = 'auto'; // Restore scrolling
}

// Close modal when clicking outside
window.onclick = function(event) {
    const addModal = document.getElementById('addModal');
    const editModal = document.getElementById('editModal');
    const deleteModal = document.getElementById('deleteModal');
    
    if (event.target == addModal) {
        closeAddModal();
    }
    if (event.target == editModal) {
        closeEditModal();
    }
    if (event.target == deleteModal) {
        closeDeleteModal();
    }
}


document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeAddModal();
        closeEditModal();
        closeDeleteModal();
    }
});
</script>
</body>
</html>
