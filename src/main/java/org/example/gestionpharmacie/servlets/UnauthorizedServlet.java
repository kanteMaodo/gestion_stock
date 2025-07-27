package org.example.gestionpharmacie.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.gestionpharmacie.model.Utilisateur;
import java.io.IOException;

/**
 * Servlet pour gérer les accès non autorisés
 */
@WebServlet(name = "unauthorizedServlet", value = "/unauthorized")
public class UnauthorizedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Utilisateur utilisateur = null;
        
        if (session != null) {
            utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        }
        
        req.setAttribute("utilisateur", utilisateur);
        req.getRequestDispatcher("/views/unauthorized.jsp").forward(req, resp);
    }
} 