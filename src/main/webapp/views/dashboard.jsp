<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Utilisateur user = (Utilisateur) request.getAttribute("user");
    if (user == null) {
        user = (Utilisateur) session.getAttribute("utilisateur");
    }
    
    // Données par défaut si les stats ne sont pas disponibles
    long totalMedicaments = 0;
    long medicamentsDisponibles = 0;
    long ventesAujourdhui = 0;
    long alertesCritiques = 0;
    double chiffreAffaires = 0.0;
    
    // Essayer de récupérer les stats du DashboardServlet
    try {
        Object statsObj = request.getAttribute("stats");
        if (statsObj != null && statsObj.getClass().getName().contains("DashboardStats")) {
            // Utiliser la réflexion pour accéder aux méthodes
            java.lang.reflect.Method getTotal = statsObj.getClass().getMethod("getTotalMedicaments");
            java.lang.reflect.Method getDisponibles = statsObj.getClass().getMethod("getMedicamentsDisponibles");
            java.lang.reflect.Method getVentes = statsObj.getClass().getMethod("getVentesAujourdhui");
            java.lang.reflect.Method getAlertes = statsObj.getClass().getMethod("getAlertesCritiques");
            java.lang.reflect.Method getCA = statsObj.getClass().getMethod("getChiffreAffairesAujourdhui");
            
            totalMedicaments = (Long) getTotal.invoke(statsObj);
            medicamentsDisponibles = (Long) getDisponibles.invoke(statsObj);
            ventesAujourdhui = (Long) getVentes.invoke(statsObj);
            alertesCritiques = (Long) getAlertes.invoke(statsObj);
            chiffreAffaires = (Double) getCA.invoke(statsObj);
        }
    } catch (Exception e) {
        // Utiliser les valeurs par défaut
    }
    
    List<Medicament> stockFaible = (List<Medicament>) request.getAttribute("stockFaible");
    List<Medicament> expirationProche = (List<Medicament>) request.getAttribute("expirationProche");
    List<Vente> ventesRecentes = (List<Vente>) request.getAttribute("ventesRecentes");
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Pharmacie Manager</title>
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
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
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
        .user-info { 
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .quick-action-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .quick-action-card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        .stats-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .alert-section {
            background: #fff;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .btn-action {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-action:hover {
            transform: scale(1.05);
        }
        .notification-badge {
            position: relative;
        }
        .sidebar .notification-badge {
            position: relative;
        }
        .sidebar .notification-badge .badge {
            position: absolute;
            top: 8px;
            right: 8px;
            font-size: 0.7em;
            min-width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="text-center py-4">
            <h4>PHARMACIE MOUHAMED</h4>
            <small>Espace <%= user != null ? user.getRole().getLibelle() : "Utilisateur" %></small>
        </div>
        
        <a href="${pageContext.request.contextPath}/dashboard" class="active">
            <i class="bi bi-speedometer2 me-2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/medicaments/">
            <i class="bi bi-box-seam me-2"></i> Gestion Stock
        </a>
        <a href="${pageContext.request.contextPath}/medicaments/ajouter">
            <i class="bi bi-plus-circle me-2"></i> Ajouter Médicament
        </a>
        <a href="${pageContext.request.contextPath}/ventes/">
            <i class="bi bi-graph-up me-2"></i> Rapports
        </a>
        <a href="${pageContext.request.contextPath}/alertes/" class="notification-badge">
            <i class="bi bi-exclamation-triangle me-2"></i> Alertes
            <span class="badge bg-danger position-absolute top-0 start-100 translate-middle rounded-pill">
                <%= alertesCritiques %>
            </span>
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
                <h2 class="mb-1">Dashboard</h2>
                <p class="text-muted mb-0">Gestion des médicaments et stocks</p>
            </div>
            <div class="user-info">
                <a href="${pageContext.request.contextPath}/alertes/" class="notification-badge position-relative text-decoration-none">
                    <i class="bi bi-bell fs-4"></i>
                    <span class="badge bg-danger position-absolute top-0 start-100 translate-middle rounded-pill">
                        <%= alertesCritiques %>
                    </span>
                </a>
                <div class="text-end">
                    <div class="fw-bold"><%= user != null ? user.getNomComplet() : "" %></div>
                    <small class="text-muted"><%= user != null ? user.getRole().getLibelle() : "" %></small>
                </div>
                <div class="ms-3">
                    <i class="bi bi-person-circle fs-1 text-primary"></i>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/medicaments/ajouter'">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-plus-circle fs-1 mb-3"></i>
                        <h5>Ajouter Médicament</h5>
                        <p class="mb-0">Nouveau produit</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/ventes/nouvelle'">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-cart-plus fs-1 mb-3"></i>
                        <h5>Nouvelle Vente</h5>
                        <p class="mb-0">Vendre des médicaments</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card quick-action-card" onclick="window.location.href='${pageContext.request.contextPath}/medicaments/'">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-boxes fs-1 mb-3"></i>
                        <h5>Gérer Stock</h5>
                        <p class="mb-0">Ajuster les quantités</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-capsule fs-1 mb-3"></i>
                        <h3 class="mb-1"><%= totalMedicaments %></h3>
                        <p class="mb-0">Total Médicaments</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-check-circle fs-1 mb-3"></i>
                        <h3 class="mb-1"><%= medicamentsDisponibles %></h3>
                        <p class="mb-0">Disponibles</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-cart-check fs-1 mb-3"></i>
                        <h3 class="mb-1"><%= ventesAujourdhui %></h3>
                        <p class="mb-0">Ventes Aujourd'hui</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-bar-chart fs-1 mb-3"></i>
                        <h3 class="mb-1"><%= String.format("%.0f", chiffreAffaires) %> FCFA</h3>
                        <p class="mb-0">Chiffre d'Affaires</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alerts Section -->
        <div class="row">
            <!-- Stock Faible -->
            <div class="col-md-6">
                <div class="alert-section">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">
                            <i class="bi bi-exclamation-triangle text-warning me-2"></i>
                            Stock Faible
                        </h5>
                        <a href="${pageContext.request.contextPath}/medicaments/?filter=stock-faible" class="btn btn-sm btn-outline-warning">
                            Voir tout
                        </a>
                    </div>
                    
                    <% if (stockFaible != null && !stockFaible.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>Médicament</th>
                                        <th>Stock</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Medicament med : stockFaible) { %>
                                        <tr>
                                            <td><%= med.getNom() %></td>
                                            <td><span class="badge bg-danger"><%= med.getStock() %></span></td>
                                            <td>
                                                <button class="btn-action btn-warning" 
                                                        data-id="<%= med.getId() %>"
                                                        data-nom="<%= med.getNom() %>"
                                                        data-stock="<%= med.getStock() %>"
                                                        data-seuil="<%= med.getSeuilAlerte() %>"
                                                        onclick="ouvrirModalReapprovisionnement(this)">
                                                    Réapprovisionner
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Expiration Proche -->
            <div class="col-md-6">
                <div class="alert-section">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">
                            <i class="bi bi-clock text-danger me-2"></i>
                            Expiration Proche
                        </h5>
                        <a href="${pageContext.request.contextPath}/medicaments/?filter=expiration" class="btn btn-sm btn-outline-danger">
                            Voir tout
                        </a>
                    </div>
                    
                    <% if (expirationProche != null && !expirationProche.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>Médicament</th>
                                        <th>Expiration</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Medicament med : expirationProche) { %>
                                        <tr>
                                            <td><%= med.getNom() %></td>
                                            <td><span class="badge bg-warning"><%= med.getDateExpiration() != null ? med.getDateExpiration().format(formatter) : "N/A" %></span></td>
                                            <td>
                                                <button class="btn-action btn-danger" 
                                                        data-id="<%= med.getId() %>"
                                                        data-nom="<%= med.getNom() %>"
                                                        data-stock="<%= med.getStock() %>"
                                                        data-seuil="<%= med.getSeuilAlerte() %>"
                                                        onclick="ouvrirModalReapprovisionnement(this)">
                                                    Réapprovisionner
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Ventes Récentes -->
        <div class="alert-section">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="mb-0">
                    <i class="bi bi-graph-up text-success me-2"></i>
                    Ventes Récentes
                </h5>
                <a href="${pageContext.request.contextPath}/ventes/" class="btn btn-sm btn-outline-success">
                    Voir toutes les ventes
                </a>
            </div>
            
            <% if (ventesRecentes != null && !ventesRecentes.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>N° Vente</th>
                                <th>Date</th>
                                <th>Montant</th>
                                <th>Vendeur</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Vente vente : ventesRecentes) { %>
                                <tr>
                                    <td>#<%= vente.getId() %></td>
                                    <td><%= vente.getDateVente() != null ? vente.getDateVente().format(formatter) : "N/A" %></td>
                                    <td><strong><%= vente.getMontantTotal() != null ? String.format("%.0f", vente.getMontantTotal()) : "0" %> FCFA</strong></td>
                                    <td><%= vente.getVendeur() != null ? vente.getVendeur().getNomComplet() : "N/A" %></td>
                                    <td>
                                        <button class="btn-action btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/ventes/details?id=<%= vente.getId() %>'">
                                            Détails
                                        </button>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
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
    </script>
</body>
</html>