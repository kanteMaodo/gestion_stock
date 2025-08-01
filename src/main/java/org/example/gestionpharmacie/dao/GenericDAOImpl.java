package org.example.gestionpharmacie.dao;

import jakarta.persistence.*;
import java.util.List;
import java.util.Optional;


public abstract class GenericDAOImpl<T, ID> implements GenericDAO<T, ID> {
    
    protected final EntityManagerFactory emf;
    protected final Class<T> entityClass;
    
    public GenericDAOImpl(Class<T> entityClass) {
        this.entityClass = entityClass;
        this.emf = Persistence.createEntityManagerFactory("PharmaPU");
    }
    
    @Override
    public T save(T entity) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            T savedEntity = em.merge(entity);
            em.getTransaction().commit();
            return savedEntity;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde de l'entité", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<T> findById(ID id) {
        EntityManager em = emf.createEntityManager();
        try {
            T entity = em.find(entityClass, id);
            return Optional.ofNullable(entity);
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<T> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<T> query = em.createQuery(
                "SELECT e FROM " + entityClass.getSimpleName() + " e", entityClass
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean deleteById(ID id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            T entity = em.find(entityClass, id);
            if (entity != null) {
                em.remove(entity);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().rollback();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de l'entité", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean delete(T entity) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.remove(em.merge(entity));
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de l'entité", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public long count() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(e) FROM " + entityClass.getSimpleName() + " e", Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean existsById(ID id) {
        return findById(id).isPresent();
    }
} 