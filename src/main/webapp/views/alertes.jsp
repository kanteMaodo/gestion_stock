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
    <style>
        body { background: #f8f9fa; }
        .alert-card { 
            border-radius: 12px; 
            border: none; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .alert-card:hover { transform: translateY(-2px); }
        .alert-header { 
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border-radius: 12px 12px 0 0;
        }
        .alert-warning-header {
            background: linear-gradient(135deg, #ffc107, #e0a800);
            color: #212529;
        }
        .stock-critical { color: #dc3545; font-weight: bold; }
        .expiration-critical { 
            background: #dc3545; 
            color: white; 
            padding: 2px 8px; 
            border-radius: 4px; 
        }
        .expiration-warning { 
            background: #ffc107; 
            color: #212529; 
            padding: 2px 8px; 
            border-radius: 4px; 
        }
        .stats-card {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 12px;
        }
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            margin: 2px;
            transition: all 0.2s;
        }
        .btn-action:hover { transform: scale(1.05); }
        .btn-primary { background: #007bff; color: white; }
        .btn-warning { background: #ffc107; color: #212529; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse" style="min-height: 100vh;">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <h4 class="text-white">🏥 Pharmacie</h4>
                        <small class="text-muted">Centre-ville Dakar</small>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/dashboard">
                                <i class="bi bi-speedometer2"></i> Tableau de bord
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/medicaments/">
                                <i class="bi bi-capsule"></i> Médicaments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white active" href="${pageContext.request.contextPath}/alertes/">
                                <i class="bi bi-exclamation-triangle"></i> Alertes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right"></i> Déconnexion
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Main content -->
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="bi bi-exclamation-triangle text-warning"></i>
                        Alertes Médicaments
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <span class="badge bg-danger fs-6">
                                <%= alertes.get("totalAlertes") %> Alertes
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Statistiques -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card stats-card">
                            <div class="card-body text-center">
                                <h5>Total Médicaments</h5>
                                <h3><%= alertes.get("totalMedicaments") %></h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stats-card">
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
                        <div class="card alert-card">
                            <div class="card-header alert-header">
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
                                                            <span class="stock-critical"><%= med.getStock() %></span>
                                                        </td>
                                                        <td><%= med.getSeuilAlerte() %></td>
                                                        <td><strong><%= String.format("%.0f", med.getPrix()) %> FCFA</strong></td>
                                                        <td>
                                                            <button class="btn-action btn-warning" 
                                                                    onclick="window.location.href='${pageContext.request.contextPath}/medicaments/reapprovisionner?id=<%= med.getId() %>'"
                                                                    title="Réapprovisionner">
                                                                <i class="bi bi-plus-circle"></i>
                                                            </button>
                                                            <button class="btn-action btn-primary" 
                                                                    onclick="window.location.href='${pageContext.request.contextPath}/medicaments/modifier?id=<%= med.getId() %>'"
                                                                    title="Modifier">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>
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
                        <div class="card alert-card">
                            <div class="card-header alert-warning-header">
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
                                                                <span class="expiration-critical">
                                                                    <%= med.getDateExpiration().format(formatter) %>
                                                                </span>
                                                            <% } else { %>
                                                                <span class="expiration-warning">
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
                                                            <button class="btn-action btn-warning" 
                                                                    onclick="window.location.href='${pageContext.request.contextPath}/medicaments/reapprovisionner?id=<%= med.getId() %>'"
                                                                    title="Réapprovisionner">
                                                                <i class="bi bi-plus-circle"></i>
                                                            </button>
                                                            <button class="btn-action btn-primary" 
                                                                    onclick="window.location.href='${pageContext.request.contextPath}/medicaments/modifier?id=<%= med.getId() %>'"
                                                                    title="Modifier">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>
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
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-refresh toutes les 5 minutes
        setTimeout(function() {
            location.reload();
        }, 300000);
    </script>
</body>
</html> 