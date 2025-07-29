<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.Utilisateur" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null || user.getRole() != Utilisateur.Role.ADMIN) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Nettoyage Base de Données - Pharmacie Manager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-danger text-white">
                        <h4 class="mb-0">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            Nettoyage Base de Données
                        </h4>
                    </div>
                    <div class="card-body">
                        
                        <% if (request.getAttribute("success") != null) { %>
                            <div class="alert alert-success">
                                <h5>✅ Succès !</h5>
                                <%= request.getAttribute("success") %>
                            </div>
                        <% } %>
                        
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger">
                                <h5>❌ Erreur !</h5>
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        
                        <div class="alert alert-warning">
                            <h5>⚠️ Attention !</h5>
                            <p>Cette action va supprimer <strong>TOUTES</strong> les données de la base de données :</p>
                            <ul>
                                <li>Tous les médicaments</li>
                                <li>Toutes les ventes</li>
                                <li>Tous les utilisateurs (sauf vous)</li>
                                <li>Toutes les lignes de vente</li>
                            </ul>
                            <p><strong>Cette action est irréversible !</strong></p>
                        </div>
                        
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                                <i class="bi bi-arrow-left me-2"></i>Retour au Dashboard
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/admin/clean-database" 
                               class="btn btn-danger"
                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer TOUTES les données ? Cette action est irréversible !')">
                                <i class="bi bi-trash me-2"></i>Vider la Base de Données
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 