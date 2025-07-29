package org.example.gestionpharmacie.dao;

import org.example.gestionpharmacie.model.Vente;
import java.time.LocalDate;
import java.util.List;

public interface VenteDAO extends GenericDAO<Vente, Long> {
    
    /**
     * Trouve les ventes par date
     */
    List<Vente> findByDate(LocalDate date);
    
    /**
     * Trouve les ventes récentes (limitées par nombre)
     */
    List<Vente> findVentesRecentes(int limit);
    
    /**
     * Trouve les ventes entre deux dates
     */
    List<Vente> findByDateBetween(LocalDate dateDebut, LocalDate dateFin);
    
    /**
     * Trouve les ventes par utilisateur
     */
    List<Vente> findByUtilisateur(Long utilisateurId);
    
    /**
     * Compte le nombre de ventes pour une date donnée
     */
    long countVentesByDate(LocalDate date);
    
    /**
     * Calcule le chiffre d'affaires pour une date donnée
     */
    double getChiffreAffairesByDate(LocalDate date);
    
    /**
     * Calcule le chiffre d'affaires entre deux dates
     */
    double getChiffreAffairesByDateBetween(LocalDate dateDebut, LocalDate dateFin);
    
    /**
     * Trouve les ventes avec un montant supérieur à un seuil
     */
    List<Vente> findByMontantSuperieur(double seuil);
} 