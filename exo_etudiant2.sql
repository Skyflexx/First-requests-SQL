-- Liste de tous les étudiants

SELECT *
FROM etudiant

-- Liste de tous les étudiants par odre alphabétique inverse

SELECT *
FROM etudiant
ORDER BY nom DESC;

-- Nom et prénom de chaque étudiant

SELECT nom, prenom
FROM etudiant e

-- Nom et prénom des étudiants résidants sur Lyon

SELECT nom, prenom
FROM etudiant et
WHERE et.ville = "Lyon"

-- Liste des notes supérieures à 10

SELECT note
FROM evaluer ev
WHERE note > 10

-- Liste des épreuves dont la date se situe entre le 1er janvier et le 30 juin 2014

SELECT *
FROM epreuve ep
WHERE date_epreuve BETWEEN '2014-01-01' AND '2014-06-30'

-- Nom, prenom, ville des étudiants dont la ville contiant la chaine 'll'

SELECT nom, prenom, ville
FROM etudiant et
WHERE LOCATE ('ll', ville) > 0

-- Prenom d'étudiants dont le nom est Dupont, Durand ou Martin

SELECT  prenom
FROM etudiant et
WHERE et.nom = 'Dupont' OR et.nom = 'Durand' OR et.nom ='Martin'

-- Somme de tous les coefficients de toutes les matières

SELECT SUM(coef) AS somme_coeff
FROM matiere m

-- Nbr total d'épreuves

SELECT COUNT(id_epreuve) AS nbr_epreuve
FROM epreuve ep

-- nbr de notes indéterminées

SELECT COUNT(*) AS nbr_note_null
FROM evaluer ev
WHERE ev.note IS NULL

-- Liste des épreuves où le libelle de la matiere est inclu

SELECT e.id_epreuve, e.date_epreuve, e.lieu
FROM epreuve e, concerner c, matiere m
WHERE e.id_epreuve = c.id_epreuve AND m.id_matiere = c.id_matiere
AND m.libelle IS NOT NULL

-- Liste des notes en précisant pour chacune le nom et le prénom de l'étudiant qui l'a obtenue

SELECT ev.note, et.nom, et.prenom
FROM etudiant et, evaluer ev
WHERE et.id_etudiant = ev.id_etudiant
AND ev.note IS NOT NULL

-- idem qu'au dessus mais en ajoutant cette fois la matière concernée

SELECT ev.note, et.nom, et.prenom, li.libelle
FROM etudiant et, evaluer ev, liste_epreuves li
WHERE et.id_etudiant = ev.id_etudiant
AND ev.id_epreuve = li.id_epreuve
AND ev.note IS NOT NULL

-- Nom, prénom des étudiants qui ont eu au moins un 20

SELECT ev.note, et.nom, et.prenom
FROM etudiant et, evaluer ev
WHERE et.id_etudiant = ev.id_etudiant
AND ev.note = 20

-- Selectionner la moyenne des notes de chaque étudiant

SELECT et.nom, et.prenom, AVG(note) AS moyenne_generale
FROM evaluer ev, etudiant et
WHERE ev.id_etudiant = et.id_etudiant
GROUP BY ev.id_etudiant

-- Idem mais on classe de la meilleure à la moins bonne

SELECT et.nom, et.prenom, AVG(note) AS moyenne_generale
FROM evaluer ev, etudiant et
WHERE ev.id_etudiant = et.id_etudiant
GROUP BY ev.id_etudiant
ORDER BY moyenne_generale DESC

-- Moyenne des notes pour les matières (indiquer libelle) comportant + d'une épreuve

CREATE OR REPLACE VIEW epreuves_par_mat AS
SELECT COUNT(id_epreuve) AS nbr_ep, m.libelle
FROM concerner c, matiere m
WHERE c.id_matiere = m.id_matiere
GROUP BY c.id_matiere


SELECT m.libelle, AVG(note) AS moyenne_matiere
FROM matiere m, epreuve ep, evaluer ev, concerner c, epreuves_par_mat epm
WHERE m.id_matiere = c.id_matiere AND c.id_epreuve = ep.id_epreuve AND ep.id_epreuve = ev.id_epreuve
AND epm.nbr_ep > 1 AND epm.libelle = m.libelle
GROUP BY m.libelle


