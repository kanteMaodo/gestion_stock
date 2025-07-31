package org.example.gestionpharmacie.dao;

import jakarta.persistence.*;
import org.example.gestionpharmacie.model.Vente;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class VenteDAOImpl extends GenericDAOImpl<Vente, Long> implements VenteDAO {
    
    public VenteDAOImpl() {
        super(Vente.class);
    }
    
    @Override
    public List<Vente> findByDate(LocalDate date) {
        EntityManager em = emf.createEntityManager();
        try {
            LocalDateTime debutJour = date.atStartOfDay();
            LocalDateTime finJour = date.atTime(23, 59, 59);
            
            TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v WHERE v.dateVente BETWEEN :debutJour AND :finJour ORDER BY v.dateVente DESC",
                Vente.class
            );
            query.setParameter("debutJour", debutJour);
            query.setParameter("finJour", finJour);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Vente> findVentesRecentes(int limit) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v JOIN FETCH v.vendeur ORDER BY v.dateVente DESC",
                Vente.class
            );
            query.setMaxResults(limit);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Vente> findByDateBetween(LocalDate dateDebut, LocalDate dateFin) {
        EntityManager em = emf.createEntityManager();
        try {
            LocalDateTime debut = dateDebut.atStartOfDay();
            LocalDateTime fin = dateFin.atTime(23, 59, 59);
            
            TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v WHERE v.dateVente BETWEEN :debut AND :fin ORDER BY v.dateVente DESC",
                Vente.class
            );
            query.setParameter("debut", debut);
            query.setParameter("fin", fin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Vente> findByUtilisateur(Long utilisateurId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v WHERE v.vendeur.id = :utilisateurId ORDER BY v.dateVente DESC",
                Vente.class
            );
            query.setParameter("utilisateurId", utilisateurId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public long countVentesByDate(LocalDate date) {
        EntityManager em = emf.createEntityManager();
        try {
            LocalDateTime debutJour = date.atStartOfDay();
            LocalDateTime finJour = date.atTime(23, 59, 59);
            
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(v) FROM Vente v WHERE v.dateVente BETWEEN :debutJour AND :finJour",
                Long.class
            );
            query.setParameter("debutJour", debutJour);
            query.setParameter("finJour", finJour);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public double getChiffreAffairesByDate(LocalDate date) {
        EntityManager em = emf.createEntityManager();
        try {
            LocalDateTime debutJour = date.atStartOfDay();
            LocalDateTime finJour = date.atTime(23, 59, 59);
            
            TypedQuery<Double> query = em.createQuery(
                "SELECT COALESCE(SUM(v.montantTotal), 0.0) FROM Vente v WHERE v.dateVente BETWEEN :debutJour AND :finJour",
                Double.class
            );
            query.setParameter("debutJour", debutJour);
            query.setParameter("finJour", finJour);
            Double result = query.getSingleResult();
            return result != null ? result : 0.0;
        } finally {
            em.close();
        }
    }
    
    @Override
    public double getChiffreAffairesByDateBetween(LocalDate dateDebut, LocalDate dateFin) {
        EntityManager em = emf.createEntityManager();
        try {
            LocalDateTime debut = dateDebut.atStartOfDay();
            LocalDateTime fin = dateFin.atTime(23, 59, 59);
            
            TypedQuery<Double> query = em.createQuery(
                "SELECT COALESCE(SUM(v.montantTotal), 0.0) FROM Vente v WHERE v.dateVente BETWEEN :debut AND :fin",
                Double.class
            );
            query.setParameter("debut", debut);
            query.setParameter("fin", fin);
            Double result = query.getSingleResult();
            return result != null ? result : 0.0;
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Vente> findByMontantSuperieur(double seuil) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v WHERE v.montantTotal > :seuil ORDER BY v.montantTotal DESC",
                Vente.class
            );
            query.setParameter("seuil", seuil);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Vente> findAllWithVendeur() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v JOIN FETCH v.vendeur ORDER BY v.dateVente DESC",
                Vente.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<Vente> findByIdWithDetails(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v " +
                "JOIN FETCH v.vendeur " +
                "LEFT JOIN FETCH v.lignesVente l " +
                "LEFT JOIN FETCH l.medicament " +
                "WHERE v.id = :id",
                Vente.class
            );
            query.setParameter("id", id);
            return query.getResultList().stream().findFirst();
        } finally {
            em.close();
        }
    }
} 