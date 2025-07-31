<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.gestionpharmacie.model.Utilisateur" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un Médicament</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Ajouter un Médicament</h1>
            <a href="${pageContext.request.contextPath}/medicaments/" class="btn btn-secondary">
                ← Retour à la liste
            </a>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Informations du médicament</h5>
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
                <form method="POST" action="${pageContext.request.contextPath}/medicaments/">
                    <input type="hidden" name="action" value="ajouter">
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nom" class="form-label">Nom du médicament *</label>
                            <input type="text" class="form-control" id="nom" name="nom" required 
                                   placeholder="Ex: Paracétamol 500mg">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="codeBarre" class="form-label">Code</label>
                            <input type="text" class="form-control" id="codeBarre" name="codeBarre" 
                                   placeholder="Ex: 1234567890123">
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" 
                                  placeholder="Description détaillée du médicament..."></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="categorie" class="form-label">Catégorie *</label>
                            <select class="form-select" id="categorie" name="categorie" required>
                                <option value="">Sélectionner une catégorie</option>
                                <option value="Antiviraux">Antiviraux</option>
                                <option value="Antihistaminiques">Antihistaminiques</option>
                                <option value="Vitamines">Vitamines</option>
                                <option value="Anti-inflammatoires">Anti-inflammatoires</option>
                                <option value="Antibiotiques">Antibiotiques</option>
                                <option value="Analgésiques">Analgésiques</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="fabricant" class="form-label">Fabricant *</label>
                            <input type="text" class="form-control" id="fabricant" name="fabricant" required 
                                   placeholder="Ex: SANOFI">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="prix" class="form-label">Prix (FCFA) *</label>
                            <input type="number" class="form-control" id="prix" name="prix" required 
                                   step="0.01" min="0" placeholder="Ex: 500">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="stock" class="form-label">Stock initial *</label>
                            <input type="number" class="form-control" id="stock" name="stock" required 
                                   min="0" placeholder="Ex: 100">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="seuilAlerte" class="form-label">Seuil d'alerte</label>
                            <input type="number" class="form-control" id="seuilAlerte" name="seuilAlerte" 
                                   min="0" placeholder="Ex: 20" value="50">
                        </div>
                    </div>
                    
                                         <div class="row">
                         <div class="col-md-6 mb-3">
                             <label for="dateExpiration" class="form-label">Date d'expiration</label>
                             <input type="date" class="form-control" id="dateExpiration" name="dateExpiration">
                         </div>
                     </div>
                    
                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/medicaments/" class="btn btn-secondary">
                            Annuler
                        </a>
                        <button type="submit" class="btn btn-primary">
                            Ajouter le médicament
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html> 