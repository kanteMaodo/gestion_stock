<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="org.example.gestionpharmacie.model.Vente" %>
<%
    List<Vente> ventes = (List<Vente>) request.getAttribute("ventes");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Liste des Ventes - Pharmacie Manager</title>
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
        }
        .main-content { 
            margin-left: 250px; 
            padding: 30px;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .btn-action {
            padding: 8px 14px;
            border-radius: 25px;
            font-size: 0.9em;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            position: relative;
            overflow: hidden;
            text-decoration: none;
            display: inline-block;
        }
        .btn-action:hover {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 4px 15px rgba(0,0,0,0.25);
            text-decoration: none;
        }
        .btn-action:active {
            transform: translateY(0) scale(0.98);
        }
        .btn-action.btn-primary {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
        }
        .btn-action.btn-primary:hover {
            background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
            color: white;
        }
        .btn-action.btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-action.btn-success:hover {
            background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);
            color: white;
        }
        .btn-action.btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        .btn-action.btn-danger:hover {
            background: linear-gradient(135deg, #c82333 0%, #a71e2a 100%);
            color: white;
        }
        .btn-action i {
            font-size: 1em;
            transition: transform 0.3s ease;
        }
        .btn-action:hover i {
            transform: scale(1.1);
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
        }
        .status-completed {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .status-cancelled {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        .status-pending {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: #212529;
        }
        .table th {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: none;
            font-weight: 600;
            color: #495057;
        }
        .table td {
            vertical-align: middle;
            border-color: #f1f3f4;
        }
        .amount {
            font-weight: 600;
            color: #28a745;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4em;
            margin-bottom: 20px;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="p-3">
            <h4><i class="bi bi-heart-pulse me-2"></i>Pharmacie</h4>
        </div>
        <nav>
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-speedometer2 me-2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/medicaments/">
                <i class="bi bi-capsule me-2"></i> Médicaments
            </a>
            <a href="${pageContext.request.contextPath}/ventes/" class="active">
                <i class="bi bi-cart me-2"></i> Ventes
            </a>
            <a href="${pageContext.request.contextPath}/alertes/">
                <i class="bi bi-exclamation-triangle me-2"></i> Alertes
            </a>
            <a href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right me-2"></i> Déconnexion
            </a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1">
                    <i class="bi bi-cart-check me-2"></i>Liste des Ventes
                </h2>
                <p class="text-muted mb-0">Gérez toutes les transactions de vente</p>
            </div>
            <a href="${pageContext.request.contextPath}/ventes/nouvelle" class="btn-action btn-success">
                <i class="bi bi-plus-circle me-2"></i>Nouvelle Vente
            </a>
        </div>

        <!-- Messages d'alerte -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i><%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i><%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Tableau des ventes -->
        <div class="card">
            <div class="card-body p-0">
                <% if (ventes != null && !ventes.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>Vendeur</th>
                                    <th>Articles</th>
                                    <th>Montant Total</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Vente vente : ventes) { %>
                                    <tr>
                                        <td>
                                            <strong>#<%= vente.getId() %></strong>
                                        </td>
                                        <td>
                                            <i class="bi bi-calendar3 me-1"></i>
                                            <%= vente.getDateVente().format(formatter) %>
                                        </td>
                                        <td>
                                            <i class="bi bi-person me-1"></i>
                                            <%= vente.getVendeur().getNom() %>
                                        </td>
                                        <td>
                                            <i class="bi bi-box me-1"></i>
                                            <%= vente.getNombreArticles() %> article(s)
                                        </td>
                                        <td>
                                            <span class="amount">
                                                <i class="bi bi-currency-dollar me-1"></i>
                                                <%= String.format("%.2f", vente.getMontantTotal()) %> €
                                            </span>
                                        </td>
                                        <td>
                                            <% if (vente.getStatut() == Vente.StatutVente.COMPLETEE) { %>
                                                <span class="status-badge status-completed">
                                                    <i class="bi bi-check-circle me-1"></i>Complétée
                                                </span>
                                            <% } else if (vente.getStatut() == Vente.StatutVente.ANNULEE) { %>
                                                <span class="status-badge status-cancelled">
                                                    <i class="bi bi-x-circle me-1"></i>Annulée
                                                </span>
                                            <% } else { %>
                                                <span class="status-badge status-pending">
                                                    <i class="bi bi-clock me-1"></i>En cours
                                                </span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group" style="gap: 8px;">
                                                <a href="${pageContext.request.contextPath}/ventes/details?id=<%= vente.getId() %>" 
                                                   class="btn-action btn-primary"
                                                   title="Voir les détails">
                                                    <i class="bi bi-eye-fill"></i>
                                                </a>
                                                <% if (vente.peutEtreAnnulee()) { %>
                                                    <a href="${pageContext.request.contextPath}/ventes/annuler?id=<%= vente.getId() %>" 
                                                       class="btn-action btn-danger"
                                                       onclick="return confirm('Êtes-vous sûr de vouloir annuler cette vente ?')"
                                                       title="Annuler la vente">
                                                        <i class="bi bi-x-circle-fill"></i>
                                                    </a>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <i class="bi bi-cart-x"></i>
                        <h4>Aucune vente trouvée</h4>
                        <p class="mb-4">Commencez par créer votre première vente</p>
                        <a href="${pageContext.request.contextPath}/ventes/nouvelle" class="btn-action btn-success">
                            <i class="bi bi-plus-circle me-2"></i>Créer une vente
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 