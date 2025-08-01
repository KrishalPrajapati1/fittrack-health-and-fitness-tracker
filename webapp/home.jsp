<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTrack - Your Health and Fitness Companion</title>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            color: #333;
            overflow-x: hidden;
        }
        
        /* Main content should account for fixed navbar */
        .hero {
            min-height: 100vh;
            position: relative;
            display: flex;
            align-items: center;
            padding-top: 140px; /* Increased to account for navbar */
            overflow: hidden;
            background-image: 
                linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)),
                url('images/homepage.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }
        
        /* Fallback background for when image doesn't load */
        .hero.no-image {
            background-image: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .hero-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
            position: relative;
            z-index: 2;
        }
        
        .hero-content {
            z-index: 3;
            position: relative;
        }
        
        .hero-content h1 {
            font-size: 3.5rem;
            font-weight: bold;
            color: white;
            margin-bottom: 1.5rem;
            margin-top: 1.5rem;
            line-height: 1.2;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .hero-content .subtitle {
            font-size: 1.3rem;
            color: rgba(255, 255, 255, 0.95);
            margin-bottom: 2rem;
            line-height: 1.6;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .hero-content .description {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 3rem;
            line-height: 1.7;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .hero-buttons {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            white-space: nowrap;
        }
        
        .btn i {
            font-size: 1rem;
        }
        
        .btn-hero {
            padding: 1rem 2rem;
            font-size: 1.1rem;
            border-radius: 30px;
            font-weight: 600;
        }
        
        .btn-white {
            background: rgba(255, 255, 255, 0.95);
            color: #667eea;
            border: 2px solid rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
        }
        
        .btn-white:hover {
            background: rgba(255, 255, 255, 1);
            color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(255, 255, 255, 0.4);
            text-decoration: none;
        }
        
        .btn-outline-white {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
        }
        
        .btn-outline-white:hover {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: white;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(255, 255, 255, 0.3);
            text-decoration: none;
        }
        
        .hero-features {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-top: 3rem;
        }
        
        .feature-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(15px);
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            background: rgba(255, 255, 255, 0.2);
        }
        
        .feature-card h3 {
            color: white;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .feature-card h3 i {
            font-size: 1.3rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .feature-card p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.9rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        
        /* Right side content overlay */
        .hero-right {
            position: relative;
            z-index: 3;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .hero-overlay-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border-radius: 25px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 2rem;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            transition: all 0.3s ease;
        }
        
        .hero-overlay-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.4);
        }
        
        .overlay-title {
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
            text-align: center;
            margin-bottom: 1.5rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .stat-item {
            text-align: center;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .stat-value {
            font-size: 1.8rem;
            font-weight: bold;
            color: white;
            margin-bottom: 0.5rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .stat-label {
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.9rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        
        .overlay-features {
            display: grid;
            gap: 0.8rem;
        }
        
        .overlay-feature {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.9rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        
        .overlay-feature i {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        /* Features Section */
        .features-section {
            padding: 5rem 0;
            background: linear-gradient(to bottom, #f8f9fa, #ffffff);
            margin-top: 4rem;
        }
        
        .features-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 4rem;
            margin-top: 2rem;
        }
        
        .section-title h2 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 1rem;
        }
        
        .section-title p {
            font-size: 1.2rem;
            color: #666;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }
        
        .feature-item {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .feature-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .feature-item:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .feature-item .icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
        }
        
        .feature-item .icon i {
            font-size: 2rem;
            color: white;
        }
        
        .feature-item h3 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 1rem;
        }
        
        .feature-item p {
            color: #666;
            line-height: 1.6;
        }
        
        /* CTA Section */
        .cta-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 5rem 0;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
            margin-top: 4rem;
        }
        
        .cta-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 20%, rgba(255,255,255,0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(255,255,255,0.1) 0%, transparent 50%);
            z-index: 1;
        }
        
        .cta-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 2rem;
            position: relative;
            z-index: 2;
        }
        
        .cta-section h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .cta-section p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        
        /* Footer Section */
        .footer-section {
            background: #2c2c2c;
            color: rgba(255, 255, 255, 0.9);
            padding: 4rem 0 2rem;
            position: relative;
        }
        
        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
        }
        
        .footer-column h3 {
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
            color: white;
        }
        
        .footer-column ul {
            list-style: none;
        }
        
        .footer-column ul li {
            margin-bottom: 0.8rem;
        }
        
        .footer-column ul li a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .footer-column ul li a:hover {
            color: white;
            text-decoration: underline;
        }
        
        .social-icons {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .social-icons a {
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.5rem;
            transition: color 0.3s ease;
        }
        
        .social-icons a:hover {
            color: white;
        }
        
        .footer-bottom {
            text-align: center;
            padding-top: 2rem;
            margin-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .hero {
                background-attachment: scroll;
                padding-top: 120px; /* Adjusted for mobile navbar */
            }
            
            .hero-container {
                grid-template-columns: 1fr;
                gap: 2rem;
                text-align: center;
            }
            
            .hero-content h1 {
                font-size: 2.5rem;
            }
            
            .hero-features {
                grid-template-columns: 1fr;
            }
            
            .hero-buttons {
                justify-content: center;
            }
            
            .btn-hero {
                width: 100%;
                max-width: 250px;
            }
            
            .features-grid {
                grid-template-columns: 1fr;
            }
            
            .cta-section h2 {
                font-size: 2rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .hero-overlay-card {
                max-width: 300px;
                padding: 1.5rem;
            }
            
            .footer-container {
                grid-template-columns: 1fr;
                text-align: center;
            }
            
            .social-icons {
                justify-content: center;
            }
        }
        
        @media (max-width: 480px) {
            .hero {
                padding-top: 110px; /* Adjusted for smaller mobile navbar */
            }
            
            .hero-content h1 {
                font-size: 2rem;
            }
            
            .hero-content .subtitle {
                font-size: 1.1rem;
            }
            
            .section-title h2 {
                font-size: 2rem;
            }
            
            .hero-overlay-card {
                margin: 0 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Include the navbar component -->
    <%@ include file="navbar.jsp" %>
    
    <!-- Hero Section with Background Image -->
    <section class="hero" id="home">
        <div class="hero-container">
            <div class="hero-content">
                <h1>Transform Your Fitness Journey</h1>
                <p class="subtitle">Your ultimate health and fitness companion</p>
                <p class="description">
                    Track workouts, monitor progress, and achieve your fitness goals with our comprehensive 
                    fitness tracking platform. Join thousands of users who have transformed their lives with FitTrack.
                </p>
                
                <div class="hero-buttons">
                    <a href="register.jsp" class="btn btn-white btn-hero">
                        <i class="fi fi-rr-rocket"></i>
                        Start Your Journey
                    </a>
                    <a href="login.jsp" class="btn btn-outline-white btn-hero">
                        <i class="fi fi-rr-sign-in-alt"></i>
                        Sign In
                    </a>
                </div>
                
                <div class="hero-features">
                    <div class="feature-card">
                        <h3>
                            <i class="fi fi-rr-dumbbell"></i>
                            Track Workouts
                        </h3>
                        <p>Log and monitor your daily workouts with detailed analytics</p>
                    </div>
                    <div class="feature-card">
                        <h3>
                            <i class="fi fi-rr-stats"></i>
                            Progress Analytics
                        </h3>
                        <p>Visualize your fitness journey with comprehensive reports</p>
                    </div>
                    <div class="feature-card">
                        <h3>
                            <i class="fi fi-rr-target"></i>
                            Goal Setting
                        </h3>
                        <p>Set and achieve personalized fitness milestones</p>
                    </div>
                    <div class="feature-card">
                        <h3>
                            <i class="fi fi-rr-smartphone"></i>
                            Mobile Friendly
                        </h3>
                        <p>Access your fitness data anywhere, anytime</p>
                    </div>
                </div>
            </div>
            
            <!-- Right side overlay content -->
            <div class="hero-right">
                <div class="hero-overlay-card">
                    <div class="overlay-title">
                        <i class="fi fi-rr-chart-mixed"></i>
                        Your Fitness Dashboard
                    </div>
                    
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-value">10K+</div>
                            <div class="stat-label">Active Users</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">50K+</div>
                            <div class="stat-label">Workouts Logged</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">95%</div>
                            <div class="stat-label">User Satisfaction</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">24/7</div>
                            <div class="stat-label">Support Available</div>
                        </div>
                    </div>
                    
                    <div class="overlay-features">
                        <div class="overlay-feature">
                            <i class="fi fi-rr-check-circle"></i>
                            Real-time progress tracking
                        </div>
                        <div class="overlay-feature">
                            <i class="fi fi-rr-check-circle"></i>
                            Personalized workout plans
                        </div>
                        <div class="overlay-feature">
                            <i class="fi fi-rr-check-circle"></i>
                            Comprehensive analytics
                        </div>
                        <div class="overlay-feature">
                            <i class="fi fi-rr-check-circle"></i>
                            Community support
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="features-container">
            <div class="section-title">
                <h2>Why Choose FitTrack?</h2>
                <p>Discover the powerful features that make FitTrack the perfect fitness companion for your journey</p>
            </div>
            
            <div class="features-grid">
                <div class="feature-item">
                    <div class="icon">
                        <i class="fi fi-sr-running"></i>
                    </div>
                    <h3>Comprehensive Workout Logging</h3>
                    <p>Track various workout types including cardio, strength training, and flexibility exercises with detailed metrics for duration and calories burned.</p>
                </div>
                
                <div class="feature-item">
                    <div class="icon">
                        <i class="fi fi-sr-chart-line-up"></i>
                    </div>
                    <h3>Advanced Progress Tracking</h3>
                    <p>Monitor your fitness journey with detailed statistics, workout history, and visual progress reports to stay motivated.</p>
                </div>
                
                <div class="feature-item">
                    <div class="icon">
                        <i class="fi fi-sr-user"></i>
                    </div>
                    <h3>Personalized User Profiles</h3>
                    <p>Create and manage your personal fitness profile with custom goals, preferences, and health metrics tailored to your needs.</p>
                </div>
                
                <div class="feature-item">
                    <div class="icon">
                        <i class="fi fi-sr-shield-check"></i>
                    </div>
                    <h3>Secure & Private</h3>
                    <p>Your fitness data is protected with advanced security measures and role-based access control for complete privacy.</p>
                </div>
                
                <div class="feature-item">
                    <div class="icon">
                        <i class="fi fi-sr-dashboard"></i>
                    </div>
                    <h3>Admin Dashboard</h3>
                    <p>Comprehensive admin panel for managing users, workouts, and system analytics with detailed reporting capabilities.</p>
                </div>
                
                <div class="feature-item">
                    <div class="icon">
                        <i class="fi fi-sr-devices"></i>
                    </div>
                    <h3>Responsive Design</h3>
                    <p>Access FitTrack seamlessly across all devices with our mobile-first, responsive web application design.</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Call to Action Section -->
    <section class="cta-section">
        <div class="cta-container">
            <h2>Ready to Start Your Fitness Journey?</h2>
            <p>Join thousands of users who have transformed their lives with FitTrack. Start tracking your workouts and achieving your fitness goals today!</p>
            <div class="hero-buttons">
                <a href="register.jsp" class="btn btn-white btn-hero">
                    <i class="fi fi-rr-user-add"></i>
                    Create Free Account
                </a>
                <a href="login.jsp" class="btn btn-outline-white btn-hero">
                    <i class="fi fi-rr-sign-in-alt"></i>
                    Already Have Account?
                </a>
            </div>
        </div>
    </section>
    
    <!-- Footer Section -->
    <footer class="footer-section">
        <div class="footer-container">
            <div class="footer-column">
                <h3>About FitTrack</h3>
                <p>FitTrack is your ultimate companion for achieving fitness goals through comprehensive tracking and analytics.</p>
            </div>
            <div class="footer-column">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="#features">Features</a></li>
                    <li><a href="register.jsp">Sign Up</a></li>
                    <li><a href="login.jsp">Login</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h3>Support</h3>
                <ul>
                    <li><a href="faq.jsp">FAQ</a></li>
                    <li><a href="contact.jsp">Contact Us</a></li>
                    <li><a href="privacy.jsp">Privacy Policy</a></li>
                    <li><a href="terms.jsp">Terms of Service</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 FitTrack. All rights reserved.</p>
        </div>
    </footer>
    
    <script>
        // Check if background image loads
        function checkBackgroundImage() {
            const hero = document.querySelector('.hero');
            const img = new Image();
            
            img.onload = function() {
                console.log('✅ Home hero background image loaded successfully');
            };
            
            img.onerror = function() {
                console.log('❌ Home hero background image failed, using fallback');
                hero.classList.add('no-image');
            };
            
            img.src = 'images/homepage.jpg';
        }
        
        // Smooth scrolling for features section
        document.querySelectorAll('a[href="#features"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const featuresSection = document.querySelector('#features');
                if (featuresSection) {
                    featuresSection.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
        
        // Initialize when page loads
        document.addEventListener('DOMContentLoaded', function() {
            checkBackgroundImage();
            console.log('🏠 Home page loaded successfully!');
        });
        
        // Add hover effects to buttons
        document.querySelectorAll('.btn').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px) scale(1.02)';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
        
        // Add animation to feature cards on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };
        
        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);
        
        // Observe feature items
        document.querySelectorAll('.feature-item').forEach(item => {
            item.style.opacity = '0';
            item.style.transform = 'translateY(30px)';
            item.style.transition = 'all 0.6s ease';
            observer.observe(item);
        });
    </script>
</body>
</html>
