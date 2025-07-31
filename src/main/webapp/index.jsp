<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("utilisateur") != null) {
        response.sendRedirect("dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
    <h1>Hello World</h1>
    <a href="auth">Login</a>
</body>
</html>