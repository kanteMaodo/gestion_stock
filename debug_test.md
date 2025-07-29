# Debug Test - Pharmacie Manager

## 🔍 Test des fonctionnalités

### 1. **Test de l'ajout**
- URL: `/medicaments/ajouter`
- Action: Remplir et soumettre le formulaire
- Résultat attendu: Redirection vers la liste avec le nouveau médicament

### 2. **Test de la modification**
- URL: `/medicaments/modifier?id=1`
- Action: Modifier et sauvegarder
- Résultat attendu: Redirection vers la liste avec les modifications

### 3. **Test du réapprovisionnement**
- URL: `/medicaments/reapprovisionner?id=1`
- Action: Ajouter une quantité
- Résultat attendu: Stock mis à jour

### 4. **Test de la suppression**
- Action: Cliquer sur le bouton poubelle
- Résultat attendu: Confirmation puis suppression

## 🐛 Problèmes possibles

### Si les liens ne marchent pas:
1. Vérifier que les pages JSP existent:
   - `/views/medicaments/modifier.jsp`
   - `/views/medicaments/reapprovisionner.jsp`

2. Vérifier les logs Tomcat pour les erreurs 404

### Si la suppression ne marche pas:
1. Vérifier que le formulaire caché est généré pour chaque médicament
2. Vérifier que l'action "supprimer" est bien gérée dans le servlet

### Si les pages sont vides:
1. Vérifier que les médicaments sont bien chargés depuis la base
2. Vérifier que les attributs sont bien passés aux JSP

## 📝 URLs à tester manuellement:
- `/medicaments/` (liste)
- `/medicaments/ajouter` (ajout)
- `/medicaments/modifier?id=1` (modification)
- `/medicaments/reapprovisionner?id=1` (réapprovisionnement) 