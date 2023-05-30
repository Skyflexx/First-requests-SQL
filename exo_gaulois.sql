-- Nom des lieux qui finissent par 'um'

SELECT nom_lieu
FROM lieu l
WHERE l.nom_lieu LIKE '%um'

-- Nombre de personnages par lieu trié par nombre de perso decroissants

CREATE OR REPLACE VIEW nbr_pers_lieu AS

SELECT COUNT(id_personnage) AS nbr_personnages, nom_lieu
FROM personnage pers, lieu l
WHERE pers.id_lieu = l.id_lieu
GROUP BY pers.id_lieu;

SELECT *
FROM nbr_pers_lieu 
ORDER BY nbr_personnages DESC;