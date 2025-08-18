package org.example.gestionpharmacie.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.example.gestionpharmacie.dao.UtilisateurDAO;
import org.example.gestionpharmacie.dao.UtilisateurDAOImpl;
import org.example.gestionpharmacie.model.Utilisateur;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/utilisateurs/*")
public class UtilisateurServlet extends HttpServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Liste des utilisateurs
            listUtilisateurs(req, resp);
        } else if (pathInfo.equals("/ajouter")) {
            // Formulaire d'ajout
            showAddForm(req, resp);
        } else if (pathInfo.equals("/modifier")) {
            // Formulaire de modification
            String id = req.getParameter("id");
            if (id != null) {
                showEditForm(req, resp, Long.parseLong(id));
            } else {
                resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
            }
        } else if (pathInfo.equals("/supprimer")) {
            // Suppression
            String id = req.getParameter("id");
            if (id != null) {
                deleteUtilisateur(req, resp, Long.parseLong(id));
            } else {
                resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Traitement de l'ajout/modification
            String action = req.getParameter("action");
            if ("ajouter".equals(action)) {
                addUtilisateur(req, resp);
            } else if ("modifier".equals(action)) {
                updateUtilisateur(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
        }
    }

    private void listUtilisateurs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Utilisateur> utilisateurs = utilisateurDAO.findAll();
            req.setAttribute("utilisateurs", utilisateurs);
            req.setAttribute("totalUtilisateurs", utilisateurDAO.countActifs());
            req.getRequestDispatcher("/views/admin/utilisateurs/liste.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors du chargement des utilisateurs : " + e.getMessage());
            req.getRequestDispatcher("/views/admin/utilisateurs/liste.jsp").forward(req, resp);
        }
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/admin/utilisateurs/ajouter.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp, Long id) throws ServletException, IOException {
        try {
            Optional<Utilisateur> utilisateurOpt = utilisateurDAO.findById(id);
            if (utilisateurOpt.isPresent()) {
                req.setAttribute("utilisateur", utilisateurOpt.get());
                req.getRequestDispatcher("/views/admin/utilisateurs/modifier.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Utilisateur non trouvé");
                resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors du chargement de l'utilisateur : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
        }
    }

    private void addUtilisateur(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String nom = req.getParameter("nom");
            String prenom = req.getParameter("prenom");
            String email = req.getParameter("email");
            String login = req.getParameter("login");
            String motDePasse = req.getParameter("motDePasse");
            String roleStr = req.getParameter("role");

            // Validation
            if (nom == null || nom.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                req.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
                req.getRequestDispatcher("/views/admin/utilisateurs/ajouter.jsp").forward(req, resp);
                return;
            }

            // Vérification de l'unicité
            if (utilisateurDAO.emailExists(email)) {
                req.setAttribute("error", "Cet email est déjà utilisé");
                req.getRequestDispatcher("/views/admin/utilisateurs/ajouter.jsp").forward(req, resp);
                return;
            }

            if (utilisateurDAO.loginExists(login)) {
                req.setAttribute("error", "Ce login est déjà utilisé");
                req.getRequestDispatcher("/views/admin/utilisateurs/ajouter.jsp").forward(req, resp);
                return;
            }

            Utilisateur utilisateur = new Utilisateur(
                nom, prenom, email, login, motDePasse, Utilisateur.Role.valueOf(roleStr)
            );
            
            utilisateurDAO.save(utilisateur);
            req.setAttribute("success", "Utilisateur créé avec succès");
            resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
            
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de la création : " + e.getMessage());
            req.getRequestDispatcher("/views/admin/utilisateurs/ajouter.jsp").forward(req, resp);
        }
    }

    private void updateUtilisateur(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Long id = Long.parseLong(req.getParameter("id"));
            String nom = req.getParameter("nom");
            String prenom = req.getParameter("prenom");
            String email = req.getParameter("email");
            String login = req.getParameter("login");
            String roleStr = req.getParameter("role");
            String motDePasse = req.getParameter("motDePasse");

            Optional<Utilisateur> utilisateurOpt = utilisateurDAO.findById(id);
            if (!utilisateurOpt.isPresent()) {
                req.setAttribute("error", "Utilisateur non trouvé");
                resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
                return;
            }

            Utilisateur utilisateur = utilisateurOpt.get();
            utilisateur.setNom(nom);
            utilisateur.setPrenom(prenom);
            utilisateur.setEmail(email);
            utilisateur.setLogin(login);
            utilisateur.setRole(Utilisateur.Role.valueOf(roleStr));
            
            // Mise à jour du mot de passe seulement si fourni
            if (motDePasse != null && !motDePasse.trim().isEmpty()) {
                utilisateur.setMotDePasse(motDePasse);
            }

            utilisateurDAO.save(utilisateur);
            req.setAttribute("success", "Utilisateur modifié avec succès");
            resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
            
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de la modification : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
        }
    }

    private void deleteUtilisateur(HttpServletRequest req, HttpServletResponse resp, Long id) throws ServletException, IOException {
        try {
            Optional<Utilisateur> utilisateurOpt = utilisateurDAO.findById(id);
            if (utilisateurOpt.isPresent()) {
                Utilisateur utilisateur = utilisateurOpt.get();
                utilisateur.setActif(false); // Désactivation au lieu de suppression
                utilisateurDAO.save(utilisateur);
                req.setAttribute("success", "Utilisateur désactivé avec succès");
            } else {
                req.setAttribute("error", "Utilisateur non trouvé");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/utilisateurs/");
    }
}
