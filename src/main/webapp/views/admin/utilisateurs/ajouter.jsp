<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ajouter un Utilisateur - PHARMACIE MOUHAMED</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 bg-success text-white min-vh-100 p-0">
                <div class="p-3">
                    <h4 class="text-white mb-4">
                        PHARMACIE
                    </h4>
                </div>
                <nav class="nav flex-column">
                    <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
                    </a>
                    <a class="nav-link text-white active" href="${pageContext.request.contextPath}/utilisateurs/">
                        <i class="fas fa-users me-2"></i>Utilisateurs
                    </a>
                    <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/medicaments/">
                        <i class="fas fa-pills me-2"></i>Médicaments
                    </a>
                    <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/ventes/">
                        <i class="fas fa-shopping-cart me-2"></i>Ventes
                    </a>
                    <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/alertes/">
                        <i class="fas fa-exclamation-triangle me-2"></i>Alertes
                    </a>
                    <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 p-4">
                <!-- Header -->
                <div class="bg-white rounded shadow-sm p-4 mb-4">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="mb-0">Ajouter un Utilisateur</h2>
                            <p class="text-muted mb-0">Créer un nouveau compte utilisateur</p>
                        </div>
                        <div class="col-auto">
                            <a href="${pageContext.request.contextPath}/utilisateurs/" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Retour à la liste
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Messages d'alerte -->
                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Formulaire -->
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/utilisateurs/" method="post" id="userForm">
                            <input type="hidden" name="action" value="ajouter">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="nom" class="form-label fw-semibold">
                                            <i class="fas fa-user me-2"></i>Nom <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-lg" id="nom" name="nom" 
                                               required placeholder="Nom de famille">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="prenom" class="form-label fw-semibold">
                                            <i class="fas fa-user me-2"></i>Prénom <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-lg" id="prenom" name="prenom" 
                                               required placeholder="Prénom">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label fw-semibold">
                                            <i class="fas fa-envelope me-2"></i>Email <span class="text-danger">*</span>
                                        </label>
                                        <input type="email" class="form-control form-control-lg" id="email" name="email" 
                                               required placeholder="exemple@email.com">
                                        <div class="form-text">L'email servira également de login</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="login" class="form-label fw-semibold">
                                            <i class="fas fa-user-tag me-2"></i>Login <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-lg" id="login" name="login" 
                                               required placeholder="Nom d'utilisateur">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="motDePasse" class="form-label fw-semibold">
                                            <i class="fas fa-lock me-2"></i>Mot de passe <span class="text-danger">*</span>
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control form-control-lg" id="motDePasse" 
                                                   name="motDePasse" required placeholder="••••••••">
                                            <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </div>
                                        <div class="form-text">Minimum 6 caractères</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="role" class="form-label fw-semibold">
                                            <i class="fas fa-user-shield me-2"></i>Rôle <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select form-select-lg" id="role" name="role" required>
                                            <option value="">Sélectionner un rôle</option>
                                            <option value="ADMIN">Administrateur</option>
                                            <option value="PHARMACIEN">Pharmacien</option>
                                            <option value="ASSISTANT">Assistant</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-12">
                                    <div class="mb-4">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="actif" name="actif" checked>
                                            <label class="form-check-label" for="actif">
                                                <i class="fas fa-check-circle me-2"></i>Compte actif
                                            </label>
                                        </div>
                                        <div class="form-text">Un compte inactif ne peut pas se connecter</div>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/utilisateurs/" class="btn btn-lg btn-outline-secondary">
                                    <i class="fas fa-times me-2"></i>Annuler
                                </a>
                                <button type="submit" class="btn btn-lg btn-success">
                                    <i class="fas fa-save me-2"></i>Créer l'utilisateur
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle password visibility
        document.getElementById('togglePassword').addEventListener('click', function() {
            const password = document.getElementById('motDePasse');
            const icon = this.querySelector('i');
            
            if (password.type === 'password') {
                password.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                password.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });

        // Form validation
        document.getElementById('userForm').addEventListener('submit', function(e) {
            const password = document.getElementById('motDePasse').value;
            if (password.length < 6) {
                e.preventDefault();
                alert('Le mot de passe doit contenir au moins 6 caractères');
                return false;
            }
        });
    </script>
</body>
</html>
