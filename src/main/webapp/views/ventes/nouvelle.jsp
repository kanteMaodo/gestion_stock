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
    Vente vente = (Vente) request.getAttribute("vente");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Nouvelle Vente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Nouvelle Vente</h1>
            <a href="${pageContext.request.contextPath}/ventes/" class="btn btn-secondary">
                <i class="bi bi-arrow-left me-2"></i>Retour aux Ventes
            </a>
        </div>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="bi bi-cart-plus me-2"></i>Créer une nouvelle vente
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/ventes/ajouter-ligne">
                            <% if (vente != null) { %>
                                <input type="hidden" name="venteId" value="<%= vente.getId() %>">
                            <% } %>
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="medicamentId" class="form-label">Médicament</label>
                                    <select class="form-select" id="medicamentId" name="medicamentId" required>
                                        <option value="">Sélectionner un médicament</option>
                                        <% if (medicaments != null) { %>
                                            <% for (Medicament medicament : medicaments) { %>
                                                <option value="<%= medicament.getId() %>" 
                                                        data-prix="<%= medicament.getPrix() %>"
                                                        data-stock="<%= medicament.getStock() %>">
                                                    <%= medicament.getNom() %> - Stock: <%= medicament.getStock() %>
                                                </option>
                                            <% } %>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="quantite" class="form-label">Quantité</label>
                                    <input type="number" class="form-control" id="quantite" name="quantite" 
                                           min="1" value="1" required>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Prix unitaire</label>
                                    <div class="form-control-plaintext" id="prixUnitaire">0 FCFA</div>
                                </div>
                            </div>
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <label class="form-label">Total</label>
                                    <div class="form-control-plaintext fw-bold text-success" id="total">0 FCFA</div>
                                </div>
                                <div class="col-md-6 text-end">
                                    <button type="submit" class="btn btn-success">
                                        <i class="bi bi-plus-circle me-2"></i>Ajouter au panier
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="bi bi-info-circle me-2"></i>Informations
                        </h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Vendeur :</strong> <%= user.getNomComplet() %></p>
                        <p><strong>Date :</strong> <%= java.time.LocalDate.now() %></p>
                        <hr>
                        <p class="text-muted small">
                            <i class="bi bi-lightbulb me-1"></i>
                            Sélectionnez un médicament et une quantité pour commencer la vente.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Calcul automatique du prix total
        document.getElementById('medicamentId').addEventListener('change', function() {
            const option = this.options[this.selectedIndex];
            const prix = option.dataset.prix || 0;
            const stock = option.dataset.stock || 0;
            
            document.getElementById('prixUnitaire').textContent = prix + ' FCFA';
            document.getElementById('quantite').max = stock;
            
            calculerTotal();
        });
        
        document.getElementById('quantite').addEventListener('input', calculerTotal);
        
        function calculerTotal() {
            const option = document.getElementById('medicamentId').options[document.getElementById('medicamentId').selectedIndex];
            const prix = option.dataset.prix || 0;
            const quantite = document.getElementById('quantite').value || 0;
            const total = prix * quantite;
            
            document.getElementById('total').textContent = total + ' FCFA';
        }
    </script>
</body>
</html> 