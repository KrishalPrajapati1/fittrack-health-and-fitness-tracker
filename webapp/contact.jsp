<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - FitTrack</title>
    
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
        
        /* Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }
        
        /* Main Content */
        .main-content {
            padding-top: 120px; /* Account for navbar height */
            min-height: 100vh;
        }
        
        /* Hero Section with Background Image */
        .hero-section {
            min-height: 70vh;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            background-image: 
                linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
                url('images/contactus.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            color: white;
        }
        
        /* Fallback background for when image doesn't load */
        .hero-section.no-image {
            background-image: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .hero-content {
            max-width: 800px;
            padding: 0 2rem;
            z-index: 2;
            position: relative;
        }
        
        .hero-section h1 {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
            font-weight: 700;
            letter-spacing: 2px;
        }
        
        .hero-section .subtitle {
            font-size: 1.2rem;
            opacity: 0.95;
            margin-bottom: 3rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
            line-height: 1.6;
        }
        
        /* Quick Contact Cards in Hero */
        .hero-contact-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }
        
        .hero-contact-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .hero-contact-card:hover {
            transform: translateY(-10px);
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }
        
        .hero-contact-card .icon {
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }
        
        .hero-contact-card .icon i {
            font-size: 1.8rem;
            color: white;
        }
        
        .hero-contact-card h3 {
            color: white;
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
        }
        
        .hero-contact-card p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        /* Contact Section - Modern Design */
        .contact-section {
            padding: 6rem 0;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            position: relative;
        }
        
        .contact-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 100px;
            background: linear-gradient(to bottom, rgba(0,0,0,0.1), transparent);
        }
        
        .contact-wrapper {
            background: white;
            border-radius: 25px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            overflow: hidden;
            position: relative;
        }
        
        .contact-wrapper::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            min-height: 600px;
        }
        
        .contact-info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4rem 3rem;
            color: white;
            position: relative;
            overflow: hidden;
        }
        
        .contact-info::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        
        .contact-info::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -10%;
            width: 150px;
            height: 150px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
        }
        
        .contact-info h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
            position: relative;
            z-index: 2;
        }
        
        .contact-info .subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 3rem;
            position: relative;
            z-index: 2;
        }
        
        .contact-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
            position: relative;
            z-index: 2;
        }
        
        .contact-item:hover {
            transform: translateX(10px);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .contact-item .icon {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1.5rem;
            flex-shrink: 0;
        }
        
        .contact-item .icon i {
            color: white;
            font-size: 1.5rem;
        }
        
        .contact-item .info h3 {
            color: white;
            margin-bottom: 0.5rem;
            font-size: 1.2rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .contact-item .info p {
            color: rgba(255, 255, 255, 0.9);
            margin: 0;
            font-size: 1rem;
            line-height: 1.5;
        }
        
        /* Contact Form - Modern Design */
        .contact-form {
            padding: 4rem 3rem;
            background: white;
            position: relative;
        }
        
        .contact-form h2 {
            color: #333;
            margin-bottom: 1rem;
            font-size: 2.5rem;
        }
        
        .contact-form .subtitle {
            color: #666;
            margin-bottom: 3rem;
            font-size: 1.1rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }
        
        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        input, textarea, select {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 1rem;
            background: #f8f9fa;
            transition: all 0.3s ease;
            font-family: inherit;
        }
        
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        textarea {
            resize: vertical;
            min-height: 140px;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-submit i {
            font-size: 1.1rem;
        }
        
        /* Map Section */
        .map-section {
            padding: 4rem 0;
            background: #f8f9fa;
        }
        
        .map-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            height: 500px;
            position: relative;
        }
        
        .map-info {
            text-align: center;
            padding: 1.5rem;
            background: white;
            border-bottom: 1px solid #eee;
        }
        
        .map-info i {
            font-size: 2.5rem;
            color: #667eea;
            margin-bottom: 0.5rem;
        }
        
        .map-info h3 {
            margin: 0.5rem 0;
            color: #333;
            font-size: 1.5rem;
        }
        
        .map-info p {
            margin: 0;
            color: #666;
            font-size: 1rem;
        }
        
        .map-container iframe {
            width: 100%;
            height: calc(100% - 120px);
            border: none;
        }
        
        /* FAQ Section */
        .faq-section {
            padding: 5rem 0;
            background: white;
        }
        
        .faq-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 2rem;
        }
        
        .faq-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .faq-header h2 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 1rem;
        }
        
        .faq-item {
            background: #f8f9fa;
            margin-bottom: 1rem;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .faq-question {
            background: white;
            padding: 1.5rem;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: none;
            width: 100%;
            text-align: left;
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
            transition: all 0.3s ease;
        }
        
        .faq-question:hover {
            background: #f0f2f5;
        }
        
        .faq-question.active {
            background: #667eea;
            color: white;
        }
        
        .faq-question i {
            transition: transform 0.3s ease;
        }
        
        .faq-question.active i {
            transform: rotate(180deg);
        }
        
        .faq-answer {
            padding: 0 1.5rem;
            max-height: 0;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .faq-answer.active {
            padding: 1.5rem;
            max-height: 500px;
        }
        
        .faq-answer p {
            color: #666;
            line-height: 1.6;
        }
        
        /* Responsive Design */
        @media (max-width: 992px) {
            .hero-section h1 {
                font-size: 2.5rem;
            }
            
            .hero-section .subtitle {
                font-size: 1.1rem;
            }
            
            .contact-grid {
                min-height: auto;
            }
        }
        
        @media (max-width: 768px) {
            .main-content {
                padding-top: 100px;
            }
            
            .hero-section {
                min-height: 60vh;
                background-attachment: scroll;
            }
            
            .hero-contact-cards {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .contact-grid {
                grid-template-columns: 1fr;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .contact-info, .contact-form {
                padding: 2rem;
            }
            
            .map-container {
                height: 400px;
            }
        }
        
        @media (max-width: 576px) {
            .main-content {
                padding-top: 90px;
            }
            
            .hero-section {
                padding: 2rem 0;
            }
            
            .hero-section h1 {
                font-size: 2rem;
            }
            
            .contact-info, .contact-form {
                padding: 1.5rem;
            }
            
            .contact-item {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .contact-item .icon {
                margin-right: 0;
                margin-bottom: 1rem;
            }
            
            .map-info {
                padding: 1rem;
            }
            
            .map-info i {
                font-size: 2rem;
            }
            
            .map-info h3 {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>
    <!-- Include the navbar component -->
    <%@ include file="navbar.jsp" %>
    
    <!-- Main Content -->
    <main class="main-content">
        <!-- Hero Section with Background Image -->
        <section class="hero-section" id="heroSection">
            <div class="hero-content">
                <h1>CONTACT US</h1>
                <p class="subtitle">Ready to transform your fitness journey? Get in touch with our team and let us help you achieve your health and wellness goals.</p>
                
                <div class="hero-contact-cards">
                    <div class="hero-contact-card">
                        <div class="icon">
                            <i class="fi fi-rr-marker"></i>
                        </div>
                        <h3>ADDRESS</h3>
                        <p>Kathmandu, Bagmati<br>Province, Nepal</p>
                    </div>
                    
                    <div class="hero-contact-card">
                        <div class="icon">
                            <i class="fi fi-rr-phone-call"></i>
                        </div>
                        <h3>PHONE</h3>
                        <p>+977-1-234-5678<br>+977-98-12345678</p>
                    </div>
                    
                    <div class="hero-contact-card">
                        <div class="icon">
                            <i class="fi fi-rr-envelope"></i>
                        </div>
                        <h3>EMAIL</h3>
                        <p>support@fittrack.com<br>info@fittrack.com</p>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Contact Section -->
        <section class="contact-section">
            <div class="container">
                <div class="contact-wrapper">
                    <div class="contact-grid">
                        <!-- Contact Information -->
                        <div class="contact-info">
                            <h2>Get in Touch</h2>
                            <p class="subtitle">We're here to help you on your fitness journey. Reach out to us anytime!</p>
                            
                            <div class="contact-item">
                                <div class="icon">
                                    <i class="fi fi-rr-marker"></i>
                                </div>
                                <div class="info">
                                    <h3>Visit Our Office</h3>
                                    <p>Kathmandu, Bagmati Province<br>Nepal 44600</p>
                                </div>
                            </div>
                            
                            <div class="contact-item">
                                <div class="icon">
                                    <i class="fi fi-rr-phone-call"></i>
                                </div>
                                <div class="info">
                                    <h3>Call Us</h3>
                                    <p>+977-1-234-5678<br>+977-98-12345678</p>
                                </div>
                            </div>
                            
                            <div class="contact-item">
                                <div class="icon">
                                    <i class="fi fi-rr-envelope"></i>
                                </div>
                                <div class="info">
                                    <h3>Email Us</h3>
                                    <p>support@fittrack.com<br>info@fittrack.com</p>
                                </div>
                            </div>
                            
                            <div class="contact-item">
                                <div class="icon">
                                    <i class="fi fi-rr-clock"></i>
                                </div>
                                <div class="info">
                                    <h3>Business Hours</h3>
                                    <p>Mon - Fri: 9:00 AM - 6:00 PM<br>Sat - Sun: 10:00 AM - 4:00 PM</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Contact Form -->
                        <div class="contact-form">
                            <h2>Send Message</h2>
                            <p class="subtitle">Fill out the form below and we'll get back to you as soon as possible.</p>
                            
                            <form id="contactForm">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="firstName">First Name *</label>
                                        <input type="text" id="firstName" name="firstName" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="lastName">Last Name *</label>
                                        <input type="text" id="lastName" name="lastName" required>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="email">Email Address *</label>
                                        <input type="email" id="email" name="email" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="phone">Phone Number</label>
                                        <input type="tel" id="phone" name="phone">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="subject">Subject *</label>
                                    <select id="subject" name="subject" required>
                                        <option value="">Select a subject</option>
                                        <option value="general">General Inquiry</option>
                                        <option value="support">Technical Support</option>
                                        <option value="feedback">Feedback</option>
                                        <option value="partnership">Partnership</option>
                                        <option value="bug">Bug Report</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="message">Message *</label>
                                    <textarea id="message" name="message" placeholder="Tell us how we can help you..." required></textarea>
                                </div>
                                
                                <button type="submit" class="btn-submit">
                                    <i class="fi fi-rr-paper-plane"></i>
                                    Send Message
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Map Section -->
        <section class="map-section">
            <div class="container">
                <div class="map-container">
                    <div class="map-info">
                        <i class="fi fi-rr-map"></i>
                        <h3>Our Location</h3>
                        <p>Kathmandu, Bagmati Province, Nepal</p>
                    </div>
                    <iframe 
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3532.460389108761!2d85.35138934748827!3d27.683874388203755!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMjfCsDQxJzAyLjAiTiA4NcKwMjEnMDUuMCJF!5e0!3m2!1sen!2snp!4v1620000000000!5m2!1sen!2snp" 
                        allowfullscreen="" 
                        loading="lazy"
                        referrerpolicy="no-referrer-when-downgrade">
                    </iframe>
                </div>
            </div>
        </section>
    </main>
    
    <script>
        // Check if background image loads
        function checkBackgroundImage() {
            const hero = document.querySelector('.hero-section');
            const img = new Image();
            
            img.onload = function() {
                console.log('✅ Contact background image loaded successfully');
            };
            
            img.onerror = function() {
                console.log('❌ Contact background image failed, using fallback');
                hero.classList.add('no-image');
            };
            
            img.src = 'images/contactus.jpg';
        }
        
        // Contact form submission
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Simple form validation
            const firstName = document.getElementById('firstName').value.trim();
            const lastName = document.getElementById('lastName').value.trim();
            const email = document.getElementById('email').value.trim();
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value.trim();
            
            if (!firstName || !lastName || !email || !subject || !message) {
                alert('Please fill in all required fields.');
                return;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('Please enter a valid email address.');
                return;
            }
            
            // Simulate form submission
            const submitBtn = document.querySelector('.btn-submit');
            const originalText = submitBtn.innerHTML;
            
            submitBtn.innerHTML = '<i class="fi fi-rr-spinner"></i> Sending...';
            submitBtn.disabled = true;
            
            setTimeout(() => {
                alert('Thank you for your message! We\'ll get back to you soon.');
                this.reset();
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 2000);
        });
        
        // Add loading animation
        document.addEventListener('DOMContentLoaded', function() {
            console.log('📞 Contact page loaded successfully!');
            checkBackgroundImage();
        });
    </script>
</body>
</html>
