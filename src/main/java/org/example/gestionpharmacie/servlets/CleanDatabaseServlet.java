package org.example.gestionpharmacie.servlets;

import jakarta.persistence.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.gestionpharmacie.model.Utilisateur;

import java.io.IOException;

/**
 * Servlet pour vider la base de données (UTILISATION DÉVELOPPEMENT UNIQUEMENT)
 * ATTENTION: Ce servlet supprime toutes les données !
 */
@WebServlet("/admin/clean-database")
public class CleanDatabaseServlet extends HttpServlet {
    
    private EntityManagerFactory emf;
    
    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("PharmaPU");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        
        // Vérifier que l'utilisateur est connecté et est admin
        if (user == null || user.getRole() != Utilisateur.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé");
            return;
        }
        
        try {
            EntityManager em = emf.createEntityManager();
            
            // Désactiver les contraintes de clés étrangères
            em.createNativeQuery("SET session_replication_role = replica").executeUpdate();
            
            // Vider les tables dans l'ordre
            em.getTransaction().begin();
            
            // Supprimer les lignes de vente
            int lignesVenteDeleted = em.createQuery("DELETE FROM LigneVente").executeUpdate();
            
            // Supprimer les ventes
            int ventesDeleted = em.createQuery("DELETE FROM Vente").executeUpdate();
            
            // Supprimer les médicaments
            int medicamentsDeleted = em.createQuery("DELETE FROM Medicament").executeUpdate();
            
            // Supprimer les utilisateurs (sauf l'admin actuel)
            int utilisateursDeleted = em.createQuery(
                "DELETE FROM Utilisateur u WHERE u.id != :currentUserId")
                .setParameter("currentUserId", user.getId())
                .executeUpdate();
            
            em.getTransaction().commit();
            
            // Réactiver les contraintes
            em.createNativeQuery("SET session_replication_role = DEFAULT").executeUpdate();
            
            // Message de succès
            String message = String.format(
                "Base de données vidée avec succès !<br>" +
                "Lignes de vente supprimées: %d<br>" +
                "Ventes supprimées: %d<br>" +
                "Médicaments supprimés: %d<br>" +
                "Utilisateurs supprimés: %d",
                lignesVenteDeleted, ventesDeleted, medicamentsDeleted, utilisateursDeleted
            );
            
            request.setAttribute("success", message);
            request.getRequestDispatcher("/views/admin/clean-database.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du nettoyage de la base de données: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/clean-database.jsp").forward(request, response);
        }
    }
    
    @Override
    public void destroy() {
        if (emf != null) emf.close();
    }
} 