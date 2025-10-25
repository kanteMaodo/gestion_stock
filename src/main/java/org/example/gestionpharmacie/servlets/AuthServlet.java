package org.example.gestionpharmacie.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.example.gestionpharmacie.dao.UtilisateurDAO;
import org.example.gestionpharmacie.dao.UtilisateurDAOImpl;
import org.example.gestionpharmacie.model.Utilisateur;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "authServlet", value = "/auth")
public class AuthServlet extends HttpServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("login".equals(action)) {
            handleLogin(req, resp);
        } else if ("register".equals(action)) {
            handleRegister(req, resp);
        } else {
            resp.sendRedirect("/views/auth.jsp");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String motDePasse = req.getParameter("motDePasse");
        
        try {
			Optional<Utilisateur> utilisateurOpt = utilisateurDAO.authenticate(email, motDePasse);
            
            if (utilisateurOpt.isPresent()) {
				Utilisateur utilisateur = utilisateurOpt.get();
				if (!BCrypt.checkpw(motDePasse, utilisateur.getMotDePasse())) {
					req.setAttribute("loginError", "Email ou mot de passe incorrect !");
					req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
					return;
				}
                HttpSession session = req.getSession();
                session.setAttribute("utilisateur", utilisateur);
                
                // Mettre à jour la dernière connexion
                utilisateur.updateDerniereConnexion();
                utilisateurDAO.save(utilisateur);
                
                // Rediriger vers le dashboard approprié selon le rôle
                if (utilisateur.getRole() == Utilisateur.Role.ADMIN) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                } else if (utilisateur.getRole() == Utilisateur.Role.PHARMACIEN) {
                    resp.sendRedirect(req.getContextPath() + "/pharmacien/dashboard");
                } else {
                    // Par défaut, rediriger vers le dashboard admin
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                }
            } else {
                req.setAttribute("loginError", "Email ou mot de passe incorrect !");
                req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("loginError", "Erreur lors de la connexion : " + e.getMessage());
            req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String nom = req.getParameter("nom");
		String prenom = req.getParameter("prenom");
		String email = req.getParameter("email");
		String login = req.getParameter("login");
		String motDePasse = req.getParameter("motDePasse");
		String roleStr = req.getParameter("role");
        
        try {
			if (utilisateurDAO.emailExists(email)) {
                req.setAttribute("registerError", "Email déjà utilisé !");
                req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
                return;
            }
			if (utilisateurDAO.loginExists(login)) {
				req.setAttribute("registerError", "Login déjà utilisé !");
				req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
				return;
			}
            
			String hashed = BCrypt.hashpw(motDePasse, BCrypt.gensalt());
			Utilisateur utilisateur = new Utilisateur(
					nom, prenom, email, login, hashed, Utilisateur.Role.valueOf(roleStr)
			);
            utilisateurDAO.save(utilisateur);
            
            req.setAttribute("registerSuccess", "Compte créé avec succès ! Vous pouvez maintenant vous connecter.");
            req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("registerError", "Erreur lors de la création du compte : " + e.getMessage());
            req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
        }
    }
}