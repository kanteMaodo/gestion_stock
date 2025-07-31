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
    
    Vente vente = (Vente) request.getAttribute("vente");
    if (vente == null) {
        response.sendRedirect(request.getContextPath() + "/ventes/");
        return;
    }
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Détails de la Vente #<%= vente.getId() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Vente #<%= vente.getId() %></h1>
            <a href="${pageContext.request.contextPath}/ventes/" class="btn btn-secondary">
                <i class="bi bi-arrow-left me-2"></i>Retour aux Ventes
            </a>
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
        
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="bi bi-list-ul me-2"></i>Articles de la vente
                        </h5>
                    </div>
                    <div class="card-body">
                        <% if (vente.getLignesVente() != null && !vente.getLignesVente().isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Médicament</th>
                                            <th>Prix unitaire</th>
                                            <th>Quantité</th>
                                            <th>Total</th>
                                            <% if (vente.getStatut() == Vente.StatutVente.EN_COURS) { %>
                                                <th>Action</th>
                                            <% } %>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (int i = 0; i < vente.getLignesVente().size(); i++) { %>
                                            <% LigneVente ligne = vente.getLignesVente().get(i); %>
                                            <tr>
                                                <td><%= ligne.getMedicament().getNom() %></td>
                                                <td><%= ligne.getPrixUnitaire() %> FCFA</td>
                                                <td><%= ligne.getQuantite() %></td>
                                                <td><strong><%= ligne.getMontantLigne() %> FCFA</strong></td>
                                                <% if (vente.getStatut() == Vente.StatutVente.EN_COURS) { %>
                                                    <td>
                                                        <form method="post" action="${pageContext.request.contextPath}/ventes/supprimer-ligne" 
                                                              style="display: inline;" onsubmit="return confirm('Supprimer cet article ?')">
                                                            <input type="hidden" name="venteId" value="<%= vente.getId() %>">
                                                            <input type="hidden" name="ligneIndex" value="<%= i %>">
                                                            <button type="submit" class="btn btn-sm btn-danger">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </form>
                                                    </td>
                                                <% } %>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-4">
                                <i class="bi bi-cart-x fs-1 text-muted mb-3"></i>
                                <h5 class="text-muted">Aucun article dans cette vente</h5>
                                <p class="text-muted">Ajoutez des articles pour commencer</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="bi bi-info-circle me-2"></i>Informations de la vente
                        </h5>
                    </div>
                    <div class="card-body">
                        <p><strong>N° Vente :</strong> #<%= vente.getId() %></p>
                        <p><strong>Date :</strong> <%= vente.getDateVente() != null ? vente.getDateVente().format(formatter) : "N/A" %></p>
                        <p><strong>Vendeur :</strong> <%= vente.getVendeur() != null ? vente.getVendeur().getNomComplet() : "N/A" %></p>
                        <p><strong>Statut :</strong> 
                            <% if (vente.getStatut() == Vente.StatutVente.COMPLETEE) { %>
                                <span class="badge bg-success">Complétée</span>
                            <% } else if (vente.getStatut() == Vente.StatutVente.ANNULEE) { %>
                                <span class="badge bg-danger">Annulée</span>
                            <% } else { %>
                                <span class="badge bg-warning text-dark">En cours</span>
                            <% } %>
                        </p>
                        <hr>
                        <h4 class="text-success">Total: <%= String.format("%.0f", vente.getMontantTotal()) %> FCFA</h4>
                        
                        <% if (vente.getStatut() == Vente.StatutVente.EN_COURS) { %>
                            <hr>
                            <form method="post" action="${pageContext.request.contextPath}/ventes/finaliser">
                                <input type="hidden" name="venteId" value="<%= vente.getId() %>">
                                <div class="mb-3">
                                    <label for="commentaire" class="form-label">Commentaire (optionnel)</label>
                                    <textarea class="form-control" id="commentaire" name="commentaire" rows="3" 
                                              placeholder="Ajouter un commentaire..."><%= vente.getCommentaire() != null ? vente.getCommentaire() : "" %></textarea>
                                </div>
                                <button type="submit" class="btn btn-success w-100">
                                    <i class="bi bi-check-circle me-2"></i>Finaliser la vente
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 