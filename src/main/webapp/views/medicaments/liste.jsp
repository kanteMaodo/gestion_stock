<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
    
    List<Medicament> medicaments = (List<Medicament>) request.getAttribute("medicaments");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Médicaments - Pharmacie Manager</title>
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
        .btn-action {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-action:hover {
            transform: scale(1.05);
        }
        .stock-low {
            color: #dc3545;
            font-weight: bold;
        }
        .stock-ok {
            color: #28a745;
        }
        .expiration-warning {
            color: #ffc107;
            font-weight: bold;
        }
        .search-section {
            background: #fff;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
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
                <h2 class="mb-1">Gestion des Médicaments</h2>
                <p class="text-muted mb-0">Liste complète du stock</p>
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

        <!-- Search Section -->
        <div class="search-section">
            <form action="${pageContext.request.contextPath}/medicaments/" method="get" class="row g-3">
                <input type="hidden" name="action" value="rechercher">
                <div class="col-md-3">
                    <label for="nom" class="form-label">Nom</label>
                    <input type="text" class="form-control" id="nom" name="nom" placeholder="Rechercher par nom...">
                </div>
                <div class="col-md-2">
                    <label for="categorie" class="form-label">Catégorie</label>
                    <select class="form-select" id="categorie" name="categorie">
                        <option value="">Toutes</option>
                        <option value="Antibiotiques">Antibiotiques</option>
                        <option value="Analgésiques">Analgésiques</option>
                        <option value="Anti-inflammatoires">Anti-inflammatoires</option>
                        <option value="Vitamines">Vitamines</option>
                        <option value="Autres">Autres</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label for="disponible" class="form-label">Disponibilité</label>
                    <select class="form-select" id="disponible" name="disponible">
                        <option value="">Tous</option>
                        <option value="true">En stock</option>
                        <option value="false">Rupture</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label for="minPrix" class="form-label">Prix min</label>
                    <input type="number" class="form-control" id="minPrix" name="minPrix" step="0.01" min="0">
                </div>
                <div class="col-md-2">
                    <label for="maxPrix" class="form-label">Prix max</label>
                    <input type="number" class="form-control" id="maxPrix" name="maxPrix" step="0.01" min="0">
                </div>
                <div class="col-md-1 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </form>
        </div>

        <!-- Success/Error Messages -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>
                <%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Médicaments List -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="bi bi-capsule me-2"></i>
                    Médicaments (<%= medicaments != null ? medicaments.size() : 0 %>)
                </h5>
                <a href="${pageContext.request.contextPath}/medicaments/ajouter" class="btn btn-success">
                    <i class="bi bi-plus-circle me-2"></i>Nouveau Médicament
                </a>
            </div>
            <div class="card-body">
                <% if (medicaments != null && !medicaments.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Nom</th>
                                    <th>Catégorie</th>
                                    <th>Fabricant</th>
                                    <th>Prix</th>
                                    <th>Stock</th>
                                    <th>Expiration</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Medicament med : medicaments) { %>
                                    <tr>
                                        <td>
                                            <div class="fw-bold"><%= med.getNom() %></div>
                                            <% if (med.getCodeBarre() != null && !med.getCodeBarre().isEmpty()) { %>
                                                <small class="text-muted">Code: <%= med.getCodeBarre() %></small>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary"><%= med.getCategorie() != null ? med.getCategorie() : "Non spécifiée" %></span>
                                        </td>
                                        <td><%= med.getFabricant() != null ? med.getFabricant() : "Non spécifié" %></td>
                                        <td>
                                            <strong><%= med.getPrix() != null ? String.format("%.0f", med.getPrix()) : "0" %> FCFA</strong>
                                        </td>
                                        <td>
                                            <% if (med.getStock() <= med.getSeuilAlerte()) { %>
                                                <span class="stock-low"><%= med.getStock() %></span>
                                            <% } else { %>
                                                <span class="stock-ok"><%= med.getStock() %></span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (med.getDateExpiration() != null) { %>
                                                <% 
                                                    long daysUntilExpiration = java.time.temporal.ChronoUnit.DAYS.between(
                                                        java.time.LocalDate.now(), med.getDateExpiration()
                                                    );
                                                    if (daysUntilExpiration <= 30) {
                                                %>
                                                    <span class="expiration-warning">
                                                        <%= med.getDateExpiration().format(formatter) %>
                                                    </span>
                                                <% } else { %>
                                                    <%= med.getDateExpiration().format(formatter) %>
                                                <% } %>
                                            <% } else { %>
                                                <span class="text-muted">Non spécifiée</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button class="btn-action btn-primary" 
                                                        onclick="window.location.href='${pageContext.request.contextPath}/medicaments/modifier?id=<%= med.getId() %>'"
                                                        title="Modifier">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn-action btn-warning" 
                                                        onclick="window.location.href='${pageContext.request.contextPath}/medicaments/reapprovisionner?id=<%= med.getId() %>'"
                                                        title="Réapprovisionner">
                                                    <i class="bi bi-plus-circle"></i>
                                                </button>
                                                <button class="btn-action btn-danger" 
                                                        onclick="if(confirm('Supprimer ce médicament ?')) { document.getElementById('formSuppression<%= med.getId() %>').submit(); }"
                                                        title="Supprimer">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                                <form id="formSuppression<%= med.getId() %>" method="post" action="${pageContext.request.contextPath}/medicaments/" style="display: none;">
                                                    <input type="hidden" name="action" value="supprimer">
                                                    <input type="hidden" name="id" value="<%= med.getId() %>">
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted mb-3"></i>
                        <h5 class="text-muted">Aucun médicament trouvé</h5>
                        <p class="text-muted">Commencez par ajouter votre premier médicament</p>
                        <a href="${pageContext.request.contextPath}/medicaments/ajouter" class="btn btn-primary">
                            <i class="bi bi-plus-circle me-2"></i>Ajouter un médicament
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 