package org.example.gestionpharmacie.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Entité JPA représentant un médicament dans le système de gestion de pharmacie
 */
@Entity
@Table(name = "medicaments")
public class Medicament implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "nom", nullable = false, length = 200)
    private String nom;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "prix", nullable = false, precision = 10, scale = 2)
    private BigDecimal prix;

    @Column(name = "stock", nullable = false)
    private Integer stock = 0;

    @Column(name = "seuil_alerte", nullable = false)
    private Integer seuilAlerte = 10;

    @Column(name = "date_expiration")
    private LocalDate dateExpiration;

    @Column(name = "code_barre", unique = true, length = 50)
    private String codeBarre;

    @Column(name = "categorie", length = 100)
    private String categorie;

    @Column(name = "fabricant", length = 150)
    private String fabricant;

    @Column(name = "actif", nullable = false)
    private boolean actif = true;

    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation;

    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    // Constructeurs
    public Medicament() {
        this.dateCreation = LocalDateTime.now();
        this.actif = true;
    }

    public Medicament(String nom, String description, BigDecimal prix, Integer stock, 
                     Integer seuilAlerte, LocalDate dateExpiration, String codeBarre, 
                     String categorie, String fabricant) {
        this();
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.stock = stock;
        this.seuilAlerte = seuilAlerte;
        this.dateExpiration = dateExpiration;
        this.codeBarre = codeBarre;
        this.categorie = categorie;
        this.fabricant = fabricant;
    }

    // Méthodes callback JPA
    @PrePersist
    protected void onCreate() {
        this.dateCreation = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.dateModification = LocalDateTime.now();
    }

    // Méthodes utilitaires
    public boolean isStockFaible() {
        return this.stock <= this.seuilAlerte;
    }

    public boolean isExpire() {
        return this.dateExpiration != null && this.dateExpiration.isBefore(LocalDate.now());
    }

    public boolean isExpireBientot() {
        return this.dateExpiration != null && 
               this.dateExpiration.isBefore(LocalDate.now().plusDays(30));
    }

    public boolean isDisponible() {
        return this.actif && this.stock > 0 && !this.isExpire();
    }

    public void decrementerStock(int quantite) {
        if (this.stock >= quantite) {
            this.stock -= quantite;
        } else {
            throw new IllegalStateException("Stock insuffisant");
        }
    }

    public void incrementerStock(int quantite) {
        this.stock += quantite;
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

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
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

    // equals et hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Medicament that = (Medicament) o;
        return Objects.equals(id, that.id) &&
                Objects.equals(codeBarre, that.codeBarre);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, codeBarre);
    }

    // toString
    @Override
    public String toString() {
        return "Medicament{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prix=" + prix +
                ", stock=" + stock +
                ", codeBarre='" + codeBarre + '\'' +
                ", actif=" + actif +
                '}';
    }
} 