<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="org.example.gestionpharmacie.model.Medicament" %>
<%
    List<Medicament> medicaments = (List<Medicament>) request.getAttribute("medicaments");
    String venteId = request.getParameter("venteId");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Nouvelle Vente - Pharmacie Manager</title>
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
        }
        .main-content { 
            margin-left: 250px; 
            padding: 30px;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .btn-action {
            padding: 8px 14px;
            border-radius: 25px;
            font-size: 0.9em;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            position: relative;
            overflow: hidden;
            text-decoration: none;
            display: inline-block;
        }
        .btn-action:hover {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 4px 15px rgba(0,0,0,0.25);
            text-decoration: none;
        }
        .btn-action:active {
            transform: translateY(0) scale(0.98);
        }
        .btn-action.btn-primary {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
        }
        .btn-action.btn-primary:hover {
            background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
            color: white;
        }
        .btn-action.btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-action.btn-success:hover {
            background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);
            color: white;
        }
        .btn-action.btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        .btn-action.btn-danger:hover {
            background: linear-gradient(135deg, #c82333 0%, #a71e2a 100%);
            color: white;
        }
        .btn-action i {
            font-size: 1em;
            transition: transform 0.3s ease;
        }
        .btn-action:hover i {
            transform: scale(1.1);
        }
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        .cart-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            border-left: 4px solid #28a745;
        }
        .total-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
        }
        .stock-warning {
            color: #dc3545;
            font-size: 0.9em;
        }
        .stock-ok {
            color: #28a745;
            font-size: 0.9em;
        }
        .empty-cart {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }
        .empty-cart i {
            font-size: 3em;
            margin-bottom: 15px;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="p-3">
            <h4><i class="bi bi-heart-pulse me-2"></i>Pharmacie</h4>
        </div>
        <nav>
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-speedometer2 me-2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/medicaments/">
                <i class="bi bi-capsule me-2"></i> Médicaments
            </a>
            <a href="${pageContext.request.contextPath}/ventes/" class="active">
                <i class="bi bi-cart me-2"></i> Ventes
            </a>
            <a href="${pageContext.request.contextPath}/alertes/">
                <i class="bi bi-exclamation-triangle me-2"></i> Alertes
            </a>
            <a href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right me-2"></i> Déconnexion
            </a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1">
                    <i class="bi bi-cart-plus me-2"></i>Nouvelle Vente
                </h2>
                <p class="text-muted mb-0">Créez une nouvelle transaction de vente</p>
            </div>
            <a href="${pageContext.request.contextPath}/ventes/" class="btn-action btn-primary">
                <i class="bi bi-arrow-left me-2"></i>Retour aux ventes
            </a>
        </div>

        <!-- Messages d'alerte -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i><%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i><%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <!-- Formulaire d'ajout de produit -->
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-plus-circle me-2"></i>Ajouter un produit
                        </h5>
                    </div>
                    <div class="card-body">
                        <% if (venteId != null) { %>
                            <form method="post" action="${pageContext.request.contextPath}/ventes/ajouter-ligne">
                                <input type="hidden" name="venteId" value="<%= venteId %>">
                                
                                <div class="mb-3">
                                    <label for="medicamentId" class="form-label">Médicament</label>
                                    <select class="form-select" id="medicamentId" name="medicamentId" required>
                                        <option value="">Sélectionnez un médicament</option>
                                        <% for (Medicament med : medicaments) { %>
                                            <option value="<%= med.getId() %>" 
                                                    data-prix="<%= med.getPrix() %>" 
                                                    data-stock="<%= med.getStock() %>">
                                                <%= med.getNom() %> - Stock: <%= med.getStock() %> - <%= String.format("%.2f", med.getPrix()) %> €
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="quantite" class="form-label">Quantité</label>
                                    <input type="number" class="form-control" id="quantite" name="quantite" 
                                           min="1" value="1" required>
                                    <div id="stockInfo" class="mt-2"></div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Prix unitaire</label>
                                    <div class="form-control-plaintext" id="prixUnitaire">-</div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Montant total</label>
                                    <div class="form-control-plaintext" id="montantLigne">-</div>
                                </div>
                                
                                <button type="submit" class="btn-action btn-success w-100">
                                    <i class="bi bi-plus-circle me-2"></i>Ajouter au panier
                                </button>
                            </form>
                        <% } else { %>
                            <form method="post" action="${pageContext.request.contextPath}/ventes/creer">
                                <p class="text-muted">Cliquez sur le bouton ci-dessous pour commencer une nouvelle vente.</p>
                                <button type="submit" class="btn-action btn-success w-100">
                                    <i class="bi bi-play-circle me-2"></i>Commencer la vente
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Panier -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-cart-check me-2"></i>Panier
                        </h5>
                    </div>
                    <div class="card-body">
                        <% if (venteId != null) { %>
                            <div id="cartContent">
                                <!-- Le contenu du panier sera chargé via AJAX -->
                                <div class="text-center">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Chargement...</span>
                                    </div>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="empty-cart">
                                <i class="bi bi-cart-x"></i>
                                <h5>Aucune vente en cours</h5>
                                <p>Commencez par ajouter des produits</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <% if (venteId != null) { %>
    <script>
        // Charger le contenu du panier
        function loadCart() {
            fetch('${pageContext.request.contextPath}/ventes/details?id=<%= venteId %>')
                .then(response => response.text())
                .then(html => {
                    // Extraire le contenu du panier de la réponse
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const cartContent = doc.querySelector('#cartContent');
                    if (cartContent) {
                        document.getElementById('cartContent').innerHTML = cartContent.innerHTML;
                    }
                })
                .catch(error => {
                    console.error('Erreur lors du chargement du panier:', error);
                });
        }

        // Charger le panier au chargement de la page
        loadCart();

        // Mettre à jour les informations de prix et stock
        document.getElementById('medicamentId').addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const prix = selectedOption.getAttribute('data-prix');
            const stock = selectedOption.getAttribute('data-stock');
            const quantite = document.getElementById('quantite').value;
            
            document.getElementById('prixUnitaire').textContent = prix ? prix + ' €' : '-';
            
            if (prix && quantite) {
                const montant = (parseFloat(prix) * parseInt(quantite)).toFixed(2);
                document.getElementById('montantLigne').textContent = montant + ' €';
            } else {
                document.getElementById('montantLigne').textContent = '-';
            }
            
            // Afficher les informations de stock
            const stockInfo = document.getElementById('stockInfo');
            if (stock) {
                const stockInt = parseInt(stock);
                if (stockInt <= 0) {
                    stockInfo.innerHTML = '<span class="stock-warning"><i class="bi bi-exclamation-triangle me-1"></i>Rupture de stock</span>';
                } else if (stockInt <= 10) {
                    stockInfo.innerHTML = '<span class="stock-warning"><i class="bi bi-exclamation-triangle me-1"></i>Stock faible: ' + stock + ' unités</span>';
                } else {
                    stockInfo.innerHTML = '<span class="stock-ok"><i class="bi bi-check-circle me-1"></i>Stock disponible: ' + stock + ' unités</span>';
                }
            } else {
                stockInfo.innerHTML = '';
            }
        });

        // Mettre à jour le montant quand la quantité change
        document.getElementById('quantite').addEventListener('input', function() {
            const selectedOption = document.getElementById('medicamentId').options[document.getElementById('medicamentId').selectedIndex];
            const prix = selectedOption.getAttribute('data-prix');
            const quantite = this.value;
            
            if (prix && quantite) {
                const montant = (parseFloat(prix) * parseInt(quantite)).toFixed(2);
                document.getElementById('montantLigne').textContent = montant + ' €';
            } else {
                document.getElementById('montantLigne').textContent = '-';
            }
        });

        // Recharger le panier après soumission du formulaire
        document.querySelector('form').addEventListener('submit', function() {
            setTimeout(loadCart, 1000);
        });
    </script>
    <% } %>
</body>
</html> 