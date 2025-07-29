package org.example.gestionpharmacie.dao;

import java.util.List;
import java.util.Optional;

/**
 * Interface générique pour les opérations CRUD de base
 * @param <T> Le type d'entité
 * @param <ID> Le type de l'identifiant
 */
public interface GenericDAO<T, ID> {
    
    /**
     * Sauvegarde une entité (création ou mise à jour)
     */
    T save(T entity);
    
    /**
     * Trouve une entité par son ID
     */
    Optional<T> findById(ID id);
    
    /**
     * Trouve toutes les entités
     */
    List<T> findAll();
    
    /**
     * Supprime une entité par son ID
     */
    boolean deleteById(ID id);
    
    /**
     * Supprime une entité
     */
    boolean delete(T entity);
    
    /**
     * Compte le nombre total d'entités
     */
    long count();
    
    /**
     * Vérifie si une entité existe par son ID
     */
    boolean existsById(ID id);
} 