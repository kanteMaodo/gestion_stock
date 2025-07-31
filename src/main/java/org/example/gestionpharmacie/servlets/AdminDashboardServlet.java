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
        
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        // Vérifier que l'utilisateur est admin
        if (user.getRole() != Utilisateur.Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return;
        }
        
        try {
            // Créer les données du dashboard
            Map<String, Object> dashboardData = getDashboardData();
            
            // Ajouter les données à la requête
            request.setAttribute("dashboardData", dashboardData);
            request.setAttribute("user", user);
            
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            // En cas d'erreur, créer des données par défaut
            Map<String, Object> defaultData = createDefaultDashboardData();
            request.setAttribute("dashboardData", defaultData);
            request.setAttribute("user", user);
            request.setAttribute("error", "Erreur lors du chargement des données: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    private Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();
        
        try {
            // Statistiques globales
            data.put("totalUtilisateurs", utilisateurDAO.countActifs());
            data.put("totalMedicaments", medicamentDAO.count());
            data.put("totalVentes", venteDAO.countVentesByDate(LocalDate.now()));
            data.put("chiffreAffaires", venteDAO.getChiffreAffairesByDate(LocalDate.now()));
            
            // Alertes
            data.put("medicamentsStockFaible", medicamentDAO.findStockFaible());
            data.put("medicamentsExpiration", medicamentDAO.findExpirationProche());
            
            // Données récentes
            data.put("utilisateursRecents", utilisateurDAO.findActifs());
            data.put("ventesRecentes", venteDAO.findVentesRecentes(10));
            
        } catch (Exception e) {
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