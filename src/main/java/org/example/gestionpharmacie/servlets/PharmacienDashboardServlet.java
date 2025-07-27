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
 * Servlet pour le dashboard pharmacien
 */
@WebServlet(name = "pharmacienDashboardServlet", value = "/pharmacien/dashboard")
public class PharmacienDashboardServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("PharmaPU");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Vérifier si l'utilisateur est connecté et est pharmacien
        if (session == null || session.getAttribute("utilisateur") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }
        
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateur.getRole() != Utilisateur.Role.PHARMACIEN) {
            resp.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }
        
        EntityManager em = emf.createEntityManager();
        try {
            // Récupérer les données pour le dashboard pharmacien
            Map<String, Object> dashboardData = getDashboardData(em);
            
            // Ajouter les données à la requête
            req.setAttribute("dashboardData", dashboardData);
            req.setAttribute("utilisateur", utilisateur);
            
            // Forward vers la JSP
            req.getRequestDispatcher("/views/pharmacien/dashboard.jsp").forward(req, resp);
            
        } finally {
            em.close();
        }
    }

    /**
     * Récupère toutes les données nécessaires pour le dashboard pharmacien
     */
    private Map<String, Object> getDashboardData(EntityManager em) {
        Map<String, Object> data = new HashMap<>();
        
        // Statistiques des médicaments
        data.put("totalMedicaments", getTotalMedicaments(em));
        data.put("medicamentsDisponibles", getMedicamentsDisponibles(em));
        data.put("medicamentsStockFaible", getMedicamentsStockFaible(em));
        data.put("medicamentsExpiration", getMedicamentsExpiration(em));
        
        // Statistiques des ventes
        data.put("ventesAujourdhui", getVentesAujourdhui(em));
        data.put("chiffreAffairesAujourdhui", getChiffreAffairesAujourdhui(em));
        data.put("ventesRecentes", getVentesRecentes(em));
        
        // Alertes
        data.put("alertesStock", getAlertesStock(em));
        data.put("alertesExpiration", getAlertesExpiration(em));
        
        return data;
    }

    private Long getTotalMedicaments(EntityManager em) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(m) FROM Medicament m WHERE m.actif = true", Long.class);
        return query.getSingleResult();
    }

    private Long getMedicamentsDisponibles(EntityManager em) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(m) FROM Medicament m WHERE m.actif = true AND m.stock > 0", Long.class);
        return query.getSingleResult();
    }

    private List<Medicament> getMedicamentsStockFaible(EntityManager em) {
        TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.stock <= m.seuilAlerte AND m.actif = true ORDER BY m.stock ASC", 
                Medicament.class);
        query.setMaxResults(15);
        return query.getResultList();
    }

    private List<Medicament> getMedicamentsExpiration(EntityManager em) {
        TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.dateExpiration <= :dateExpiration AND m.actif = true ORDER BY m.dateExpiration ASC", 
                Medicament.class);
        query.setParameter("dateExpiration", LocalDate.now().plusDays(30));
        query.setMaxResults(15);
        return query.getResultList();
    }

    private Long getVentesAujourdhui(EntityManager em) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(v) FROM Vente v WHERE v.dateVente >= :dateDebut", Long.class);
        query.setParameter("dateDebut", LocalDate.now().atStartOfDay());
        return query.getSingleResult();
    }

    private BigDecimal getChiffreAffairesAujourdhui(EntityManager em) {
        TypedQuery<BigDecimal> query = em.createQuery(
                "SELECT COALESCE(SUM(v.montantTotal), 0) FROM Vente v WHERE v.dateVente >= :dateDebut", BigDecimal.class);
        query.setParameter("dateDebut", LocalDate.now().atStartOfDay());
        return query.getSingleResult();
    }

    private List<Vente> getVentesRecentes(EntityManager em) {
        TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v ORDER BY v.dateVente DESC", 
                Vente.class);
        query.setMaxResults(10);
        return query.getResultList();
    }

    private List<Medicament> getAlertesStock(EntityManager em) {
        TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.stock <= m.seuilAlerte AND m.actif = true ORDER BY m.stock ASC", 
                Medicament.class);
        query.setMaxResults(5);
        return query.getResultList();
    }

    private List<Medicament> getAlertesExpiration(EntityManager em) {
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