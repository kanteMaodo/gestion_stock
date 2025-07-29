package org.example.gestionpharmacie.dao;

import org.example.gestionpharmacie.model.Medicament;
import java.math.BigDecimal;
import java.util.List;

public interface MedicamentDAO extends GenericDAO<Medicament, Long> {
    
    /**
     * Trouve les médicaments par nom (recherche partielle)
     */
    List<Medicament> findByNomContaining(String nom);
    
    /**
     * Trouve les médicaments par catégorie
     */
    List<Medicament> findByCategorie(String categorie);
    
    /**
     * Trouve les médicaments en stock faible (stock <= seuil d'alerte)
     */
    List<Medicament> findStockFaible();
    
    /**
     * Trouve les médicaments qui expirent bientôt (dans les 30 jours)
     */
    List<Medicament> findExpirationProche();
    
    /**
     * Trouve les médicaments disponibles (stock > 0 et actif = true)
     */
    List<Medicament> findDisponibles();
    
    /**
     * Trouve les médicaments par fabricant
     */
    List<Medicament> findByFabricant(String fabricant);
    
    /**
     * Trouve les médicaments par code barre
     */
    Medicament findByCodeBarre(String codeBarre);
    
    /**
     * Trouve les médicaments par fourchette de prix
     */
    List<Medicament> findByPrixBetween(BigDecimal minPrix, BigDecimal maxPrix);
    
    /**
     * Met à jour le stock d'un médicament
     */
    boolean updateStock(Long medicamentId, int nouvelleQuantite);
    
    /**
     * Décrémente le stock d'un médicament
     */
    boolean decrementerStock(Long medicamentId, int quantite);
    
    /**
     * Incrémente le stock d'un médicament
     */
    boolean incrementerStock(Long medicamentId, int quantite);
    
    /**
     * Recherche avancée avec plusieurs critères
     */
    List<Medicament> rechercheAvancee(String nom, String categorie, String fabricant, 
                                     BigDecimal minPrix, BigDecimal maxPrix, Boolean disponible);
    
    /**
     * Compte le nombre total de médicaments actifs
     */
    long count();
    
    /**
     * Compte le nombre de médicaments disponibles (stock > 0)
     */
    long countDisponibles();
    
    /**
     * Compte le nombre de médicaments en stock faible
     */
    long countStockFaible();
    
    /**
     * Compte le nombre de médicaments qui expirent bientôt
     */
    long countExpirationProche();
    
    List<Medicament> findAllActifs();
} 