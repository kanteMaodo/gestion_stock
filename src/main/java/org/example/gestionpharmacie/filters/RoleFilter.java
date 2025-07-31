package org.example.gestionpharmacie.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.gestionpharmacie.model.Utilisateur;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Filtre de sécurité pour vérifier les rôles et protéger l'accès aux pages
 */
@WebFilter(urlPatterns = {"/admin/*", "/pharmacien/*"})
public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation du filtre
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Vérifier si l'utilisateur est connecté
        if (session == null || session.getAttribute("utilisateur") == null) {
            httpResponse.sendRedirect(contextPath + "/auth");
            return;
        }
        
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        
        // Vérifier les permissions selon le chemin
        if (!hasPermission(utilisateur, path)) {
            // Rediriger vers une page d'erreur ou le dashboard approprié
            httpResponse.sendRedirect(contextPath + "/unauthorized");
            return;
        }
        
        // Continuer vers la ressource demandée
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Nettoyage du filtre
    }

    /**
     * Vérifie si l'utilisateur a la permission d'accéder à la ressource
     */
    private boolean hasPermission(Utilisateur utilisateur, String path) {
        if (utilisateur == null) {
            return false;
        }

        // Définir les permissions par rôle
        switch (utilisateur.getRole()) {
            case ADMIN:
                // L'admin peut accéder à tout
                return true;
                
            case PHARMACIEN:
                // Le pharmacien peut accéder aux pages pharmacien
                return path.startsWith("/pharmacien/");
                
            default:
                return false;
        }
    }
} 