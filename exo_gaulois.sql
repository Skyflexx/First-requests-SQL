-- Nom des lieux qui finissent par 'um'

SELECT 
    nom_lieu
FROM 
    lieu l
WHERE 
    l.nom_lieu LIKE '%um';

-- Nombre de personnages par lieu trié par nombre de perso decroissants

CREATE OR REPLACE VIEW nbr_pers_lieu AS

SELECT 
    COUNT(id_personnage) AS nbr_personnages, nom_lieu
FROM 
    personnage pers, lieu l
WHERE 
    pers.id_lieu = l.id_lieu
GROUP BY 
    pers.id_lieu;

SELECT 
    *
FROM 
    nbr_pers_lieu 
ORDER BY 
    nbr_personnages DESC;

-- Nom, spécialité, adresse, lieu triés par lieu et par nom de perso

CREATE OR REPLACE VIEW profil_personnage AS

SELECT 
    nom_personnage, nom_specialite, adresse_personnage, nom_lieu
FROM 
    personnage p, specialite s, lieu l
WHERE 
    p.id_specialite = s.id_specialite
AND 
    p.id_lieu = l.id_lieu;

SELECT 
    *
FROM 
    profil_personnage
ORDER BY 
    nom_lieu ;

SELECT 
    *
FROM 
    profil_personnage
ORDER BY 
    nom_personnage;

-- Nom, date, lieu des batailles classées de la + récente à la + ancienne. Format date jj/mm/aa

SELECT 
    nom_bataille, 
    DATE_FORMAT(date_bataille, "%d/%m/%y") AS date_bat, nom_lieu
FROM 
    bataille b, lieu l
WHERE 
    b.id_lieu = l.id_lieu
ORDER BY 
    date_bataille DESC;

-- note : pour la date, on peut rajouter ce qu'on veut car on affiche une string. le code reconnu est %d %m etc. voir Date_format() SQL.


-- Nom + cout realisation potion dans l'ordre décroissant

CREATE OR REPLACE VIEW prix_potion AS

SELECT 
    nom_potion, SUM(c.qte * i.cout_ingredient) AS cout_realisation
FROM 
    potion p, composer c, ingredient i
WHERE 
    p.id_potion = c.id_potion
AND 
    c.id_ingredient = i.id_ingredient
GROUP BY 
    c.id_potion;

SELECT 
    *
FROM 
    prix_potion pr
ORDER BY 
    pr.cout_realisation DESC;


-- nom des ingrédients + cout + qte de chaque ingrédient composant la potion "santé"

SELECT 
    i.nom_ingredient, i.cout_ingredient, c.qte
FROM 
    ingredient i, composer c, potion p
WHERE 
    c.id_potion = p.id_potion
AND 
    i.id_ingredient = c.id_ingredient
AND 
    p.nom_potion = "Santé";


-- Nom du/des personnages qui ont pris le + de casques durant la bataille "Bataille du village"

SELECT
	nom_personnage,
	SUM(pc.qte) AS qtt_casques
FROM
	personnage p,
	prendre_casque pc,
	bataille b
WHERE
	p.id_personnage = pc.id_personnage
	AND pc.id_bataille = b.id_bataille
	AND b.nom_bataille = "Bataille du village gaulois"
GROUP BY
	p.nom_personnage
HAVING
	qtt_casques >= ALL
	(
		SELECT
			SUM(pca.qte) AS qtt_casques_max
		FROM
			prendre_casque pca,
			bataille ba
		WHERE
			ba.id_bataille = pca.id_bataille
			AND ba.nom_bataille = "Bataille du village gaulois"
		GROUP BY
			id_personnage
	)
ORDER BY
	qtt_casques DESC
;

-- Correction de la question AJOUT DE INNER JOIN, INDENTATION et >= ALL

SELECT
	p.nom_personnage,
	SUM(pc.qte) AS qtt_casques
FROM
	personnage p
	INNER JOIN prendre_casque pc
		ON p.id_personnage = pc.id_personnage
	INNER JOIN bataille b
		ON pc.id_bataille = b.id_bataille
WHERE
	b.nom_bataille = "Bataille du village gaulois"
GROUP BY
	p.nom_personnage
HAVING
	qtt_casques >= ALL
	(
		SELECT
			SUM(pca.qte) AS qtt_casques_max
		FROM
			prendre_casque pca
			INNER JOIN bataille ba
				ON ba.id_bataille = pca.id_bataille
		WHERE
			ba.nom_bataille = "Bataille du village gaulois"
		GROUP BY
			id_personnage
	)
ORDER BY
	p.nom_personnage ASC
;

-- Nom des personnages et la quantité de potions bues (classement du + grand buveut au + petit)

SELECT 
    p.nom_personnage, SUM(b.dose_boire) AS potions_bues
FROM 
    personnage p, boire b
WHERE 
    p.id_personnage = b.id_personnage
GROUP BY 
    p.nom_personnage
ORDER BY 
    potions_bues DESC

-- Nom de la bataille où le nbr de casques pris a été le plus important.

SELECT 
	nom_bataille, SUM(pc.qte) qtt_casques
FROM 
	bataille b 
	INNER JOIN prendre_casque pc
		ON b.id_bataille = pc.id_bataille
GROUP BY nom_bataille
HAVING 
	qtt_casques >= ALL -- Indique qu'on veut la quantité casque qui est supérieur ou = à toutes les valeurs du tableau qui suit. Technique pour avoir le max.
	(
	 	SELECT 
			SUM(pca.qte)
	 	
	 	FROM
	 		bataille ba
	 		INNER JOIN prendre_casque pca
	 		ON ba.id_bataille = pca.id_bataille 		
	 		 		
	 	GROUP BY ba.id_bataille	 	
	);
	
-- Combien existe-t-il de casques de chaque type et quel est le cout total classe par ordre decroiss

SELECT 
    tc.nom_type_casque, COUNT(c.id_casque) AS nb_casques, SUM(cout_casque) AS prix_total
FROM 
    casque c, type_casque tc
WHERE 
    c.id_type_casque = tc.id_type_casque
GROUP BY 
    tc.nom_type_casque
ORDER BY 
    prix_total DESC

