<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("utilisateur") != null) {
        response.sendRedirect("dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>PHARMACIE MOUHAMED - Accueil</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #e8f5e8 0%, #f1f8f1 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }

        /* Header Navigation */
        .navbar-pharma {
            background: linear-gradient(90deg, #1e7e34 0%, #28a745 100%);
            color: #fff;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            backdrop-filter: blur(10px);
            position: relative;
            z-index: 100;
        }

        .navbar-pharma::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="pill" patternUnits="userSpaceOnUse" width="20" height="20"><circle cx="10" cy="10" r="1" fill="rgba(255,255,255,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23pill)"/></svg>');
            opacity: 0.3;
        }

        .navbar-pharma .logo {
            display: flex;
            align-items: center;
            z-index: 2;
        }

        .navbar-pharma .logo svg {
            width: 45px;
            height: 45px;
            margin-right: 15px;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.2));
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .navbar-pharma .title {
            font-size: 1.6em;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            z-index: 2;
        }

        .navbar-pharma .nav-actions {
            display: flex;
            gap: 1rem;
            z-index: 2;
        }

        .nav-btn {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            text-decoration: none;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .nav-btn:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            transform: translateY(-2px);
        }

        /* Main Content Area */
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
            position: relative;
            overflow: hidden;
            width: 100%;
        }

        .main-content::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(40,167,69,0.05) 0%, transparent 70%);
            animation: rotate 30s linear infinite;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Welcome Container */
        .welcome-container {
            background: rgba(255,255,255,0.95);
            border-radius: 0;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 3rem 2.5rem;
            width: 100%;
            text-align: center;
            backdrop-filter: blur(20px);
            border: none;
            border-top: 4px solid #28a745;
            border-bottom: 4px solid #28a745;
            position: relative;
            z-index: 2;
            transform: translateY(0);
            animation: slideUp 0.6s ease-out;
            margin: 0;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .welcome-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #28a745, #20c997, #28a745);
            border-radius: 0;
        }

        /* Pharmacy Branding */
        .pharma-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            box-shadow: 0 8px 25px rgba(40,167,69,0.3);
        }

        .pharma-icon i {
            font-size: 2.5rem;
            color: white;
        }

        .pharma-title {
            color: #1e7e34;
            font-size: 2.5em;
            font-weight: 800;
            letter-spacing: 1.5px;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, #1e7e34, #28a745);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .pharma-subtitle {
            color: #6c757d;
            font-size: 1.3em;
            margin-bottom: 2rem;
            font-weight: 500;
            position: relative;
        }

        .pharma-subtitle::after {
            content: '';
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #28a745, #20c997);
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 2px;
        }

        /* Features Grid */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }

        .feature-card {
            background: rgba(248,249,250,0.8);
            padding: 1.5rem;
            border-radius: 16px;
            border: 1px solid rgba(40,167,69,0.1);
            transition: all 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(40,167,69,0.15);
            border-color: rgba(40,167,69,0.3);
        }

        .feature-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }

        .feature-icon i {
            font-size: 1.5rem;
            color: #1976d2;
        }

        .feature-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .feature-desc {
            font-size: 0.9rem;
            color: #6c757d;
            line-height: 1.4;
        }

        /* Welcome Message */
        .welcome-msg {
            color: #495057;
            margin-bottom: 2.5rem;
            font-size: 1.1em;
            line-height: 1.6;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Login Button */
        .btn-login {
            font-size: 1.2em;
            padding: 16px 3rem;
            width: auto;
            min-width: 200px;
            border-radius: 50px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(40,167,69,0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-login:hover::before {
            left: 100%;
        }

        .btn-login:hover {
            background: linear-gradient(135deg, #1e7e34 0%, #17a2b8 100%);
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(40,167,69,0.4);
            color: white;
        }

        .btn-login:active {
            transform: translateY(-1px);
        }

        /* Footer */
        footer {
            background: linear-gradient(90deg, #1e7e34 0%, #28a745 100%);
            color: #fff;
            text-align: center;
            padding: 2rem 0;
            margin-top: auto;
            font-size: 1em;
            letter-spacing: 0.5px;
            position: relative;
        }

        footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .footer-links {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .footer-links a {
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: white;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .navbar-pharma {
                padding: 0 1rem;
                height: 65px;
            }

            .navbar-pharma .title {
                font-size: 1.2em;
            }

            .navbar-pharma .logo svg {
                width: 35px;
                height: 35px;
                margin-right: 10px;
            }

            .nav-actions {
                display: none;
            }

            .welcome-container {
                padding: 2rem 1.5rem;
                margin: 0;
            }

            .pharma-title {
                font-size: 2em;
            }

            .features-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .main-content {
                padding: 1rem 0;
            }

            .footer-links {
                flex-direction: column;
                gap: 0.5rem;
            }
        }

        @media (max-width: 480px) {
            .navbar-pharma .title {
                font-size: 1em;
            }

            .pharma-title {
                font-size: 1.8em;
            }

            .btn-login {
                padding: 14px 2rem;
                font-size: 1.1em;
                min-width: 180px;
            }
        }

        /* Loading Animation */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.9);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #e3f2fd;
            border-top: 4px solid #28a745;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="loading-spinner"></div>
</div>

<!-- Navigation Header -->
<nav class="navbar-pharma">
    <div class="logo">
        <svg viewBox="0 0 64 64" fill="none">
            <rect x="26" y="8" width="12" height="48" rx="6" fill="#fff"/>
            <rect x="8" y="26" width="48" height="12" rx="6" fill="#fff"/>
            <circle cx="32" cy="32" r="28" stroke="#fff" stroke-width="2" fill="none" opacity="0.3"/>
        </svg>
    </div>
    <div class="title">GESTION DE STOCK PHARMACIE</div>
    <div class="nav-actions">
        <a href="#" class="nav-btn">
            <i class="fas fa-info-circle"></i> À propos
        </a>

    </div>
</nav>

<!-- Main Content -->
<div class="main-content">
    <div class="welcome-container">
        <!-- Pharmacy Icon -->
        <div class="pharma-icon">
            <i class="fas fa-pills"></i>
        </div>

        <!-- Title and Branding -->
        <div class="pharma-title">PHARMACIE MOUHAMED</div>
        <div class="pharma-subtitle">Système de Gestion Avancé</div>

        <!-- Features Grid -->
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-boxes"></i>
                </div>
                <div class="feature-title">Gestion des Stocks</div>
                <div class="feature-desc">Suivi en temps réel des médicaments et alertes automatiques</div>
            </div>

            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="feature-title">Analyse des Ventes</div>
                <div class="feature-desc">Rapports détaillés et statistiques de performance</div>
            </div>

            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <div class="feature-title">Sécurité Avancée</div>
                <div class="feature-desc">Protection des données et accès sécurisé</div>
            </div>
        </div>

        <!-- Welcome Message -->
        <div class="welcome-msg">
            Plateforme professionnelle conçue pour optimiser la gestion pharmaceutique.
            Contrôlez vos stocks, analysez vos performances et développez votre activité
            avec nos outils innovants.
        </div>

        <!-- Login Button -->
        <a href="auth" class="btn btn-login">
            <i class="fas fa-sign-in-alt"></i>
            Accéder au Système
        </a>
    </div>
</div>

<!-- Footer -->
<footer>
    <div class="footer-content">
        <div class="footer-links">
            <a href="#">Politique de Confidentialité</a>
            <a href="#">Conditions d'Utilisation</a>
            <a href="#">Support Technique</a>
            <a href="#">Documentation</a>
        </div>
        <div>
            &copy; 2024 PHARMACIE MOUHAMED &mdash; Tous droits réservés.
            <br>
            <i class="fas fa-envelope"></i> contact@pharmacie-mouhamed.com
            <span style="margin: 0 1rem;">|</span>
            <i class="fas fa-phone"></i> +221 XX XXX XX XX
        </div>
    </div>
</footer>

<script>
    // Smooth loading transition
    window.addEventListener('load', function() {
        setTimeout(() => {
            document.getElementById('loadingOverlay').style.opacity = '0';
            document.getElementById('loadingOverlay').style.visibility = 'hidden';
        }, 500);
    });

    // Enhanced button interaction
    document.querySelector('.btn-login').addEventListener('click', function(e) {
        this.style.transform = 'translateY(-1px) scale(0.98)';
        setTimeout(() => {
            this.style.transform = '';
        }, 150);
    });

    // Parallax effect for background
    let tilt = 0;
    setInterval(() => {
        tilt += 0.5;
        document.querySelector('.main-content::before') &&
        (document.querySelector('.main-content').style.setProperty('--tilt', tilt + 'deg'));
    }, 100);
</script>
</body>
</html>