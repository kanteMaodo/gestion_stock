-- Script pour activer tous les médicaments existants
UPDATE medicaments SET actif = true WHERE actif = false;

-- Vérifier le résultat
SELECT id, nom, actif FROM medicaments; 