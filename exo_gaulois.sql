-- Nom des lieux qui finissent par 'um'

SELECT nom_lieu
FROM lieu l
WHERE l.nom_lieu LIKE '%um';

-- Nombre de personnages par lieu trié par nombre de perso decroissants

CREATE OR REPLACE VIEW nbr_pers_lieu AS

SELECT COUNT(id_personnage) AS nbr_personnages, nom_lieu
FROM personnage pers, lieu l
WHERE pers.id_lieu = l.id_lieu
GROUP BY pers.id_lieu;

SELECT *
FROM nbr_pers_lieu 
ORDER BY nbr_personnages DESC;

-- Nom, spécialité, adresse, lieu triés par lieu et par nom de perso

CREATE OR REPLACE VIEW profil_personnage AS

SELECT nom_personnage, nom_specialite, adresse_personnage, nom_lieu
FROM personnage p, specialite s, lieu l
WHERE p.id_specialite = s.id_specialite
AND p.id_lieu = l.id_lieu;

SELECT *
FROM profil_personnage
ORDER BY nom_lieu ;

SELECT *
FROM profil_personnage
ORDER BY nom_personnage;

-- Nom, date, lieu des batailles classées de la + récente à la + ancienne. Format date jj/mm/aa

SELECT nom_bataille, DATE_FORMAT(date_bataille, "%d/%m/%y") AS date_bat, nom_lieu
FROM bataille b, lieu l
WHERE b.id_lieu = l.id_lieu
ORDER BY date_bataille DESC;

-- note : pour la date, on peut rajouter ce qu'on veut car on affiche une string. le code reconnu est %d %m etc. voir Date_format() SQL.


-- Nom + cout realisation potion dans l'ordre décroissant

CREATE OR REPLACE VIEW prix_potion AS

SELECT nom_potion, SUM(c.qte * i.cout_ingredient) AS cout_realisation
FROM potion p, composer c, ingredient i
WHERE p.id_potion = c.id_potion
AND c.id_ingredient = i.id_ingredient
GROUP BY c.id_potion;

SELECT *
FROM prix_potion pr
ORDER BY pr.cout_realisation DESC;


-- nom des ingrédients + cout + qte de chaque ingrédient composant la potion "santé"

SELECT i.nom_ingredient, i.cout_ingredient, c.qte
FROM ingredient i, composer c, potion p
WHERE c.id_potion = p.id_potion
AND i.id_ingredient = c.id_ingredient
AND p.nom_potion = "Santé";


-- Nom du/des personnages qui ont pris le + de casques durant la bataille "Bataille du village"

SELECT nom_personnage, SUM(pc.qte) AS qtt_casques
FROM personnage p, prendre_casque pc, bataille b
WHERE p.id_personnage = pc.id_personnage
AND pc.id_bataille = b.id_bataille
AND b.nom_bataille = "Bataille du village gaulois"
GROUP BY p.nom_personnage
ORDER BY qtt_casques DESC;