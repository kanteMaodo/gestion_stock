package org.example.gestionpharmacie.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "ventes")
public class Vente {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vendeur_id", nullable = false)
    private Utilisateur vendeur;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private StatutVente statut = StatutVente.EN_COURS;
    
    @Column(name = "montant_total")
    private Double montantTotal = 0.0;
    
    @Column(name = "date_vente", nullable = false)
    private LocalDateTime dateVente = LocalDateTime.now();
    
    @Column(name = "commentaire", columnDefinition = "TEXT")
    private String commentaire;
    
    @OneToMany(mappedBy = "vente", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    private List<LigneVente> lignesVente = new ArrayList<>();
    
    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation = LocalDateTime.now();
    
    public Vente() {}
    
    public Vente(Utilisateur vendeur) {
        this.vendeur = vendeur;
        this.dateVente = LocalDateTime.now();
        this.dateCreation = LocalDateTime.now();
    }
    
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
    
    public void ajouterLigne(LigneVente ligne) {
        lignesVente.add(ligne);
        ligne.setVente(this);
        calculerMontantTotal();
    }
    
    public void supprimerLigne(int index) {
        if (index >= 0 && index < lignesVente.size()) {
            LigneVente ligne = lignesVente.remove(index);
            ligne.setVente(null);
            calculerMontantTotal();
        }
    }
    
    public void calculerMontantTotal() {
        this.montantTotal = lignesVente.stream()
                .mapToDouble(LigneVente::getMontantLigne)
                .sum();
    }
    
    public int getNombreArticles() {
        return lignesVente.stream()
                .mapToInt(LigneVente::getQuantite)
                .sum();
    }
    
    public boolean peutEtreAnnulee() {
        return statut == StatutVente.EN_COURS;
    }
    
    public void annuler() {
        if (peutEtreAnnulee()) {
            // Restaurer les stocks
            for (LigneVente ligne : lignesVente) {
                ligne.getMedicament().incrementerStock(ligne.getQuantite());
            }
            this.statut = StatutVente.ANNULEE;
        }
    }
    
    public void finaliser() {
        if (statut == StatutVente.EN_COURS && !lignesVente.isEmpty()) {
            for (LigneVente ligne : lignesVente) {
                if (!ligne.validerStock()) {
                    throw new IllegalStateException("Stock insuffisant pour " + ligne.getMedicament().getNom());
                }
            }
            
            for (LigneVente ligne : lignesVente) {
                ligne.getMedicament().decrementerStock(ligne.getQuantite());
            }
            
            this.statut = StatutVente.COMPLETEE;
            this.dateVente = LocalDateTime.now();
        }
    }
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Utilisateur getVendeur() { return vendeur; }
    public void setVendeur(Utilisateur vendeur) { this.vendeur = vendeur; }
    
    public StatutVente getStatut() { return statut; }
    public void setStatut(StatutVente statut) { this.statut = statut; }
    
    public Double getMontantTotal() { return montantTotal; }
    public void setMontantTotal(Double montantTotal) { this.montantTotal = montantTotal; }
    
    public LocalDateTime getDateVente() { return dateVente; }
    public void setDateVente(LocalDateTime dateVente) { this.dateVente = dateVente; }
    
    public String getCommentaire() { return commentaire; }
    public void setCommentaire(String commentaire) { this.commentaire = commentaire; }
    
    public List<LigneVente> getLignesVente() { return lignesVente; }
    public void setLignesVente(List<LigneVente> lignesVente) { this.lignesVente = lignesVente; }
    
    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }
} 