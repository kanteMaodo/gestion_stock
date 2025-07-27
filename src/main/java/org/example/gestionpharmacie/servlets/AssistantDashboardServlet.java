package org.example.gestionpharmacie.servlets;

import jakarta.persistence.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.gestionpharmacie.model.Utilisateur;
import org.example.gestionpharmacie.model.Medicament;
import org.example.gestionpharmacie.model.Vente;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * Servlet pour le dashboard assistant
 */
@WebServlet(name = "assistantDashboardServlet", value = "/assistant/dashboard")
public class AssistantDashboardServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("PharmaPU");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Vérifier si l'utilisateur est connecté et est assistant
        if (session == null || session.getAttribute("utilisateur") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }
        
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateur.getRole() != Utilisateur.Role.ASSISTANT) {
            resp.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }
        
        EntityManager em = emf.createEntityManager();
        try {
            // Récupérer les données pour le dashboard assistant
            Map<String, Object> dashboardData = getDashboardData(em, utilisateur);
            
            // Ajouter les données à la requête
            req.setAttribute("dashboardData", dashboardData);
            req.setAttribute("utilisateur", utilisateur);
            
            // Forward vers la JSP
            req.getRequestDispatcher("/views/assistant/dashboard.jsp").forward(req, resp);
            
        } finally {
            em.close();
        }
    }

    /**
     * Récupère toutes les données nécessaires pour le dashboard assistant
     */
    private Map<String, Object> getDashboardData(EntityManager em, Utilisateur utilisateur) {
        Map<String, Object> data = new HashMap<>();
        
        // Médicaments disponibles pour la vente
        data.put("medicamentsDisponibles", getMedicamentsDisponibles(em));
        data.put("medicamentsPopulaires", getMedicamentsPopulaires(em));
        
        // Statistiques personnelles
        data.put("mesVentesAujourdhui", getMesVentesAujourdhui(em, utilisateur));
        data.put("monChiffreAffairesAujourdhui", getMonChiffreAffairesAujourdhui(em, utilisateur));
        data.put("mesVentesRecentes", getMesVentesRecentes(em, utilisateur));
        
        // Informations utiles
        data.put("medicamentsStockFaible", getMedicamentsStockFaible(em));
        data.put("medicamentsExpiration", getMedicamentsExpiration(em));
        
        return data;
    }

    private List<Medicament> getMedicamentsDisponibles(EntityManager em) {
        TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.actif = true AND m.stock > 0 ORDER BY m.nom ASC", 
                Medicament.class);
        query.setMaxResults(20);
        return query.getResultList();
    }

    private List<Medicament> getMedicamentsPopulaires(EntityManager em) {
        // Requête pour obtenir les médicaments les plus vendus
        TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.actif = true AND m.stock > 0 ORDER BY m.stock DESC", 
                Medicament.class);
        query.setMaxResults(10);
        return query.getResultList();
    }

    private Long getMesVentesAujourdhui(EntityManager em, Utilisateur utilisateur) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(v) FROM Vente v WHERE v.vendeur = :vendeur AND v.dateVente >= :dateDebut", Long.class);
        query.setParameter("vendeur", utilisateur);
        query.setParameter("dateDebut", LocalDate.now().atStartOfDay());
        return query.getSingleResult();
    }

    private BigDecimal getMonChiffreAffairesAujourdhui(EntityManager em, Utilisateur utilisateur) {
        TypedQuery<BigDecimal> query = em.createQuery(
                "SELECT COALESCE(SUM(v.montantTotal), 0) FROM Vente v WHERE v.vendeur = :vendeur AND v.dateVente >= :dateDebut", BigDecimal.class);
        query.setParameter("vendeur", utilisateur);
        query.setParameter("dateDebut", LocalDate.now().atStartOfDay());
        return query.getSingleResult();
    }

    private List<Vente> getMesVentesRecentes(EntityManager em, Utilisateur utilisateur) {
        TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v WHERE v.vendeur = :vendeur ORDER BY v.dateVente DESC", 
                Vente.class);
        query.setParameter("vendeur", utilisateur);
        query.setMaxResults(10);
        return query.getResultList();
    }

    private List<Medicament> getMedicamentsStockFaible(EntityManager em) {
        TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.stock <= m.seuilAlerte AND m.actif = true ORDER BY m.stock ASC", 
                Medicament.class);
        query.setMaxResults(5);
        return query.getResultList();
    }

    private List<Medicament> getMedicamentsExpiration(EntityManager em) {
        TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.dateExpiration <= :dateExpiration AND m.actif = true ORDER BY m.dateExpiration ASC", 
                Medicament.class);
        query.setParameter("dateExpiration", LocalDate.now().plusDays(7));
        query.setMaxResults(5);
        return query.getResultList();
    }

    @Override
    public void destroy() {
        if (emf != null) emf.close();
    }
} 