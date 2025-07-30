<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.*" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
    
    Medicament medicament = (Medicament) request.getAttribute("medicament");
    if (medicament == null) {
        response.sendRedirect(request.getContextPath() + "/medicaments/");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Réapprovisionner - Pharmacie Manager</title>
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
            transform: translateX(5px);
        }
        .main {
            margin-left: 250px;
            padding: 20px;
        }
        .card {
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 30px;
            background: #fff;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .info-card {
            background: #fff;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .stock-low {
            color: #dc3545;
            font-weight: bold;
        }
        .stock-ok {
            color: #28a745;
        }
        .btn-action {
            padding: 12px 24px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-action:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="text-center py-4">
            <h4>PHARMACIE MOUHAMED</h4>
            <small>Espace <%= user.getRole().getLibelle() %></small>
        </div>

        <a href="${pageContext.request.contextPath}/dashboard">
            <i class="bi bi-speedometer2 me-2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/medicaments/" class="active">
            <i class="bi bi-box-seam me-2"></i> Gestion Stock
        </a>
        <a href="${pageContext.request.contextPath}/medicaments/ajouter">
            <i class="bi bi-plus-circle me-2"></i> Ajouter Médicament
        </a>
        <a href="${pageContext.request.contextPath}/ventes/">
            <i class="bi bi-graph-up me-2"></i> Rapports
        </a>
        <a href="${pageContext.request.contextPath}/alertes/">
            <i class="bi bi-exclamation-triangle me-2"></i> Alertes
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="bi bi-box-arrow-right me-2"></i> Déconnexion
        </a>
    </div>

    <!-- Main Content -->
    <div class="main">
        <!-- Header -->
        <div class="header">
            <div>
                <h2 class="mb-1">Réapprovisionner le Stock</h2>
                <p class="text-muted mb-0">Ajouter des unités au stock</p>
            </div>
            <div class="d-flex align-items-center">
                <div class="me-3">
                    <i class="bi bi-person-circle fs-1 text-primary"></i>
                </div>
                <div class="text-end">
                    <div class="fw-bold"><%= user.getNomComplet() %></div>
                    <small class="text-muted"><%= user.getRole().getLibelle() %></small>
                </div>
            </div>
        </div>

        <!-- Error Messages -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Informations du médicament -->
        <div class="info-card">
            <h5 class="mb-3">
                <i class="bi bi-capsule me-2"></i>
                Informations du Médicament
            </h5>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Nom:</strong> <%= medicament.getNom() %></p>
                    <p><strong>Catégorie:</strong> <span class="badge bg-secondary"><%= medicament.getCategorie() != null ? medicament.getCategorie() : "Non spécifiée" %></span></p>
                    <p><strong>Fabricant:</strong> <%= medicament.getFabricant() != null ? medicament.getFabricant() : "Non spécifié" %></p>
                    <% if (medicament.getCodeBarre() != null && !medicament.getCodeBarre().isEmpty()) { %>
                        <p><strong>Code-barres:</strong> <%= medicament.getCodeBarre() %></p>
                    <% } %>
                </div>
                <div class="col-md-6">
                    <p><strong>Prix unitaire:</strong> <span class="fw-bold text-success"><%= medicament.getPrix() != null ? String.format("%.0f", medicament.getPrix()) : "0" %> FCFA</span></p>
                    <p><strong>Stock actuel:</strong> 
                        <span class="<%= medicament.getStock() <= medicament.getSeuilAlerte() ? 'stock-low' : 'stock-ok' %>">
                            <%= medicament.getStock() %>
                        </span>
                    </p>
                    <p><strong>Seuil d'alerte:</strong> <%= medicament.getSeuilAlerte() %></p>
                    <% if (medicament.getDateExpiration() != null) { %>
                        <p><strong>Expiration:</strong> <%= medicament.getDateExpiration().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></p>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Formulaire de réapprovisionnement -->
        <div class="info-card">
            <h5 class="mb-3">
                <i class="bi bi-plus-circle me-2"></i>
                Réapprovisionnement
            </h5>
            <form action="${pageContext.request.contextPath}/medicaments/" method="post" id="formReapprovisionnement">
                <input type="hidden" name="action" value="reapprovisionner">
                <input type="hidden" name="id" value="<%= medicament.getId() %>">
                <% if (request.getParameter("retour") != null) { %>
                    <input type="hidden" name="retour" value="<%= request.getParameter("retour") %>">
                <% } %>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="quantite" class="form-label required">Quantité à ajouter</label>
                        <input type="number" class="form-control" id="quantite" name="quantite" 
                               min="1" required placeholder="Ex: 50">
                        <div class="form-text">Entrez le nombre d'unités à ajouter au stock</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="nouveauStock" class="form-label">Nouveau stock (calculé automatiquement)</label>
                        <input type="number" class="form-control" id="nouveauStock" readonly
                               value="<%= medicament.getStock() %>">
                        <div class="form-text">Stock après réapprovisionnement</div>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="commentaire" class="form-label">Commentaire (optionnel)</label>
                    <textarea class="form-control" id="commentaire" name="commentaire" rows="3"
                              placeholder="Raison du réapprovisionnement, fournisseur, etc..."></textarea>
                </div>

                <!-- Actions -->
                <div class="d-flex justify-content-between mt-4">
                    <button type="button" onclick="annuler()" class="btn btn-secondary btn-action">
                        <i class="bi bi-arrow-left me-2"></i>Annuler
                    </button>
                    <button type="submit" class="btn btn-success btn-action">
                        <i class="bi bi-plus-circle me-2"></i>Réapprovisionner
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Calcul automatique du nouveau stock
        document.getElementById('quantite').addEventListener('input', function() {
            const quantiteActuelle = <%= medicament.getStock() %>;
            const quantiteAjoutee = parseInt(this.value) || 0;
            const nouveauStock = quantiteActuelle + quantiteAjoutee;
            
            document.getElementById('nouveauStock').value = nouveauStock;
            
            // Changer la couleur selon le seuil d'alerte
            const seuilAlerte = <%= medicament.getSeuilAlerte() %>;
            const stockField = document.getElementById('nouveauStock');
            
            if (nouveauStock <= seuilAlerte) {
                stockField.style.color = '#dc3545';
                stockField.style.fontWeight = 'bold';
            } else {
                stockField.style.color = '#28a745';
                stockField.style.fontWeight = 'normal';
            }
        });
        
        // Validation du formulaire
        document.getElementById('formReapprovisionnement').addEventListener('submit', function(e) {
            const quantite = parseInt(document.getElementById('quantite').value);
            
            if (quantite <= 0) {
                e.preventDefault();
                alert('La quantité doit être supérieure à 0');
                return false;
            }
            
            if (quantite > 10000) {
                if (!confirm('Vous allez ajouter ' + quantite + ' unités. Êtes-vous sûr ?')) {
                    e.preventDefault();
                    return false;
                }
            }
        });
        
        // Fonction pour gérer le bouton Annuler
        function annuler() {
            const retour = '<%= request.getParameter("retour") %>';
            if (retour === 'alertes') {
                window.location.href = '${pageContext.request.contextPath}/alertes/';
            } else {
                window.location.href = '${pageContext.request.contextPath}/medicaments/';
            }
        }
    </script>
</body>
</html> 