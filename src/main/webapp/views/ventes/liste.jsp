<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
    
    List<Vente> ventes = (List<Vente>) request.getAttribute("ventes");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Ventes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Gestion des Ventes</h1>
            <a href="${pageContext.request.contextPath}/<%= user.getRole() == Utilisateur.Role.ADMIN ? "admin" : "pharmacien" %>/dashboard" class="btn btn-primary">
                Retour au Tableau de bord
            </a>
        </div>
        
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Ventes (<%= ventes != null ? ventes.size() : 0 %>)</h5>
                <a href="${pageContext.request.contextPath}/ventes/nouvelle" class="btn btn-success">
                    <i class="bi bi-plus-circle me-2"></i>Nouvelle Vente
                </a>
            </div>
            <div class="card-body">
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
                
                <table class="table">
                    <thead>
                        <tr>
                            <th>N° Vente</th>
                            <th>Date</th>
                            <th>Vendeur</th>
                            <th>Montant</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (ventes != null && !ventes.isEmpty()) { %>
                            <% for (Vente vente : ventes) { %>
                                <tr>
                                    <td><strong>#<%= vente.getId() %></strong></td>
                                    <td>
                                        <i class="bi bi-calendar3 me-1"></i>
                                        <%= vente.getDateVente() != null ? vente.getDateVente().format(formatter) : "N/A" %>
                                    </td>
                                    <td>
                                        <i class="bi bi-person me-1"></i>
                                        <%= vente.getVendeur() != null ? vente.getVendeur().getNomComplet() : "N/A" %>
                                    </td>
                                    <td>
                                        <strong class="text-success">
                                            <%= vente.getMontantTotal() != null ? String.format("%.0f", vente.getMontantTotal()) : "0" %> FCFA
                                        </strong>
                                    </td>
                                    <td>
                                        <% if (vente.getStatut() == Vente.StatutVente.COMPLETEE) { %>
                                            <span class="badge bg-success">
                                                <i class="bi bi-check-circle me-1"></i>Complétée
                                            </span>
                                        <% } else if (vente.getStatut() == Vente.StatutVente.ANNULEE) { %>
                                            <span class="badge bg-danger">
                                                <i class="bi bi-x-circle me-1"></i>Annulée
                                            </span>
                                        <% } else { %>
                                            <span class="badge bg-warning text-dark">
                                                <i class="bi bi-clock me-1"></i>En cours
                                            </span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/ventes/details?id=<%= vente.getId() %>" 
                                           class="btn btn-sm btn-primary" title="Voir les détails">
                                            <i class="bi bi-eye-fill"></i>
                                        </a>
                                        <% if (vente.getStatut() == Vente.StatutVente.EN_COURS) { %>
                                            <a href="${pageContext.request.contextPath}/ventes/nouvelle?venteId=<%= vente.getId() %>" 
                                               class="btn btn-sm btn-success" title="Continuer la vente">
                                                <i class="bi bi-plus-circle"></i>
                                            </a>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-5">
                                    <i class="bi bi-cart-x fs-1 text-muted mb-3 d-block"></i>
                                    <h5 class="text-muted">Aucune vente trouvée</h5>
                                    <p class="text-muted">Commencez par créer votre première vente</p>
                                    <a href="${pageContext.request.contextPath}/ventes/nouvelle" class="btn btn-success">
                                        <i class="bi bi-plus-circle me-2"></i>Créer une vente
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 