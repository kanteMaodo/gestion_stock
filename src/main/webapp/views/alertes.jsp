<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.Medicament" %>
<%@ page import="org.example.gestionpharmacie.model.Utilisateur" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    Map<String, Object> alertes = (Map<String, Object>) request.getAttribute("alertes");
    List<Medicament> stockFaible = (List<Medicament>) alertes.get("stockFaible");
    List<Medicament> expirationProche = (List<Medicament>) alertes.get("expirationProche");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alertes - Pharmacie Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container-fluid">
        <!-- Main content -->
        <div class="px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="bi bi-exclamation-triangle text-warning"></i>
                    Alertes Médicaments
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/<%= user.getRole() == Utilisateur.Role.ADMIN ? "admin" : "pharmacien" %>/dashboard" class="btn btn-outline-primary">
                        <i class="bi bi-arrow-left me-2"></i>Retour au Tableau de bord
                    </a>
                </div>
            </div>

            <!-- Messages de succès/erreur -->
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i>
                    <%= request.getParameter("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    <%= request.getParameter("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Statistiques -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card bg-primary text-white">
                        <div class="card-body text-center">
                            <h5>Total Médicaments</h5>
                            <h3><%= alertes.get("totalMedicaments") %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-success text-white">
                        <div class="card-body text-center">
                            <h5>Disponibles</h5>
                            <h3><%= alertes.get("medicamentsDisponibles") %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-danger text-white">
                        <div class="card-body text-center">
                            <h5>Stock Faible</h5>
                            <h3><%= alertes.get("countStockFaible") %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-warning text-dark">
                        <div class="card-body text-center">
                            <h5>Expiration Proche</h5>
                            <h3><%= alertes.get("countExpirationProche") %></h3>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Alertes Stock Faible -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-danger text-white">
                            <h5 class="mb-0">
                                <i class="bi bi-exclamation-circle"></i>
                                Stock Faible (<%= stockFaible.size() %>)
                            </h5>
                        </div>
                        <div class="card-body">
                            <% if (stockFaible != null && !stockFaible.isEmpty()) { %>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Médicament</th>
                                                <th>Stock Actuel</th>
                                                <th>Seuil d'Alerte</th>
                                                <th>Prix</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Medicament med : stockFaible) { %>
                                                <tr>
                                                    <td>
                                                        <strong><%= med.getNom() %></strong>
                                                        <% if (med.getCodeBarre() != null) { %>
                                                            <br><small class="text-muted">Code: <%= med.getCodeBarre() %></small>
                                                        <% } %>
                                                    </td>
                                                    <td>
                                                        <span class="text-danger fw-bold"><%= med.getStock() %></span>
                                                    </td>
                                                    <td><%= med.getSeuilAlerte() %></td>
                                                    <td><strong><%= String.format("%.0f", med.getPrix()) %> FCFA</strong></td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/medicaments/?action=modifier&id=<%= med.getId() %>&retour=alertes" 
                                                           class="btn btn-warning btn-sm" 
                                                           title="Modifier le stock">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            <% } else { %>
                                <div class="text-center py-4">
                                    <i class="bi bi-check-circle text-success fs-1"></i>
                                    <h5 class="text-success mt-2">Aucun médicament en stock faible</h5>
                                    <p class="text-muted">Tous les stocks sont suffisants</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Alertes Expiration Proche -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-warning text-dark">
                            <h5 class="mb-0">
                                <i class="bi bi-clock"></i>
                                Expiration Proche (<%= expirationProche.size() %>)
                            </h5>
                        </div>
                        <div class="card-body">
                            <% if (expirationProche != null && !expirationProche.isEmpty()) { %>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Médicament</th>
                                                <th>Date d'Expiration</th>
                                                <th>Jours Restants</th>
                                                <th>Stock</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Medicament med : expirationProche) { %>
                                                <% 
                                                    long joursRestants = java.time.temporal.ChronoUnit.DAYS.between(
                                                        java.time.LocalDate.now(), med.getDateExpiration()
                                                    );
                                                %>
                                                <tr>
                                                    <td>
                                                        <strong><%= med.getNom() %></strong>
                                                        <% if (med.getCodeBarre() != null) { %>
                                                            <br><small class="text-muted">Code: <%= med.getCodeBarre() %></small>
                                                        <% } %>
                                                    </td>
                                                    <td>
                                                        <% if (joursRestants <= 7) { %>
                                                            <span class="badge bg-danger">
                                                                <%= med.getDateExpiration().format(formatter) %>
                                                            </span>
                                                        <% } else { %>
                                                            <span class="badge bg-warning text-dark">
                                                                <%= med.getDateExpiration().format(formatter) %>
                                                            </span>
                                                        <% } %>
                                                    </td>
                                                    <td>
                                                        <% if (joursRestants <= 0) { %>
                                                            <span class="text-danger fw-bold">EXPIRÉ</span>
                                                        <% } else { %>
                                                            <span class="<%= joursRestants <= 7 ? "text-danger" : "text-warning" %>">
                                                                <%= joursRestants %> jours
                                                            </span>
                                                        <% } %>
                                                    </td>
                                                    <td><%= med.getStock() %></td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/medicaments/?action=modifier&id=<%= med.getId() %>&retour=alertes" 
                                                           class="btn btn-warning btn-sm" 
                                                           title="Modifier la date d'expiration">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            <% } else { %>
                                <div class="text-center py-4">
                                    <i class="bi bi-check-circle text-success fs-1"></i>
                                    <h5 class="text-success mt-2">Aucun médicament proche de l'expiration</h5>
                                    <p class="text-muted">Tous les médicaments ont une date d'expiration éloignée</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-refresh toutes les 5 minutes
        setTimeout(function() {
            location.reload();
        }, 300000);
        
        // Si on a un message de succès, rafraîchir la page après 3 secondes pour voir les changements
        <% if (request.getParameter("success") != null) { %>
            setTimeout(function() {
                location.reload();
            }, 3000);
        <% } %>
    </script>
</body>
</html> 