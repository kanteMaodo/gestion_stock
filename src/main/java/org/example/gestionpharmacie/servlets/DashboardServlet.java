package org.example.gestionpharmacie.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.gestionpharmacie.dao.MedicamentDAO;
import org.example.gestionpharmacie.dao.MedicamentDAOImpl;
import org.example.gestionpharmacie.dao.VenteDAO;
import org.example.gestionpharmacie.dao.VenteDAOImpl;
import org.example.gestionpharmacie.dao.UtilisateurDAO;
import org.example.gestionpharmacie.dao.UtilisateurDAOImpl;
import org.example.gestionpharmacie.model.Medicament;
import org.example.gestionpharmacie.model.Utilisateur;
import org.example.gestionpharmacie.model.Vente;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
    private final MedicamentDAO medicamentDAO = new MedicamentDAOImpl();
    private final VenteDAO venteDAO = new VenteDAOImpl();
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        try {
            // Créer un admin par défaut si aucun utilisateur n'existe
            createDefaultAdminIfNeeded();
            
            // Récupérer les statistiques du dashboard
            DashboardStats stats = getDashboardStats();
            
            // Récupérer les alertes
            List<Medicament> stockFaible = new ArrayList<>();
            List<Medicament> expirationProche = new ArrayList<>();
            try {
                stockFaible = medicamentDAO.findStockFaible();
                expirationProche = medicamentDAO.findExpirationProche();
            } catch (Exception e) {
                System.err.println("Erreur lors de la récupération des alertes: " + e.getMessage());
            }
            
            // Récupérer les ventes récentes
            List<Vente> ventesRecentes = new ArrayList<>();
            try {
                ventesRecentes = venteDAO.findVentesRecentes(10); // 10 dernières ventes
            } catch (Exception e) {
                System.err.println("Erreur lors de la récupération des ventes: " + e.getMessage());
            }
            
            // Ajouter les données à la requête
            request.setAttribute("stats", stats);
            request.setAttribute("stockFaible", stockFaible);
            request.setAttribute("expirationProche", expirationProche);
            request.setAttribute("ventesRecentes", ventesRecentes);
            request.setAttribute("user", user);
            
            // Rediriger vers le dashboard approprié selon le rôle
            String dashboardPath = getDashboardPathByRole(user.getRole());
            request.getRequestDispatcher(dashboardPath).forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement du dashboard: " + e.getMessage());
            // En cas d'erreur, rediriger vers le dashboard admin par défaut
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Classe interne pour encapsuler les statistiques du dashboard
     */
    public static class DashboardStats {
        private final long totalMedicaments;
        private final long medicamentsDisponibles;
        private final long ventesAujourdhui;
        private final long alertesCritiques;
        private final double chiffreAffairesAujourdhui;
        
        public DashboardStats(long totalMedicaments, long medicamentsDisponibles, 
                            long ventesAujourdhui, long alertesCritiques, 
                            double chiffreAffairesAujourdhui) {
            this.totalMedicaments = totalMedicaments;
            this.medicamentsDisponibles = medicamentsDisponibles;
            this.ventesAujourdhui = ventesAujourdhui;
            this.alertesCritiques = alertesCritiques;
            this.chiffreAffairesAujourdhui = chiffreAffairesAujourdhui;
        }
        
        // Getters
        public long getTotalMedicaments() { return totalMedicaments; }
        public long getMedicamentsDisponibles() { return medicamentsDisponibles; }
        public long getVentesAujourdhui() { return ventesAujourdhui; }
        public long getAlertesCritiques() { return alertesCritiques; }
        public double getChiffreAffairesAujourdhui() { return chiffreAffairesAujourdhui; }
    }
    
    /**
     * Récupère toutes les statistiques du dashboard en une seule fois pour optimiser les performances
     */
    private DashboardStats getDashboardStats() {
        try {
            // Compter les médicaments
            long totalMedicaments = medicamentDAO.count();
            long medicamentsDisponibles = medicamentDAO.countDisponibles();
            
            // Compter les ventes d'aujourd'hui
            LocalDate aujourdhui = LocalDate.now();
            long ventesAujourdhui = venteDAO.countVentesByDate(aujourdhui);
            double chiffreAffairesAujourdhui = venteDAO.getChiffreAffairesByDate(aujourdhui);
            
            // Compter les alertes critiques
            long alertesCritiques = medicamentDAO.countStockFaible() + medicamentDAO.countExpirationProche();
            
            return new DashboardStats(totalMedicaments, medicamentsDisponibles, 
                                    ventesAujourdhui, alertesCritiques, chiffreAffairesAujourdhui);
        } catch (Exception e) {
            // En cas d'erreur (tables non créées, etc.), retourner des valeurs par défaut
            System.err.println("Erreur lors du calcul des statistiques: " + e.getMessage());
            return new DashboardStats(0, 0, 0, 0, 0.0);
        }
    }
    
    /**
     * Détermine le chemin du dashboard selon le rôle de l'utilisateur
     */
    private String getDashboardPathByRole(Utilisateur.Role role) {
        switch (role) {
            case PHARMACIEN:
                return "/views/pharmacien/dashboard.jsp";
            case ADMIN:
                return "/views/admin/dashboard.jsp";
            default:
                // Par défaut, rediriger vers le dashboard admin
                return "/views/admin/dashboard.jsp";
        }
    }
    
    /**
     * Crée un utilisateur admin par défaut si aucun utilisateur n'existe dans la base
     */
    private void createDefaultAdminIfNeeded() {
        try {
            long userCount = utilisateurDAO.count();
            if (userCount == 0) {
                Utilisateur admin = new Utilisateur(
                    "Admin", "Système", "admin@pharmacie.com", "admin", 
                    "admin123", Utilisateur.Role.ADMIN
                );
                admin.setActif(true);
                utilisateurDAO.save(admin);
                System.out.println("Utilisateur admin par défaut créé : admin@pharmacie.com / admin123");
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de la création de l'admin par défaut : " + e.getMessage());
        }
    }
}