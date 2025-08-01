package org.example.gestionpharmacie.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import org.example.gestionpharmacie.dao.MedicamentDAO;
import org.example.gestionpharmacie.dao.MedicamentDAOImpl;
import org.example.gestionpharmacie.model.Medicament;
import org.example.gestionpharmacie.model.Utilisateur;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/alertes/*")
public class AlertesServlet extends HttpServlet {
    private MedicamentDAO medicamentDAO = new MedicamentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Utilisateur user = (Utilisateur) request.getSession().getAttribute("utilisateur");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        try {
            Map<String, Object> alertes = chargerAlertes();
            
            request.setAttribute("alertes", alertes);
            request.setAttribute("user", user);
            
            request.getRequestDispatcher("/views/alertes.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des alertes: " + e.getMessage());
            request.getRequestDispatcher("/views/alertes.jsp").forward(request, response);
        }
    }

    private Map<String, Object> chargerAlertes() {
        Map<String, Object> alertes = new HashMap<>();
        
        List<Medicament> stockFaible = medicamentDAO.findStockFaible();
        alertes.put("stockFaible", stockFaible);
        alertes.put("countStockFaible", stockFaible.size());
        
        List<Medicament> expirationProche = medicamentDAO.findExpirationProche();
        alertes.put("expirationProche", expirationProche);
        alertes.put("countExpirationProche", expirationProche.size());
        
        long totalMedicaments = medicamentDAO.count();
        long medicamentsDisponibles = medicamentDAO.countDisponibles();
        
        alertes.put("totalMedicaments", totalMedicaments);
        alertes.put("medicamentsDisponibles", medicamentsDisponibles);
        alertes.put("totalAlertes", stockFaible.size() + expirationProche.size());
        
        return alertes;
    }
} 