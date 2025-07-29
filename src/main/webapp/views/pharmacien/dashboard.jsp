<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.*" %>
<%@ page import="org.example.gestionpharmacie.servlets.DashboardServlet.DashboardStats" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Utilisateur user = (Utilisateur) request.getAttribute("user");
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    List<Medicament> stockFaible = (List<Medicament>) request.getAttribute("stockFaible");
    List<Medicament> expirationProche = (List<Medicament>) request.getAttribute("expirationProche");
    List<Vente> ventesRecentes = (List<Vente>) request.getAttribute("ventesRecentes");
    
    if (stats == null) {
        stats = new DashboardStats(0, 0, 0, 0, 0.0);
    }
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Pharmacien - Pharmacie Manager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { 
            background: #f4f7fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar { 
            width: 250px; 
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: #fff; 
            min-height: 100vh; 
            position: fixed;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar a { 
            color: #fff; 
            text-decoration: none; 
            display: block; 
            padding: 16px 20px;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }
        .sidebar a:hover, .sidebar a.active { 
            background: rgba(255,255,255,0.1);
            border-left-color: #fff;
            transform: translateX(5px);
        }
        .main { 
            margin-left: 250px; 
            padding: 20px;
        }
        .card { 
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            padding: 20px 30px; 
            background: #fff; 
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .user-info { 
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .quick-action-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .quick-action-card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        .stats-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .alert-section {
            background: #fff;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .btn-action {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-action:hover {
            transform: scale(1.05);
        }
        .notification-badge {
            position: relative;
        }
        .notification-badge::after {
            content: '<%= stats.getAlertesCritiques() %>';
            position: absolute;
            top: -8px;
            right: -8px;
            background: #dc3545;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 0.7em;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="text-center py-4">
            <h4>PHARMACIE MOUHAMED</h4>
            <small>Espace Pharmacien</small>
        </div>
        
        <a href="${pageContext.request.contextPath}/dashboard" class="active">
            <i class="bi bi-speedometer2 me-2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/medicaments/">
            <i class="bi bi-box-seam me-2"></i> Gestion Stock
        </a>
        <a href="${pageContext.request.contextPath}/medicaments/ajouter">
            <i class="bi bi-plus-circle me-2"></i> Ajouter Médicament
        </a>
        <a href="${pageContext.request.contextPath}/ventes/">
            <i class="bi bi-graph-up me-2"></i> Rapports
        </a>
        <a href="${pageContext.request.contextPath}/alertes/" class="notification-badge">
            <i class="bi bi-exclamation-triangle me-2"></i> Alertes
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="bi bi-box-arrow-right me-2"></i> Déconnexion
        </a>
    </div>

    <!-- Main Content -->
    <div class="main">
        <!-- Header -->
        <div class="header">
            <div>
                <h2 class="mb-1">Dashboard Pharmacien</h2>
                <p class="text-muted mb-0">Gestion des médicaments et stocks</p>
            </div>
            <div class="user-info">
                <div class="notification-badge">
                    <i class="bi bi-bell fs-4"></i>
                </div>
                <div class="text-end">
                    <div class="fw-bold"><%= user != null ? user.getNomComplet() : "" %></div>
                    <small class="text-muted"><%= user != null ? user.getRole().getLibelle() : "" %></small>
                </div>
                <div class="ms-3">
                    <i class="bi bi-person-circle fs-1 text-primary"></i>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/medicaments/ajouter'">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-plus-circle fs-1 mb-3"></i>
                        <h5>Ajouter Médicament</h5>
                        <p class="mb-0">Nouveau produit</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/ventes/nouvelle'">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-cart-plus fs-1 mb-3"></i>
                        <h5>Nouvelle Vente</h5>
                        <p class="mb-0">Vendre des médicaments</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/medicaments/'">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-boxes fs-1 mb-3"></i>
                        <h5>Gérer Stock</h5>
                        <p class="mb-0">Ajuster les quantités</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-capsule fs-1 mb-3"></i>
                        <h3 class="mb-1"><%= stats.getTotalMedicaments() %></h3>
                        <p class="mb-0">Total Médicaments</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-check-circle fs-1 mb-3"></i>
                        <h3 class="mb-1"><%= stats.getMedicamentsDisponibles() %></h3>
                        <p class="mb-0">Disponibles</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-cart-check fs-1 mb-3"></i>
                        <h3 class="mb-1"><%= stats.getVentesAujourdhui() %></h3>
                        <p class="mb-0">Ventes Aujourd'hui</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-currency-dollar fs-1 mb-3"></i>
                        <h3 class="mb-1"><%= String.format("%.0f", stats.getChiffreAffairesAujourdhui()) %> FCFA</h3>
                        <p class="mb-0">Chiffre d'Affaires</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alerts Section -->
        <div class="row">
            <!-- Stock Faible -->
            <div class="col-md-6">
                <div class="alert-section">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">
                            <i class="bi bi-exclamation-triangle text-warning me-2"></i>
                            Stock Faible
                        </h5>
                        <a href="${pageContext.request.contextPath}/medicaments/?filter=stock-faible" class="btn btn-sm btn-outline-warning">
                            Voir tout
                        </a>
                    </div>
                    
                    <% if (stockFaible != null && !stockFaible.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>Médicament</th>
                                        <th>Stock</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Medicament med : stockFaible) { %>
                                        <tr>
                                            <td><%= med.getNom() %></td>
                                            <td><span class="badge bg-danger"><%= med.getStock() %></span></td>
                                            <td>
                                                <button class="btn-action btn-warning" onclick="window.location.href='${pageContext.request.contextPath}/medicaments/modifier?id=<%= med.getId() %>'">
                                                    Réapprovisionner
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } else { %>
                        <p class="text-muted text-center py-3">Aucun médicament en stock faible</p>
                    <% } %>
                </div>
            </div>

            <!-- Expiration Proche -->
            <div class="col-md-6">
                <div class="alert-section">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">
                            <i class="bi bi-clock text-danger me-2"></i>
                            Expiration Proche
                        </h5>
                        <a href="${pageContext.request.contextPath}/medicaments/?filter=expiration" class="btn btn-sm btn-outline-danger">
                            Voir tout
                        </a>
                    </div>
                    
                    <% if (expirationProche != null && !expirationProche.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>Médicament</th>
                                        <th>Expiration</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Medicament med : expirationProche) { %>
                                        <tr>
                                            <td><%= med.getNom() %></td>
                                            <td><span class="badge bg-warning"><%= med.getDateExpiration() != null ? med.getDateExpiration().format(formatter) : "N/A" %></span></td>
                                            <td>
                                                <button class="btn-action btn-danger" onclick="window.location.href='${pageContext.request.contextPath}/medicaments/modifier?id=<%= med.getId() %>'">
                                                    Gérer
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } else { %>
                        <p class="text-muted text-center py-3">Aucun médicament en expiration proche</p>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Ventes Récentes -->
        <div class="alert-section">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="mb-0">
                    <i class="bi bi-graph-up text-success me-2"></i>
                    Ventes Récentes
                </h5>
                <a href="${pageContext.request.contextPath}/ventes/" class="btn btn-sm btn-outline-success">
                    Voir toutes les ventes
                </a>
            </div>
            
            <% if (ventesRecentes != null && !ventesRecentes.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>N° Vente</th>
                                <th>Date</th>
                                <th>Montant</th>
                                <th>Vendeur</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Vente vente : ventesRecentes) { %>
                                <tr>
                                    <td>#<%= vente.getId() %></td>
                                    <td><%= vente.getDateVente().format(formatter) %></td>
                                    <td><strong><%= String.format("%.0f", vente.getMontantTotal()) %> FCFA</strong></td>
                                    <td><%= vente.getUtilisateur() != null ? vente.getUtilisateur().getNomComplet() : "N/A" %></td>
                                    <td>
                                        <button class="btn-action btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/ventes/details?id=<%= vente.getId() %>'">
                                            Détails
                                        </button>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <p class="text-muted text-center py-3">Aucune vente récente</p>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 