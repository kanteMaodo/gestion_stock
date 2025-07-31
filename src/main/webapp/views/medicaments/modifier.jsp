<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

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
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    

%>

<!DOCTYPE html>
<html>
<head>
    <title>Modifier Médicament - Pharmacie Manager</title>
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
        .form-section {
            background: #fff;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .form-section h5 {
            color: #28a745;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .required::after {
            content: " *";
            color: #dc3545;
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
                        <i class="bi bi-speedometer2 me-2"></i> Tableau de bord
                    </a>
        <a href="${pageContext.request.contextPath}/medicaments/">
            <i class="bi bi-box-seam me-2"></i> Gestion Stock
        </a>
        <a href="${pageContext.request.contextPath}/medicaments/ajouter">
            <i class="bi bi-plus-circle me-2"></i> Ajouter Médicament
        </a>
        <a href="${pageContext.request.contextPath}/ventes/">
            <i class="bi bi-cart me-2"></i> Ventes
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
                <h2 class="mb-1">Modifier le Médicament</h2>
                <p class="text-muted mb-0">Mise à jour des informations</p>
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

        <!-- Formulaire de modification -->
        <div class="form-section">
            <form action="${pageContext.request.contextPath}/medicaments/" method="post" id="formMedicament">
                <input type="hidden" name="action" value="modifier">
                <input type="hidden" name="id" value="<%= medicament.getId() %>">
                <input type="hidden" name="retour" value="<%= request.getParameter("retour") != null ? request.getParameter("retour") : "" %>">

                
                <!-- Informations de base -->
                <div class="form-section">
                    <h5>
                        <i class="bi bi-info-circle me-2"></i>
                        Informations de base
                    </h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nom" class="form-label required">Nom du médicament</label>
                            <input type="text" class="form-control" id="nom" name="nom" required
                                   value="<%= medicament.getNom() != null ? medicament.getNom() : "" %>"
                                   placeholder="Ex: Paracétamol 500mg">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="codeBarre" class="form-label">Code-barres</label>
                            <input type="text" class="form-control" id="codeBarre" name="codeBarre"
                                   value="<%= medicament.getCodeBarre() != null ? medicament.getCodeBarre() : "" %>"
                                   placeholder="Ex: 1234567890123">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3"
                                  placeholder="Description détaillée du médicament..."><%= medicament.getDescription() != null ? medicament.getDescription() : "" %></textarea>
                    </div>
                </div>

                <!-- Catégorisation -->
                <div class="form-section">
                    <h5>
                        <i class="bi bi-tags me-2"></i>
                        Catégorisation
                    </h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="categorie" class="form-label required">Catégorie</label>
                            <select class="form-select" id="categorie" name="categorie" required>
                                <option value="">Sélectionner une catégorie</option>
                                <option value="Antibiotiques" <%= "Antibiotiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Antibiotiques</option>
                                <option value="Analgésiques" <%= "Analgésiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Analgésiques</option>
                                <option value="Anti-inflammatoires" <%= "Anti-inflammatoires".equals(medicament.getCategorie()) ? "selected" : "" %>>Anti-inflammatoires</option>
                                <option value="Antihistaminiques" <%= "Antihistaminiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Antihistaminiques</option>
                                <option value="Vitamines" <%= "Vitamines".equals(medicament.getCategorie()) ? "selected" : "" %>>Vitamines</option>
                                <option value="Minéraux" <%= "Minéraux".equals(medicament.getCategorie()) ? "selected" : "" %>>Minéraux</option>
                                <option value="Antiviraux" <%= "Antiviraux".equals(medicament.getCategorie()) ? "selected" : "" %>>Antiviraux</option>
                                <option value="Antifongiques" <%= "Antifongiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Antifongiques</option>
                                <option value="Antiparasitaires" <%= "Antiparasitaires".equals(medicament.getCategorie()) ? "selected" : "" %>>Antiparasitaires</option>
                                <option value="Cardiovasculaires" <%= "Cardiovasculaires".equals(medicament.getCategorie()) ? "selected" : "" %>>Cardiovasculaires</option>
                                <option value="Respiratoires" <%= "Respiratoires".equals(medicament.getCategorie()) ? "selected" : "" %>>Respiratoires</option>
                                <option value="Digestifs" <%= "Digestifs".equals(medicament.getCategorie()) ? "selected" : "" %>>Digestifs</option>
                                <option value="Dermatologiques" <%= "Dermatologiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Dermatologiques</option>
                                <option value="Oculaires" <%= "Oculaires".equals(medicament.getCategorie()) ? "selected" : "" %>>Oculaires</option>
                                <option value="Otorhinolaryngologiques" <%= "Otorhinolaryngologiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Otorhinolaryngologiques</option>
                                <option value="Gynécologiques" <%= "Gynécologiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Gynécologiques</option>
                                <option value="Urologiques" <%= "Urologiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Urologiques</option>
                                <option value="Endocrinologiques" <%= "Endocrinologiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Endocrinologiques</option>
                                <option value="Neurologiques" <%= "Neurologiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Neurologiques</option>
                                <option value="Psychiatriques" <%= "Psychiatriques".equals(medicament.getCategorie()) ? "selected" : "" %>>Psychiatriques</option>
                                <option value="Oncologiques" <%= "Oncologiques".equals(medicament.getCategorie()) ? "selected" : "" %>>Oncologiques</option>
                                <option value="Autres" <%= "Autres".equals(medicament.getCategorie()) ? "selected" : "" %>>Autres</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="fabricant" class="form-label required">Fabricant</label>
                            <input type="text" class="form-control" id="fabricant" name="fabricant" required
                                   value="<%= medicament.getFabricant() != null ? medicament.getFabricant() : "" %>"
                                   placeholder="Ex: Pfizer, Sanofi, etc.">
                        </div>
                    </div>
                </div>

                <!-- Prix et Stock -->
                <div class="form-section">
                    <h5>
                        <i class="bi bi-euro me-2"></i>
                        Prix et Stock
                    </h5>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="prix" class="form-label required">Prix unitaire (FCFA)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="prix" name="prix" 
                                       step="0.01" min="0" required 
                                       value="<%= medicament.getPrix() != null ? medicament.getPrix() : "" %>"
                                       placeholder="0.00">
                                <span class="input-group-text">FCFA</span>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="stock" class="form-label required">Stock actuel</label>
                            <input type="number" class="form-control" id="stock" name="stock" 
                                   min="0" required 
                                   value="<%= medicament.getStock() != null ? medicament.getStock() : "" %>"
                                   placeholder="0">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="seuilAlerte" class="form-label required">Seuil d'alerte</label>
                            <input type="number" class="form-control" id="seuilAlerte" name="seuilAlerte" 
                                   min="0" required 
                                   value="<%= medicament.getSeuilAlerte() != null ? medicament.getSeuilAlerte() : "" %>"
                                   placeholder="0">
                        </div>
                    </div>
                </div>

                <!-- Date d'expiration -->
                <div class="form-section">
                    <h5>
                        <i class="bi bi-calendar me-2"></i>
                        Date d'expiration
                    </h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="dateExpiration" class="form-label">Date d'expiration</label>
                            <input type="date" class="form-control" id="dateExpiration" name="dateExpiration"
                                   value="<%= medicament.getDateExpiration() != null ? medicament.getDateExpiration().format(formatter) : "" %>"
                                   min="<%= java.time.LocalDate.now() %>">
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="d-flex justify-content-between mt-4">
                    <a href="${pageContext.request.contextPath}/<%= request.getParameter("retour") != null && request.getParameter("retour").equals("alertes") ? "alertes/" : "medicaments/" %>" class="btn btn-secondary btn-action">
                        <i class="bi bi-arrow-left me-2"></i>Annuler
                    </a>
                    <div>
                        <button type="button" class="btn btn-info btn-action me-2" onclick="previsualiser()">
                            <i class="bi bi-eye me-2"></i>Aperçu
                        </button>
                        <button type="submit" class="btn btn-success btn-action">
                            <i class="bi bi-check-circle me-2"></i>Enregistrer les modifications
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal de prévisualisation -->
    <div class="modal fade" id="modalPrevisualisation" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-eye me-2"></i>
                        Aperçu du Médicament
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="previsualisationContent">
                    <!-- Le contenu sera généré par JavaScript -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>

        
        // Validation en temps réel
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('formMedicament');
            const inputs = form.querySelectorAll('input[required], select[required]');
            
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    validateField(this);
                });
            });
            
            form.addEventListener('submit', function(e) {
                if (!validateForm()) {
                    e.preventDefault();
                }
            });
        });
        
        function validateField(field) {
            const value = field.value.trim();
            const isValid = value !== '';
            
            if (isValid) {
                field.classList.remove('is-invalid');
                field.classList.add('is-valid');
            } else {
                field.classList.remove('is-valid');
                field.classList.add('is-invalid');
            }
            
            return isValid;
        }
        
        function validateForm() {
            const requiredFields = document.querySelectorAll('input[required], select[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!validateField(field)) {
                    isValid = false;
                }
            });
            
            return isValid;
        }
        
        function previsualiser() {
            const formData = new FormData(document.getElementById('formMedicament'));
            const data = {};
            
            for (let [key, value] of formData.entries()) {
                data[key] = value;
            }
            
            const content = 
                '<div class="card">' +
                    '<div class="card-body">' +
                        '<h6 class="card-title">' + (data.nom || 'Nom du médicament') + '</h6>' +
                        '<p class="card-text">' + (data.description || 'Aucune description') + '</p>' +
                        '<div class="row">' +
                            '<div class="col-md-6">' +
                                '<strong>Catégorie:</strong> ' + (data.categorie || 'Non spécifiée') + '<br>' +
                                '<strong>Fabricant:</strong> ' + (data.fabricant || 'Non spécifié') + '<br>' +
                                '<strong>Code-barres:</strong> ' + (data.codeBarre || 'Non spécifié') +
                            '</div>' +
                            '<div class="col-md-6">' +
                                '<strong>Prix:</strong> ' + (data.prix ? data.prix + ' FCFA' : 'Non spécifié') + '<br>' +
                                '<strong>Stock:</strong> ' + (data.stock || 'Non spécifié') + '<br>' +
                                '<strong>Seuil d\'alerte:</strong> ' + (data.seuilAlerte || 'Non spécifié') +
                            '</div>' +
                        '</div>' +
                        (data.dateExpiration ? '<br><strong>Date d\'expiration:</strong> ' + data.dateExpiration : '') +
                    '</div>' +
                '</div>';
            
            document.getElementById('previsualisationContent').innerHTML = content;
            new bootstrap.Modal(document.getElementById('modalPrevisualisation')).show();
        }
    </script>
</body>
</html> 