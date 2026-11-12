USE maison_valmont;
 
-- Question 2 : combien de clients ? 
SELECT COUNT(*) AS nb_clients
FROM clients;
 
 
-- Question 3 : combien de produits ? 
SELECT COUNT(*) AS nb_produits
FROM produits;
 
 
-- Question 4 : combien de magasins ? 
SELECT COUNT(*) AS nb_magasins
FROM magasins;
 
 
-- Question 5 : combien de vendeurs ? 
SELECT COUNT(*) AS nb_vendeurs
FROM vendeurs;
 
 
-- Question 6 : combien de lignes de budget ? 
SELECT COUNT(*) AS nb_lignes_budget
FROM budget;
 
 
-- Question 7 : combien de jours dans le calendrier ? 
SELECT COUNT(*) AS nb_jours
FROM calendrier;
 
 
 
-- ============ 2. LES DOUBLONS ============
 
-- Question 8 : est-ce qu'un ID_Vente apparait plusieurs fois ?
SELECT COUNT(*) - COUNT(DISTINCT ID_Vente) AS nb_doublons
FROM ventes;
 
 
-- Question 9 : est-ce qu'un meme client apparait plusieurs fois dans la table clients ?
SELECT COUNT(*) - COUNT(DISTINCT ID_Client) AS nb_doublons
FROM clients;
 
 
 
-- ============ 3. LES LIENS ENTRE LES TABLES ============
 
-- Question 10 : y a-t-il des ventes avec un client qui n'existe pas ?

SELECT COUNT(*) AS ventes_sans_client
FROM ventes
LEFT JOIN clients ON ventes.ID_Client = clients.ID_Client
WHERE clients.ID_Client IS NULL;
 
 
-- Question 11 : y a-t-il des ventes avec un produit qui n'existe pas ?
SELECT COUNT(*) AS ventes_sans_produit
FROM ventes
LEFT JOIN produits ON ventes.ID_Produit = produits.ID_Produit
WHERE produits.ID_Produit IS NULL;
 
 
-- Question 12 : y a-t-il des ventes avec un vendeur qui n'existe pas ?
SELECT COUNT(*) AS ventes_sans_vendeur
FROM ventes
LEFT JOIN vendeurs ON ventes.ID_Vendeur = vendeurs.ID_Vendeur
WHERE vendeurs.ID_Vendeur IS NULL;
 
 
-- Question 13 : y a-t-il des clients qui n'ont aucune vente ?
SELECT COUNT(*) AS clients_sans_achat
FROM clients
LEFT JOIN ventes ON clients.ID_Client = ventes.ID_Client
WHERE ventes.ID_Vente IS NULL;
 
 
-- Question 14 : y a-t-il des produits qui ne se sont jamais vendus ?
SELECT COUNT(*) AS produits_jamais_vendus
FROM produits
LEFT JOIN ventes ON produits.ID_Produit = ventes.ID_Produit
WHERE ventes.ID_Vente IS NULL;
 
 
-- Question 15 : y a-t-il des vendeurs qui n'ont fait aucune vente ?
SELECT COUNT(*) AS vendeurs_sans_vente
FROM vendeurs
LEFT JOIN ventes ON vendeurs.ID_Vendeur = ventes.ID_Vendeur
WHERE ventes.ID_Vente IS NULL;
 
 
 
-- ============ 4. LES VALEURS MANQUANTES ============
 
-- Question 16 : combien de ventes sans note de satisfaction ?
SELECT COUNT(*) AS notes_vides
FROM ventes
WHERE Note_satisfaction IS NULL;
 
 
-- Question 17 : combien de modes de paiement "Inconnu" ?
SELECT COUNT(*) AS paiements_inconnus
FROM ventes
WHERE Mode_paiement = 'Inconnu';
 
 
-- Question 18 : combien de clients sans age ?
SELECT COUNT(*) AS clients_sans_age
FROM clients
WHERE Age IS NULL;
 
 
-- Question 19 : combien de clients sans date d'inscription ?
SELECT COUNT(*) AS clients_sans_date_inscription
FROM clients
WHERE Date_inscription IS NULL;
 
 
-- Question 20 : combien de clients sans magasin favori ?
SELECT COUNT(*) AS clients_sans_magasin_favori
FROM clients
WHERE Magasin_favori IS NULL;
 
 
-- Question 21 : combien de clients avec le pays "Inconnu" ?
SELECT COUNT(*) AS clients_pays_inconnu
FROM clients
WHERE Pays = 'Inconnu';
 
-- Question 22 : quels canaux et combien de ventes pour chacun ?
SELECT Canal, COUNT(*) AS nb
FROM ventes
GROUP BY Canal
ORDER BY nb DESC;

-- Question 23 : quels modes de paiement ?
SELECT Mode_paiement, COUNT(*) AS nb
FROM ventes
GROUP BY Mode_paiement
ORDER BY nb DESC;
 
 
-- Question 24 : quelles valeurs pour "Retour" ?
SELECT Retour, COUNT(*) AS nb
FROM ventes
GROUP BY Retour;
 
 
-- Question 25 : quelles remises existent et combien de ventes pour chacune ?

