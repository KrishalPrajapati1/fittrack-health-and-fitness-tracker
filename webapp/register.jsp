<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTrack - Register</title>
    
    <!-- Flaticon CSS -->
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-solid-rounded/css/uicons-solid-rounded.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/register.css">
</head>
<body>
    <div class="register-container">
        <div class="header">
            <div class="logo-container">
                <img src="images/logo1.png" alt="FitTrack Logo">
            </div>
            <h1>Join FitTrack</h1>
            <p>Start Your Fitness Journey Today</p>
        </div>
        
        <%
            String errorMessage = (String) request.getAttribute("error");
            String successMessage = (String) request.getAttribute("success");
            
            if (errorMessage != null && !errorMessage.trim().isEmpty()) {
        %>
            <div class="alert error">
                <i class="alert-icon fi fi-rr-exclamation"></i>
                <%= errorMessage %>
            </div>
        <%
            }
            
            if (successMessage != null && !successMessage.trim().isEmpty()) {
        %>
            <div class="alert success">
                <i class="alert-icon fi fi-rr-check"></i>
                <%= successMessage %>
            </div>
        <%
            }
        %>
        
        <form action="register" method="post" id="registerForm">
            <!-- Personal Information -->
            <div class="form-section">
                <div class="form-group full-width">
                    <label for="username">Full Name <span class="required">*</span></label>
                    <div class="input-container">
                        <i class="input-icon fi fi-rr-user"></i>
                        <input type="text" id="username" name="username" required placeholder="Enter your full name">
                    </div>
                </div>
                
                <div class="form-group full-width">
                    <label for="email">Email Address <span class="required">*</span></label>
                    <div class="input-container">
                        <i class="input-icon fi fi-rr-envelope"></i>
                        <input type="email" id="email" name="email" required placeholder="Enter your email address">
                    </div>
                </div>
            </div>
            
            <!-- Security -->
            <div class="form-section">
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password <span class="required">*</span></label>
                        <div class="input-container">
                            <i class="input-icon fi fi-rr-lock"></i>
                            <input type="password" id="password" name="password" required placeholder="Create password">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                        <div class="input-container">
                            <i class="input-icon fi fi-rr-lock"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Confirm password">
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Physical Information -->
            <div class="form-section">
                <div class="form-row">
                    <div class="form-group">
                        <label for="gender">Gender <span class="required">*</span></label>
                        <select name="gender" id="gender" required>
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="age">Age <span class="required">*</span></label>
                        <div class="input-container">
                            <i class="input-icon fi fi-rr-calendar"></i>
                            <input type="number" id="age" name="age" required placeholder="Age" min="13" max="120">
                        </div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="weight">Weight (kg) <span class="required">*</span></label>
                        <div class="input-container">
                            <i class="input-icon fi fi-rr-scale"></i>
                            <input type="number" id="weight" name="weight" required placeholder="Weight" min="20" max="500" step="0.1">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="height">Height (cm) <span class="required">*</span></label>
                        <div class="input-container">
                            <i class="input-icon fi fi-rr-ruler-vertical"></i>
                            <input type="number" id="height" name="height" required placeholder="Height" min="100" max="250" step="0.1">
                        </div>
                    </div>
                </div>
            </div>
            
            <button type="submit" class="btn" id="submitBtn">
                Create Account
            </button>
        </form>
        
        <div class="links">
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            var submitBtn = document.getElementById('submitBtn');
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long!');
                return false;
            }
            
            // Add loading state
            submitBtn.classList.add('loading');
            submitBtn.innerHTML = 'Creating Account...';
            submitBtn.disabled = true;
        });
        
        // Real-time password confirmation validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            var password = document.getElementById('password').value;
            var confirmPassword = this.value;
            
            if (confirmPassword && password !== confirmPassword) {
                this.classList.add('error');
                this.classList.remove('success');
            } else if (confirmPassword && password === confirmPassword) {
                this.classList.add('success');
                this.classList.remove('error');
            } else {
                this.classList.remove('error', 'success');
            }
        });

        // Enhanced form interactions
        document.querySelectorAll('input, select').forEach(input => {
            input.addEventListener('focus', function() {
                if (this.parentElement.classList.contains('input-container')) {
                    this.parentElement.classList.add('focused');
                }
            });
            
            input.addEventListener('blur', function() {
                if (this.parentElement.classList.contains('input-container')) {
                    this.parentElement.classList.remove('focused');
                }
            });
        });

        // Console welcome message
        console.log('%c🏋️‍♂️ FitTrack Registration Ready!', 'color: #667eea; font-size: 16px; font-weight: bold;');
    </script>
</body>
</html>
