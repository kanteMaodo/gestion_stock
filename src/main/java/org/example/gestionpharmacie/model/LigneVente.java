package org.example.gestionpharmacie.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;

/**
 * Entité JPA représentant une ligne de vente dans le système de gestion de pharmacie
 */
@Entity
@Table(name = "lignes_vente")
public class LigneVente implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vente_id", nullable = false)
    private Vente vente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medicament_id", nullable = false)
    private Medicament medicament;

    @Column(name = "quantite", nullable = false)
    private Integer quantite;

    @Column(name = "prix_unitaire", nullable = false, precision = 10, scale = 2)
    private BigDecimal prixUnitaire;

    @Column(name = "montant_ligne", nullable = false, precision = 10, scale = 2)
    private BigDecimal montantLigne;

    // Constructeurs
    public LigneVente() {
    }

    public LigneVente(Vente vente, Medicament medicament, Integer quantite) {
        this.vente = vente;
        this.medicament = medicament;
        this.quantite = quantite;
        this.prixUnitaire = medicament.getPrix();
        this.calculerMontantLigne();
    }

    // Méthodes utilitaires
    public void calculerMontantLigne() {
        if (this.prixUnitaire != null && this.quantite != null) {
            this.montantLigne = this.prixUnitaire.multiply(BigDecimal.valueOf(this.quantite));
        }
    }

    public void validerStock() {
        if (this.medicament != null && this.quantite != null) {
            this.medicament.decrementerStock(this.quantite);
        }
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Vente getVente() {
        return vente;
    }

    public void setVente(Vente vente) {
        this.vente = vente;
    }

    public Medicament getMedicament() {
        return medicament;
    }

    public void setMedicament(Medicament medicament) {
        this.medicament = medicament;
        if (medicament != null) {
            this.prixUnitaire = medicament.getPrix();
            this.calculerMontantLigne();
        }
    }

    public Integer getQuantite() {
        return quantite;
    }

    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
        this.calculerMontantLigne();
    }

    public BigDecimal getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(BigDecimal prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
        this.calculerMontantLigne();
    }

    public BigDecimal getMontantLigne() {
        return montantLigne;
    }

    public void setMontantLigne(BigDecimal montantLigne) {
        this.montantLigne = montantLigne;
    }

    // equals et hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        LigneVente that = (LigneVente) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    // toString
    @Override
    public String toString() {
        return "LigneVente{" +
                "id=" + id +
                ", medicament=" + (medicament != null ? medicament.getNom() : "null") +
                ", quantite=" + quantite +
                ", prixUnitaire=" + prixUnitaire +
                ", montantLigne=" + montantLigne +
                '}';
    }
} 