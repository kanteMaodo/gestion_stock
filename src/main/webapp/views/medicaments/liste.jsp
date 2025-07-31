<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.*" %>
<%@ page import="java.util.List" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
    
    List<Medicament> medicaments = (List<Medicament>) request.getAttribute("medicaments");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Médicaments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Gestion des Médicaments</h1>
            <a href="${pageContext.request.contextPath}/<%= user.getRole() == Utilisateur.Role.ADMIN ? "admin" : "pharmacien" %>/dashboard" class="btn btn-primary">
                Retour au Tableau de bord
            </a>
        </div>
        
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Médicaments (<%= medicaments != null ? medicaments.size() : 0 %>)</h5>
                <a href="${pageContext.request.contextPath}/medicaments/ajouter" class="btn btn-success">
                    Nouveau Médicament
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
                            <th>Nom</th>
                            <th>Catégorie</th>
                            <th>Prix</th>
                            <th>Stock</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (medicaments != null && !medicaments.isEmpty()) { %>
                            <% for (Medicament medicament : medicaments) { %>
                                <tr>
                                    <td><%= medicament.getNom() %></td>
                                    <td><%= medicament.getCategorie() %></td>
                                    <td><%= medicament.getPrix() %> FCFA</td>
                                    <td><%= medicament.getStock() %></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/medicaments/?action=modifier&id=<%= medicament.getId() %>" class="btn btn-sm btn-primary">Modifier</a>
                                        <a href="${pageContext.request.contextPath}/medicaments/?action=supprimer&id=<%= medicament.getId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer ?')">Supprimer</a>
                                    </td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr>
                                <td colspan="5" class="text-center">Aucun médicament trouvé</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html> 