-- Afficher les numeros et libelles des art dont le stock est < 10

SELECT id_article, libelle
FROM articles art -- Cette fois on prend soin de mettre des alias. Bonne pratique pour la suite.
WHERE stock < 10

-- Liste des articles dont le prix d'inventaire est compris entre 100 et 300

SELECT id_article, libelle, stock 
FROM articles art
WHERE prix_invent <= 300
AND prix_invent >= 100

-- Liste des fournisseurs dont on ne connaît pas l'adresse

SELECT id_fournisseur, nom_four
FROM fournisseurs four
WHERE adresse_four IS NULL

-- Liste des fournisseurs dont le nom commence par "STE"

SELECT id_fournisseur, nom_four, ville_four, adresse_four
FROM fournisseurs four
WHERE LOCATE('STE', nom_four) > 0

-- Noms et adresse des fournisseurs qui proposent des articles pour lesquels le délai d'approvisionnement est supérieur à 20 jours

SELECT nom_four, ville_four, adresse_four
FROM acheter a, fournisseurs f
WHERE a.delai > 20
AND a.id_fournisseur = f.id_fournisseur
GROUP BY nom_four, ville_four, adresse_four -- Group By doit être égal au contenu du SELECT sinon il y aura une erreur. (sauf si fct en +)

-- Nombres d'articles référencés

SELECT COUNT(id_article)
FROM articles art
WHERE libelle IS NOT NULL -- On s'assure que tout soit bien rempli
AND stock IS NOT NULL
AND prix_invent IS NOT NULL

-- Valeur du stock

SELECT SUM(prix_invent) AS valeur_totale 
FROM articles art

-- OU si le prix invent ne correspond pas au total en  fct du stock :

SELECT SUM(prix_invent*stock) AS valeur_totale
FROM articles art

-- Numero et libelle des articles triés dans l'ordre decroissant des stocks

SELECT id_article, libelle
FROM articles
ORDER BY stock DESC

-- Liste pour chaque article (numero et libellé) du prix d'achat max, min et moy



-- Délai moyen pour chaque fournisseur proposant au moins 2 articles

CREATE OR REPLACE VIEW articles_par_fournisseur AS 

SELECT COUNT(id_article) AS nb_art, id_fournisseur
FROM acheter a
GROUP BY id_fournisseur


SELECT AVG(delai) AS delai_moyen, nom_four
FROM acheter a, fournisseurs f, articles_par_fournisseur ar
WHERE ar.nb_art = 2
AND a.id_fournisseur = ar.id_fournisseur
GROUP BY nom_four

-- Ne fonctionne pas correctement.
