package org.example.gestionpharmacie.dao;

import jakarta.persistence.*;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.example.gestionpharmacie.model.Medicament;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class MedicamentDAOImpl extends GenericDAOImpl<Medicament, Long> implements MedicamentDAO {
    
    public MedicamentDAOImpl() {
        super(Medicament.class);
    }
    
    @Override
    public List<Medicament> findByNomContaining(String nom) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE LOWER(m.nom) LIKE LOWER(:nom) AND m.actif = true ORDER BY m.nom",
                Medicament.class
            );
            query.setParameter("nom", "%" + nom + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Medicament> findByCategorie(String categorie) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.categorie = :categorie AND m.actif = true ORDER BY m.nom",
                Medicament.class
            );
            query.setParameter("categorie", categorie);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Medicament> findStockFaible() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.stock <= m.seuilAlerte AND m.actif = true ORDER BY m.stock ASC",
                Medicament.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Medicament> findExpirationProche() {
        EntityManager em = emf.createEntityManager();
        try {
            LocalDate dateLimite = LocalDate.now().plusDays(30);
            TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.dateExpiration <= :dateLimite AND m.actif = true ORDER BY m.dateExpiration ASC",
                Medicament.class
            );
            query.setParameter("dateLimite", dateLimite);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Medicament> findDisponibles() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.stock > 0 AND m.actif = true ORDER BY m.nom",
                Medicament.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Medicament> findByFabricant(String fabricant) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.fabricant = :fabricant AND m.actif = true ORDER BY m.nom",
                Medicament.class
            );
            query.setParameter("fabricant", fabricant);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public Medicament findByCodeBarre(String codeBarre) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.codeBarre = :codeBarre AND m.actif = true",
                Medicament.class
            );
            query.setParameter("codeBarre", codeBarre);
            return query.getResultStream().findFirst().orElse(null);
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Medicament> findByPrixBetween(BigDecimal minPrix, BigDecimal maxPrix) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.prix BETWEEN :minPrix AND :maxPrix AND m.actif = true ORDER BY m.prix",
                Medicament.class
            );
            query.setParameter("minPrix", minPrix);
            query.setParameter("maxPrix", maxPrix);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean updateStock(Long medicamentId, int nouvelleQuantite) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            int updatedRows = em.createQuery(
                "UPDATE Medicament m SET m.stock = :nouvelleQuantite WHERE m.id = :medicamentId"
            )
            .setParameter("nouvelleQuantite", nouvelleQuantite)
            .setParameter("medicamentId", medicamentId)
            .executeUpdate();
            
            em.getTransaction().commit();
            return updatedRows > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour du stock", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean decrementerStock(Long medicamentId, int quantite) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            int updatedRows = em.createQuery(
                "UPDATE Medicament m SET m.stock = m.stock - :quantite WHERE m.id = :medicamentId AND m.stock >= :quantite"
            )
            .setParameter("quantite", quantite)
            .setParameter("medicamentId", medicamentId)
            .executeUpdate();
            
            em.getTransaction().commit();
            return updatedRows > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la décrémentation du stock", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean incrementerStock(Long medicamentId, int quantite) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            int updatedRows = em.createQuery(
                "UPDATE Medicament m SET m.stock = m.stock + :quantite WHERE m.id = :medicamentId"
            )
            .setParameter("quantite", quantite)
            .setParameter("medicamentId", medicamentId)
            .executeUpdate();
            
            em.getTransaction().commit();
            return updatedRows > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de l'incrémentation du stock", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Medicament> rechercheAvancee(String nom, String categorie, String fabricant, 
                                           BigDecimal minPrix, BigDecimal maxPrix, Boolean disponible) {
        EntityManager em = emf.createEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Medicament> cq = cb.createQuery(Medicament.class);
            Root<Medicament> root = cq.from(Medicament.class);
            
            List<Predicate> predicates = new ArrayList<>();
            
            // Toujours filtrer par actif = true
            predicates.add(cb.equal(root.get("actif"), true));
            
            // Filtres optionnels
            if (nom != null && !nom.trim().isEmpty()) {
                predicates.add(cb.like(cb.lower(root.get("nom")), "%" + nom.toLowerCase() + "%"));
            }
            
            if (categorie != null && !categorie.trim().isEmpty()) {
                predicates.add(cb.equal(root.get("categorie"), categorie));
            }
            
            if (fabricant != null && !fabricant.trim().isEmpty()) {
                predicates.add(cb.equal(root.get("fabricant"), fabricant));
            }
            
            if (minPrix != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("prix"), minPrix));
            }
            
            if (maxPrix != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("prix"), maxPrix));
            }
            
            if (disponible != null && disponible) {
                predicates.add(cb.greaterThan(root.get("stock"), 0));
            }
            
            cq.where(predicates.toArray(new Predicate[0]));
            cq.orderBy(cb.asc(root.get("nom")));
            
            TypedQuery<Medicament> query = em.createQuery(cq);
            return query.getResultList();
            
        } finally {
            em.close();
        }
    }
    
    @Override
    public long count() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(m) FROM Medicament m WHERE m.actif = true", Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public long countDisponibles() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(m) FROM Medicament m WHERE m.stock > 0 AND m.actif = true", Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public long countStockFaible() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(m) FROM Medicament m WHERE m.stock <= m.seuilAlerte AND m.actif = true", Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public long countExpirationProche() {
        EntityManager em = emf.createEntityManager();
        try {
            LocalDate dateLimite = LocalDate.now().plusDays(30);
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(m) FROM Medicament m WHERE m.dateExpiration <= :dateLimite AND m.actif = true", Long.class
            );
            query.setParameter("dateLimite", dateLimite);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Medicament> findAllActifs() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Medicament> query = em.createQuery(
                "SELECT m FROM Medicament m WHERE m.actif = true ORDER BY m.nom",
                Medicament.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
} 