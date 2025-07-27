package org.example.gestionpharmacie.servlets;

import jakarta.persistence.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.example.gestionpharmacie.model.Utilisateur;

import java.io.IOException;

@WebServlet(name = "authServlet", value = "/auth")
public class AuthServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("PharmaPU");
    }

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
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                    "SELECT u FROM Utilisateur u WHERE u.email = :email AND u.motDePasse = :motDePasse", Utilisateur.class);
            query.setParameter("email", email);
            query.setParameter("motDePasse", motDePasse);
            Utilisateur utilisateur = query.getResultStream().findFirst().orElse(null);
            if (utilisateur != null && utilisateur.isActif()) {
                HttpSession session = req.getSession();
                session.setAttribute("utilisateur", utilisateur);
                
                // Mettre à jour la dernière connexion
                utilisateur.updateDerniereConnexion();
                em.getTransaction().begin();
                em.merge(utilisateur);
                em.getTransaction().commit();
                
                // Redirection selon le rôle
                switch (utilisateur.getRole()) {
                    case ADMIN:
                        resp.sendRedirect("admin/dashboard");
                        break;
                    case PHARMACIEN:
                        resp.sendRedirect("pharmacien/dashboard");
                        break;
                    case ASSISTANT:
                        resp.sendRedirect("assistant/dashboard");
                        break;
                    default:
                        resp.sendRedirect("dashboard");
                        break;
                }
            } else {
                req.setAttribute("loginError", "Email ou mot de passe incorrect !");
                req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
            }
        } finally {
            em.close();
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String email = req.getParameter("email");
        String login = req.getParameter("login");
        String motDePasse = req.getParameter("motDePasse");
        String roleStr = req.getParameter("role");
        EntityManager em = emf.createEntityManager();
        try {
            // Vérifier si le login ou l'email existe déjà
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(u) FROM Utilisateur u WHERE u.login = :login OR u.email = :email", Long.class);
            query.setParameter("login", login);
            query.setParameter("email", email);
            Long count = query.getSingleResult();
            if (count > 0) {
                req.setAttribute("registerError", "Login ou email déjà utilisé !");
                req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
                return;
            }
            // Créer et enregistrer l'utilisateur
            em.getTransaction().begin();
            Utilisateur utilisateur = new Utilisateur(
                    nom, prenom, email, login, motDePasse, Utilisateur.Role.valueOf(roleStr)
            );
            em.persist(utilisateur);
            em.getTransaction().commit();
            req.setAttribute("registerSuccess", "Compte créé avec succès ! Vous pouvez maintenant vous connecter.");
            req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            req.setAttribute("registerError", "Erreur lors de la création du compte : " + e.getMessage());
            req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
        } finally {
            em.close();
        }
    }

    @Override
    public void destroy() {
        if (emf != null) emf.close();
    }
}