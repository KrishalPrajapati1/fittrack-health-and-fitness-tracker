<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
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
    // Get userId from request
    String userIdStr = request.getParameter("userId");
    if (userIdStr == null) {
        response.sendRedirect("user-management");
        return;
    }
    // Get user details from request attribute (set by servlet) or fetch from DB if needed
    Map<String, Object> userDetails = (Map<String, Object>) request.getAttribute("userDetails");
    if (userDetails == null) {
       
        response.sendRedirect("user-management?action=view&userId=" + userIdStr);
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User - <%= userDetails.get("username") %> - FitTrack Admin</title>
    <link rel="stylesheet" href="../css/admin/admin-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="admin-layout">
        <header class="admin-header">
            <div class="container">
                <a href="admin-dashboard.jsp" class="admin-brand">
                    <i class="fas fa-dumbbell"></i> FitTrack Admin
                </a>
                <nav class="admin-nav">
                    <a href="admin-dashboard.jsp" class="admin-nav-link"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                    <a href="user-management" class="admin-nav-link active"><i class="fas fa-users"></i> Users</a>
                    <a href="#" class="admin-nav-link"><i class="fas fa-dumbbell"></i> Workouts</a>
                    <a href="#" class="admin-nav-link"><i class="fas fa-chart-bar"></i> Reports</a>
                    <a href="../login.jsp" class="admin-nav-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </nav>
            </div>
        </header>
        <main class="admin-main">
            <div class="container">
                <div style="margin-bottom: var(--spacing-lg);">
                    <a href="user-management?action=view&userId=<%= userIdStr %>" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to User Details
                    </a>
                </div>
                <div class="content-card" style="max-width: 600px; margin: 0 auto;">
                    <div class="card-header">
                        <h2 class="card-title"><i class="fas fa-edit"></i> Edit User</h2>
                    </div>
                    <div class="card-content">
                        <form id="editUserForm" action="/FitTrack/admin/user-management?action=edit" method="POST">
                            <input type="hidden" name="userId" value="<%= userDetails.get("user_id") %>">
                            <div class="form-group">
                                <label class="form-label">Username *</label>
                                <input type="text" class="form-input" name="username" value="<%= userDetails.get("username") %>" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email *</label>
                                <input type="email" class="form-input" name="email" value="<%= userDetails.get("email") %>" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Gender</label>
                                <select class="form-input" name="gender">
                                    <option value="">Not specified</option>
                                    <option value="Male" <%= "Male".equals(userDetails.get("gender")) ? "selected" : "" %>>Male</option>
                                    <option value="Female" <%= "Female".equals(userDetails.get("gender")) ? "selected" : "" %>>Female</option>
                                    <option value="Other" <%= "Other".equals(userDetails.get("gender")) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Age</label>
                                <input type="number" class="form-input" name="age" value="<%= userDetails.get("age") %>" min="0">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Weight (kg)</label>
                                <input type="number" step="0.1" class="form-input" name="weight" value="<%= userDetails.get("weight") %>" min="0">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Height (cm)</label>
                                <input type="number" step="0.1" class="form-input" name="height" value="<%= userDetails.get("height") %>" min="0">
                            </div>
                            <div class="form-footer" style="margin-top: var(--spacing-lg); display: flex; gap: var(--spacing-md);">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Changes</button>
                                <a href="user-management?action=view&userId=<%= userIdStr %>" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
