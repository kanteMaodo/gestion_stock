<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.Utilisateur" %>
<%@ page import="java.util.*" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    List<Utilisateur> utilisateurs = (List<Utilisateur>) request.getAttribute("utilisateurs");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Utilisateurs - PHARMACIE MOUHAMED</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .avatar-sm {
            width: 40px;
            height: 40px;
            font-size: 14px;
            font-weight: bold;
        }
        .table th {
            border-top: none;
            font-weight: 600;
            color: #495057;
        }
        .btn-group .btn {
            border-radius: 0.375rem !important;
        }
        .btn-group .btn:first-child {
            border-top-right-radius: 0 !important;
            border-bottom-right-radius: 0 !important;
        }
        .btn-group .btn:last-child {
            border-top-left-radius: 0 !important;
            border-bottom-left-radius: 0 !important;
        }
        .card {
            transition: transform 0.2s ease-in-out;
        }
        .card:hover {
            transform: translateY(-2px);
        }
    </style>
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
                            <h2 class="mb-0">Gestion des Utilisateurs</h2>
                            <p class="text-muted mb-0">Administration des comptes utilisateurs</p>
                        </div>
                        <div class="col-auto">
                            <a href="${pageContext.request.contextPath}/utilisateurs/ajouter" class="btn btn-success">
                                <i class="fas fa-plus me-2"></i>Nouvel Utilisateur
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
                
                <% if (success != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Statistiques -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body text-center">
                                <h3 class="fw-bold text-success mb-1"><%= utilisateurs != null ? utilisateurs.size() : 0 %></h3>
                                <p class="text-muted mb-0">Total Utilisateurs</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body text-center">
                                <h3 class="fw-bold text-primary mb-1">
                                    <%= utilisateurs != null ? utilisateurs.stream().filter(u -> u.getRole() == Utilisateur.Role.ADMIN).count() : 0 %>
                                </h3>
                                <p class="text-muted mb-0">Administrateurs</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body text-center">
                                <h3 class="fw-bold text-info mb-1">
                                    <%= utilisateurs != null ? utilisateurs.stream().filter(u -> u.getRole() == Utilisateur.Role.PHARMACIEN).count() : 0 %>
                                </h3>
                                <p class="text-muted mb-0">Pharmaciens</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body text-center">
                                <h3 class="fw-bold text-warning mb-1">
                                    <%= utilisateurs != null ? utilisateurs.stream().filter(u -> u.getRole() == Utilisateur.Role.ASSISTANT).count() : 0 %>
                                </h3>
                                <p class="text-muted mb-0">Assistants</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Table des utilisateurs -->
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <i class="fas fa-users me-2"></i>Liste des Utilisateurs
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <% if (utilisateurs != null && !utilisateurs.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Nom Complet</th>
                                            <th>Email</th>
                                            <th>Login</th>
                                            <th>Rôle</th>
                                            <th>Statut</th>
                                            <th>Dernière Connexion</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Utilisateur u : utilisateurs) { %>
                                            <tr>
                                                <td><span class="badge bg-secondary">#<%= u.getId() %></span></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-3">
                                                            <%= u.getNom().charAt(0) %><%= u.getPrenom().charAt(0) %>
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold"><%= u.getNomComplet() %></div>
                                                            <small class="text-muted">Créé le <%= u.getDateCreation().toLocalDate() %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><%= u.getEmail() %></td>
                                                <td><%= u.getLogin() %></td>
                                                <td>
                                                    <% if (u.getRole() == Utilisateur.Role.ADMIN) { %>
                                                        <span class="badge bg-danger"><%= u.getRole().getLibelle() %></span>
                                                    <% } else if (u.getRole() == Utilisateur.Role.PHARMACIEN) { %>
                                                        <span class="badge bg-primary"><%= u.getRole().getLibelle() %></span>
                                                    <% } else { %>
                                                        <span class="badge bg-warning text-dark"><%= u.getRole().getLibelle() %></span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <% if (u.isActif()) { %>
                                                        <span class="badge bg-success">Actif</span>
                                                    <% } else { %>
                                                        <span class="badge bg-secondary">Inactif</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <% if (u.getDerniereConnexion() != null) { %>
                                                        <small class="text-muted"><%= u.getDerniereConnexion().toLocalDate() %></small>
                                                    <% } else { %>
                                                        <small class="text-muted">Jamais connecté</small>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/utilisateurs/modifier?id=<%= u.getId() %>" 
                                                           class="btn btn-sm btn-outline-primary" title="Modifier">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <% if (u.isActif()) { %>
                                                            <a href="${pageContext.request.contextPath}/utilisateurs/supprimer?id=<%= u.getId() %>" 
                                                               class="btn btn-sm btn-outline-danger" title="Désactiver"
                                                               onclick="return confirm('Êtes-vous sûr de vouloir désactiver cet utilisateur ?')">
                                                                <i class="fas fa-user-slash"></i>
                                                            </a>
                                                        <% } else { %>
                                                            <span class="btn btn-sm btn-outline-secondary disabled" title="Déjà désactivé">
                                                                <i class="fas fa-user-slash"></i>
                                                            </span>
                                                        <% } %>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">Aucun utilisateur trouvé</h5>
                                <p class="text-muted">Commencez par créer votre premier utilisateur</p>
                                <a href="${pageContext.request.contextPath}/utilisateurs/ajouter" class="btn btn-success">
                                    <i class="fas fa-plus me-2"></i>Créer un utilisateur
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
