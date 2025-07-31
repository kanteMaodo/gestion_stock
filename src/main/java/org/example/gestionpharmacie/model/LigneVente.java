package org.example.gestionpharmacie.model;

import jakarta.persistence.*;

@Entity
@Table(name = "lignes_vente")
public class LigneVente {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vente_id", nullable = false)
    private Vente vente;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medicament_id", nullable = false)
    private Medicament medicament;
    
    @Column(name = "quantite", nullable = false)
    private Integer quantite;
    
    @Column(name = "prix_unitaire", nullable = false)
    private Double prixUnitaire;
    
    @Column(name = "montant_ligne", nullable = false)
    private Double montantLigne;
    
    // Constructeurs
    public LigneVente() {}
    
    public LigneVente(Medicament medicament, Integer quantite) {
        this.medicament = medicament;
        this.quantite = quantite;
        this.prixUnitaire = medicament.getPrix().doubleValue();
        this.montantLigne = this.prixUnitaire * this.quantite;
    }
    
    // Méthodes métier
    public Double getMontantLigne() {
        return montantLigne;
    }
    
    public void calculerMontantLigne() {
        if (prixUnitaire != null && quantite != null) {
            this.montantLigne = prixUnitaire * quantite;
        }
    }
    
    public boolean validerStock() {
        return medicament != null && medicament.getStock() >= quantite;
    }
    
    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Vente getVente() { return vente; }
    public void setVente(Vente vente) { this.vente = vente; }
    
    public Medicament getMedicament() { return medicament; }
    public void setMedicament(Medicament medicament) { this.medicament = medicament; }
    
    public Integer getQuantite() { return quantite; }
    public void setQuantite(Integer quantite) { 
        this.quantite = quantite; 
        calculerMontantLigne();
    }
    
    public Double getPrixUnitaire() { return prixUnitaire; }
    public void setPrixUnitaire(Double prixUnitaire) { 
        this.prixUnitaire = prixUnitaire; 
        calculerMontantLigne();
    }
    
    public void setMontantLigne(Double montantLigne) { this.montantLigne = montantLigne; }
} 