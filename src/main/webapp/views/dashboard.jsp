<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.gestionpharmacie.model.Utilisateur" %>
<%
  Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Pharmacie Manager - Tableau de bord</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <style>
    body { background: #f4f7fa; }
    .sidebar { width: 220px; background: #111c44; color: #fff; min-height: 100vh; position: fixed; }
    .sidebar a { color: #fff; text-decoration: none; display: block; padding: 16px; }
    .sidebar a.active, .sidebar a:hover { background: #2563eb; }
    .main { margin-left: 220px; padding: 32px; }
    .card { border-radius: 16px; }
    .header { display: flex; justify-content: flex-end; align-items: center; padding: 16px 32px; background: #fff; border-bottom: 1px solid #eee; }
    .user-info { margin-left: 24px; }
  </style>
</head>
<body>
<div class="sidebar">
  <h3 class="text-center py-4">Pharmacie<br><small>Centre-ville Dakar</small></h3>
  <a href="#" class="active">Tableau de bord</a>
  <a href="#">Médicaments</a>
  <a href="#">Ventes</a>
  <a href="#">Alertes</a>
  <a href="#">Utilisateurs</a>
</div>
<div class="main">
  <div class="header">
    <span class="me-3">🔔 <span class="badge bg-danger">3</span></span>
    <span class="user-info">
                <b><%= user != null ? user.getNomComplet() : "" %></b>
                <span class="badge bg-primary"><%= user != null ? user.getRole().getLibelle() : "" %></span>
            </span>
    <a href="logout" class="btn btn-outline-secondary ms-3">Déconnexion</a>
  </div>
  <h2>Tableau de bord</h2>
  <p>Vue d'ensemble de votre pharmacie</p>
  <div class="row g-4 my-4">
    <div class="col-md-3">
      <div class="card p-3 text-center">
        <div>Total Médicaments</div>
        <h3>4</h3>
        <small class="text-success">+12% ce mois</small>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card p-3 text-center">
        <div>Stock Total</div>
        <h3>435</h3>
        <small class="text-success">+8% ce mois</small>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card p-3 text-center">
        <div>Ventes Aujourd'hui</div>
        <h3>0</h3>
        <small class="text-success">+15% ce mois</small>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card p-3 text-center">
        <div>Alertes Critiques</div>
        <h3>3</h3>
        <small class="text-danger">-5% ce mois</small>
      </div>
    </div>
  </div>
  <!-- Ajoute ici les autres sections (chiffre d'affaires, état des stocks, activité récente, etc.) -->
</div>
</body>
</html>