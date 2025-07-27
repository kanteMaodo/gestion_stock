<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Pharmacie Manager - Authentification</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <style>
    body { background: #f4f7fa; }
    .auth-container { max-width: 400px; margin: 40px auto; background: #fff; border-radius: 16px; box-shadow: 0 2px 16px #0001; padding: 32px 24px; }
    .logo { display: flex; justify-content: center; margin-bottom: 16px; }
    .logo svg { width: 56px; height: 56px; }
    h2 { text-align: center; margin-bottom: 8px; }
    .subtitle { text-align: center; color: #555; margin-bottom: 24px; }
    .form-switcher { display: flex; gap: 0; margin-bottom: 24px; }
    .form-switcher .btn { border-radius: 0; border-right: none; width: 50%; font-weight: 500; font-size: 1.1em; }
    .form-switcher .btn:last-child { border-top-right-radius: 8px; border-bottom-right-radius: 8px; border-right: 1px solid #2563eb; }
    .form-switcher .btn:first-child { border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
    .form-section { display: none; }
    .form-section.active { display: block; }
    label { display:block; margin-bottom: 12px; color: #222; }
    input, select { width:100%; padding:10px; border:1px solid #ddd; border-radius:6px; margin-top:4px; margin-bottom:16px; font-size:1em; }
    button[type=submit] { width:100%; background:#2563eb; color:#fff; border:none; border-radius:8px; padding:12px; font-size:1.1em; cursor:pointer; margin-top:8px; }
    button[type=submit]:hover { background:#174bbd; }
    .msg-error { color: #e74c3c; text-align: center; margin-bottom: 8px; }
    .msg-success { color: #27ae60; text-align: center; margin-bottom: 8px; }
  </style>
  <script>
    function showForm(form) {
      document.getElementById('login-form').style.display = (form === 'login') ? 'block' : 'none';
      document.getElementById('register-form').style.display = (form === 'register') ? 'block' : 'none';
      document.getElementById('btn-login').className = 'btn w-50 ' + (form === 'login' ? 'btn-primary' : 'btn-outline-primary');
      document.getElementById('btn-register').className = 'btn w-50 ' + (form === 'register' ? 'btn-primary' : 'btn-outline-primary');
    }
    window.onload = function() { showForm('login'); };
  </script>
</head>
<body>
<div class="auth-container">
  <div class="logo">
    <svg width="56" height="56" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="12" fill="#eaf1fb"/><rect x="7" y="11" width="10" height="2" rx="1" fill="#2563eb"/><rect x="11" y="7" width="2" height="10" rx="1" fill="#2563eb"/></svg>
  </div>
  <h2>Pharmacie Manager</h2>
  <div class="subtitle">Connectez-vous à votre compte</div>
  <div class="form-switcher">
    <button id="btn-login" type="button" class="btn btn-primary w-50" onclick="showForm('login')">Se connecter</button>
    <button id="btn-register" type="button" class="btn btn-outline-primary w-50" onclick="showForm('register')">Créer un compte</button>
  </div>
  <div id="login-form">
    <form action="auth" method="post">
      <input type="hidden" name="action" value="login"/>
      <label>Email
        <input type="email" name="email" placeholder="votre@email.com" required />
      </label>
      <label>Mot de passe
        <input type="password" name="motDePasse" placeholder="••••••••" required />
      </label>
      <button type="submit"> Se connecter</button>
    </form>
    <div class="msg-error"><%= request.getAttribute("loginError") != null ? request.getAttribute("loginError") : "" %></div>
  </div>
  <div id="register-form" style="display:none;">
    <form action="auth" method="post">
      <input type="hidden" name="action" value="register"/>
      <label>Nom
        <input type="text" name="nom" required />
      </label>
      <label>Prénom
        <input type="text" name="prenom" required />
      </label>
      <label>Email
        <input type="email" name="email" required />
      </label>
      <label>Login
        <input type="text" name="login" required />
      </label>
      <label>Mot de passe
        <input type="password" name="motDePasse" required />
      </label>
      <label>Rôle
        <select name="role" required>
          <option value="PHARMACIEN">Pharmacien</option>
          <option value="ASSISTANT">Assistant</option>
        </select>
      </label>
      <button type="submit">Créer un compte</button>
    </form>
    <div class="msg-error"><%= request.getAttribute("registerError") != null ? request.getAttribute("registerError") : "" %></div>
    <div class="msg-success"><%= request.getAttribute("registerSuccess") != null ? request.getAttribute("registerSuccess") : "" %></div>
  </div>
</div>
</body>
</html>
