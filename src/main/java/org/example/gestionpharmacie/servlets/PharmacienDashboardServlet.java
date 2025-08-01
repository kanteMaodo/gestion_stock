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
import org.example.gestionpharmacie.model.Utilisateur;
import org.example.gestionpharmacie.model.Medicament;
import org.example.gestionpharmacie.model.Vente;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/pharmacien/dashboard")
public class PharmacienDashboardServlet extends HttpServlet {
    
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
        
        if (user.getRole() != Utilisateur.Role.PHARMACIEN) {
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return;
        }
        
        try {
            Map<String, Object> dashboardData = getDashboardData();
            
            request.setAttribute("dashboardData", dashboardData);
            request.setAttribute("user", user);
            
            request.getRequestDispatcher("/views/pharmacien/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            Map<String, Object> defaultData = createDefaultDashboardData();
            request.setAttribute("dashboardData", defaultData);
            request.setAttribute("user", user);
            request.setAttribute("error", "Erreur lors du chargement des données: " + e.getMessage());
            request.getRequestDispatcher("/views/pharmacien/dashboard.jsp").forward(request, response);
        }
    }
    
    private Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();
        
        try {
            data.put("totalMedicaments", medicamentDAO.count());
            data.put("totalVentes", venteDAO.countVentesByDate(LocalDate.now()));
            data.put("chiffreAffaires", venteDAO.getChiffreAffairesByDate(LocalDate.now()));
            
            data.put("medicamentsStockFaible", medicamentDAO.findStockFaible());
            data.put("medicamentsExpiration", medicamentDAO.findExpirationProche());
            
            data.put("ventesRecentes", venteDAO.findVentesRecentes(10));
            
        } catch (Exception e) {
            data = createDefaultDashboardData();
        }
        
        return data;
    }
    
    private Map<String, Object> createDefaultDashboardData() {
        Map<String, Object> data = new HashMap<>();
        data.put("totalMedicaments", 0L);
        data.put("totalVentes", 0L);
        data.put("chiffreAffaires", 0.0);
        data.put("medicamentsStockFaible", new java.util.ArrayList<Medicament>());
        data.put("medicamentsExpiration", new java.util.ArrayList<Medicament>());
        data.put("ventesRecentes", new java.util.ArrayList<Vente>());
        return data;
    }
} 