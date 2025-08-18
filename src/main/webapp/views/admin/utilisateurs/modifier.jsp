<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.Utilisateur" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    Utilisateur utilisateur = (Utilisateur) request.getAttribute("utilisateur");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Modifier un Utilisateur - PHARMACIE MOUHAMED</title>
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
                            <h2 class="mb-0">Modifier l'Utilisateur</h2>
                            <p class="text-muted mb-0">Modifier les informations du compte</p>
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
                        <% if (utilisateur != null) { %>
                            <form action="${pageContext.request.contextPath}/utilisateurs/" method="post" id="userForm">
                                <input type="hidden" name="action" value="modifier">
                                <input type="hidden" name="id" value="<%= utilisateur.getId() %>">
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="nom" class="form-label fw-semibold">
                                                <i class="fas fa-user me-2"></i>Nom <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" class="form-control form-control-lg" id="nom" name="nom" 
                                                   value="<%= utilisateur.getNom() %>" required placeholder="Nom de famille">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="prenom" class="form-label fw-semibold">
                                                <i class="fas fa-user me-2"></i>Prénom <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" class="form-control form-control-lg" id="prenom" name="prenom" 
                                                   value="<%= utilisateur.getPrenom() %>" required placeholder="Prénom">
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
                                                   value="<%= utilisateur.getEmail() %>" required placeholder="exemple@email.com">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="login" class="form-label fw-semibold">
                                                <i class="fas fa-user-tag me-2"></i>Login <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" class="form-control form-control-lg" id="login" name="login" 
                                                   value="<%= utilisateur.getLogin() %>" required placeholder="Nom d'utilisateur">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="motDePasse" class="form-label fw-semibold">
                                                <i class="fas fa-lock me-2"></i>Nouveau mot de passe
                                            </label>
                                            <div class="input-group">
                                                <input type="password" class="form-control form-control-lg" id="motDePasse" 
                                                       name="motDePasse" placeholder="•••••••• (laisser vide pour ne pas changer)">
                                                <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <div class="form-text">Laissez vide pour conserver l'ancien mot de passe</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="role" class="form-label fw-semibold">
                                                <i class="fas fa-user-shield me-2"></i>Rôle <span class="text-danger">*</span>
                                            </label>
                                            <select class="form-select form-select-lg" id="role" name="role" required>
                                                <option value="">Sélectionner un rôle</option>
                                                <option value="ADMIN" <%= utilisateur.getRole() == Utilisateur.Role.ADMIN ? "selected" : "" %>>Administrateur</option>
                                                <option value="PHARMACIEN" <%= utilisateur.getRole() == Utilisateur.Role.PHARMACIEN ? "selected" : "" %>>Pharmacien</option>
                                                <option value="ASSISTANT" <%= utilisateur.getRole() == Utilisateur.Role.ASSISTANT ? "selected" : "" %>>Assistant</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-12">
                                        <div class="mb-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="actif" name="actif" 
                                                       <%= utilisateur.isActif() ? "checked" : "" %>>
                                                <label class="form-check-label" for="actif">
                                                    <i class="fas fa-check-circle me-2"></i>Compte actif
                                                </label>
                                            </div>
                                            <div class="form-text">Un compte inactif ne peut pas se connecter</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Informations système -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="alert alert-info">
                                            <h6 class="alert-heading">
                                                <i class="fas fa-info-circle me-2"></i>Informations système
                                            </h6>
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <small class="text-muted">ID Utilisateur:</small><br>
                                                    <strong>#<%= utilisateur.getId() %></strong>
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted">Date de création:</small><br>
                                                    <strong><%= utilisateur.getDateCreation().toLocalDate() %></strong>
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted">Dernière modification:</small><br>
                                                    <strong>
                                                        <% if (utilisateur.getDateModification() != null) { %>
                                                            <%= utilisateur.getDateModification().toLocalDate() %>
                                                        <% } else { %>
                                                            Jamais modifié
                                                        <% } %>
                                                    </strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <hr class="my-4">

                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/utilisateurs/" class="btn btn-lg btn-outline-secondary">
                                        <i class="fas fa-times me-2"></i>Annuler
                                    </a>
                                    <button type="submit" class="btn btn-lg btn-primary">
                                        <i class="fas fa-save me-2"></i>Enregistrer les modifications
                                    </button>
                                </div>
                            </form>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
                                <h5 class="text-warning">Utilisateur non trouvé</h5>
                                <p class="text-muted">L'utilisateur que vous recherchez n'existe pas ou a été supprimé.</p>
                                <a href="${pageContext.request.contextPath}/utilisateurs/" class="btn btn-primary">
                                    <i class="fas fa-arrow-left me-2"></i>Retour à la liste
                                </a>
                            </div>
                        <% } %>
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
            if (password.length > 0 && password.length < 6) {
                e.preventDefault();
                alert('Le mot de passe doit contenir au moins 6 caractères');
                return false;
            }
        });
    </script>
</body>
</html>
