<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion - PHARMACIE MOUHAMED</title>
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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }

        .auth-container {
            min-height: 100vh;
            display: flex;
        }

        /* Section gauche - Illustration */
        .illustration-section {
            background: linear-gradient(135deg, #1e7e34 0%, #28a745 100%);
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .illustration-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="pill" patternUnits="userSpaceOnUse" width="20" height="20"><circle cx="10" cy="10" r="1" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23pill)"/></svg>');
            opacity: 0.3;
        }

        .illustration-content {
            text-align: center;
            color: white;
            z-index: 2;
            position: relative;
        }

        .pharma-icon {
            width: 120px;
            height: 120px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            backdrop-filter: blur(10px);
        }

        .pharma-icon i {
            font-size: 48px;
            color: white;
        }

        .illustration-title {
            font-size: 2.5em;
            font-weight: 700;
            margin-bottom: 15px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .illustration-subtitle {
            font-size: 1.2em;
            opacity: 0.9;
            line-height: 1.6;
        }

        /* Section droite - Formulaire */
        .form-section {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            background: white;
        }

        .form-container {
            width: 100%;
            max-width: 400px;
        }

        .form-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .form-title {
            font-size: 2.2em;
            font-weight: 700;
            color: #1e7e34;
            margin-bottom: 10px;
        }

        .form-subtitle {
            color: #6c757d;
            font-size: 1.1em;
        }

        /* Messages d'erreur/succès */
        .message-container {
            margin-bottom: 20px;
        }

        .message {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.95em;
            margin-bottom: 10px;
            border-left: 4px solid;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border-color: #dc3545;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border-color: #28a745;
        }

        /* Onglets de navigation */
        .tab-navigation {
            display: flex;
            background: #f8f9fa;
            border-radius: 12px;
            padding: 4px;
            margin-bottom: 30px;
        }

        .tab-btn {
            flex: 1;
            padding: 12px 20px;
            border: none;
            background: transparent;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1em;
            color: #6c757d;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .tab-btn.active {
            background: #28a745;
            color: white;
            box-shadow: 0 2px 8px rgba(40,167,69,0.3);
        }

        /* Formulaires */
        .form-content {
            display: none;
        }

        .form-content.active {
            display: block;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-input:focus {
            outline: none;
            border-color: #28a745;
            background: white;
            box-shadow: 0 0 0 3px rgba(40,167,69,0.1);
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .form-select {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 1em;
            background: #f8f9fa;
            transition: all 0.3s ease;
        }

        .form-select:focus {
            outline: none;
            border-color: #28a745;
            background: white;
            box-shadow: 0 0 0 3px rgba(40,167,69,0.1);
        }

        /* Bouton de soumission */
        .submit-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 10px;
            color: white;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .submit-btn:hover {
            background: linear-gradient(135deg, #1e7e34 0%, #17a2b8 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40,167,69,0.3);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        /* Liens de navigation */
        .register-link, .login-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }

        .register-link p, .login-link p {
            color: #6c757d;
            font-size: 0.95em;
            margin: 0;
        }

        .register-link a, .login-link a {
            color: #28a745;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .register-link a:hover, .login-link a:hover {
            color: #1e7e34;
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .auth-container {
                flex-direction: column;
            }
            
            .illustration-section {
                min-height: 200px;
                padding: 40px 20px;
            }
            
            .form-section {
                padding: 30px 20px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <!-- Section gauche - Illustration -->
        <div class="illustration-section">
            <div class="illustration-content">
                <div class="pharma-icon">
                    <i class="fas fa-clinic-medical"></i>
                </div>
                <h1 class="illustration-title">PHARMACIE MOUHAMED</h1>
                <p class="illustration-subtitle">
                    Système de gestion de stock avancé<br>
                    Optimisez votre pharmacie avec nos outils innovants
                </p>
            </div>
        </div>

        <!-- Section droite - Formulaire -->
        <div class="form-section">
            <div class="form-container">
                <div class="form-header">
                    <h2 class="form-title">Connexion</h2>
                    <p class="form-subtitle">Accédez à votre espace de gestion</p>
                </div>

                <!-- Messages d'erreur/succès -->
                <div class="message-container">
                    <% if (request.getAttribute("loginError") != null) { %>
                        <div class="message error">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <%= request.getAttribute("loginError") %>
                        </div>
                    <% } %>
                    <% if (request.getAttribute("registerError") != null) { %>
                        <div class="message error">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <%= request.getAttribute("registerError") %>
                        </div>
                    <% } %>
                    <% if (request.getAttribute("registerSuccess") != null) { %>
                        <div class="message success">
                            <i class="fas fa-check-circle me-2"></i>
                            <%= request.getAttribute("registerSuccess") %>
                        </div>
                    <% } %>
                </div>

                <!-- Formulaire de connexion -->
                <div id="login-form" class="form-content active">
                    <form action="auth" method="post">
                        <input type="hidden" name="action" value="login"/>
                        
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-input" placeholder="votre@email.com" required />
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Mot de passe</label>
                            <input type="password" name="motDePasse" class="form-input" placeholder="••••••••" required />
                        </div>
                        
                        <button type="submit" class="submit-btn">
                            <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                        </button>
                    </form>
                    
                    <!-- Lien pour s'inscrire -->
                    <div class="register-link">
                        <p>Pas encore de compte ? <a href="#" onclick="showRegisterForm()">S'inscrire</a></p>
                    </div>
                </div>

                <!-- Formulaire d'inscription -->
                <div id="register-form" class="form-content">
                    <form action="auth" method="post">
                        <input type="hidden" name="action" value="register"/>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Nom</label>
                                <input type="text" name="nom" class="form-input" placeholder="Votre nom" required />
                            </div>
                            <div class="form-group">
                                <label class="form-label">Prénom</label>
                                <input type="text" name="prenom" class="form-input" placeholder="Votre prénom" required />
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-input" placeholder="votre@email.com" required />
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Login</label>
                            <input type="text" name="login" class="form-input" placeholder="Nom d'utilisateur" required />
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Mot de passe</label>
                            <input type="password" name="motDePasse" class="form-input" placeholder="••••••••" required />
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Rôle</label>
                            <select name="role" class="form-select" required>
                                <option value="">Sélectionnez un rôle</option>
                                <option value="ADMIN">Administrateur</option>
                                <option value="PHARMACIEN">Pharmacien</option>
        
                            </select>
                        </div>
                        
                        <button type="submit" class="submit-btn">
                            <i class="fas fa-user-plus me-2"></i>Créer un compte
                        </button>
                    </form>
                    
                    <!-- Lien pour se connecter -->
                    <div class="login-link">
                        <p>Déjà un compte ? <a href="#" onclick="showLoginForm()">Se connecter</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showRegisterForm() {
            document.getElementById('login-form').classList.remove('active');
            document.getElementById('register-form').classList.add('active');
        }

        function showLoginForm() {
            document.getElementById('register-form').classList.remove('active');
            document.getElementById('login-form').classList.add('active');
        }

        // Animation d'entrée
        document.addEventListener('DOMContentLoaded', function() {
            const formContainer = document.querySelector('.form-container');
            formContainer.style.opacity = '0';
            formContainer.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                formContainer.style.transition = 'all 0.6s ease';
                formContainer.style.opacity = '1';
                formContainer.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>
</body>
</html>
