package org.example.gestionpharmacie.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.gestionpharmacie.dao.MedicamentDAO;
import org.example.gestionpharmacie.dao.MedicamentDAOImpl;
import org.example.gestionpharmacie.model.Medicament;
import org.example.gestionpharmacie.model.Utilisateur;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/medicaments/*")
public class MedicamentServlet extends HttpServlet {
    
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
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
            // Vérifier s'il y a des paramètres d'action
            String action = request.getParameter("action");
            if ("supprimer".equals(action)) {
                handleSupprimerMedicament(request, response, user);
            } else {
                // Liste des médicaments
                handleListeMedicaments(request, response, user);
            }
        } else if (pathInfo.equals("/ajouter")) {
            // Formulaire d'ajout
            handleFormulaireAjout(request, response, user);
        } else if (pathInfo.equals("/modifier")) {
            // Formulaire de modification
            handleFormulaireModifier(request, response, user);
        } else if (pathInfo.equals("/reapprovisionner")) {
            // Formulaire de réapprovisionnement
            handleFormulaireReapprovisionner(request, response, user);
        } else if (pathInfo.startsWith("/api/")) {
            // Requêtes API
            handleApiRequest(request, response, user);
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
        
        String action = request.getParameter("action");
        
        if ("ajouter".equals(action)) {
            handleAjouterMedicament(request, response, user);
        } else if ("modifier".equals(action)) {
            handleModifierMedicament(request, response, user);
        } else if ("supprimer".equals(action)) {
            handleSupprimerMedicament(request, response, user);
        } else if ("rechercher".equals(action)) {
            handleRechercheMedicaments(request, response, user);
        } else if ("reapprovisionner".equals(action)) {
            handleReapprovisionner(request, response, user);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void handleListeMedicaments(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        try {
            List<Medicament> medicaments = medicamentDAO.findAllActifs();
            
            request.setAttribute("medicaments", medicaments);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/medicaments/liste.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des médicaments: " + e.getMessage());
            request.getRequestDispatcher("/views/medicaments/liste.jsp").forward(request, response);
        }
    }
    
    private void handleFormulaireAjout(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/medicaments/ajouter.jsp").forward(request, response);
    }
    
    private void handleFormulaireModifier(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        try {
            Long medicamentId = Long.parseLong(request.getParameter("id"));
            Medicament medicament = medicamentDAO.findById(medicamentId).orElse(null);
            
            if (medicament == null) {
                response.sendRedirect(request.getContextPath() + "/medicaments/?error=Médicament non trouvé");
                return;
            }
            
            request.setAttribute("medicament", medicament);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/medicaments/modifier.jsp").forward(request, response);
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/medicaments/?error=Erreur: " + e.getMessage());
        }
    }
    
    private void handleAjouterMedicament(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        try {
            // Récupérer les données du formulaire
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            BigDecimal prix = new BigDecimal(request.getParameter("prix"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            int seuilAlerte = Integer.parseInt(request.getParameter("seuilAlerte"));
            String codeBarre = request.getParameter("codeBarre");
            String categorie = request.getParameter("categorie");
            String fabricant = request.getParameter("fabricant");
            
            // Parser la date d'expiration
            LocalDate dateExpiration = null;
            if (request.getParameter("dateExpiration") != null && !request.getParameter("dateExpiration").isEmpty()) {
                dateExpiration = LocalDate.parse(request.getParameter("dateExpiration"));
            }
            
            // Créer le médicament
            Medicament medicament = new Medicament();
            medicament.setNom(nom);
            medicament.setDescription(description);
            medicament.setPrix(prix);
            medicament.setStock(stock);
            medicament.setSeuilAlerte(seuilAlerte);
            medicament.setCodeBarre(codeBarre);
            medicament.setCategorie(categorie);
            medicament.setFabricant(fabricant);
            medicament.setDateExpiration(dateExpiration);
            medicament.setActif(true);
            
            // Sauvegarder
            medicamentDAO.save(medicament);
            
            // Rediriger avec un message de succès
            response.sendRedirect(request.getContextPath() + "/medicaments/");
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Veuillez saisir des valeurs numériques valides pour le prix, le stock et le seuil d'alerte");
            request.getRequestDispatcher("/views/medicaments/ajouter.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de l'ajout du médicament: " + e.getMessage());
            request.getRequestDispatcher("/views/medicaments/ajouter.jsp").forward(request, response);
        }
    }
    
    private void handleModifierMedicament(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        try {
            Long medicamentId = Long.parseLong(request.getParameter("id"));
            Medicament medicament = medicamentDAO.findById(medicamentId).orElse(null);
            
            if (medicament == null) {
                response.sendRedirect(request.getContextPath() + "/medicaments/?error=Médicament non trouvé");
                return;
            }
            
            // Mettre à jour les données
            medicament.setNom(request.getParameter("nom"));
            medicament.setDescription(request.getParameter("description"));
            medicament.setPrix(new BigDecimal(request.getParameter("prix")));
            medicament.setStock(Integer.parseInt(request.getParameter("stock")));
            medicament.setSeuilAlerte(Integer.parseInt(request.getParameter("seuilAlerte")));
            medicament.setCodeBarre(request.getParameter("codeBarre"));
            medicament.setCategorie(request.getParameter("categorie"));
            medicament.setFabricant(request.getParameter("fabricant"));
            
            if (request.getParameter("dateExpiration") != null && !request.getParameter("dateExpiration").isEmpty()) {
                medicament.setDateExpiration(LocalDate.parse(request.getParameter("dateExpiration")));
            }
            
            // Sauvegarder
            medicamentDAO.save(medicament);
            
            response.sendRedirect(request.getContextPath() + "/medicaments/");
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/medicaments/");
        }
    }
    
    private void handleSupprimerMedicament(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        try {
            Long medicamentId = Long.parseLong(request.getParameter("id"));
            
            // Supprimer logiquement (désactiver)
            Medicament medicament = medicamentDAO.findById(medicamentId).orElse(null);
            if (medicament != null) {
                medicament.setActif(false);
                medicamentDAO.save(medicament);
                response.sendRedirect(request.getContextPath() + "/medicaments/");
            } else {
                response.sendRedirect(request.getContextPath() + "/medicaments/");
            }
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/medicaments/?error=Erreur lors de la suppression: " + e.getMessage());
        }
    }
    
    private void handleRechercheMedicaments(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        try {
            String nom = request.getParameter("nom");
            String categorie = request.getParameter("categorie");
            String fabricant = request.getParameter("fabricant");
            BigDecimal minPrix = null;
            BigDecimal maxPrix = null;
            Boolean disponible = null;
            
            try {
                if (request.getParameter("minPrix") != null && !request.getParameter("minPrix").isEmpty()) {
                    minPrix = new BigDecimal(request.getParameter("minPrix"));
                }
                if (request.getParameter("maxPrix") != null && !request.getParameter("maxPrix").isEmpty()) {
                    maxPrix = new BigDecimal(request.getParameter("maxPrix"));
                }
                if (request.getParameter("disponible") != null) {
                    disponible = Boolean.parseBoolean(request.getParameter("disponible"));
                }
            } catch (NumberFormatException e) {
                // Ignorer les erreurs de parsing
            }
            
            List<Medicament> medicaments = medicamentDAO.rechercheAvancee(nom, categorie, fabricant, minPrix, maxPrix, disponible);
            
            request.setAttribute("medicaments", medicaments);
            request.setAttribute("user", user);
            request.setAttribute("recherche", true);
            request.setAttribute("nomRecherche", nom);
            request.setAttribute("categorieRecherche", categorie);
            request.setAttribute("fabricantRecherche", fabricant);
            request.setAttribute("minPrixRecherche", minPrix);
            request.setAttribute("maxPrixRecherche", maxPrix);
            request.setAttribute("disponibleRecherche", disponible);
            
            request.getRequestDispatcher("/views/medicaments/liste.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la recherche: " + e.getMessage());
            request.getRequestDispatcher("/views/medicaments/liste.jsp").forward(request, response);
        }
    }
    
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo.equals("/api/stock-faible")) {
            // API pour récupérer les médicaments en stock faible
            List<Medicament> stockFaible = medicamentDAO.findStockFaible();
            request.setAttribute("medicaments", stockFaible);
            request.getRequestDispatcher("/views/medicaments/api/stock-faible.jsp").forward(request, response);
            
        } else if (pathInfo.equals("/api/expiration-proche")) {
            // API pour récupérer les médicaments qui expirent bientôt
            List<Medicament> expirationProche = medicamentDAO.findExpirationProche();
            request.setAttribute("medicaments", expirationProche);
            request.getRequestDispatcher("/views/medicaments/api/expiration-proche.jsp").forward(request, response);
            
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleFormulaireReapprovisionner(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        try {
            String idParam = request.getParameter("id");
            System.out.println("DEBUG: ID parameter = " + idParam); // Debug
            
            Long medicamentId = Long.parseLong(idParam);
            System.out.println("DEBUG: Parsed ID = " + medicamentId); // Debug
            
            Medicament medicament = medicamentDAO.findById(medicamentId).orElse(null);
            System.out.println("DEBUG: Found medicament = " + (medicament != null ? medicament.getNom() : "null")); // Debug
            
            if (medicament == null) {
                System.out.println("DEBUG: Medicament not found, redirecting to list"); // Debug
                response.sendRedirect(request.getContextPath() + "/medicaments/");
                return;
            }
            
            request.setAttribute("medicament", medicament);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/medicaments/reapprovisionner.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in handleFormulaireReapprovisionner: " + e.getMessage()); // Debug
            e.printStackTrace(); // Debug
            response.sendRedirect(request.getContextPath() + "/medicaments/");
        }
    }
    
    private void handleReapprovisionner(HttpServletRequest request, HttpServletResponse response, Utilisateur user) 
            throws ServletException, IOException {
        
        try {
            Long medicamentId = Long.parseLong(request.getParameter("id"));
            int quantite = Integer.parseInt(request.getParameter("quantite"));
            String retour = request.getParameter("retour");
            
            if (quantite <= 0) {
                if ("alertes".equals(retour)) {
                    response.sendRedirect(request.getContextPath() + "/alertes/");
                } else {
                    response.sendRedirect(request.getContextPath() + "/medicaments/");
                }
                return;
            }
            
            Medicament medicament = medicamentDAO.findById(medicamentId).orElse(null);
            if (medicament == null) {
                if ("alertes".equals(retour)) {
                    response.sendRedirect(request.getContextPath() + "/alertes/");
                } else {
                    response.sendRedirect(request.getContextPath() + "/medicaments/");
                }
                return;
            }
            
            // Mettre à jour le stock
            int nouveauStock = medicament.getStock() + quantite;
            medicament.setStock(nouveauStock);
            
            // Sauvegarder
            medicamentDAO.save(medicament);
            
            // Rediriger avec succès selon la page d'origine
            if ("alertes".equals(retour)) {
                response.sendRedirect(request.getContextPath() + "/alertes/?success=Médicament réapprovisionné avec succès");
            } else {
                response.sendRedirect(request.getContextPath() + "/medicaments/?success=Médicament réapprovisionné avec succès");
            }
            
        } catch (Exception e) {
            String retour = request.getParameter("retour");
            if ("alertes".equals(retour)) {
                response.sendRedirect(request.getContextPath() + "/alertes/?error=Erreur lors du réapprovisionnement");
            } else {
                response.sendRedirect(request.getContextPath() + "/medicaments/?error=Erreur lors du réapprovisionnement");
            }
        }
    }
} 