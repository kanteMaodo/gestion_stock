package org.example.gestionpharmacie.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * Entité JPA représentant une vente dans le système de gestion de pharmacie
 */
@Entity
@Table(name = "ventes")
public class Vente implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vendeur_id", nullable = false)
    private Utilisateur vendeur;

    @Column(name = "montant_total", nullable = false, precision = 10, scale = 2)
    private BigDecimal montantTotal = BigDecimal.ZERO;

    @Column(name = "date_vente", nullable = false)
    private LocalDateTime dateVente;

    @Column(name = "statut", nullable = false, length = 20)
    @Enumerated(EnumType.STRING)
    private StatutVente statut = StatutVente.EN_COURS;

    @Column(name = "commentaire", columnDefinition = "TEXT")
    private String commentaire;

    @OneToMany(mappedBy = "vente", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    private List<LigneVente> lignesVente = new ArrayList<>();

    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation;

    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    // Énumération pour les statuts de vente
    public enum StatutVente {
        EN_COURS("En cours"),
        COMPLETEE("Complétée"),
        ANNULEE("Annulée");

        private final String libelle;

        StatutVente(String libelle) {
            this.libelle = libelle;
        }

        public String getLibelle() {
            return libelle;
        }
    }

    // Constructeurs
    public Vente() {
        this.dateVente = LocalDateTime.now();
        this.dateCreation = LocalDateTime.now();
        this.statut = StatutVente.EN_COURS;
    }

    public Vente(Utilisateur vendeur) {
        this();
        this.vendeur = vendeur;
    }

    // Méthodes callback JPA
    @PrePersist
    protected void onCreate() {
        this.dateCreation = LocalDateTime.now();
        if (this.dateVente == null) {
            this.dateVente = LocalDateTime.now();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.dateModification = LocalDateTime.now();
    }

    // Méthodes utilitaires
    public void ajouterLigne(Medicament medicament, int quantite) {
        LigneVente ligne = new LigneVente(this, medicament, quantite);
        this.lignesVente.add(ligne);
        this.calculerMontantTotal();
    }

    public void calculerMontantTotal() {
        this.montantTotal = this.lignesVente.stream()
                .map(LigneVente::getMontantLigne)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public int getNombreArticles() {
        return this.lignesVente.stream()
                .mapToInt(LigneVente::getQuantite)
                .sum();
    }

    public boolean peutEtreAnnulee() {
        return this.statut == StatutVente.COMPLETEE;
    }

    public void annuler() {
        if (peutEtreAnnulee()) {
            this.statut = StatutVente.ANNULEE;
            // Restaurer le stock
            this.lignesVente.forEach(ligne -> 
                ligne.getMedicament().incrementerStock(ligne.getQuantite()));
        }
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Utilisateur getVendeur() {
        return vendeur;
    }

    public void setVendeur(Utilisateur vendeur) {
        this.vendeur = vendeur;
    }

    public BigDecimal getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(BigDecimal montantTotal) {
        this.montantTotal = montantTotal;
    }

    public LocalDateTime getDateVente() {
        return dateVente;
    }

    public void setDateVente(LocalDateTime dateVente) {
        this.dateVente = dateVente;
    }

    public StatutVente getStatut() {
        return statut;
    }

    public void setStatut(StatutVente statut) {
        this.statut = statut;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    public List<LigneVente> getLignesVente() {
        return lignesVente;
    }

    public void setLignesVente(List<LigneVente> lignesVente) {
        this.lignesVente = lignesVente;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public LocalDateTime getDateModification() {
        return dateModification;
    }

    public void setDateModification(LocalDateTime dateModification) {
        this.dateModification = dateModification;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Vente vente = (Vente) o;
        return Objects.equals(id, vente.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "Vente{" +
                "id=" + id +
                ", montantTotal=" + montantTotal +
                ", dateVente=" + dateVente +
                ", statut=" + statut +
                '}';
    }
} 