package org.example.gestionpharmacie.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "medicaments")
public class Medicament {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "nom", nullable = false, length = 255)
    private String nom;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "prix", nullable = false, precision = 10, scale = 2)
    private BigDecimal prix;
    
    @Column(name = "stock", nullable = false)
    private Integer stock;
    
    @Column(name = "seuil_alerte", nullable = false)
    private Integer seuilAlerte;
    
    @Column(name = "date_expiration")
    private LocalDate dateExpiration;
    
    @Column(name = "code_barre", length = 50)
    private String codeBarre;
    
    @Column(name = "categorie", length = 100)
    private String categorie;
    
    @Column(name = "fabricant", length = 255)
    private String fabricant;
    
    @Column(name = "actif", nullable = false)
    private Boolean actif = true;
    
    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation;
    
    @Column(name = "date_modification")
    private LocalDateTime dateModification;
    
    // Constructeurs
    public Medicament() {
        this.dateCreation = LocalDateTime.now();
        this.actif = true;
    }
    
    public Medicament(String nom, String description, BigDecimal prix, Integer stock, Integer seuilAlerte) {
        this();
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.stock = stock;
        this.seuilAlerte = seuilAlerte;
    }
    
    // Méthodes utilitaires
    public boolean isStockFaible() {
        return stock <= seuilAlerte;
    }
    
    public boolean isExpire() {
        return dateExpiration != null && dateExpiration.isBefore(LocalDate.now());
    }
    
    public boolean isDisponible() {
        return actif && stock > 0 && !isExpire();
    }
    
    public void decrementerStock(int quantite) {
        if (stock >= quantite) {
            this.stock -= quantite;
        } else {
            throw new IllegalStateException("Stock insuffisant");
        }
    }
    
    public void incrementerStock(int quantite) {
        this.stock += quantite;
    }
    
    // Callbacks JPA
    @PrePersist
    protected void onCreate() {
        dateCreation = LocalDateTime.now();
        if (actif == null) {
            actif = true;
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        dateModification = LocalDateTime.now();
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getNom() {
        return nom;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrix() {
        return prix;
    }
    
    public void setPrix(BigDecimal prix) {
        this.prix = prix;
    }
    
    public Integer getStock() {
        return stock;
    }
    
    public void setStock(Integer stock) {
        this.stock = stock;
    }
    
    public Integer getSeuilAlerte() {
        return seuilAlerte;
    }
    
    public void setSeuilAlerte(Integer seuilAlerte) {
        this.seuilAlerte = seuilAlerte;
    }
    
    public LocalDate getDateExpiration() {
        return dateExpiration;
    }
    
    public void setDateExpiration(LocalDate dateExpiration) {
        this.dateExpiration = dateExpiration;
    }
    
    public String getCodeBarre() {
        return codeBarre;
    }
    
    public void setCodeBarre(String codeBarre) {
        this.codeBarre = codeBarre;
    }
    
    public String getCategorie() {
        return categorie;
    }
    
    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }
    
    public String getFabricant() {
        return fabricant;
    }
    
    public void setFabricant(String fabricant) {
        this.fabricant = fabricant;
    }
    
    public Boolean getActif() {
        return actif;
    }
    
    public void setActif(Boolean actif) {
        this.actif = actif;
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
    public String toString() {
        return "Medicament{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prix=" + prix +
                ", stock=" + stock +
                ", actif=" + actif +
                '}';
    }
} 