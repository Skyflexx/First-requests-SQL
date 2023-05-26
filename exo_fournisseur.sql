-- Après création de la BDD vide, ajouter via des requêtes :

-- Ajouter un new fournisseur avec les attributs de votre choix

INSERT INTO fournisseur (id_fournisseur, nom_four, statut, ville_four)
VALUE
('1', 'Abedis', 'pas compris le statut', 'Colmar') -- notez ici que je n'ai absolument aucune idée de ce qu'est le statut. haha. (booléen ? type d'entreprise ?)

-- Supprimer tous les produits de couleur noire et de numéros compris entre 100 et 1999

DELETE FROM produit p
WHERE p.id_produit >= 100 AND p.id_produit <= 1999
AND p.couleur = 'noir'

-- Changer la ville du fournisseur 3 par Mulhouse

UPDATE fournisseur f
SET f.ville_four = 'Mulhouse'
WHERE f.id_fournisseur = 3

