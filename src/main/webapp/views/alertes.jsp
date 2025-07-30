<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.Medicament" %>
<%@ page import="org.example.gestionpharmacie.model.Utilisateur" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>


<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    Map<String, Object> alertes = (Map<String, Object>) request.getAttribute("alertes");
    List<Medicament> stockFaible = (List<Medicament>) alertes.get("stockFaible");
    List<Medicament> expirationProche = (List<Medicament>) alertes.get("expirationProche");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alertes - Pharmacie Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; }
        .alert-card { 
            border-radius: 12px; 
            border: none; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .alert-card:hover { transform: translateY(-2px); }
        .alert-header { 
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border-radius: 12px 12px 0 0;
        }
        .alert-warning-header {
            background: linear-gradient(135deg, #ffc107, #e0a800);
            color: #212529;
        }
        .stock-critical { color: #dc3545; font-weight: bold; }
        .expiration-critical { 
            background: #dc3545; 
            color: white; 
            padding: 2px 8px; 
            border-radius: 4px; 
        }
        .expiration-warning { 
            background: #ffc107; 
            color: #212529; 
            padding: 2px 8px; 
            border-radius: 4px; 
        }
        .stats-card {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 12px;
        }
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            margin: 2px;
            transition: all 0.2s;
        }
        .btn-action:hover { transform: scale(1.05); }
        .btn-primary { background: #007bff; color: white; }
        .btn-warning { background: #ffc107; color: #212529; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Main content -->
        <div class="px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="bi bi-exclamation-triangle text-warning"></i>
                    Alertes Médicaments
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <span class="badge bg-danger fs-6">
                            <%= alertes.get("totalAlertes") %> Alertes
                        </span>
                    </div>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary">
                        <i class="bi bi-arrow-left me-2"></i>Retour au Dashboard
                    </a>
                </div>
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

                <!-- Statistiques -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card stats-card">
                            <div class="card-body text-center">
                                <h5>Total Médicaments</h5>
                                <h3><%= alertes.get("totalMedicaments") %></h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stats-card">
                            <div class="card-body text-center">
                                <h5>Disponibles</h5>
                                <h3><%= alertes.get("medicamentsDisponibles") %></h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-danger text-white">
                            <div class="card-body text-center">
                                <h5>Stock Faible</h5>
                                <h3><%= alertes.get("countStockFaible") %></h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-dark">
                            <div class="card-body text-center">
                                <h5>Expiration Proche</h5>
                                <h3><%= alertes.get("countExpirationProche") %></h3>
                            </div>
                        </div>
                    </div>
                </div>

                                                <!-- Alertes Stock Faible -->
                                <div class="row mb-4">
                                    <div class="col-12">
                                        <div class="card alert-card">
                                            <div class="card-header alert-header">
                                                <h5 class="mb-0">
                                                    <i class="bi bi-exclamation-circle"></i>
                                                    Stock Faible (<%= stockFaible.size() %>)
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <% if (stockFaible != null && !stockFaible.isEmpty()) { %>
                                                    <div class="table-responsive">
                                                        <table class="table table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>Médicament</th>
                                                                    <th>Stock Actuel</th>
                                                                    <th>Seuil d'Alerte</th>
                                                                    <th>Prix</th>
                                                                    <th>Actions</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% for (Medicament med : stockFaible) { %>
                                                                    <tr>
                                                                        <td>
                                                                            <strong><%= med.getNom() %></strong>
                                                                            <% if (med.getCodeBarre() != null) { %>
                                                                                <br><small class="text-muted">Code: <%= med.getCodeBarre() %></small>
                                                                            <% } %>
                                                                        </td>
                                                                        <td>
                                                                            <span class="stock-critical"><%= med.getStock() %></span>
                                                                        </td>
                                                                        <td><%= med.getSeuilAlerte() %></td>
                                                                        <td><strong><%= String.format("%.0f", med.getPrix()) %> FCFA</strong></td>
                                                                                                                                <td>
                                                            <button class="btn-action btn-warning" 
                                                                    data-id="<%= med.getId() %>"
                                                                    data-nom="<%= med.getNom() %>"
                                                                    data-stock="<%= med.getStock() %>"
                                                                    data-seuil="<%= med.getSeuilAlerte() %>"
                                                                    onclick="ouvrirModalReapprovisionnement(this)"
                                                                    title="Réapprovisionner">
                                                                <i class="bi bi-plus-circle"></i>
                                                            </button>
                                                        </td>
                                                                    </tr>
                                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } else { %>
                                    <div class="text-center py-4">
                                        <i class="bi bi-check-circle text-success fs-1"></i>
                                        <h5 class="text-success mt-2">Aucun médicament en stock faible</h5>
                                        <p class="text-muted">Tous les stocks sont suffisants</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Alertes Expiration Proche -->
                <div class="row">
                    <div class="col-12">
                        <div class="card alert-card">
                            <div class="card-header alert-warning-header">
                                <h5 class="mb-0">
                                    <i class="bi bi-clock"></i>
                                    Expiration Proche (<%= expirationProche.size() %>)
                                </h5>
                            </div>
                            <div class="card-body">
                                <% if (expirationProche != null && !expirationProche.isEmpty()) { %>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Médicament</th>
                                                    <th>Date d'Expiration</th>
                                                    <th>Jours Restants</th>
                                                    <th>Stock</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (Medicament med : expirationProche) { %>
                                                    <% 
                                                        long joursRestants = java.time.temporal.ChronoUnit.DAYS.between(
                                                            java.time.LocalDate.now(), med.getDateExpiration()
                                                        );
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <strong><%= med.getNom() %></strong>
                                                            <% if (med.getCodeBarre() != null) { %>
                                                                <br><small class="text-muted">Code: <%= med.getCodeBarre() %></small>
                                                            <% } %>
                                                        </td>
                                                        <td>
                                                            <% if (joursRestants <= 7) { %>
                                                                <span class="expiration-critical">
                                                                    <%= med.getDateExpiration().format(formatter) %>
                                                                </span>
                                                            <% } else { %>
                                                                <span class="expiration-warning">
                                                                    <%= med.getDateExpiration().format(formatter) %>
                                                                </span>
                                                            <% } %>
                                                        </td>
                                                        <td>
                                                            <% if (joursRestants <= 0) { %>
                                                                <span class="text-danger fw-bold">EXPIRÉ</span>
                                                            <% } else { %>
                                                                <span class="<%= joursRestants <= 7 ? "text-danger" : "text-warning" %>">
                                                                    <%= joursRestants %> jours
                                                                </span>
                                                            <% } %>
                                                        </td>
                                                        <td><%= med.getStock() %></td>
                                                        <td>
                                                            <button class="btn-action btn-warning" 
                                                                    data-id="<%= med.getId() %>"
                                                                    data-nom="<%= med.getNom() %>"
                                                                    data-stock="<%= med.getStock() %>"
                                                                    data-seuil="<%= med.getSeuilAlerte() %>"
                                                                    onclick="ouvrirModalReapprovisionnement(this)"
                                                                    title="Réapprovisionner">
                                                                <i class="bi bi-plus-circle"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } else { %>
                                    <div class="text-center py-4">
                                        <i class="bi bi-check-circle text-success fs-1"></i>
                                        <h5 class="text-success mt-2">Aucun médicament proche de l'expiration</h5>
                                        <p class="text-muted">Tous les médicaments ont une date d'expiration éloignée</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <!-- Modal de Réapprovisionnement Rapide -->
    <div class="modal fade" id="modalReapprovisionnement" tabindex="-1" aria-labelledby="modalReapprovisionnementLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalReapprovisionnementLabel">
                        <i class="bi bi-plus-circle me-2"></i>Réapprovisionnement Rapide
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formReapprovisionnementRapide">
                        <input type="hidden" id="medicamentId" name="id">
                        <input type="hidden" name="action" value="reapprovisionner">
                        
                        <div class="mb-3">
                            <label class="form-label">Médicament</label>
                            <input type="text" class="form-control" id="medicamentNom" readonly>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Stock actuel</label>
                                    <input type="number" class="form-control" id="stockActuel" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Seuil d'alerte</label>
                                    <input type="number" class="form-control" id="seuilAlerte" readonly>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="quantite" class="form-label">Quantité à ajouter</label>
                            <input type="number" class="form-control" id="quantite" name="quantite" min="1" required>
                            <div class="form-text">Entrez le nombre d'unités à ajouter</div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Nouveau stock (calculé automatiquement)</label>
                            <input type="number" class="form-control" id="nouveauStock" readonly>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-success" onclick="reapprovisionnerRapide()">
                        <i class="bi bi-plus-circle me-2"></i>Réapprovisionner
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Variables globales
        let modalReapprovisionnement;
        
        // Initialiser le modal au chargement de la page
        document.addEventListener('DOMContentLoaded', function() {
            modalReapprovisionnement = new bootstrap.Modal(document.getElementById('modalReapprovisionnement'));
        });
        
        // Fonction pour ouvrir le modal de réapprovisionnement
        function ouvrirModalReapprovisionnement(button) {
            try {
                const id = button.getAttribute('data-id');
                const nom = button.getAttribute('data-nom');
                const stock = button.getAttribute('data-stock');
                const seuil = button.getAttribute('data-seuil');
                
                console.log('Données récupérées:', { id, nom, stock, seuil });
                
                document.getElementById('medicamentId').value = id;
                document.getElementById('medicamentNom').value = nom;
                document.getElementById('stockActuel').value = stock;
                document.getElementById('seuilAlerte').value = seuil;
                document.getElementById('quantite').value = '';
                document.getElementById('nouveauStock').value = stock;
                
                modalReapprovisionnement.show();
            } catch (error) {
                console.error('Erreur dans ouvrirModalReapprovisionnement:', error);
                alert('Erreur lors de l\'ouverture du modal: ' + error.message);
            }
        }
        
        // Calcul automatique du nouveau stock
        document.getElementById('quantite').addEventListener('input', function() {
            const stockActuel = parseInt(document.getElementById('stockActuel').value) || 0;
            const quantiteAjoutee = parseInt(this.value) || 0;
            const nouveauStock = stockActuel + quantiteAjoutee;
            
            document.getElementById('nouveauStock').value = nouveauStock;
            
            // Changer la couleur selon le seuil d'alerte
            const seuilAlerte = parseInt(document.getElementById('seuilAlerte').value) || 0;
            const stockField = document.getElementById('nouveauStock');
            
            if (nouveauStock <= seuilAlerte) {
                stockField.style.color = '#dc3545';
                stockField.style.fontWeight = 'bold';
            } else {
                stockField.style.color = '#28a745';
                stockField.style.fontWeight = 'normal';
            }
        });
        
        // Fonction pour réapprovisionner rapidement
        function reapprovisionnerRapide() {
            const form = document.getElementById('formReapprovisionnementRapide');
            const formData = new FormData(form);
            
            // Validation
            const quantite = parseInt(formData.get('quantite'));
            if (quantite <= 0) {
                alert('La quantité doit être supérieure à 0');
                return;
            }
            
            // Envoyer la requête AJAX
            fetch('${pageContext.request.contextPath}/medicaments/', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    // Succès - fermer le modal et recharger la page
                    modalReapprovisionnement.hide();
                    location.reload();
                } else {
                    alert('Erreur lors du réapprovisionnement');
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                alert('Erreur lors du réapprovisionnement');
            });
        }
        
        // Auto-refresh toutes les 5 minutes
        setTimeout(function() {
            location.reload();
        }, 300000);
        
        // Si on a un message de succès, rafraîchir la page après 3 secondes pour voir les changements
        <% if (request.getParameter("success") != null) { %>
            setTimeout(function() {
                location.reload();
            }, 3000);
        <% } %>
    </script>
</body>
</html> 