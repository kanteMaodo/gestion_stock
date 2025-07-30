<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="org.example.gestionpharmacie.model.Vente" %>
<%@ page import="org.example.gestionpharmacie.model.LigneVente" %>
<%
    Vente vente = (Vente) request.getAttribute("vente");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    boolean isNewVente = vente.getStatut() == Vente.StatutVente.EN_COURS;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Détails de la Vente - Pharmacie Manager</title>
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
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.9em;
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
        .cart-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            border-left: 4px solid #28a745;
        }
        .total-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        .info-value {
            color: #6c757d;
        }
        .amount {
            font-weight: 600;
            color: #28a745;
        }
        .empty-cart {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }
        .empty-cart i {
            font-size: 3em;
            margin-bottom: 15px;
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
                    <i class="bi bi-receipt me-2"></i>Détails de la Vente #<%= vente.getId() %>
                </h2>
                <p class="text-muted mb-0">Informations complètes de la transaction</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/ventes/" class="btn-action btn-primary">
                    <i class="bi bi-arrow-left me-2"></i>Retour aux ventes
                </a>
                <% if (isNewVente) { %>
                    <a href="${pageContext.request.contextPath}/ventes/nouvelle?venteId=<%= vente.getId() %>" class="btn-action btn-success">
                        <i class="bi bi-plus-circle me-2"></i>Continuer la vente
                    </a>
                <% } %>
            </div>
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

        <div class="row">
            <!-- Informations de la vente -->
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-info-circle me-2"></i>Informations
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="info-item">
                            <span class="info-label">ID Vente:</span>
                            <span class="info-value">#<%= vente.getId() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Date:</span>
                            <span class="info-value">
                                <i class="bi bi-calendar3 me-1"></i>
                                <%= vente.getDateVente().format(formatter) %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Vendeur:</span>
                            <span class="info-value">
                                <i class="bi bi-person me-1"></i>
                                <%= vente.getVendeur().getNom() %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Statut:</span>
                            <span>
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
                            </span>
                        </div>
                        <% if (vente.getCommentaire() != null && !vente.getCommentaire().trim().isEmpty()) { %>
                            <div class="info-item">
                                <span class="info-label">Commentaire:</span>
                                <span class="info-value"><%= vente.getCommentaire() %></span>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Panier -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-cart-check me-2"></i>Détails du panier
                        </h5>
                    </div>
                    <div class="card-body">
                        <div id="cartContent">
                            <% if (vente.getLignesVente() != null && !vente.getLignesVente().isEmpty()) { %>
                                <% for (int i = 0; i < vente.getLignesVente().size(); i++) { 
                                    LigneVente ligne = vente.getLignesVente().get(i);
                                %>
                                    <div class="cart-item">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">
                                                    <i class="bi bi-capsule me-2"></i>
                                                    <%= ligne.getMedicament().getNom() %>
                                                </h6>
                                                <small class="text-muted">
                                                    Prix unitaire: <%= String.format("%.2f", ligne.getPrixUnitaire()) %> €
                                                </small>
                                            </div>
                                            <div class="text-end">
                                                <div class="fw-bold">
                                                    <%= ligne.getQuantite() %> x <%= String.format("%.2f", ligne.getPrixUnitaire()) %> €
                                                </div>
                                                <div class="amount">
                                                    <%= String.format("%.2f", ligne.getMontantLigne()) %> €
                                                </div>
                                                <% if (isNewVente) { %>
                                                    <form method="post" action="${pageContext.request.contextPath}/ventes/supprimer-ligne" 
                                                          style="display: inline;" class="mt-2">
                                                        <input type="hidden" name="venteId" value="<%= vente.getId() %>">
                                                        <input type="hidden" name="ligneIndex" value="<%= i %>">
                                                        <button type="submit" class="btn-action btn-danger btn-sm"
                                                                onclick="return confirm('Supprimer cet article ?')"
                                                                title="Supprimer">
                                                            <i class="bi bi-trash-fill"></i>
                                                        </button>
                                                    </form>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                                
                                <div class="total-section mt-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h5 class="mb-1">Total</h5>
                                            <small>Nombre d'articles: <%= vente.getNombreArticles() %></small>
                                        </div>
                                        <div class="text-end">
                                            <h4 class="mb-0">
                                                <i class="bi bi-currency-dollar me-2"></i>
                                                <%= String.format("%.2f", vente.getMontantTotal()) %> €
                                            </h4>
                                        </div>
                                    </div>
                                </div>

                                <% if (isNewVente) { %>
                                    <div class="mt-4">
                                        <form method="post" action="${pageContext.request.contextPath}/ventes/finaliser">
                                            <input type="hidden" name="venteId" value="<%= vente.getId() %>">
                                            <div class="mb-3">
                                                <label for="commentaire" class="form-label">Commentaire (optionnel)</label>
                                                <textarea class="form-control" id="commentaire" name="commentaire" 
                                                          rows="3" placeholder="Ajouter un commentaire à la vente..."></textarea>
                                            </div>
                                            <div class="d-flex gap-2">
                                                <button type="submit" class="btn-action btn-success flex-fill">
                                                    <i class="bi bi-check-circle me-2"></i>Finaliser la vente
                                                </button>
                                                <a href="${pageContext.request.contextPath}/ventes/annuler?id=<%= vente.getId() %>" 
                                                   class="btn-action btn-danger"
                                                   onclick="return confirm('Êtes-vous sûr de vouloir annuler cette vente ?')">
                                                    <i class="bi bi-x-circle me-2"></i>Annuler
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                <% } %>
                            <% } else { %>
                                <div class="empty-cart">
                                    <i class="bi bi-cart-x"></i>
                                    <h5>Panier vide</h5>
                                    <p>Aucun article dans cette vente</p>
                                    <% if (isNewVente) { %>
                                        <a href="${pageContext.request.contextPath}/ventes/nouvelle?venteId=<%= vente.getId() %>" 
                                           class="btn-action btn-success">
                                            <i class="bi bi-plus-circle me-2"></i>Ajouter des produits
                                        </a>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 