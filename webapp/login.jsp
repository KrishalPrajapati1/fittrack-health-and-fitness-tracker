<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTrack - Login</title>
    
    <!-- Flaticon CSS -->
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-bold-rounded/css/uicons-bold-rounded.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-solid-rounded/css/uicons-solid-rounded.css">
    
    <!-- Google Fonts for better typography -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
    <div class="login-container">
        <!-- Header Section with gradient background -->
        <div class="login-header">
            <div class="logo-container">
                <div class="logo">
                    <img src="images/logo1.png" alt="FitTrack Logo" onerror="this.style.display='none'; this.parentElement.innerHTML='<i class=\'fi fi-br-dumbbell\' style=\'font-size: 2rem; color: white;\'></i>';">
                </div>
            </div>
        </div>

        <!-- Body Section -->
        <div class="login-body">
            <div class="welcome-text">
                <h2 class="welcome-title">Welcome Back!</h2>
                <p class="welcome-subtitle">Sign in to continue your fitness journey</p>
            </div>

            <!-- Success/Error Messages using JSP -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="alert-icon fi fi-br-cross-circle"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <i class="alert-icon fi fi-br-check"></i>
                    <span><%= request.getAttribute("success") %></span>
                </div>
            <% } %>

            <form id="loginForm" action="login" method="post">
                <!-- Role Selection -->
                <div class="role-selector">
                    <div class="role-option">
                        <input type="radio" id="userRole" name="userType" value="user" class="role-input" checked>
                        <label for="userRole" class="role-label">
                            <i class="role-icon fi fi-br-user"></i>
                            <div class="role-title">User</div>
                        </label>
                    </div>
                    <div class="role-option">
                        <input type="radio" id="adminRole" name="userType" value="admin" class="role-input">
                        <label for="adminRole" class="role-label">
                            <i class="role-icon fi fi-br-shield"></i>
                            <div class="role-title">Admin</div>
                        </label>
                    </div>
                </div>

                <!-- Email Input -->
                <div class="form-group">
                    <label for="email" class="form-label">
                        <i class="form-label-icon fi fi-rr-envelope"></i>
                        Email Address
                    </label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="Enter your email address" required>
                </div>

                <!-- Password Input -->
                <div class="form-group">
                    <label for="password" class="form-label">
                        <i class="form-label-icon fi fi-rr-lock"></i>
                        Password
                    </label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
                    <button type="button" class="password-toggle" onclick="togglePassword()">
                        <i class="fi fi-br-eye" id="passwordToggleIcon"></i>
                    </button>
                </div>

                <!-- Login Button -->
                <button type="submit" class="btn-login" id="loginBtn">
                    <i class="btn-icon fi fi-br-sign-in-alt"></i>
                    <span>Sign In</span>
                </button>
            </form>

            <!-- Footer -->
            <div class="form-footer">
                <p class="signup-link">
                    Don't have an account? <a href="register.jsp">Create account here</a>
                </p>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Password toggle functionality
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('passwordToggleIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.className = 'fi fi-br-eye-crossed';
            } else {
                passwordInput.type = 'password';
                toggleIcon.className = 'fi fi-br-eye';
            }
        }

        // Form validation and submission
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();
            const loginBtn = document.getElementById('loginBtn');

            // Basic validation
            if (!email || !password) {
                e.preventDefault();
                alert('Please fill in all fields.');
                return;
            }

            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Please enter a valid email address.');
                return;
            }

            // Add loading state
            loginBtn.classList.add('loading');
            loginBtn.innerHTML = '<i class="btn-icon fi fi-br-spinner"></i><span>Signing In...</span>';
        });

        // Role selection change with admin credentials hint
        document.querySelectorAll('input[name="userType"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const emailInput = document.getElementById('email');
                const passwordInput = document.getElementById('password');
                
                if (this.value === 'admin') {
                    emailInput.placeholder = 'Admin email (admin@fittrack.com)';
                    passwordInput.placeholder = 'Admin password (admin123)';
                    emailInput.value = 'admin@fittrack.com';
                } else {
                    emailInput.placeholder = 'Enter your email address';
                    passwordInput.placeholder = 'Enter your password';
                    emailInput.value = '';
                }
            });
        });

        // Enhanced form interactions
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('focused');
            });
        });

        // Keyboard navigation enhancement
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && e.target.classList.contains('role-label')) {
                e.target.querySelector('input').checked = true;
                e.target.querySelector('input').dispatchEvent(new Event('change'));
            }
        });
    </script>
</body>
</html>
