CREATE DATABASE IF NOT EXISTS maison_valmont CHARACTER SET utf8mb4;
USE maison_valmont;
 
DROP VIEW  IF EXISTS vue_ventes_detail;
DROP TABLE IF EXISTS ventes;
DROP TABLE IF EXISTS budget;
DROP TABLE IF EXISTS calendrier;
DROP TABLE IF EXISTS vendeurs;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS produits;
DROP TABLE IF EXISTS magasins;
 
 
CREATE TABLE magasins (
    ID_Magasin  VARCHAR(10)  NOT NULL PRIMARY KEY,
    Magasin     VARCHAR(100),
    Ville       VARCHAR(50),
    Pays        VARCHAR(50),
    Region      VARCHAR(50),
    Type        VARCHAR(30)
);
 
CREATE TABLE produits (
    ID_Produit      VARCHAR(10)  NOT NULL PRIMARY KEY,
    Produit         VARCHAR(100),
    Categorie       VARCHAR(50),
    Sous_categorie  VARCHAR(50),
    Prix_unitaire   DECIMAL(10,2),
    Cout_unitaire   DECIMAL(10,2),
    Collection      VARCHAR(50)
);
 
CREATE TABLE clients (
    ID_Client         VARCHAR(10) NOT NULL PRIMARY KEY,
    Prenom            VARCHAR(50),
    Nom               VARCHAR(50),
    Genre             VARCHAR(10),
    Age               INT NULL,
    Tranche_age       VARCHAR(20),
    Pays              VARCHAR(50),
    Date_inscription  DATE NULL,
    Magasin_favori    VARCHAR(10) NULL,
    Newsletter        VARCHAR(5)
);
 
CREATE TABLE vendeurs (
    ID_Vendeur   VARCHAR(10) NOT NULL PRIMARY KEY,
    Nom_complet  VARCHAR(100),
    Prenom       VARCHAR(50),
    Nom          VARCHAR(50),
    Magasin      VARCHAR(100),
    Photo        LONGTEXT
);
 
CREATE TABLE calendrier (
    Date          DATE NOT NULL PRIMARY KEY,
    Annee         INT,
    Trimestre     VARCHAR(5),
    Mois_num      INT,
    Mois          VARCHAR(10),
    Mois_nom      VARCHAR(20),
    Annee_Mois    VARCHAR(10),
    Semaine       INT,
    Jour_num      INT,
    Jour_semaine  VARCHAR(15),
    Week_end      VARCHAR(5)
);
 
 
 
CREATE TABLE budget (
    ID_Vendeur  VARCHAR(10)   NOT NULL,
    Date_mois   DATE          NOT NULL,
    Budget      DECIMAL(12,2),
    PRIMARY KEY (ID_Vendeur, Date_mois)
);
 
CREATE TABLE ventes (
    ID_Vente           VARCHAR(10) NOT NULL PRIMARY KEY,
    Date               DATE        NOT NULL,
    ID_Client          VARCHAR(10),
    ID_Magasin         VARCHAR(10),
    ID_Produit         VARCHAR(10),
    ID_Vendeur         VARCHAR(10),
    Quantite           INT,
    Prix_unitaire      DECIMAL(10,2),
    Remise_pct         DECIMAL(5,2),
    Mode_paiement      VARCHAR(30),
    Canal              VARCHAR(20),
    Retour             VARCHAR(5),
    Note_satisfaction  INT NULL,
    CA_vente           DECIMAL(12,2),
    Cout_vente         DECIMAL(12,2),
    Marge_vente        DECIMAL(12,2)
);
 
SHOW TABLES;
