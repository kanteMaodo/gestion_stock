package org.example.gestionpharmacie.dao;

import jakarta.persistence.*;
import org.example.gestionpharmacie.model.Utilisateur;
import java.util.List;
import java.util.Optional;

public class UtilisateurDAOImpl extends GenericDAOImpl<Utilisateur, Long> implements UtilisateurDAO {
    
    public UtilisateurDAOImpl() {
        super(Utilisateur.class);
    }
    
    @Override
    public Optional<Utilisateur> findByEmail(String email) {
		EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                "SELECT u FROM Utilisateur u WHERE u.email = :email", Utilisateur.class
            );
            query.setParameter("email", email);
            return query.getResultStream().findFirst();
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<Utilisateur> findByLogin(String login) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                "SELECT u FROM Utilisateur u WHERE u.login = :login", Utilisateur.class
            );
            query.setParameter("login", login);
            return query.getResultStream().findFirst();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Utilisateur> findByRole(Utilisateur.Role role) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                "SELECT u FROM Utilisateur u WHERE u.role = :role ORDER BY u.nom, u.prenom", Utilisateur.class
            );
            query.setParameter("role", role);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Utilisateur> findActifs() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                "SELECT u FROM Utilisateur u WHERE u.actif = true ORDER BY u.nom, u.prenom", Utilisateur.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean emailExists(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(u) FROM Utilisateur u WHERE u.email = :email", Long.class
            );
            query.setParameter("email", email);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean loginExists(String login) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(u) FROM Utilisateur u WHERE u.login = :login", Long.class
            );
            query.setParameter("login", login);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<Utilisateur> authenticate(String email, String motDePasse) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                "SELECT u FROM Utilisateur u WHERE u.email = :email AND u.actif = true",
                Utilisateur.class
            );
            query.setParameter("email", email);
            Optional<Utilisateur> userOpt = query.getResultStream().findFirst();
            return userOpt;
        } finally {
            em.close();
        }
    }
    
    @Override
    public long countByRole(Utilisateur.Role role) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(u) FROM Utilisateur u WHERE u.role = :role AND u.actif = true", Long.class
            );
            query.setParameter("role", role);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public long countActifs() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(u) FROM Utilisateur u WHERE u.actif = true", Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
} 