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
import org.example.gestionpharmacie.model.Medicament;
import org.example.gestionpharmacie.model.Utilisateur;
import org.example.gestionpharmacie.model.Vente;
import org.example.gestionpharmacie.model.LigneVente;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet("/ventes/*")
public class VenteServlet extends HttpServlet {
    
    private VenteDAO venteDAO;
    private MedicamentDAO medicamentDAO;
    
    @Override
    public void init() throws ServletException {
        venteDAO = new VenteDAOImpl();
        medicamentDAO = new MedicamentDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        try {
            switch (pathInfo) {
                case "/":
                    handleListeVentes(request, response, user);
                    break;
                case "/nouvelle":
                    handleNouvelleVente(request, response, user);
                    break;
                case "/details":
                    handleDetailsVente(request, response, user);
                    break;
                case "/annuler":
                    handleAnnulerVente(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        try {
            switch (pathInfo) {
                case "/creer":
                    handleCreerVente(request, response, user);
                    break;
                case "/ajouter-ligne":
                    handleAjouterLigne(request, response, user);
                    break;
                case "/supprimer-ligne":
                    handleSupprimerLigne(request, response, user);
                    break;
                case "/finaliser":
                    handleFinaliserVente(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur: " + e.getMessage());
        }
    }
    
    private void handleListeVentes(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        try {
            List<Vente> ventes = venteDAO.findVentesRecentes(50);
            request.setAttribute("ventes", ventes);
            
            request.getRequestDispatcher("/views/ventes/liste.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // En cas d'erreur, on affiche une liste vide
            request.setAttribute("ventes", new ArrayList<>());
            request.setAttribute("error", "Erreur lors du chargement des ventes: " + e.getMessage());
            request.getRequestDispatcher("/views/ventes/liste.jsp").forward(request, response);
        }
    }
    
    private void handleNouvelleVente(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        List<Medicament> medicaments = medicamentDAO.findAll();
        request.setAttribute("medicaments", medicaments);
        
        request.getRequestDispatcher("/views/ventes/nouvelle.jsp").forward(request, response);
    }
    
    private void handleDetailsVente(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ventes/?error=ID de vente manquant");
            return;
        }
        
        try {
            Long id = Long.parseLong(idStr);
            Optional<Vente> venteOpt = venteDAO.findById(id);

            if (venteOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ventes/?error=Vente non trouvée");
                return;
            }
            
            Vente vente = venteOpt.get();
            request.setAttribute("vente", vente);
            request.getRequestDispatcher("/views/ventes/details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/?error=ID de vente invalide");
        }
    }
    
    private void handleAnnulerVente(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ventes/?error=ID de vente manquant");
            return;
        }
        
        try {
            Long id = Long.parseLong(idStr);
            Optional<Vente> venteOpt = venteDAO.findById(id);
            
            if (venteOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ventes/?error=Vente non trouvée");
                return;
            }
            
            Vente vente = venteOpt.get();
            
            if (!vente.peutEtreAnnulee()) {
                response.sendRedirect(request.getContextPath() + "/ventes/?error=Cette vente ne peut pas être annulée");
                return;
            }
            
            vente.annuler();
            venteDAO.save(vente);
            
            response.sendRedirect(request.getContextPath() + "/ventes/?success=Vente annulée avec succès");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/?error=ID de vente invalide");
        }
    }
    
    private void handleCreerVente(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        // Créer une nouvelle vente
        Vente vente = new Vente(user);
        venteDAO.save(vente);
        
        // Stocker l'ID de la vente en session pour les lignes suivantes
        HttpSession session = request.getSession();
        session.setAttribute("venteEnCours", vente.getId());
        
        response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?venteId=" + vente.getId());
    }
    
    private void handleAjouterLigne(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        String venteIdStr = request.getParameter("venteId");
        String medicamentIdStr = request.getParameter("medicamentId");
        String quantiteStr = request.getParameter("quantite");
        
        if (venteIdStr == null || medicamentIdStr == null || quantiteStr == null) {
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=Paramètres manquants");
            return;
        }
        
        try {
            Long venteId = Long.parseLong(venteIdStr);
            Long medicamentId = Long.parseLong(medicamentIdStr);
            Integer quantite = Integer.parseInt(quantiteStr);
            
            Optional<Vente> venteOpt = venteDAO.findById(venteId);
            Optional<Medicament> medicamentOpt = medicamentDAO.findById(medicamentId);
            
            if (venteOpt.isEmpty() || medicamentOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=Vente ou médicament non trouvé");
                return;
            }
            
            Vente vente = venteOpt.get();
            Medicament medicament = medicamentOpt.get();
            
            // Vérifier le stock disponible
            if (medicament.getStock() < quantite) {
                response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=Stock insuffisant pour " + medicament.getNom());
                return;
            }
            
            // Ajouter la ligne de vente
            vente.ajouterLigne(medicament, quantite);
            venteDAO.save(vente);
            
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?venteId=" + venteId + "&success=Ligne ajoutée");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=Paramètres invalides");
        }
    }
    
    private void handleSupprimerLigne(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        String venteIdStr = request.getParameter("venteId");
        String ligneIndexStr = request.getParameter("ligneIndex");
        
        if (venteIdStr == null || ligneIndexStr == null) {
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=Paramètres manquants");
            return;
        }
        
        try {
            Long venteId = Long.parseLong(venteIdStr);
            Integer ligneIndex = Integer.parseInt(ligneIndexStr);
            
            Optional<Vente> venteOpt = venteDAO.findById(venteId);
            
            if (venteOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=Vente non trouvée");
                return;
            }
            
            Vente vente = venteOpt.get();
            
            if (ligneIndex >= 0 && ligneIndex < vente.getLignesVente().size()) {
                vente.getLignesVente().remove(ligneIndex.intValue());
                vente.calculerMontantTotal();
                venteDAO.save(vente);
            }
            
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?venteId=" + venteId + "&success=Ligne supprimée");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=Paramètres invalides");
        }
    }
    
    private void handleFinaliserVente(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        String venteIdStr = request.getParameter("venteId");
        String commentaire = request.getParameter("commentaire");
        
        if (venteIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=ID de vente manquant");
            return;
        }
        
        try {
            Long venteId = Long.parseLong(venteIdStr);
            Optional<Vente> venteOpt = venteDAO.findById(venteId);
            
            if (venteOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=Vente non trouvée");
                return;
            }
            
            Vente vente = venteOpt.get();
            
            if (vente.getLignesVente().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=Impossible de finaliser une vente vide");
                return;
            }
            
            // Déduire le stock pour chaque ligne
            for (LigneVente ligne : vente.getLignesVente()) {
                ligne.validerStock();
            }
            
            // Finaliser la vente
            vente.setCommentaire(commentaire);
            vente.setStatut(Vente.StatutVente.COMPLETEE);
            venteDAO.save(vente);
            
            // Nettoyer la session
            HttpSession session = request.getSession();
            session.removeAttribute("venteEnCours");
            
            response.sendRedirect(request.getContextPath() + "/ventes/details?id=" + venteId + "&success=Vente finalisée avec succès");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?error=ID de vente invalide");
        }
    }
} 