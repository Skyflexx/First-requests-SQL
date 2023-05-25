-- Nombre total d'étudiants : 

SELECT COUNT(*)
FROM etudiant

-- Note la plus haute et la plus basse :

SELECT MAX(note) FROM evaluer

SELECT MIN(note) FROM evaluer

-- Moyennes de chaque étudiant Dans chaque matière

CREATE OR REPLACE VIEW moyenne_notes AS       -- Create or replace c'est pour rafraichir la vue en cas de modif de la requête.
SELECT etudiant.nom, AVG(evaluer.note), matiere.libelle_mat -- on demande l'affichage du nom de l'étudiant, la moyenne de notes et le nom de la matière 
FROM evaluer, etudiant, matiere   -- depuis nos trois tables.
WHERE evaluer.id_etudiant = etudiant.id_etudiant  -- où l'id etudiant de la table evaluer correspond à l'id étudiant de la table étudiant.
AND evaluer.id_matiere = matiere.id_matiere  -- et où l'id matière de la table evaluer correspond à l'id matière de la table matière.
GROUP BY etudiant.id_etudiant, matiere.id_matiere -- et on fait cette opération pour chaque étudiant, pour chaque matière. On regroupe tous les étudiants du même ID et toutes les matières du même ID. Ce qui permet de sortir une moyenne

-- Moyenne par matière

CREATE OR REPLACE VIEW moyenne_matiere AS 
SELECT matiere.libelle_mat, AVG(evaluer.note) -- On veut afficher le libelle de la matière ainsi qu'une moyenne de notes
FROM matiere, evaluer -- depuis les tables matiere et evaluer
WHERE matiere.id_matiere = evaluer.id_matiere -- on fait le lien entre les id matiere des 2 tables
GROUP BY matiere.libelle_mat -- Et on regroupe par matière ce qui permettra de faire une moyenne par matière.

-- Moyenne générale de chaque étudiant

CREATE OR REPLACE VIEW moyenne_etudiant AS -- Création d'une view moyenne_etudiant
SELECT etudiant.nom, AVG(evaluer.note) -- On demande le nom ainsi qu'une moyenne de notes
FROM etudiant, evaluer -- à partir des bases étudiant et évaluer
WHERE etudiant.id_etudiant = evaluer.id_etudiant -- en faisant le lien entre la table etudiant et evaluer
GROUP BY etudiant.nom -- et on fait cette opération pour chaque étudiant. C'est ce qui permet d'afficher la moyenne pour 1 étudiant donné.

-- Moyenne de la promo

CREATE OR REPLACE VIEW moyenne_promo AS
SELECT AVG(evaluer.note)
FROM evaluer

