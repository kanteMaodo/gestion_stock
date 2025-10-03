# 🏥 Système de Gestion de Pharmacie - PHARMACIE MOUHAMED

## 📋 Description

**Gestion Pharmacie** est une application web complète développée en Java EE pour la gestion intelligente des opérations d'une pharmacie. Ce système offre une solution intégrée pour la gestion des médicaments, des stocks, des ventes et des utilisateurs avec un système d'alertes automatisées.

## ✨ Fonctionnalités Principales

### 🔐 Gestion des Utilisateurs
- **Authentification sécurisée** avec système de rôles (Admin, Pharmacien, Assistant)
- **Gestion des comptes utilisateurs** avec hashage BCrypt des mots de passe
- **Contrôle d'accès** basé sur les rôles avec filtres de sécurité

### 💊 Gestion des Médicaments
- **Catalogue complet** avec nom, description, prix, fabricant
- **Gestion des stocks** avec seuils d'alerte personnalisables
- **Suivi des dates d'expiration** avec notifications automatiques
- **Classification par catégories** et codes-barres
- **Statut actif/inactif** pour contrôler la disponibilité

### 📊 Gestion des Ventes
- **Enregistrement des ventes** avec lignes de détail
- **Calcul automatique** des totaux et sous-totaux
- **Historique complet** des transactions
- **Mise à jour automatique** des stocks après vente

### 🚨 Système d'Alertes
- **Alertes de stock faible** automatiques
- **Notifications d'expiration** des médicaments
- **Dashboard centralisé** pour le suivi des alertes

### 📱 Interface Utilisateur
- **Design responsive** avec Bootstrap 5
- **Interface intuitive** et moderne
- **Dashboards spécialisés** par rôle d'utilisateur
- **Navigation fluide** entre les modules

## 🛠️ Technologies Utilisées

### Backend
- **Java 21** - Langage de programmation principal
- **Jakarta EE** - Framework d'entreprise
- **Hibernate 6.4.1** - ORM (Object-Relational Mapping)
- **JPA 3.1** - API de persistance Java
- **PostgreSQL** - Base de données relationnelle
- **BCrypt** - Hashage sécurisé des mots de passe
- **Maven** - Gestionnaire de dépendances

### Frontend
- **JSP (Jakarta Server Pages)** - Technologies de vue
- **JSTL** - Bibliothèque de tags standard
- **Bootstrap 5** - Framework CSS responsive
- **Font Awesome** - Iconographie
- **JavaScript** - Interactions côté client

### Infrastructure
- **Apache Tomcat** - Serveur d'applications
- **JDBC** - Connectivité base de données
- **JUnit 5** - Tests unitaires

## 📁 Structure du Projet

```
gestion-pharmacie/
├── 📁 src/main/java/org/example/gestionpharmacie/
│   ├── 📁 dao/                 # Couche d'accès aux données
│   │   ├── GenericDAO.java
│   │   ├── GenericDAOImpl.java
│   │   ├── MedicamentDAO.java
│   │   ├── MedicamentDAOImpl.java
│   │   ├── UtilisateurDAO.java
│   │   ├── UtilisateurDAOImpl.java
│   │   ├── VenteDAO.java
│   │   └── VenteDAOImpl.java
│   ├── 📁 model/               # Entités métier
│   │   ├── Medicament.java
│   │   ├── Utilisateur.java
│   │   ├── Vente.java
│   │   └── LigneVente.java
│   ├── 📁 servlets/            # Contrôleurs web
│   │   ├── AuthServlet.java
│   │   ├── MedicamentServlet.java
│   │   ├── VenteServlet.java
│   │   ├── AdminDashboardServlet.java
│   │   ├── PharmacienDashboardServlet.java
│   │   └── AlertesServlet.java
│   └── 📁 filters/             # Filtres de sécurité
│       └── RoleFilter.java
├── 📁 src/main/webapp/
│   ├── 📁 views/               # Pages JSP
│   │   ├── 📁 admin/
│   │   ├── 📁 pharmacien/
│   │   ├── 📁 medicaments/
│   │   ├── 📁 ventes/
│   │   └── auth.jsp
│   ├── 📁 WEB-INF/
│   │   └── web.xml
│   └── index.jsp
├── 📁 src/main/resources/
│   └── 📁 META-INF/
│       └── persistence.xml
├── pom.xml
└── README.md
```