SELECT Remise_pct, COUNT(*) AS nb
FROM ventes
GROUP BY Remise_pct
ORDER BY Remise_pct;
 
 
-- Question 26 : quelles categories de produits ?
SELECT Categorie, COUNT(*) AS nb_produits
FROM produits
GROUP BY Categorie
ORDER BY nb_produits DESC;
 
 
-- Question 27 : quels pays pour les clients ?
SELECT Pays, COUNT(*) AS nb_clients
FROM clients
GROUP BY Pays
ORDER BY nb_clients DESC;
 
 
-- Question 28 : quelles tranches d'age ?
SELECT Tranche_age, COUNT(*) AS nb_clients
FROM clients
GROUP BY Tranche_age
ORDER BY Tranche_age;
 
 
-- Question 29 : reste-t-il des espaces en trop au debut ou a la fin ?

SELECT COUNT(*) AS lignes_avec_espaces
FROM ventes
WHERE Canal <> TRIM(Canal)
   OR Mode_paiement <> TRIM(Mode_paiement)
   OR Retour <> TRIM(Retour);
 
 
 
-- ============ 6. LES MONTANTS ET LES DATES ============
 
-- Question 30 : y a-t-il des quantites a zero ou negatives ?
SELECT COUNT(*) AS quantites_anormales
FROM ventes
WHERE Quantite <= 0;
 
 
-- Question 31 : y a-t-il des chiffres d'affaires negatifs ou a zero ?
SELECT COUNT(*) AS ca_anormaux
FROM ventes
WHERE CA_vente <= 0;
 
 
-- Question 32 : combien de ventes sont a perte (marge negative) ?
-- (c'est normal d'en avoir : ce sont les grosses remises, voir question 41)
SELECT COUNT(*) AS ventes_a_perte
FROM ventes
WHERE Marge_vente < 0;
 
 
-- Question 33 : la marge est-elle bien egale a CA - cout ?
-- (on tolere 1 centime d'ecart d'arrondi)
SELECT COUNT(*) AS marges_incoherentes
FROM ventes
WHERE ABS(CA_vente - Cout_vente - Marge_vente) > 0.01;
 
 
-- Question 34 : le CA est-il bien egal a quantite x prix x (1 - remise) ?
-- (la remise est deja ecrite en fraction : 0.1 = 10 %, donc pas de division par 100)
SELECT COUNT(*) AS ca_incoherents
FROM ventes
WHERE ABS(CA_vente - Quantite * Prix_unitaire * (1 - Remise_pct)) > 0.01;
 
 
-- Question 35 : quelle est la premiere et la derniere date de vente ?
SELECT MIN(Date) AS premiere_vente, MAX(Date) AS derniere_vente
FROM ventes;
 
 
-- Question 36 : combien de ventes par annee ?
SELECT calendrier.Annee, COUNT(*) AS nb_ventes
FROM ventes
JOIN calendrier ON ventes.Date = calendrier.Date
GROUP BY calendrier.Annee
ORDER BY calendrier.Annee;
 
 
 
-- ============ 7. POINTS D'ATTENTION ============
 
-- Question 37 : combien de ventes ont ete retournees et pour quel montant ?
SELECT COUNT(*) AS nb_retours, SUM(CA_vente) AS ca_retourne
FROM ventes
WHERE Retour = 'Oui';
 
 
-- Question 38 : combien de ventes ont ete faites AVANT la date d'inscription du client ?
SELECT COUNT(*) AS ventes_avant_inscription
FROM ventes
JOIN clients ON ventes.ID_Client = clients.ID_Client
WHERE ventes.Date < clients.Date_inscription;
 
 
-- Question 39 : le prix de la vente est-il different du prix du catalogue ?
SELECT COUNT(*) AS prix_differents
FROM ventes
JOIN produits ON ventes.ID_Produit = produits.ID_Produit
WHERE ventes.Prix_unitaire <> produits.Prix_unitaire;
 
 
-- Question 40 : un vendeur a-t-il vendu dans un autre magasin que le sien ?
-- (on compare le magasin de la vente avec le magasin du vendeur)
SELECT COUNT(*) AS ventes_hors_magasin_du_vendeur
FROM ventes
JOIN vendeurs ON ventes.ID_Vendeur = vendeurs.ID_Vendeur
JOIN magasins ON ventes.ID_Magasin = magasins.ID_Magasin
WHERE vendeurs.Magasin <> magasins.Magasin;
 
 
-- Question 41 : a partir de quelle remise vend-on a perte ?
SELECT Remise_pct, COUNT(*) AS nb_ventes, SUM(Marge_vente) AS marge_totale
FROM ventes
WHERE Marge_vente < 0
GROUP BY Remise_pct
ORDER BY Remise_pct;
