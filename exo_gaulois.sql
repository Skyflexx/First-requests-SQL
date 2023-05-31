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

-- Nom des potions dont un des ingrédients est le poisson frais

SELECT 
	p.nom_potion
FROM
	potion p
	INNER JOIN composer c
		ON c.id_potion = p.id_potion
	INNER JOIN ingredient i
		ON c.id_ingredient = i.id_ingredient
WHERE i.nom_ingredient = "Poisson frais"



-- Nom du/des lieux possédant le + d'habitants, en dehors du village gaulois

SELECT l.nom_lieu, COUNT(id_personnage) AS nombre_hts

FROM
	lieu l
	INNER JOIN personnage p
		ON p.id_lieu = l.id_lieu
GROUP BY 
	l.nom_lieu	
HAVING
	nombre_hts >= ALL
		(
			SELECT 
				COUNT(id_personnage)
			FROM
				lieu li
				INNER JOIN personnage pe
					ON pe.id_lieu = li.id_lieu										
			WHERE 
				li.nom_lieu != "Village gaulois"			
			GROUP BY 
				li.nom_lieu				
		)		
AND 
	l.nom_lieu != "Village gaulois"
ORDER BY
	l.nom_lieu ASC
		

-- Nom des personnages qui n'ont jamais bu aucune potion

SELECT 
	p.nom_personnage
FROM 
	personnage p
	LEFT JOIN boire b
		ON p.id_personnage = b.id_personnage
WHERE 
b.id_personnage IS NULL

-- Nom du/des personnages qui n'ont pas le droit de boire de la popo magique

SELECT
 p.nom_personnage, po.nom_potion
FROM
 personnage p
LEFT JOIN autoriser_boire ab
	ON p.id_personnage = ab.id_personnage
INNER JOIN potion po
	ON ab.id_potion = po.id_potion
WHERE 
	po.nom_potion != "Magique"
OR 
	ab.id_personnage IS NULL

----------------------------------------
-- REQUETES MODIF DE LA BDD
----------------------------------------

-- Ajouter le personnage Champdeblix, Agriculteur résidant à la ferme Hantassion de Rotomagus

INSERT INTO 
	personnage (nom_personnage, adresse_personnage, id_specialite, id_lieu)
VALUE 
	('Champdeblix', 'Ferme Hantassion', 
	(SELECT id_specialite FROM specialite WHERE nom_specialite = 'Agriculteur'), 
	(SELECT id_lieu FROM lieu WHERE nom_lieu = 'Rotomagus')) 

-- Dans personnage on a que les id. Donc il suffit de faire un select de l'ID correspondant à notre entrée (comme le métier vu qu'il est déjà enregistré dans une table)


-- Autoriser Bonemine à boire de la popo magique

INSERT INTO 
	autoriser_boire (id_personnage, id_potion)
VALUE 
	((SELECT id_personnage FROM personnage  WHERE nom_personnage = 'Bonemine'),
	(SELECT id_potion FROM potion po WHERE po.nom_potion = 'Magique'))




--- Delete les casques grecs qui n'ont pas été pris lors d'une bataille


DELETE FROM 
	casque ca
WHERE 
	ca.id_casque IN -- Si la subquery retourne + qu'une row, on doit utiliser IN ou not IN selon le cas
		( 
			SELECT
				c.id_casque
			FROM
				(SELECT * FROM casque) AS c -- SQL ne permet pas de target la table casque directement
				INNER JOIN type_casque tc
					ON c.id_type_casque = tc.id_type_casque
				LEFT JOIN prendre_casque pc
					ON c.id_casque = pc.id_casque
				
			WHERE
				pc.id_casque IS NULL
			AND tc.nom_type_casque = "Grec"
		);

-- AUTRE SOLUTION (Avec un autre style d'indentation)

DELETE FROM casque
WHERE id_type_casque = (
		SELECT id_type_casque
		FROM type_casque
		WHERE nom_type_casque = 'Grec'
)
AND id_casque NOT IN (
		SELECT pc.id_casque
		FROM prendre_casque pc
)

-- Modifier l'adresse de Zerozerosix

UPDATE personnage p
SET p.adresse_personnage = 'Prison'
WHERE p.nom_personnage = 'Zérozérosix';

UPDATE personnage p
SET p.id_lieu = ( SELECT l.id_lieu FROM lieu l WHERE l.nom_lieu = 'Condate')
WHERE p.nom_personnage = 'Zérozérosix';
