package org.example.gestionpharmacie.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.gestionpharmacie.dao.MedicamentDAO;
import org.example.gestionpharmacie.dao.MedicamentDAOImpl;
import org.example.gestionpharmacie.dao.UtilisateurDAO;
import org.example.gestionpharmacie.dao.UtilisateurDAOImpl;
import org.example.gestionpharmacie.dao.VenteDAO;
import org.example.gestionpharmacie.dao.VenteDAOImpl;
import org.example.gestionpharmacie.model.Utilisateur;
import org.example.gestionpharmacie.model.Medicament;
import org.example.gestionpharmacie.model.Vente;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAOImpl();
    private final MedicamentDAO medicamentDAO = new MedicamentDAOImpl();
    private final VenteDAO venteDAO = new VenteDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== AdminDashboardServlet.doGet() appelé ===");
        
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        
        System.out.println("Utilisateur en session: " + (user != null ? user.getNomComplet() : "null"));
        
        if (user == null) {
            System.out.println("Redirection vers /auth - utilisateur non connecté");
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        // Vérifier que l'utilisateur est admin
        if (user.getRole() != Utilisateur.Role.ADMIN) {
            System.out.println("Redirection vers /unauthorized - rôle: " + user.getRole());
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return;
        }
        
        System.out.println("Utilisateur admin détecté, récupération des données...");
        
        try {
            // Créer les données du dashboard
            Map<String, Object> dashboardData = getDashboardData();
            System.out.println("Données du dashboard récupérées avec succès");
            
            // Ajouter les données à la requête
            request.setAttribute("dashboardData", dashboardData);
            request.setAttribute("user", user);
            
            System.out.println("Redirection vers /views/admin/dashboard.jsp");
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("ERREUR dans AdminDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            
            // En cas d'erreur, créer des données par défaut
            Map<String, Object> defaultData = createDefaultDashboardData();
            request.setAttribute("dashboardData", defaultData);
            request.setAttribute("user", user);
            request.setAttribute("error", "Erreur lors du chargement des données: " + e.getMessage());
            
            System.out.println("Redirection vers dashboard.jsp avec données par défaut");
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    private Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();
        
        System.out.println("=== getDashboardData() appelé ===");
        
        try {
            System.out.println("Récupération des statistiques globales...");
            
            // Statistiques globales
            long totalUtilisateurs = utilisateurDAO.countActifs();
            System.out.println("Total utilisateurs: " + totalUtilisateurs);
            data.put("totalUtilisateurs", totalUtilisateurs);
            
            long totalMedicaments = medicamentDAO.count();
            System.out.println("Total médicaments: " + totalMedicaments);
            data.put("totalMedicaments", totalMedicaments);
            
            long totalVentes = venteDAO.countVentesByDate(LocalDate.now());
            System.out.println("Total ventes: " + totalVentes);
            data.put("totalVentes", totalVentes);
            
            double chiffreAffaires = venteDAO.getChiffreAffairesByDate(LocalDate.now());
            System.out.println("Chiffre d'affaires: " + chiffreAffaires);
            data.put("chiffreAffaires", chiffreAffaires);
            
            System.out.println("Récupération des alertes...");
            
            // Alertes
            List<Medicament> stockFaible = medicamentDAO.findStockFaible();
            System.out.println("Médicaments stock faible: " + stockFaible.size());
            data.put("medicamentsStockFaible", stockFaible);
            
            List<Medicament> expiration = medicamentDAO.findExpirationProche();
            System.out.println("Médicaments expiration: " + expiration.size());
            data.put("medicamentsExpiration", expiration);
            
            System.out.println("Récupération des données récentes...");
            
            // Données récentes
            List<Utilisateur> utilisateursRecents = utilisateurDAO.findActifs();
            System.out.println("Utilisateurs récents: " + utilisateursRecents.size());
            data.put("utilisateursRecents", utilisateursRecents);
            
            List<Vente> ventesRecentes = venteDAO.findVentesRecentes(10);
            System.out.println("Ventes récentes: " + ventesRecentes.size());
            data.put("ventesRecentes", ventesRecentes);
            
            System.out.println("=== getDashboardData() terminé avec succès ===");
            
        } catch (Exception e) {
            System.err.println("ERREUR dans getDashboardData(): " + e.getMessage());
            e.printStackTrace();
            // En cas d'erreur, utiliser des valeurs par défaut
            data = createDefaultDashboardData();
        }
        
        return data;
    }
    
    private Map<String, Object> createDefaultDashboardData() {
        Map<String, Object> data = new HashMap<>();
        data.put("totalUtilisateurs", 0L);
        data.put("totalMedicaments", 0L);
        data.put("totalVentes", 0L);
        data.put("chiffreAffaires", 0.0);
        data.put("medicamentsStockFaible", new java.util.ArrayList<Medicament>());
        data.put("medicamentsExpiration", new java.util.ArrayList<Medicament>());
        data.put("utilisateursRecents", new java.util.ArrayList<Utilisateur>());
        data.put("ventesRecentes", new java.util.ArrayList<Vente>());
        return data;
    }
} 