USE maison_valmont;
 
-- Question 1 : quel est le chiffre d'affaires, le cout, la marge et le nombre de ventes ?
SELECT SUM(CA_vente)    AS chiffre_affaires,
       SUM(Cout_vente)  AS cout_total,
       SUM(Marge_vente) AS marge,
       COUNT(*)         AS nb_transactions,
       SUM(Quantite)    AS quantite_totale
FROM ventes;
 
 
-- Question 2 : quel est le taux de marge (marge / chiffre d'affaires) en % ?
SELECT ROUND(SUM(Marge_vente) * 100 / SUM(CA_vente), 1) AS taux_marge_pct
FROM ventes;
 
 
-- Question 3 : quel est le panier moyen (CA moyen par vente) ?
SELECT ROUND(AVG(CA_vente), 2) AS panier_moyen
FROM ventes;
 
 
-- Question 4 : quel est le budget total ?
SELECT SUM(budget) AS budget_total
FROM budget;
 
-- Question 5 : quel est le CA et la marge de chaque annee ?
SELECT calendrier.Annee,
       SUM(ventes.CA_vente)    AS chiffre_affaires,
       SUM(ventes.Marge_vente) AS marge
FROM ventes
JOIN calendrier ON ventes.Date = calendrier.Date
GROUP BY calendrier.Annee
ORDER BY calendrier.Annee;
 
 
-- Question 6 : quel est le CA de chaque trimestre ?
SELECT calendrier.Annee, calendrier.Trimestre,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN calendrier ON ventes.Date = calendrier.Date
GROUP BY calendrier.Annee, calendrier.Trimestre
ORDER BY calendrier.Annee, calendrier.Trimestre;
 
 
-- Question 7 : quel est le CA de chaque mois ?
SELECT calendrier.Annee_Mois,
       SUM(ventes.CA_vente)    AS chiffre_affaires,
       SUM(ventes.Marge_vente) AS marge
FROM ventes
JOIN calendrier ON ventes.Date = calendrier.Date
GROUP BY calendrier.Annee_Mois
ORDER BY calendrier.Annee_Mois;
 
 
-- Question 8 : quels jours de la semaine vend-on le plus ?
SELECT calendrier.Jour_semaine,
       COUNT(*)             AS nb_ventes,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN calendrier ON ventes.Date = calendrier.Date
GROUP BY calendrier.Jour_semaine
ORDER BY chiffre_affaires DESC;
 
 
-- Question 9 : le week-end vend-il plus que la semaine ?
SELECT calendrier.Week_end,
       COUNT(*)             AS nb_ventes,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN calendrier ON ventes.Date = calendrier.Date
GROUP BY calendrier.Week_end;
 
 
-- Question 10 : quel est le classement des magasins par CA ?
SELECT magasins.Magasin, magasins.Pays,
       SUM(ventes.CA_vente)    AS chiffre_affaires,
       SUM(ventes.Marge_vente) AS marge
FROM ventes
JOIN magasins ON ventes.ID_Magasin = magasins.ID_Magasin
GROUP BY magasins.Magasin, magasins.Pays
ORDER BY chiffre_affaires DESC;
 
 
-- Question 11 : quel est le CA de chaque region ?
SELECT magasins.Region,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN magasins ON ventes.ID_Magasin = magasins.ID_Magasin
GROUP BY magasins.Region
ORDER BY chiffre_affaires DESC;
 
 
-- Question 12 : quel est le CA de chaque magasin en 2025 uniquement ?
SELECT magasins.Magasin,
       SUM(ventes.CA_vente) AS ca_2025
FROM ventes
JOIN calendrier ON ventes.Date = calendrier.Date
JOIN magasins   ON ventes.ID_Magasin = magasins.ID_Magasin
WHERE calendrier.Annee = 2025
GROUP BY magasins.Magasin
ORDER BY ca_2025 DESC;
 
 
-- Question 13 : quelle est la note de satisfaction moyenne de chaque magasin ?
SELECT magasins.Magasin,
       ROUND(AVG(ventes.Note_satisfaction), 2) AS note_moyenne,
       COUNT(ventes.Note_satisfaction)         AS nb_notes
FROM ventes
JOIN magasins ON ventes.ID_Magasin = magasins.ID_Magasin
WHERE ventes.Note_satisfaction IS NOT NULL
GROUP BY magasins.Magasin
ORDER BY note_moyenne DESC;
 
-- Question 14 : quel est le CA, la marge et le taux de marge de chaque categorie ?
SELECT produits.Categorie,
       SUM(ventes.CA_vente)    AS chiffre_affaires,
       SUM(ventes.Marge_vente) AS marge,
       ROUND(SUM(ventes.Marge_vente) * 100 / SUM(ventes.CA_vente), 1) AS taux_marge_pct
FROM ventes
JOIN produits ON ventes.ID_Produit = produits.ID_Produit
GROUP BY produits.Categorie
ORDER BY chiffre_affaires DESC;
 
 
-- Question 15 : quel est le CA de chaque sous-categorie ?
SELECT produits.Categorie, produits.Sous_categorie,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN produits ON ventes.ID_Produit = produits.ID_Produit
GROUP BY produits.Categorie, produits.Sous_categorie
ORDER BY chiffre_affaires DESC;
 
-- Question 16 : quels sont les 10 produits qui rapportent le plus ?
SELECT produits.Produit, produits.Categorie,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN produits ON ventes.ID_Produit = produits.ID_Produit
GROUP BY produits.Produit, produits.Categorie
ORDER BY chiffre_affaires DESC
LIMIT 10;
 

-- Question 17 : quels sont les 5 produits les moins vendus (en quantite) ?
SELECT produits.Produit,
       SUM(ventes.Quantite) AS quantite_vendue
FROM ventes
JOIN produits ON ventes.ID_Produit = produits.ID_Produit
GROUP BY produits.Produit
ORDER BY quantite_vendue ASC
LIMIT 5;
 
 
-- Question 18 : quel est le CA de chaque collection ?
SELECT produits.Collection,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN produits ON ventes.ID_Produit = produits.ID_Produit
GROUP BY produits.Collection
ORDER BY chiffre_affaires DESC;
 
 
 
-- ============ 5. LES CLIENTS ============
 
-- Question 19 : quels sont les 5 meilleurs clients ?
SELECT clients.Prenom, clients.Nom,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN clients ON ventes.ID_Client = clients.ID_Client
GROUP BY clients.ID_Client, clients.Prenom, clients.Nom
ORDER BY chiffre_affaires DESC
LIMIT 5;
 
 
-- Question 20 : quel est le CA par pays du client ?
SELECT clients.Pays,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN clients ON ventes.ID_Client = clients.ID_Client
GROUP BY clients.Pays
ORDER BY chiffre_affaires DESC;
 
 
-- Question 21 : quel est le CA par tranche d'age ?
SELECT clients.Tranche_age,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN clients ON ventes.ID_Client = clients.ID_Client
GROUP BY clients.Tranche_age
ORDER BY clients.Tranche_age;
 
 
-- Question 22 : qui depense le plus, les femmes ou les hommes ?
SELECT clients.Genre,
       COUNT(*)             AS nb_ventes,
       SUM(ventes.CA_vente) AS chiffre_affaires
FROM ventes
JOIN clients ON ventes.ID_Client = clients.ID_Client
GROUP BY clients.Genre;
 
 
-- Question 23 : les clients inscrits a la newsletter achetent-ils plus ?
SELECT clients.Newsletter,
       COUNT(*)                     AS nb_ventes,
       ROUND(AVG(ventes.CA_vente))  AS panier_moyen
FROM ventes
JOIN clients ON ventes.ID_Client = clients.ID_Client
GROUP BY clients.Newsletter;
 
 
 
-- ============ 6. LES VENDEURS ============
 
-- Question 24 : quel est le classement general des vendeurs ?
SELECT vendeurs.Nom_complet, vendeurs.Magasin,
       SUM(ventes.Quantite)    AS quantite,
       SUM(ventes.CA_vente)    AS chiffre_affaires,
       SUM(ventes.Marge_vente) AS marge
FROM ventes
JOIN vendeurs ON ventes.ID_Vendeur = vendeurs.ID_Vendeur
GROUP BY vendeurs.ID_Vendeur, vendeurs.Nom_complet, vendeurs.Magasin
ORDER BY chiffre_affaires DESC;
 
 
-- Question 25 : quel est le top 5 des vendeurs en 2025 ?
SELECT vendeurs.Nom_complet,
       SUM(ventes.CA_vente) AS ca_2025
FROM ventes
JOIN calendrier ON ventes.Date = calendrier.Date
JOIN vendeurs   ON ventes.ID_Vendeur = vendeurs.ID_Vendeur
WHERE calendrier.Annee = 2025
GROUP BY vendeurs.ID_Vendeur, vendeurs.Nom_complet
ORDER BY ca_2025 DESC
LIMIT 5;
 
 
-- Question 26 : quel est le budget de chaque vendeur ?
SELECT vendeurs.Nom_complet,
       SUM(budget.budget) AS budget_total
FROM budget
JOIN vendeurs ON budget.ID_Vendeur = vendeurs.ID_Vendeur
GROUP BY vendeurs.ID_Vendeur, vendeurs.Nom_complet
ORDER BY budget_total DESC;
 
 
-- Question 27 : quel est le budget de chaque annee ?
SELECT calendrier.Annee,
       SUM(budget.budget) AS budget_total
FROM budget
JOIN calendrier ON budget.Date_mois = calendrier.Date
GROUP BY calendrier.Annee
ORDER BY calendrier.Annee;
 
 
-- Question 28 : boutique ou en ligne, que rapporte chaque canal ?
SELECT Canal,
       COUNT(*)      AS nb_ventes,
       SUM(CA_vente) AS chiffre_affaires
FROM ventes
GROUP BY Canal;
 
 
-- Question 29 : quels modes de paiement sont les plus utilises ?
SELECT Mode_paiement,
       COUNT(*)      AS nb_ventes,
       SUM(CA_vente) AS chiffre_affaires
FROM ventes
GROUP BY Mode_paiement
ORDER BY nb_ventes DESC;
 
 
-- Question 30 : quelles categories sont le plus retournees ?
SELECT produits.Categorie,
       COUNT(*) AS nb_retours
FROM ventes
JOIN produits ON ventes.ID_Produit = produits.ID_Produit
WHERE ventes.Retour = 'Oui'
GROUP BY produits.Categorie
ORDER BY nb_retours DESC;
 
 
-- Question 31 : les remises font-elles vendre plus ? (nombre de ventes par niveau de remise)
SELECT Remise_pct,
       COUNT(*)         AS nb_ventes,
       SUM(CA_vente)    AS chiffre_affaires,
       SUM(Marge_vente) AS marge
FROM ventes
GROUP BY Remise_pct
ORDER BY Remise_pct;
 
 
 -- Question 32: la vue marche-t-elle ?
SELECT COUNT(*) AS nb_lignes_vue
FROM vue_ventes_detail;
