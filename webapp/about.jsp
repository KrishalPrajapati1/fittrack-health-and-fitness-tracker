<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - FitTrack</title>
    
    <!-- Flaticon CSS -->
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.0.0/uicons-bold-rounded/css/uicons-bold-rounded.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.0.0/uicons-solid-rounded/css/uicons-solid-rounded.css">
    
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
            background: #f8f9fa;
        }
        
        /* Main Content */
        .main-content {
            padding-top: 120px; /* Adjusted for navbar height */
            min-height: 100vh;
        }
        
        /* Hero Section */
        .hero-section {
            background: 
                linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                url('images/aboutus2.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            color: white;
            padding: 4rem 0;
            text-align: center;
            position: relative;
        }
        
        /* Fallback for when image doesn't load */
        .hero-section.no-image {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .hero-section h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .hero-section p {
            font-size: 1.2rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }
        
        /* Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }
        
        /* Story Section */
        .story-section {
            padding: 5rem 0;
            background: white;
        }
        
        .story-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
        }
        
        .story-content h2 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 2rem;
        }
        
        .story-content p {
            color: #666;
            margin-bottom: 1.5rem;
            font-size: 1.1rem;
            line-height: 1.8;
        }
        
        .story-image {
            text-align: center;
            position: relative;
        }
        
        /* Updated story image container */
        .story-image img {
            width: 100%;
            height: 400px;
            border-radius: 15px;
            object-fit: cover;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }
        
        .story-image img:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        
        /* Fallback placeholder when image doesn't load */
        .story-placeholder {
            width: 100%;
            height: 400px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            display: none; /* Hidden by default, shown when image fails */
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .story-placeholder i {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        
        .story-placeholder h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }
        
        /* Image overlay for better visual effect */
        .image-container {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
        }
        
        .image-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            z-index: 1;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .image-container:hover::before {
            opacity: 1;
        }
        
        /* Mission Section */
        .mission-section {
            padding: 5rem 0;
            background: #f8f9fa;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .section-header h2 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 1rem;
        }
        
        .section-header p {
            font-size: 1.2rem;
            color: #666;
        }
        
        .mission-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }
        
        .mission-card {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .mission-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .mission-card .icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }
        
        .mission-card .icon i {
            font-size: 2.5rem;
            color: white;
        }
        
        .mission-card h3 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 1rem;
        }
        
        .mission-card p {
            color: #666;
            line-height: 1.6;
        }
        
        /* Stats Section */
        .stats-section {
            padding: 5rem 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
        }
        
        .stats-section h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .stats-section > .container > p {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }
        
        .stat-item {
            padding: 2rem;
        }
        
        .stat-item .number {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .stat-item .label {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        /* Values Section */
        .values-section {
            padding: 5rem 0;
            background: #f8f9fa;
        }
        
        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }
        
        .value-item {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .value-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .value-item h3 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }
        
        .value-item h3 i {
            font-size: 1.8rem;
            color: #667eea;
        }
        
        .value-item p {
            color: #666;
            line-height: 1.6;
        }
        
        /* CTA Section */
        .cta-section {
            padding: 5rem 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
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
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .cta-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }
        
        .btn {
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-white {
            background: white;
            color: #667eea;
            border: 2px solid white;
            padding: 1rem 2rem;
            border-radius: 30px;
            font-size: 1.1rem;
            font-weight: 600;
        }
        
        .btn-white:hover {
            background: transparent;
            color: white;
            transform: translateY(-3px);
        }
        
        .btn-outline-white {
            background: transparent;
            color: white;
            border: 2px solid white;
            padding: 1rem 2rem;
            border-radius: 30px;
            font-size: 1.1rem;
            font-weight: 600;
        }
        
        .btn-outline-white:hover {
            background: white;
            color: #667eea;
            transform: translateY(-3px);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .hero-section {
                background-attachment: scroll; /* Better performance on mobile */
            }
            
            .hero-section h1 {
                font-size: 2rem;
            }
            
            .story-grid {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .story-content h2 {
                font-size: 2rem;
            }
            
            .story-image img,
            .story-placeholder {
                height: 300px;
            }
            
            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-white, .btn-outline-white {
                width: 100%;
                max-width: 300px;
            }
        }
        
        @media (max-width: 480px) {
            .main-content {
                padding-top: 100px;
            }
            
            .hero-section {
                padding: 2rem 0;
            }
            
            .hero-section h1 {
                font-size: 1.8rem;
            }
            
            .mission-card, .value-item {
                padding: 1.5rem;
            }
            
            .stats-section {
                padding: 3rem 0;
            }
            
            .stat-item .number {
                font-size: 2rem;
            }
            
            .story-image img,
            .story-placeholder {
                height: 250px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Navigation -->
    <%@ include file="navbar.jsp" %>
    
    <!-- Main Content -->
    <main class="main-content">
        <!-- Hero Section -->
        <section class="hero-section" id="heroSection">
            <div class="container">
                <h1>About FitTrack</h1>
                <p>Empowering individuals to achieve their fitness goals through innovative technology and comprehensive health tracking solutions.</p>
            </div>
        </section>
        
        <!-- Story Section -->
        <section class="story-section">
            <div class="container">
                <div class="story-grid">
                    <div class="story-content">
                        <h2>Our Story</h2>
                        <p>FitTrack was born from a simple yet powerful idea: everyone deserves access to effective fitness tracking tools that make health and wellness achievable for all.</p>
                        <p>Founded in 2024, our journey began when our team realized that existing fitness solutions were either too complex for beginners or too basic for serious fitness enthusiasts. We set out to create a platform that bridges this gap.</p>
                        <p>Today, FitTrack serves thousands of users worldwide, helping them transform their fitness journeys through data-driven insights, personalized recommendations, and a supportive community.</p>
                    </div>
                    <div class="story-image">
                        <div class="image-container">
                            <img src="images/aboutus.jpg" alt="About FitTrack - Our Story" id="aboutImage" 
                                 onerror="this.style.display='none'; document.getElementById('aboutPlaceholder').style.display='flex';">
                            <div class="story-placeholder" id="aboutPlaceholder">
                                <i class="fi fi-sr-heart-pulse"></i>
                                <h3>Your Fitness Journey</h3>
                                <p>Starts Here</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Mission Section -->
        <section class="mission-section">
            <div class="container">
                <div class="section-header">
                    <h2>Our Mission & Vision</h2>
                    <p>Driving positive change in global health and wellness through technology</p>
                </div>
                
                <div class="mission-grid">
                    <div class="mission-card">
                        <div class="icon">
                            <i class="fi fi-sr-target"></i>
                        </div>
                        <h3>Our Mission</h3>
                        <p>To democratize fitness tracking and make healthy living accessible to everyone, regardless of their fitness level or background.</p>
                    </div>
                    
                    <div class="mission-card">
                        <div class="icon">
                            <i class="fi fi-sr-eye"></i>
                        </div>
                        <h3>Our Vision</h3>
                        <p>To become the world's leading platform for personal fitness transformation, empowering millions to live healthier, more active lives.</p>
                    </div>
                    
                    <div class="mission-card">
                        <div class="icon">
                            <i class="fi fi-sr-heart"></i>
                        </div>
                        <h3>Our Purpose</h3>
                        <p>To inspire and support individuals on their unique fitness journeys, providing tools that make progress visible and goals achievable.</p>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Stats Section -->
        <section class="stats-section">
            <div class="container">
                <h2>FitTrack by the Numbers</h2>
                <p>Our impact in the fitness community continues to grow</p>
                
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="number">10K+</div>
                        <div class="label">Active Users</div>
                    </div>
                    <div class="stat-item">
                        <div class="number">50K+</div>
                        <div class="label">Workouts Logged</div>
                    </div>
                    <div class="stat-item">
                        <div class="number">1M+</div>
                        <div class="label">Calories Tracked</div>
                    </div>
                    <div class="stat-item">
                        <div class="number">95%</div>
                        <div class="label">User Satisfaction</div>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Values Section -->
        <section class="values-section">
            <div class="container">
                <div class="section-header">
                    <h2>Our Core Values</h2>
                    <p>The principles that guide everything we do</p>
                </div>
                
                <div class="values-grid">
                    <div class="value-item">
                        <h3>
                            <i class="fi fi-sr-users"></i>
                            User-Centric
                        </h3>
                        <p>Every feature we build is designed with our users' needs and goals at the forefront. Your success is our success.</p>
                    </div>
                    
                    <div class="value-item">
                        <h3>
                            <i class="fi fi-sr-lightbulb-on"></i>
                            Innovation
                        </h3>
                        <p>We continuously explore new ways to make fitness tracking more effective, engaging, and accessible for everyone.</p>
                    </div>
                    
                    <div class="value-item">
                        <h3>
                            <i class="fi fi-sr-shield-check"></i>
                            Privacy & Security
                        </h3>
                        <p>Your personal health data is sacred. We implement the highest security standards to protect your information.</p>
                    </div>
                    
                    <div class="value-item">
                        <h3>
                            <i class="fi fi-sr-handshake"></i>
                            Community
                        </h3>
                        <p>We believe in the power of community support and strive to create connections that motivate and inspire.</p>
                    </div>
                    
                    <div class="value-item">
                        <h3>
                            <i class="fi fi-sr-diploma"></i>
                            Continuous Learning
                        </h3>
                        <p>We stay updated with the latest fitness research and technology to provide you with cutting-edge tools.</p>
                    </div>
                    
                    <div class="value-item">
                        <h3>
                            <i class="fi fi-sr-earth"></i>
                            Accessibility
                        </h3>
                        <p>Fitness should be inclusive. We design our platform to be accessible to users of all abilities and backgrounds.</p>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- CTA Section -->
        <section class="cta-section">
            <div class="container">
                <h2>Ready to Join Our Community?</h2>
                <p>Become part of the FitTrack family and start your transformation journey today. Together, we'll help you achieve your fitness goals and live a healthier life.</p>
                <div class="cta-buttons">
                    <a href="register.jsp" class="btn btn-white">
                        <i class="fi fi-rr-user-add"></i>
                        Start Your Journey
                    </a>
                    <a href="contact.jsp" class="btn btn-outline-white">
                        <i class="fi fi-rr-envelope"></i>
                        Contact Us
                    </a>
                </div>
            </div>
        </section>
    </main>
</body>
</html>
