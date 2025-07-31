<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.Utilisateur" %>
<%@ page import="org.example.gestionpharmacie.model.Medicament" %>
<%@ page import="org.example.gestionpharmacie.model.Vente" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    Map<String, Object> dashboardData = (Map<String, Object>) request.getAttribute("dashboardData");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - PHARMACIE MOUHAMED</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1e7e34;
            --secondary-color: #28a745;
            --accent-color: #20c997;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
        }

        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            background: linear-gradient(180deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 4px 12px;
            transition: all 0.3s ease;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
            transform: translateX(5px);
        }

        .main-content {
            padding: 20px;
        }

        .header {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .stats-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-5px);
        }

        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            margin-bottom: 16px;
        }

        .stats-number {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .stats-label {
            color: #6c757d;
            font-size: 0.9em;
        }

        .alert-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .alert-header {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
        }

        .alert-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            color: white;
        }

        .table-responsive {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .table {
            margin-bottom: 0;
        }

        .table th {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 16px 12px;
        }

        .table td {
            padding: 12px;
            vertical-align: middle;
        }

        .badge-stock {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
        }

        .btn-action {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-action:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="text-center py-4">
                    <i class="fas fa-clinic-medical fa-2x text-white mb-2"></i>
                    <h5 class="text-white">PHARMACIE MOUHAMED</h5>
                    <small class="text-white-50">Administration</small>
                </div>
                
                <nav class="nav flex-column">
                    <a class="nav-link active" href="#">
                        <i class="fas fa-tachometer-alt me-2"></i> Tableau de bord
                    </a>
                    <a class="nav-link" href="#">
                        <i class="fas fa-users me-2"></i> Utilisateurs
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/medicaments/">
                        <i class="fas fa-pills me-2"></i> Médicaments
                    </a>
                    <a class="nav-link" href="#">
                        <i class="fas fa-chart-line me-2"></i> Ventes
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/alertes/">
                        <i class="fas fa-exclamation-triangle me-2"></i> Alertes
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i> Déconnexion
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Header -->
                <div class="header">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="mb-0">Dashboard Administrateur</h2>
                            <p class="text-muted mb-0">Vue d'ensemble du système</p>
                        </div>
                        <div class="col-auto">
                            <div class="d-flex align-items-center">
                                <div class="me-3">
                                    <i class="fas fa-bell text-muted"></i>
                                    <span class="badge bg-danger ms-1">3</span>
                                </div>
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" class="rounded-circle me-2" alt="Avatar">
                                    <div>
                                        <div class="fw-bold"><%= user.getNomComplet() %></div>
                                        <small class="text-muted"><%= user.getRole().getLibelle() %></small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>



                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-icon" style="background: var(--info-color);">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stats-number"><%= dashboardData.get("totalUtilisateurs") %></div>
                            <div class="stats-label">Utilisateurs Actifs</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-icon" style="background: var(--secondary-color);">
                                <i class="fas fa-pills"></i>
                            </div>
                            <div class="stats-number"><%= dashboardData.get("totalMedicaments") %></div>
                            <div class="stats-label">Médicaments</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-icon" style="background: var(--accent-color);">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div class="stats-number"><%= dashboardData.get("totalVentes") %></div>
                            <div class="stats-label">Ventes Aujourd'hui</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-icon" style="background: var(--primary-color);">
                                <i class="fas fa-money-bill-wave"></i>
                            </div>
                            <div class="stats-number"><%= String.format("%.0f", dashboardData.get("chiffreAffaires")) %> FCFA</div>
                            <div class="stats-label">Chiffre d'Affaires</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Alertes Stock Faible -->
                    <div class="col-md-6">
                        <div class="alert-card">
                            <div class="alert-header">
                                <div class="alert-icon" style="background: var(--warning-color);">
                                    <i class="fas fa-exclamation-triangle"></i>
                                </div>
                                <h5 class="mb-0">Stock Faible</h5>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Médicament</th>
                                            <th>Stock</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        List<Medicament> stockFaible = (List<Medicament>) dashboardData.get("medicamentsStockFaible");
                                        for (Medicament med : stockFaible) {
                                        %>
                                        <tr>
                                            <td><%= med.getNom() %></td>
                                            <td>
                                                <span class="badge-stock bg-danger"><%= med.getStock() %></span>
                                            </td>
                                            <td>
                                                <a href="#" class="btn-action btn btn-sm btn-outline-primary">Commander</a>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Médicaments Expiration -->
                    <div class="col-md-6">
                        <div class="alert-card">
                            <div class="alert-header">
                                <div class="alert-icon" style="background: var(--danger-color);">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <h5 class="mb-0">Expiration Proche</h5>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Médicament</th>
                                            <th>Expiration</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        List<Medicament> expiration = (List<Medicament>) dashboardData.get("medicamentsExpiration");
                                        for (Medicament med : expiration) {
                                        %>
                                        <tr>
                                            <td><%= med.getNom() %></td>
                                            <td>
                                                <span class="badge-stock bg-warning text-dark">
                                                    <%= med.getDateExpiration() %>
                                                </span>
                                            </td>
                                            <td>
                                                <a href="#" class="btn-action btn btn-sm btn-outline-warning">Gérer</a>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Ventes Récentes -->
                <div class="row">
                    <div class="col-12">
                        <div class="alert-card">
                            <div class="alert-header">
                                <div class="alert-icon" style="background: var(--accent-color);">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <h5 class="mb-0">Ventes Récentes</h5>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Vendeur</th>
                                            <th>Montant</th>
                                            <th>Date</th>
                                            <th>Statut</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        List<Vente> ventesRecentes = (List<Vente>) dashboardData.get("ventesRecentes");
                                        for (Vente vente : ventesRecentes) {
                                        %>
                                        <tr>
                                            <td>#<%= vente.getId() %></td>
                                            <td><%= vente.getVendeur() != null ? vente.getVendeur().getNomComplet() : "N/A" %></td>
                                            <td><strong><%= String.format("%.0f", vente.getMontantTotal()) %> FCFA</strong></td>
                                            <td><%= vente.getDateVente().toLocalDate() %></td>
                                            <td>
                                                <span class="badge-stock bg-success"><%= vente.getStatut().getLibelle() %></span>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Animation pour les cartes de statistiques
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.stats-card');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    card.style.transition = 'all 0.5s ease';
                    
                    setTimeout(() => {
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, 100);
                }, index * 100);
            });
        });
    </script>
</body>
</html> 