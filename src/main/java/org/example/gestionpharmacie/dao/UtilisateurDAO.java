package org.example.gestionpharmacie.dao;

import org.example.gestionpharmacie.model.Utilisateur;
import java.util.List;
import java.util.Optional;

public interface UtilisateurDAO extends GenericDAO<Utilisateur, Long> {
    
    /**
     * Trouve un utilisateur par son email
     */
    Optional<Utilisateur> findByEmail(String email);
    
    /**
     * Trouve un utilisateur par son login
     */
    Optional<Utilisateur> findByLogin(String login);
    
    /**
     * Trouve les utilisateurs par rôle
     */
    List<Utilisateur> findByRole(Utilisateur.Role role);
    
    /**
     * Trouve les utilisateurs actifs
     */
    List<Utilisateur> findActifs();
    
    /**
     * Vérifie si un email existe déjà
     */
    boolean emailExists(String email);
    
    /**
     * Vérifie si un login existe déjà
     */
    boolean loginExists(String login);
    
    /**
     * Authentifie un utilisateur par email et mot de passe
     */
    Optional<Utilisateur> authenticate(String email, String motDePasse);
    
    /**
     * Compte les utilisateurs par rôle
     */
    long countByRole(Utilisateur.Role role);
    
    /**
     * Compte les utilisateurs actifs
     */
    long countActifs();
} 