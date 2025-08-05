<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Authentification - PHARMACIE MOUHAMED</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2c7a7b;
            --primary-dark: #234f4f;
            --primary-light: #4fd1c7;
            --secondary-color: #38a169;
            --accent-color: #ed8936;
            --text-dark: #1a202c;
            --text-light: #718096;
            --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --shadow-light: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-medium: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            --shadow-heavy: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        .auth-container {
            min-height: 100vh;
            background: var(--bg-gradient);
            display: flex;
            align-items: center;
            padding: 2rem 0;
        }

        .auth-card {
            background: white;
            border-radius: 24px;
            box-shadow: var(--shadow-heavy);
            overflow: hidden;
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
        }

        .brand-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            padding: 4rem 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .brand-section::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(-50%, -50%) rotate(0deg); }
            50% { transform: translate(-50%, -50%) rotate(180deg); }
        }

        .brand-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin-bottom: 2rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            position: relative;
            z-index: 2;
        }

        .brand-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            letter-spacing: -0.02em;
            position: relative;
            z-index: 2;
        }

        .brand-subtitle {
            font-size: 1.25rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            opacity: 0.95;
            position: relative;
            z-index: 2;
        }

        .brand-description {
            font-size: 1rem;
            opacity: 0.8;
            line-height: 1.6;
            position: relative;
            z-index: 2;
        }

        .form-section {
            padding: 4rem 3rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-container {
            width: 100%;
            max-width: 400px;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .form-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            letter-spacing: -0.02em;
        }

        .form-subtitle {
            color: var(--text-light);
            font-size: 1rem;
            font-weight: 400;
        }

        .alert-custom {
            border: none;
            border-radius: 12px;
            padding: 1rem 1.25rem;
            font-weight: 500;
            margin-bottom: 1.5rem;
        }

        .alert-danger-custom {
            background: rgba(254, 226, 226, 0.8);
            color: #c53030;
            border-left: 4px solid #e53e3e;
        }

        .alert-success-custom {
            background: rgba(236, 253, 245, 0.8);
            color: #276749;
            border-left: 4px solid var(--secondary-color);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label-custom {
            display: block;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-input {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
            color: var(--text-dark);
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(44, 122, 123, 0.1);
            transform: translateY(-1px);
        }

        .form-input::placeholder {
            color: #a0aec0;
        }

        .btn-primary-custom {
            width: 100%;
            padding: 0.875rem 1.5rem;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            border-radius: 12px;
            color: white;
            font-size: 1rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .btn-primary-custom:active {
            transform: translateY(0);
        }

        .btn-primary-custom::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-primary-custom:hover::before {
            left: 100%;
        }

        .divider {
            margin: 2rem 0;
            text-align: center;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e2e8f0;
        }

        .divider-text {
            background: white;
            padding: 0 1rem;
            color: var(--text-light);
            font-size: 0.875rem;
            font-weight: 500;
        }

        .switch-form {
            text-align: center;
        }

        .switch-form a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
        }

        .switch-form a:hover {
            color: var(--primary-dark);
        }

        .switch-form a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--primary-color);
            transition: width 0.3s ease;
        }

        .switch-form a:hover::after {
            width: 100%;
        }

        .row-equal-height {
            display: flex;
            align-items: stretch;
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .slide-in {
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @media (max-width: 991.98px) {
            .brand-section {
                padding: 3rem 2rem;
            }

            .form-section {
                padding: 3rem 2rem;
            }

            .brand-title {
                font-size: 2rem;
            }

            .brand-subtitle {
                font-size: 1.125rem;
            }
        }

        @media (max-width: 576px) {
            .auth-container {
                padding: 1rem;
            }

            .auth-card {
                border-radius: 16px;
                margin: 1rem;
            }

            .brand-section, .form-section {
                padding: 2rem 1.5rem;
            }

            .brand-title {
                font-size: 1.75rem;
            }

            .form-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
<div class="auth-container">
    <div class="container">
        <div class="auth-card">
            <div class="row row-equal-height g-0">
                <!-- Section de marque -->
                <div class="col-lg-6">
                    <div class="brand-section h-100">
                        <div class="brand-icon">
                            <i class="fas fa-pills"></i>
                        </div>
                        <h1 class="brand-title">PHARMACIE MOUHAMED</h1>
                        <p class="brand-subtitle">Gestion intelligente de votre pharmacie</p>
                        <p class="brand-description">
                            Système de gestion complet et moderne pour optimiser toutes vos opérations pharmaceutiques avec sécurité et efficacité.
                        </p>
                    </div>
                </div>

                <!-- Section formulaire -->
                <div class="col-lg-6">
                    <div class="form-section h-100">
                        <div class="form-container">
                            <!-- En-tête du formulaire -->
                            <div class="form-header">
                                <h2 class="form-title" id="form-title">Connexion</h2>
                                <p class="form-subtitle" id="form-subtitle">Accédez à votre espace de gestion</p>
                            </div>

                            <!-- Messages d'erreur/succès -->
                            <% if (request.getAttribute("loginError") != null) { %>
                            <div class="alert alert-custom alert-danger-custom fade-in" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <%= request.getAttribute("loginError") %>
                            </div>
                            <% } %>
                            <% if (request.getAttribute("registerError") != null) { %>
                            <div class="alert alert-custom alert-danger-custom fade-in" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <%= request.getAttribute("registerError") %>
                            </div>
                            <% } %>
                            <% if (request.getAttribute("registerSuccess") != null) { %>
                            <div class="alert alert-custom alert-success-custom fade-in" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <%= request.getAttribute("registerSuccess") %>
                            </div>
                            <% } %>

                            <!-- Formulaire de connexion -->
                            <div id="login-form" class="fade-in">
                                <form action="auth" method="post">
                                    <input type="hidden" name="action" value="login"/>

                                    <div class="form-group">
                                        <label class="form-label-custom">Email</label>
                                        <input type="email" name="email" class="form-input" placeholder="votre@email.com" required />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label-custom">Mot de passe</label>
                                        <input type="password" name="motDePasse" class="form-input" placeholder="••••••••" required />
                                    </div>

                                    <button type="submit" class="btn btn-primary-custom">
                                        <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                                    </button>
                                </form>

                                <div class="divider">
                                    <span class="divider-text">Nouveau utilisateur ?</span>
                                </div>

                                <div class="switch-form">
                                    <a href="#" onclick="showRegisterForm()">Créer un compte</a>
                                </div>
                            </div>

                            <!-- Formulaire d'inscription -->
                            <div id="register-form" style="display: none;">
                                <form action="auth" method="post">
                                    <input type="hidden" name="action" value="register"/>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Nom</label>
                                                <input type="text" name="nom" class="form-input" placeholder="Votre nom" required />
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Prénom</label>
                                                <input type="text" name="prenom" class="form-input" placeholder="Votre prénom" required />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label-custom">Email</label>
                                        <input type="email" name="email" class="form-input" placeholder="votre@email.com" required />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label-custom">Nom d'utilisateur</label>
                                        <input type="text" name="login" class="form-input" placeholder="Nom d'utilisateur" required />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label-custom">Mot de passe</label>
                                        <input type="password" name="motDePasse" class="form-input" placeholder="••••••••" required />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label-custom">Rôle</label>
                                        <select name="role" class="form-input" required>
                                            <option value="">Sélectionnez un rôle</option>
                                            <option value="ADMIN">Administrateur</option>
                                            <option value="PHARMACIEN">Pharmacien</option>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn btn-primary-custom">
                                        <i class="fas fa-user-plus me-2"></i>Créer un compte
                                    </button>
                                </form>

                                <div class="divider">
                                    <span class="divider-text">Déjà membre ?</span>
                                </div>

                                <div class="switch-form">
                                    <a href="#" onclick="showLoginForm()">Se connecter</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function showRegisterForm() {
        const loginForm = document.getElementById('login-form');
        const registerForm = document.getElementById('register-form');
        const formTitle = document.getElementById('form-title');
        const formSubtitle = document.getElementById('form-subtitle');

        loginForm.style.display = 'none';
        registerForm.style.display = 'block';
        registerForm.classList.add('slide-in');

        formTitle.textContent = 'Inscription';
        formSubtitle.textContent = 'Créez votre compte professionnel';
    }

    function showLoginForm() {
        const loginForm = document.getElementById('login-form');
        const registerForm = document.getElementById('register-form');
        const formTitle = document.getElementById('form-title');
        const formSubtitle = document.getElementById('form-subtitle');

        registerForm.style.display = 'none';
        loginForm.style.display = 'block';
        loginForm.classList.add('slide-in');

        formTitle.textContent = 'Connexion';
        formSubtitle.textContent = 'Accédez à votre espace de gestion';
    }

    // Animation d'entrée au chargement
    document.addEventListener('DOMContentLoaded', function() {
        const authCard = document.querySelector('.auth-card');
        authCard.classList.add('fade-in');
    });

    // Amélioration de l'accessibilité
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            // Fermer les alertes avec Escape
            const alerts = document.querySelectorAll('.alert-custom');
            alerts.forEach(alert => alert.remove());
        }
    });
</script>
</body>
</html>