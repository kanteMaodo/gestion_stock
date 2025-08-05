<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion - PHARMACIE MOUHAMED</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
        .container-fluid {
            height: 100vh;
            padding: 0;
        }
        .row {
            height: 100%;
            margin: 0;
        }
        .col-lg-6 {
            padding: 0;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <!-- Section gauche (illustration) -->
            <div class="col-lg-6 bg-success d-flex align-items-center justify-content-center text-white p-5">
                <div class="text-center">
                    <i class="fas fa-pills fa-5x mb-4"></i>
                    <h2 class="display-4 fw-bold mb-3">PHARMACIE MOUHAMED</h2>
                    <p class="lead mb-0">Gestion intelligente de votre pharmacie</p>
                    <p class="text-white-50">Système de gestion complet pour optimiser vos opérations</p>
                </div>
            </div>

            <!-- Section droite (formulaire) -->
            <div class="col-lg-6 d-flex align-items-center justify-content-center p-5">
                <div class="w-100" style="max-width: 400px;">
                    <div class="text-center mb-4">
                        <h2 class="display-6 fw-bold text-success mb-2">Connexion</h2>
                        <p class="text-muted">Accédez à votre espace de gestion</p>
                    </div>

                    <!-- Messages d'erreur/succès -->
                    <div class="mb-4">
                        <% if (request.getAttribute("loginError") != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <%= request.getAttribute("loginError") %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        <% if (request.getAttribute("registerError") != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <%= request.getAttribute("registerError") %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        <% if (request.getAttribute("registerSuccess") != null) { %>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <%= request.getAttribute("registerSuccess") %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                    </div>

                    <!-- Formulaire de connexion -->
                    <div id="login-form">
                        <form action="auth" method="post">
                            <input type="hidden" name="action" value="login"/>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Email</label>
                                <input type="email" name="email" class="form-control form-control-lg" placeholder="votre@email.com" required />
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Mot de passe</label>
                                <input type="password" name="motDePasse" class="form-control form-control-lg" placeholder="••••••••" required />
                            </div>
                            
                            <button type="submit" class="btn btn-success btn-lg w-100 mb-3">
                                <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                            </button>
                        </form>
                        
                        <!-- Lien pour s'inscrire -->
                        <div class="text-center pt-3 border-top">
                            <p class="text-muted mb-0">Pas encore de compte ? <a href="#" class="text-success fw-semibold text-decoration-none" onclick="showRegisterForm()">S'inscrire</a></p>
                        </div>
                    </div>

                    <!-- Formulaire d'inscription -->
                    <div id="register-form" style="display: none;">
                        <form action="auth" method="post">
                            <input type="hidden" name="action" value="register"/>
                            
                            <div class="row mb-3">
                                <div class="col">
                                    <label class="form-label fw-semibold">Nom</label>
                                    <input type="text" name="nom" class="form-control form-control-lg" placeholder="Votre nom" required />
                                </div>
                                <div class="col">
                                    <label class="form-label fw-semibold">Prénom</label>
                                    <input type="text" name="prenom" class="form-control form-control-lg" placeholder="Votre prénom" required />
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Email</label>
                                <input type="email" name="email" class="form-control form-control-lg" placeholder="votre@email.com" required />
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Login</label>
                                <input type="text" name="login" class="form-control form-control-lg" placeholder="Nom d'utilisateur" required />
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Mot de passe</label>
                                <input type="password" name="motDePasse" class="form-control form-control-lg" placeholder="••••••••" required />
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Rôle</label>
                                <select name="role" class="form-select form-select-lg" required>
                                    <option value="">Sélectionnez un rôle</option>
                                    <option value="ADMIN">Administrateur</option>
                                    <option value="PHARMACIEN">Pharmacien</option>
                                </select>
                            </div>
                            
                            <button type="submit" class="btn btn-success btn-lg w-100 mb-3">
                                <i class="fas fa-user-plus me-2"></i>Créer un compte
                            </button>
                        </form>
                        
                        <!-- Lien pour se connecter -->
                        <div class="text-center pt-3 border-top">
                            <p class="text-muted mb-0">Déjà un compte ? <a href="#" class="text-success fw-semibold text-decoration-none" onclick="showLoginForm()">Se connecter</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showRegisterForm() {
            document.getElementById('login-form').style.display = 'none';
            document.getElementById('register-form').style.display = 'block';
        }

        function showLoginForm() {
            document.getElementById('register-form').style.display = 'none';
            document.getElementById('login-form').style.display = 'block';
        }
    </script>
</body>
</html>
