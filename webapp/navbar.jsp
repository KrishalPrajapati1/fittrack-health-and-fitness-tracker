<%-- navbar.jsp - Reusable Navigation Component --%>
<!-- Flaticon CSS -->
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.0.0/uicons-bold-rounded/css/uicons-bold-rounded.css">
<link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.0.0/uicons-solid-rounded/css/uicons-solid-rounded.css">

<style>
    /* Navbar Styles */
    .navbar {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        padding: 1rem 0;
        position: fixed;
        top: 0;
        width: 100%;
        z-index: 1000;
        box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        transition: all 0.3s ease;
    }
    
    .nav-container {
        width: 100%;
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .logo {
        display: flex;
        align-items: center;
        text-decoration: none;
    }
    
    .logo img {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
    }
    
    .logo-fallback {
        width: 80px;
        height: 80px;
        font-size: 3.2rem;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #667eea;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 50%;
        color: white;
    }
    
    .nav-links {
        display: flex;
        list-style: none;
        gap: 1.5rem;
        align-items: center;
        flex: 1;
        justify-content: center;
        margin: 0 2rem;
    }
    
    .nav-links a {
        text-decoration: none;
        color: #333;
        font-weight: 500;
        transition: color 0.3s ease;
        position: relative;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .nav-links a:hover {
        color: #667eea;
    }
    
    .nav-links a::after {
        content: '';
        position: absolute;
        bottom: -5px;
        left: 0;
        width: 0;
        height: 2px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        transition: width 0.3s ease;
    }
    
    .nav-links a:hover::after {
        width: 100%;
    }
    
    /* Active link styling */
    .nav-links a.active {
        color: #667eea;
    }
    
    .nav-links a.active::after {
        width: 100%;
    }
    
    .auth-buttons {
        display: flex;
        gap: 0.8rem;
        flex-shrink: 0;
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
    
    .btn-outline {
        background: transparent;
        color: #667eea;
        border: 2px solid #667eea;
    }
    
    .btn-outline:hover {
        background: #667eea;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: 2px solid transparent;
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
    }
    
    /* Mobile Menu */
    .mobile-menu-toggle {
        display: none;
        background: none;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
        color: #333;
    }
    
    /* Responsive Design */
    @media (max-width: 1200px) {
        .nav-container {
            padding: 0 1.5rem;
        }
        
        .nav-links {
            gap: 1rem;
            margin: 0 1rem;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
        }
    }
    
    @media (max-width: 768px) {
        .mobile-menu-toggle {
            display: block;
        }
        
        .nav-links {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            flex-direction: column;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .nav-links.active {
            display: flex;
        }
        
        .logo img, .logo-fallback {
            width: 70px;
            height: 70px;
        }
        
        .logo-fallback {
            font-size: 2.8rem;
        }
    }
    
    @media (max-width: 480px) {
        .nav-container {
            padding: 0 1rem;
        }
        
        .logo img, .logo-fallback {
            width: 65px;
            height: 65px;
        }
        
        .logo-fallback {
            font-size: 2.5rem;
        }
    }
</style>

<!-- Navigation -->
<nav class="navbar">
    <div class="nav-container">
        <a href="home.jsp" class="logo">
            <img src="images/logo1.png" alt="FitTrack Logo" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
            <div class="logo-fallback" style="display: none;">
                <i class="fi fi-sr-dumbbell"></i>
            </div>
        </a>
        
        <ul class="nav-links" id="navLinks">
            <li><a href="home.jsp" id="homeLink"><i class="fi fi-rr-home"></i> Home</a></li>
            <li><a href="home.jsp#features" id="featuresLink"><i class="fi fi-rr-star"></i> Features</a></li>
            <li><a href="about.jsp" id="aboutLink"><i class="fi fi-rr-info"></i> About</a></li>
            <li><a href="contact.jsp" id="contactLink"><i class="fi fi-rr-envelope"></i> Contact</a></li>
        </ul>
        
        <!-- Desktop auth buttons -->
        <div class="auth-buttons">
            <a href="login.jsp" class="btn btn-outline">
                <i class="fi fi-rr-sign-in-alt"></i>
                Login
            </a>
            <a href="register.jsp" class="btn btn-primary">
                <i class="fi fi-rr-user-add"></i>
                Get Started
            </a>
        </div>
        
        <button class="mobile-menu-toggle" onclick="toggleMobileMenu()">
            <i class="fi fi-rr-menu-burger"></i>
        </button>
    </div>
</nav>

<script>
    // Mobile menu toggle
    function toggleMobileMenu() {
        const navLinks = document.getElementById('navLinks');
        navLinks.classList.toggle('active');
    }
    
    // Function to set active navigation link
    function setActiveNavLink() {
        const currentPage = window.location.pathname.split('/').pop() || 'home.jsp';
        const links = document.querySelectorAll('.nav-links a');
        
        // Remove active class from all links
        links.forEach(link => link.classList.remove('active'));
        
        // Add active class to current page link
        if (currentPage === 'home.jsp' || currentPage === '' || currentPage === '/') {
            document.getElementById('homeLink').classList.add('active');
        } else if (currentPage === 'about.jsp') {
            document.getElementById('aboutLink').classList.add('active');
        } else if (currentPage === 'contact.jsp') {
            document.getElementById('contactLink').classList.add('active');
        }
    }
    
    // Smooth scrolling for anchor links (only when on the same page)
    document.querySelectorAll('a[href*="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            const currentPage = window.location.pathname.split('/').pop() || 'home.jsp';
            
            // If it's a link to features section and we're not on home page
            if (href.includes('#features') && currentPage !== 'home.jsp') {
                // Let the browser handle the navigation normally
                return;
            }
            
            // If it's an anchor link on the same page
            if (href.startsWith('#')) {
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    });
    
    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.style.background = 'rgba(255, 255, 255, 0.98)';
            navbar.style.boxShadow = '0 2px 20px rgba(0,0,0,0.15)';
        } else {
            navbar.style.background = 'rgba(255, 255, 255, 0.95)';
            navbar.style.boxShadow = '0 2px 20px rgba(0,0,0,0.1)';
        }
    });
    
    // Close mobile menu when clicking outside
    document.addEventListener('click', function(event) {
        const navLinks = document.getElementById('navLinks');
        const mobileToggle = document.querySelector('.mobile-menu-toggle');
        const navbar = document.querySelector('.navbar');
        
        if (!navbar.contains(event.target)) {
            navLinks.classList.remove('active');
        }
    });
    
    // Close mobile menu when window is resized
    window.addEventListener('resize', function() {
        const navLinks = document.getElementById('navLinks');
        if (window.innerWidth > 768) {
            navLinks.classList.remove('active');
        }
    });
    
    // Set active link when page loads
    document.addEventListener('DOMContentLoaded', function() {
        setActiveNavLink();
    });
</script>
