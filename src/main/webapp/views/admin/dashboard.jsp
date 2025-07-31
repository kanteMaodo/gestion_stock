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
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 bg-success text-white min-vh-100 p-0">
                <div class="p-3">
                    <h4 class="text-white mb-4">
                        <i class="fas fa-clinic-medical me-2"></i>
                        PHARMACIE
                    </h4>
                </div>
                <nav class="nav flex-column">
                    <a class="nav-link text-white-50 active" href="#">
                        <i class="fas fa-tachometer-alt me-2"></i> Tableau de bord
                    </a>
                    <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/medicaments/">
                        <i class="fas fa-pills me-2"></i> Médicaments
                    </a>
                    <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/ventes/">
                        <i class="fas fa-chart-line me-2"></i> Ventes
                    </a>
                    <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/alertes/">
                        <i class="fas fa-exclamation-triangle me-2"></i> Alertes
                    </a>
                    <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i> Déconnexion
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 p-4">
                <!-- Header -->
                <div class="bg-white rounded shadow-sm p-4 mb-4">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="mb-0">Dashboard Administrateur</h2>
                            <p class="text-muted mb-0">Vue d'ensemble du système</p>
                        </div>
                        <div class="col-auto">
                            <div class="d-flex align-items-center">
                                <div>
                                    <div class="fw-bold"><%= user.getNomComplet() %></div>
                                    <small class="text-muted"><%= user.getRole().getLibelle() %></small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body text-center">
                                <div class="bg-info rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                                    <i class="fas fa-users text-white fs-4"></i>
                                </div>
                                <h3 class="fw-bold mb-1"><%= dashboardData.get("totalUtilisateurs") %></h3>
                                <p class="text-muted mb-0">Utilisateurs Actifs</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body text-center">
                                <div class="bg-success rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                                    <i class="fas fa-pills text-white fs-4"></i>
                                </div>
                                <h3 class="fw-bold mb-1"><%= dashboardData.get("totalMedicaments") %></h3>
                                <p class="text-muted mb-0">Médicaments</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body text-center">
                                <div class="bg-warning rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                                    <i class="fas fa-shopping-cart text-white fs-4"></i>
                                </div>
                                <h3 class="fw-bold mb-1"><%= dashboardData.get("totalVentes") %></h3>
                                <p class="text-muted mb-0">Ventes Aujourd'hui</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body text-center">
                                <div class="bg-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                                    <i class="fas fa-money-bill-wave text-white fs-4"></i>
                                </div>
                                <h3 class="fw-bold mb-1"><%= String.format("%.0f", dashboardData.get("chiffreAffaires")) %> FCFA</h3>
                                <p class="text-muted mb-0">Chiffre d'Affaires</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Alertes Stock Faible -->
                    <div class="col-md-6 mb-4">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-warning text-dark d-flex align-items-center">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <h5 class="mb-0">Stock Faible</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Médicament</th>
                                                <th>Stock</th>
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
                                                    <span class="badge bg-warning text-dark">
                                                        <%= med.getStock() %>
                                                    </span>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Médicaments en Expiration -->
                    <div class="col-md-6 mb-4">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-danger text-white d-flex align-items-center">
                                <i class="fas fa-calendar-times me-2"></i>
                                <h5 class="mb-0">Expiration Proche</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Médicament</th>
                                                <th>Expiration</th>
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
                                                    <span class="badge bg-warning text-dark">
                                                        <%= med.getDateExpiration() %>
                                                    </span>
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

                <!-- Ventes Récentes -->
                <div class="row">
                    <div class="col-12">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-info text-white d-flex align-items-center">
                                <i class="fas fa-chart-line me-2"></i>
                                <h5 class="mb-0">Ventes Récentes</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
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
                                                    <span class="badge bg-success"><%= vente.getStatut().getLibelle() %></span>
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
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 