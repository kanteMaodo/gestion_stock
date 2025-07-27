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
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * Servlet pour le dashboard administrateur
 */
@WebServlet(name = "adminDashboardServlet", value = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("PharmaPU");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Vérifier si l'utilisateur est connecté et est admin
        if (session == null || session.getAttribute("utilisateur") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }
        
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateur.getRole() != Utilisateur.Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }
        
        EntityManager em = emf.createEntityManager();
        try {
            // Récupérer les données pour le dashboard admin
            Map<String, Object> dashboardData = getDashboardData(em);
            
            // Ajouter les données à la requête
            req.setAttribute("dashboardData", dashboardData);
            req.setAttribute("utilisateur", utilisateur);
            
            // Forward vers la JSP
            req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
            
        } finally {
            em.close();
        }
    }

    /**
     * Récupère toutes les données nécessaires pour le dashboard administrateur
     */
    private Map<String, Object> getDashboardData(EntityManager em) {
        Map<String, Object> data = new HashMap<>();
        
        // Statistiques globales
        data.put("totalUtilisateurs", getTotalUtilisateurs(em));
        data.put("totalMedicaments", getTotalMedicaments(em));
        data.put("totalVentes", getTotalVentes(em));
        data.put("chiffreAffaires", getChiffreAffaires(em));
        
        // Alertes
        data.put("medicamentsStockFaible", getMedicamentsStockFaible(em));
        data.put("medicamentsExpiration", getMedicamentsExpiration(em));
        
        // Données récentes
        data.put("utilisateursRecents", getUtilisateursRecents(em));
        data.put("ventesRecentes", getVentesRecentes(em));
        
        return data;
    }

    private Long getTotalUtilisateurs(EntityManager em) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(u) FROM Utilisateur u WHERE u.actif = true", Long.class);
        return query.getSingleResult();
    }

    private Long getTotalMedicaments(EntityManager em) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(m) FROM Medicament m WHERE m.actif = true", Long.class);
        return query.getSingleResult();
    }

    private Long getTotalVentes(EntityManager em) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(v) FROM Vente v WHERE v.dateVente >= :dateDebut", Long.class);
        query.setParameter("dateDebut", LocalDate.now().atStartOfDay());
        return query.getSingleResult();
    }

    private BigDecimal getChiffreAffaires(EntityManager em) {
        TypedQuery<BigDecimal> query = em.createQuery(
                "SELECT COALESCE(SUM(v.montantTotal), 0) FROM Vente v WHERE v.dateVente >= :dateDebut", BigDecimal.class);
        query.setParameter("dateDebut", LocalDate.now().atStartOfDay());
        return query.getSingleResult();
    }

    private List<Medicament> getMedicamentsStockFaible(EntityManager em) {
        TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.stock <= m.seuilAlerte AND m.actif = true ORDER BY m.stock ASC", 
                Medicament.class);
        query.setMaxResults(10);
        return query.getResultList();
    }

    private List<Medicament> getMedicamentsExpiration(EntityManager em) {
        TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.dateExpiration <= :dateExpiration AND m.actif = true ORDER BY m.dateExpiration ASC", 
                Medicament.class);
        query.setParameter("dateExpiration", LocalDate.now().plusDays(30));
        query.setMaxResults(10);
        return query.getResultList();
    }

    private List<Utilisateur> getUtilisateursRecents(EntityManager em) {
        TypedQuery<Utilisateur> query = em.createQuery(
                "SELECT u FROM Utilisateur u WHERE u.actif = true ORDER BY u.dateCreation DESC", 
                Utilisateur.class);
        query.setMaxResults(5);
        return query.getResultList();
    }

    private List<Vente> getVentesRecentes(EntityManager em) {
        TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v ORDER BY v.dateVente DESC", 
                Vente.class);
        query.setMaxResults(10);
        return query.getResultList();
    }

    @Override
    public void destroy() {
        if (emf != null) emf.close();
    }
} 