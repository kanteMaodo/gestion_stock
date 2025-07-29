-- Script pour vider la base de données et la remettre à zéro
-- ATTENTION: Ce script supprime toutes les données existantes !

-- Désactiver les contraintes de clés étrangères temporairement
SET session_replication_role = replica;

-- Vider les tables dans l'ordre (en respectant les contraintes de clés étrangères)
DELETE FROM lignes_vente;
DELETE FROM ventes;
DELETE FROM medicaments;
DELETE FROM utilisateurs;

-- Réactiver les contraintes de clés étrangères
SET session_replication_role = DEFAULT;

-- Réinitialiser les séquences d'auto-incrémentation
ALTER SEQUENCE IF EXISTS lignes_vente_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS ventes_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS medicaments_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS utilisateurs_id_seq RESTART WITH 1;

-- Vérifier que les tables sont vides
SELECT 'lignes_vente' as table_name, COUNT(*) as count FROM lignes_vente
UNION ALL
SELECT 'ventes' as table_name, COUNT(*) as count FROM ventes
UNION ALL
SELECT 'medicaments' as table_name, COUNT(*) as count FROM medicaments
UNION ALL
SELECT 'utilisateurs' as table_name, COUNT(*) as count FROM utilisateurs;

-- Message de confirmation
SELECT 'Base de données vidée avec succès !' as message; 