## 🔧 Installation et Configuration

### Prérequis
- **Java 21** ou version supérieure
- **Maven 3.6+**
- **PostgreSQL 12+**
- **Apache Tomcat 10+**

### Configuration de la Base de Données

1. **Créer la base de données PostgreSQL :**
   ```sql
   CREATE DATABASE pharmacie_db;
   CREATE USER pharma_user WITH ENCRYPTED PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE pharmacie_db TO pharma_user;
   ```

2. **Configurer la connexion :**
   
   Modifier le fichier `src/main/resources/META-INF/persistence.xml` :
   ```xml
   <property name="javax.persistence.jdbc.url" value="jdbc:postgresql://localhost:5432/pharmacie_db"/>
   <property name="javax.persistence.jdbc.user" value="pharma_user"/>
   <property name="javax.persistence.jdbc.password" value="your_password"/>
   ```

### Installation

1. **Cloner le projet :**
   ```bash
   git clone [url-du-repository]
   cd gestion-pharmacie
   ```

2. **Compiler le projet :**
   ```bash
   mvn clean compile
   ```

3. **Générer le fichier WAR :**
   ```bash
   mvn clean package
   ```

4. **Déployer sur Tomcat :**
   - Copier `target/gestion-pharmacie.war` vers le dossier `webapps` de Tomcat
   - Démarrer Tomcat

## 🚀 Utilisation

### Première Connexion

1. **Accéder à la page d'authentification**
2. **Créer un compte Administrateur** via le formulaire d'inscription
3. **Se connecter** avec les identifiants créés

### Fonctionnalités par Rôle

#### 👑 Administrateur
- Gestion complète des utilisateurs
- Configuration du système
- Accès à toutes les fonctionnalités
- Rapports et statistiques avancées

#### 👨‍⚕️ Pharmacien
- Gestion des médicaments
- Traitement des ventes
- Consultation des stocks
- Visualisation des alertes

#### 👤 Assistant
- Enregistrement des ventes
- Consultation du catalogue
- Vérification des stocks

## 📈 Fonctionnalités Avancées

### Système d'Alertes
- **Alertes de stock faible :** Notification automatique quand un médicament atteint son seuil d'alerte
- **Alertes d'expiration :** Suivi des médicaments proches de leur date d'expiration
- **Dashboard centralisé :** Vue d'ensemble de toutes les alertes actives

### Gestion Intelligente des Stocks
- **Mise à jour automatique** lors des ventes
- **Seuils personnalisables** par médicament
- **Historique des mouvements** de stock

### Sécurité
- **Authentification robuste** avec BCrypt
- **Contrôle d'accès** par rôles
- **Sessions sécurisées**
- **Validation des données** côté serveur

## 🧪 Tests

```bash
# Exécuter les tests unitaires
mvn test

# Générer le rapport de couverture
mvn jacoco:report
```

## 📝 API et Endpoints

### Authentification
- `POST /auth?action=login` - Connexion utilisateur
- `POST /auth?action=register` - Inscription utilisateur
- `GET /logout` - Déconnexion

### Médicaments
- `GET /medicaments` - Liste des médicaments
- `POST /medicaments?action=ajouter` - Ajouter un médicament
- `POST /medicaments?action=modifier` - Modifier un médicament
- `POST /medicaments?action=supprimer` - Supprimer un médicament

### Ventes
- `GET /ventes` - Liste des ventes
- `POST /ventes?action=nouvelle` - Nouvelle vente
- `GET /ventes?action=details` - Détails d'une vente

## 🤝 Contribution

1. **Fork** le projet
2. **Créer** une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. **Committer** vos changements (`git commit -am 'Ajout nouvelle fonctionnalité'`)
4. **Pousser** vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. **Créer** une Pull Request

## 👥 Équipe de Développement

- **Développeur Principal :** Maodo KANTE
- **Contact :** [kantechagency@gmail.com]

## 🐛 Signaler un Bug

Pour signaler un bug ou demander une nouvelle fonctionnalité, veuillez créer une [issue](lien-vers-issues) sur le repository.

---

**⚡ Gestion Pharmacie** - *Optimisez vos opérations pharmaceutiques avec intelligence*