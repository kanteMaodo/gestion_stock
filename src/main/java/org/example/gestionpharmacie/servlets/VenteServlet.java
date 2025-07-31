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
import java.util.List;
import java.util.Optional;

@WebServlet("/ventes/*")
public class VenteServlet extends HttpServlet {
    
    private final VenteDAO venteDAO = new VenteDAOImpl();
    private final MedicamentDAO medicamentDAO = new MedicamentDAOImpl();
    
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
        if (pathInfo == null || pathInfo.equals("/")) {
            handleListeVentes(request, response);
        } else if (pathInfo.equals("/nouvelle")) {
            handleNouvelleVente(request, response);
        } else if (pathInfo.equals("/details")) {
            handleDetailsVente(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
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
        if (pathInfo == null || pathInfo.equals("/")) {
            handleCreerVente(request, response);
        } else if (pathInfo.equals("/ajouter-ligne")) {
            handleAjouterLigne(request, response);
        } else if (pathInfo.equals("/supprimer-ligne")) {
            handleSupprimerLigne(request, response);
        } else if (pathInfo.equals("/finaliser")) {
            handleFinaliserVente(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleListeVentes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Vente> ventes = venteDAO.findAll();
            request.setAttribute("ventes", ventes);
            request.getRequestDispatcher("/views/ventes/liste.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des ventes: " + e.getMessage());
            request.getRequestDispatcher("/views/ventes/liste.jsp").forward(request, response);
        }
    }
    
    private void handleNouvelleVente(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String venteId = request.getParameter("venteId");
        
        if (venteId != null && !venteId.trim().isEmpty()) {
            // Continuer une vente existante
            try {
                Long id = Long.parseLong(venteId);
                Optional<Vente> venteOpt = venteDAO.findById(id);
                if (venteOpt.isPresent()) {
                    Vente vente = venteOpt.get();
                    request.setAttribute("vente", vente);
                }
            } catch (NumberFormatException e) {
                // Ignorer l'erreur et créer une nouvelle vente
            }
        }
        
        List<Medicament> medicaments = medicamentDAO.findAll();
        request.setAttribute("medicaments", medicaments);
        request.getRequestDispatcher("/views/ventes/nouvelle.jsp").forward(request, response);
    }
    
    private void handleDetailsVente(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String venteId = request.getParameter("id");
        
        if (venteId == null || venteId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ventes/");
            return;
        }
        
        try {
            Long id = Long.parseLong(venteId);
            Optional<Vente> venteOpt = venteDAO.findById(id);
            
            if (venteOpt.isPresent()) {
                request.setAttribute("vente", venteOpt.get());
                request.getRequestDispatcher("/views/ventes/details.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/ventes/");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/");
        }
    }
    
    private void handleCreerVente(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        
        Vente vente = new Vente(user);
        venteDAO.save(vente);
        
        response.sendRedirect(request.getContextPath() + "/ventes/nouvelle?venteId=" + vente.getId());
    }
    
    private void handleAjouterLigne(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String venteId = request.getParameter("venteId");
        String medicamentId = request.getParameter("medicamentId");
        String quantite = request.getParameter("quantite");
        
        if (venteId == null || medicamentId == null || quantite == null) {
            response.sendRedirect(request.getContextPath() + "/ventes/");
            return;
        }
        
        try {
            Long vId = Long.parseLong(venteId);
            Long mId = Long.parseLong(medicamentId);
            Integer qte = Integer.parseInt(quantite);
            
            Optional<Vente> venteOpt = venteDAO.findById(vId);
            Optional<Medicament> medicamentOpt = medicamentDAO.findById(mId);
            
            if (venteOpt.isPresent() && medicamentOpt.isPresent()) {
                Vente vente = venteOpt.get();
                Medicament medicament = medicamentOpt.get();
                
                if (medicament.getStock() >= qte) {
                    LigneVente ligne = new LigneVente(medicament, qte);
                    vente.ajouterLigne(ligne);
                    venteDAO.save(vente);
                    
                    response.sendRedirect(request.getContextPath() + "/ventes/details?id=" + vente.getId() + "&success=Article ajouté avec succès");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ventes/details?id=" + vente.getId() + "&error=Stock insuffisant");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/ventes/");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/");
        }
    }
    
    private void handleSupprimerLigne(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String venteId = request.getParameter("venteId");
        String ligneIndex = request.getParameter("ligneIndex");
        
        if (venteId == null || ligneIndex == null) {
            response.sendRedirect(request.getContextPath() + "/ventes/");
            return;
        }
        
        try {
            Long vId = Long.parseLong(venteId);
            int index = Integer.parseInt(ligneIndex);
            
            Optional<Vente> venteOpt = venteDAO.findById(vId);
            
            if (venteOpt.isPresent()) {
                Vente vente = venteOpt.get();
                vente.supprimerLigne(index);
                venteDAO.save(vente);
                
                response.sendRedirect(request.getContextPath() + "/ventes/details?id=" + vente.getId() + "&success=Article supprimé avec succès");
            } else {
                response.sendRedirect(request.getContextPath() + "/ventes/");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/");
        }
    }
    
    private void handleFinaliserVente(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String venteId = request.getParameter("venteId");
        String commentaire = request.getParameter("commentaire");
        
        if (venteId == null) {
            response.sendRedirect(request.getContextPath() + "/ventes/");
            return;
        }
        
        try {
            Long vId = Long.parseLong(venteId);
            Optional<Vente> venteOpt = venteDAO.findById(vId);
            
            if (venteOpt.isPresent()) {
                Vente vente = venteOpt.get();
                
                if (commentaire != null && !commentaire.trim().isEmpty()) {
                    vente.setCommentaire(commentaire);
                }
                
                vente.finaliser();
                venteDAO.save(vente);
                
                response.sendRedirect(request.getContextPath() + "/ventes/details?id=" + vente.getId() + "&success=Vente finalisée avec succès");
            } else {
                response.sendRedirect(request.getContextPath() + "/ventes/");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/");
        } catch (IllegalStateException e) {
            response.sendRedirect(request.getContextPath() + "/ventes/details?id=" + venteId + "&error=" + e.getMessage());
        }
    }
} 