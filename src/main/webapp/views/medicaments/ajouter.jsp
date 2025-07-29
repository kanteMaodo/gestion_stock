<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un Médicament - PHARMACIE MOUHAMED</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #28a745;
            --secondary-color: #20c997;
            --accent-color: #17a2b8;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #343a40;
        }
        
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .navbar-brand {
            font-weight: bold;
            color: var(--primary-color) !important;
        }
        
        .sidebar {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            min-height: 100vh;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .sidebar .nav-link {
            color: white !important;
            padding: 12px 20px;
            border-radius: 8px;
            margin: 4px 0;
            transition: all 0.3s ease;
        }
        
        .sidebar .nav-link:hover {
            background-color: rgba(255,255,255,0.2);
            transform: translateX(5px);
        }
        
        .sidebar .nav-link.active {
            background-color: rgba(255,255,255,0.3);
            font-weight: bold;
        }
        
        .main-content {
            padding: 20px;
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 20px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        
        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
        }
        
        .required::after {
            content: " *";
            color: var(--danger-color);
        }
        
        .form-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid var(--primary-color);
        }
        
        .form-section h5 {
            color: var(--primary-color);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-clinic-medical me-2"></i>
                PHARMACIE MOUHAMED
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    <i class="fas fa-user me-1"></i>
                    ${user.nom} ${user.prenom} (${user.role})
                </span>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-0">
                <div class="p-3">
                    <h5 class="text-white mb-4">
                        <i class="fas fa-tachometer-alt me-2"></i>
                        Dashboard
                    </h5>
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-home me-2"></i> Accueil
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/medicaments/">
                            <i class="fas fa-pills me-2"></i> Médicaments
                        </a>
                        <a class="nav-link" href="#">
                            <i class="fas fa-shopping-cart me-2"></i> Ventes
                        </a>
                        <a class="nav-link" href="#">
                            <i class="fas fa-users me-2"></i> Utilisateurs
                        </a>
                        <a class="nav-link" href="#">
                            <i class="fas fa-chart-bar me-2"></i> Rapports
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="text-dark">
                            <i class="fas fa-plus-circle me-2"></i>
                            Ajouter un Médicament
                        </h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/medicaments/">
                                        <i class="fas fa-pills me-1"></i> Médicaments
                                    </a>
                                </li>
                                <li class="breadcrumb-item active">Ajouter</li>
                            </ol>
                        </nav>
                    </div>
                    <a href="${pageContext.request.contextPath}/medicaments/" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>
                        Retour à la liste
                    </a>
                </div>

                <!-- Messages d'erreur -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Formulaire -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-pills me-2"></i>
                            Informations du Médicament
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/medicaments/" method="post" id="formMedicament">
                            <input type="hidden" name="action" value="ajouter">
                            
                            <!-- Informations de base -->
                            <div class="form-section">
                                <h5>
                                    <i class="fas fa-info-circle me-2"></i>
                                    Informations de base
                                </h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="nom" class="form-label required">Nom du médicament</label>
                                        <input type="text" class="form-control" id="nom" name="nom" required
                                               placeholder="Ex: Paracétamol 500mg">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="codeBarre" class="form-label">Code-barres</label>
                                        <input type="text" class="form-control" id="codeBarre" name="codeBarre"
                                               placeholder="Ex: 1234567890123">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea class="form-control" id="description" name="description" rows="3"
                                              placeholder="Description détaillée du médicament..."></textarea>
                                </div>
                            </div>

                            <!-- Catégorisation -->
                            <div class="form-section">
                                <h5>
                                    <i class="fas fa-tags me-2"></i>
                                    Catégorisation
                                </h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="categorie" class="form-label required">Catégorie</label>
                                        <select class="form-select" id="categorie" name="categorie" required>
                                            <option value="">Sélectionner une catégorie</option>
                                            <option value="Antibiotiques">Antibiotiques</option>
                                            <option value="Analgésiques">Analgésiques</option>
                                            <option value="Anti-inflammatoires">Anti-inflammatoires</option>
                                            <option value="Antihistaminiques">Antihistaminiques</option>
                                            <option value="Vitamines">Vitamines</option>
                                            <option value="Minéraux">Minéraux</option>
                                            <option value="Antibiotiques">Antibiotiques</option>
                                            <option value="Antiviraux">Antiviraux</option>
                                            <option value="Antifongiques">Antifongiques</option>
                                            <option value="Antiparasitaires">Antiparasitaires</option>
                                            <option value="Cardiovasculaires">Cardiovasculaires</option>
                                            <option value="Respiratoires">Respiratoires</option>
                                            <option value="Digestifs">Digestifs</option>
                                            <option value="Dermatologiques">Dermatologiques</option>
                                            <option value="Oculaires">Oculaires</option>
                                            <option value="Otorhinolaryngologiques">Otorhinolaryngologiques</option>
                                            <option value="Gynécologiques">Gynécologiques</option>
                                            <option value="Urologiques">Urologiques</option>
                                            <option value="Endocrinologiques">Endocrinologiques</option>
                                            <option value="Neurologiques">Neurologiques</option>
                                            <option value="Psychiatriques">Psychiatriques</option>
                                            <option value="Oncologiques">Oncologiques</option>
                                            <option value="Autres">Autres</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="fabricant" class="form-label required">Fabricant</label>
                                        <input type="text" class="form-control" id="fabricant" name="fabricant" required
                                               placeholder="Ex: Pfizer, Sanofi, etc.">
                                    </div>
                                </div>
                            </div>

                            <!-- Prix et Stock -->
                            <div class="form-section">
                                <h5>
                                    <i class="fas fa-euro-sign me-2"></i>
                                    Prix et Stock
                                </h5>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label for="prix" class="form-label required">Prix unitaire (€)</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="prix" name="prix" 
                                                   step="0.01" min="0" required placeholder="0.00">
                                            <span class="input-group-text">€</span>
                                        </div>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="stock" class="form-label required">Stock initial</label>
                                        <input type="number" class="form-control" id="stock" name="stock" 
                                               min="0" required placeholder="0">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="seuilAlerte" class="form-label required">Seuil d'alerte</label>
                                        <input type="number" class="form-control" id="seuilAlerte" name="seuilAlerte" 
                                               min="0" required placeholder="0">
                                    </div>
                                </div>
                            </div>

                            <!-- Date d'expiration -->
                            <div class="form-section">
                                <h5>
                                    <i class="fas fa-calendar-alt me-2"></i>
                                    Date d'expiration
                                </h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="dateExpiration" class="form-label">Date d'expiration</label>
                                        <input type="date" class="form-control" id="dateExpiration" name="dateExpiration"
                                               min="${java.time.LocalDate.now()}">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Laissez vide si pas de date d'expiration spécifique
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Boutons d'action -->
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/medicaments/" class="btn btn-outline-secondary">
                                    <i class="fas fa-times me-2"></i>
                                    Annuler
                                </a>
                                <div>
                                    <button type="button" class="btn btn-outline-info me-2" onclick="previsualiser()">
                                        <i class="fas fa-eye me-2"></i>
                                        Prévisualiser
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>
                                        Enregistrer le médicament
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de prévisualisation -->
    <div class="modal fade" id="modalPrevisualisation" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-eye me-2"></i>
                        Prévisualisation du médicament
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
                                '<strong>Prix:</strong> ' + (data.prix ? data.prix + '€' : 'Non spécifié') + '<br>' +
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
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html> 