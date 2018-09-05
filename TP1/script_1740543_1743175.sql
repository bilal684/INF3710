CREATE TABLE COMPAGNIE (
nom VARCHAR(20) CONSTRAINT COMP_PK PRIMARY KEY,
ville VARCHAR(30) CONSTRAINT COMP_VILLE_UQ UNIQUE,
province VARCHAR (30),
pays VARCHAR(30)
);
-- Table numéro 2 : Pilote 

CREATE TABLE PILOTE (
brevet CHAR(8) CONSTRAINT PILOTE_PK PRIMARY KEY,
nom CHAR(30) CONSTRAINT PILOTE_NOM_NN NOT NULL,
nbrHVol Integer CONSTRAINT PILOTE_NBRHVOL_NN NOT NULL,
compa VARCHAR(20) CONSTRAINT PILOTE_COMP_FK REFERENCES COMPAGNIE(nom) ON DELETE SET NULL,
CONSTRAINT PILOTE_UQ UNIQUE(nom,compa)
);

-- Table numéro 3 : Avion

CREATE TABLE AVION (
matricule CHAR(6) CONSTRAINT AVION_PK PRIMARY KEY,
typeAvion VARCHAR(20),
nbrHVol INTEGER CONSTRAINT AVION_NBRHVOL_NN NOT NULL,
proprio VARCHAR(20) CONSTRAINT AVION_PROP_FK REFERENCES COMPAGNIE(nom) ON DELETE SET NULL
);

-- Table numéro 4 : Affretement

CREATE TABLE AFFRETEMENT (
compaAff VARCHAR(20) CONSTRAINT AFF_COMP_FK REFERENCES COMPAGNIE(nom),
avion CHAR(6) CONSTRAINT AFF_AVION_FK REFERENCES AVION(matricule),
dateAff DATE,
prix DECIMAL(9,2) CONSTRAINT AFF_PRIX_NN NOT NULL,
CONSTRAINT AFF_PK PRIMARY KEY (compaAff, avion, dateAff)
);
drop table pilote;
drop table avion cascade constraints;
drop table compagnie cascade constraints;
drop table pilote cascade constraints;
drop table affretement cascade constraints;

--Q1
drop table avion;
--Q3
drop table avion cascade constraints;
--Q4
CREATE TABLE PILOTE (
brevet CHAR(8) ,--CONSTRAINT PILOTE_PK PRIMARY KEY,
nom CHAR(30),-- CONSTRAINT PILOTE_NOM_NN NOT NULL,
nbrHVol Integer ,--CONSTRAINT PILOTE_NBRHVOL_NN NOT NULL,
compa VARCHAR(20)-- CONSTRAINT PILOTE_COMP_FK--REFERENCES COMPAGNIE(nom) ON DELETE SET NULL,
--CONSTRAINT PILOTE_UQ UNIQUE(nom,compa)
);
alter table pilote modify (nom default 'monNomParDefaut');
insert into pilote values('test', default, 12, 'n');
--Q5
CREATE TABLE PILOTE (
brevet CHAR(8),
nom CHAR(30) not null,
nbrHVol Integer,
compa VARCHAR(20)
);
insert into pilote values('test', '', 12, 'n');
--Q6
CREATE TABLE PILOTE (
brevet CHAR(8),
nom CHAR(30) unique,
nbrHVol Integer,
compa VARCHAR(20)
);
insert into pilote values ('test', 'mehdi', 12, 'n');
insert into pilote values ('test', '', 12, 'n');
--Q7
drop table pilote cascade constraints;
CREATE TABLE PILOTE (
brevet CHAR(8) unique,
nom CHAR(30) unique,
nbrHVol Integer,
compa VARCHAR(20)
);
insert into pilote values('', '', 12, 'n');
insert into pilote values('test', 'test', 12, 'n');
insert into pilote values('', 'test2', 12, 'n');
insert into pilote values('', 'test3', 12, 'n');
--Q8
CREATE TABLE COMPAGNIE (
nom VARCHAR(20) CONSTRAINT COMP_PK PRIMARY KEY,
ville VARCHAR(30),
province VARCHAR (30),
pays VARCHAR(30)
);
drop table compagnie cascade constraints;
insert into compagnie values('kadi', 'laval', 'qc', 'canada');
insert into compagnie values('', 'laval', 'qc', 'canada');
--Q9
drop table affretement cascade constraints;
CREATE TABLE AFFRETEMENT (
compaAff VARCHAR(20), --CONSTRAINT AFF_COMP_FK REFERENCES COMPAGNIE(nom),
avion CHAR(6),-- CONSTRAINT AFF_AVION_FK REFERENCES AVION(matricule),
dateAff DATE,
prix DECIMAL(9,2), -- CONSTRAINT AFF_PRIX_NN NOT NULL,
CONSTRAINT AFF_PK PRIMARY KEY (compaAff, avion, dateAff)
);
insert into affretement values('test', 'test', to_date('03/05/2008','DD/MM/YYYY'), 0.1);
insert into affretement values('', '', to_date('03/05/2002','DD/MM/YYYY'), 0.1);
--Q10
drop table compagnie cascade constraints;
drop table pilote cascade constraints;
CREATE TABLE COMPAGNIE (
nom VARCHAR(20) CONSTRAINT COMP_PK PRIMARY KEY,
ville VARCHAR(30),
province VARCHAR (30),
pays VARCHAR(30)
);
insert into compagnie values ('1', '1', '1', '1');
insert into compagnie values ('2', '2', '2', '2');
insert into compagnie values ('3', '3', '3', '3');
CREATE TABLE PILOTE (
brevet CHAR(8),-- CONSTRAINT PILOTE_PK PRIMARY KEY,
nom CHAR(30),-- CONSTRAINT PILOTE_NOM_NN NOT NULL,
nbrHVol Integer,-- CONSTRAINT PILOTE_NBRHVOL_NN NOT NULL,
compa VARCHAR(20) CONSTRAINT PILOTE_COMP_FK REFERENCES COMPAGNIE(nom)
--CONSTRAINT PILOTE_UQ UNIQUE(nom,compa)
);
CREATE TABLE PILOTE (
brevet CHAR(8),-- CONSTRAINT PILOTE_PK PRIMARY KEY,
nom CHAR(30),-- CONSTRAINT PILOTE_NOM_NN NOT NULL,
nbrHVol Integer,-- CONSTRAINT PILOTE_NBRHVOL_NN NOT NULL,
compa VARCHAR(20) CONSTRAINT PILOTE_COMP_FK REFERENCES COMPAGNIE(nom) on delete cascade
--CONSTRAINT PILOTE_UQ UNIQUE(nom,compa)
);
CREATE TABLE PILOTE (
brevet CHAR(8),-- CONSTRAINT PILOTE_PK PRIMARY KEY,
nom CHAR(30),-- CONSTRAINT PILOTE_NOM_NN NOT NULL,
nbrHVol Integer,-- CONSTRAINT PILOTE_NBRHVOL_NN NOT NULL,
compa VARCHAR(20) CONSTRAINT PILOTE_COMP_FK REFERENCES COMPAGNIE(nom) on delete set null
--CONSTRAINT PILOTE_UQ UNIQUE(nom,compa)
);
insert into pilote values ('brev1', 'test', 12, '4');
insert into pilote values ('brev1', 'test', 12, '2');
delete from compagnie where nom = '2';

--Q12

drop table compagnie cascade constraints;
drop table pilote cascade constraints;
drop table avion cascade constraints;
drop table affretement cascade constraints;

CREATE TABLE COMPAGNIE (
nom VARCHAR(20) CONSTRAINT COMP_PK PRIMARY KEY,
ville VARCHAR(30) CONSTRAINT COMP_VILLE_UQ UNIQUE,
province VARCHAR (30),
pays VARCHAR(30)
);
-- Table numéro 2 : Pilote 

CREATE TABLE PILOTE (
brevet CHAR(8) CONSTRAINT PILOTE_PK PRIMARY KEY,
nom CHAR(30) CONSTRAINT PILOTE_NOM_NN NOT NULL,
nbrHVol Integer CONSTRAINT PILOTE_NBRHVOL_NN NOT NULL,
compa VARCHAR(20) CONSTRAINT PILOTE_COMP_FK REFERENCES COMPAGNIE(nom) ON DELETE SET NULL,
CONSTRAINT PILOTE_UQ UNIQUE(nom,compa)
);

-- Requête 1
SELECT * 
FROM COMPAGNIE C, PILOTE P
WHERE C.nom=P.compa ;

-- Requête 2
SELECT * 
FROM COMPAGNIE C, PILOTE P ;

-- Requête 3
SELECT * 
FROM COMPAGNIE C, PILOTE P
WHERE C.nom=P.compa 
AND C.nom='Air Canada';

insert into compagnie values ('Air Canada', '1', '1', '1');
insert into compagnie values ('2', '2', '2', '2');
insert into compagnie values ('3', '3', '3', '3');

insert into pilote values('1','test', 12, 'Air Canada');
insert into pilote values('2','test2', 12, '2');
insert into pilote values('3','test3', 12, '3');

--Q13

CREATE TABLE COMPAGNIE (
nom VARCHAR(20) CONSTRAINT COMP_PK PRIMARY KEY,
ville VARCHAR(30) CONSTRAINT COMP_VILLE_UQ UNIQUE,
province VARCHAR (30),
pays VARCHAR(30)
);
-- Table numéro 2 : Pilote 

CREATE TABLE PILOTE (
brevet CHAR(8) CONSTRAINT PILOTE_PK PRIMARY KEY,
nom CHAR(30) CONSTRAINT PILOTE_NOM_NN NOT NULL,
nbrHVol Integer CONSTRAINT PILOTE_NBRHVOL_NN NOT NULL,
compa VARCHAR(20) CONSTRAINT PILOTE_COMP_FK REFERENCES COMPAGNIE(nom) ON DELETE SET NULL,
CONSTRAINT PILOTE_UQ UNIQUE(nom,compa)
);
--Table 3
CREATE TABLE AVION (
matricule CHAR(6) CONSTRAINT AVION_PK PRIMARY KEY,
typeAvion VARCHAR(20),
nbrHVol INTEGER CONSTRAINT AVION_NBRHVOL_NN NOT NULL,
proprio VARCHAR(20) CONSTRAINT AVION_PROP_FK REFERENCES COMPAGNIE(nom) ON DELETE SET NULL
);

-- Table numéro 4 : Affretement

CREATE TABLE AFFRETEMENT (
compaAff VARCHAR(20) CONSTRAINT AFF_COMP_FK REFERENCES COMPAGNIE(nom),
avion CHAR(6) CONSTRAINT AFF_AVION_FK REFERENCES AVION(matricule),
dateAff DATE,
prix DECIMAL(9,2) CONSTRAINT AFF_PRIX_NN NOT NULL,
CONSTRAINT AFF_PK PRIMARY KEY (compaAff, avion, dateAff)
);

INSERT INTO COMPAGNIE VALUES ('Air Canada', 'Montreal', 'Quebec', 'Canada');
INSERT INTO COMPAGNIE VALUES ('West Jet', 'Toronto', 'Ontario', 'Canada');
INSERT INTO COMPAGNIE VALUES ('Air France', 'Paris', 'Ile de France', 'France');
INSERT INTO COMPAGNIE VALUES ('American Airlines', 'Albany', 'New York', 'USA');
INSERT INTO COMPAGNIE VALUES ('Alitalia', 'Rome', 'Rome', 'Italie');

INSERT INTO PILOTE VALUES ('BR21675', 'Jean Lemieux', 965, 'Air Canada');
INSERT INTO PILOTE VALUES ('BR21431', 'Pierre Lheureux', 543, 'Air Canada');
INSERT INTO PILOTE VALUES ('BR45665', 'Serge Paris', 705, 'Air France');
INSERT INTO PILOTE VALUES ('BR35332', 'Marco Rossi', 801, 'Alitalia');
INSERT INTO PILOTE VALUES ('BR22445', 'John Steinpack', 433, 'West Jet');
INSERT INTO PILOTE VALUES ('BR26587', 'George McDonald',559, 'West Jet');
INSERT INTO PILOTE VALUES ('BR28811', 'Sam Withney', 606, 'Air Canada');
INSERT INTO PILOTE VALUES ('BR45321', 'Sami Zidane', 542, 'Air France');

INSERT INTO AVION VALUES ('A4327V', 'Boeing 717',  245, 'Air Canada');
INSERT INTO Avion VALUES ('A7602S', 'Boeing 737',  312, 'West Jet');
INSERT INTO Avion VALUES ('A1329K', 'Airbus A320', 409, 'Air France');

INSERT INTO AFFRETEMENT (compaAff, avion, prix,dateAff) VALUES ('Air Canada', 'A4327V', 15750.00, to_date('03/05/2008','DD/MM/YYYY'));
INSERT INTO AFFRETEMENT (compaAff, avion, prix,  dateAff) VALUES ('Air Canada', 'A4327V', 12050.00, to_date('04/05/2008','DD/MM/YYYY'));

INSERT INTO AFFRETEMENT VALUES ('West Jet', 'A7602S', to_date('03/05/2008','DD/MM/YYYY'), 10500.00);
--query demander
select affretement.avion, affretement.compaAff, affretement.prix from affretement where affretement.compaAff = 'West Jet';
--Q14
CREATE TABLE COMPAGNIE (
nom VARCHAR(20) CONSTRAINT COMP_PK PRIMARY KEY,
ville VARCHAR(30) CONSTRAINT COMP_VILLE_UQ UNIQUE,
province VARCHAR (30),
pays VARCHAR(30)
);
desc compagnie;
alter table compagnie add numeroTel varchar(10);
desc compagnie;
--Q15
comment on table affretement is 'Table contenant les informations relatives aux affretements';
comment on column affretement.compaAff is 'Compagnie qui a affrete';
comment on column affretement.avion is 'Matricule identifiant lavion affrete';
comment on column affretement.dateAff is 'Date de laffretement.';
comment on column affretement.prix is 'Prix de laffretement.';

comment on table compagnie is 'Table contenant les informations relatives aux compagnies';
comment on column compagnie.nom is 'Nom de la compagnie.';
comment on column compagnie.ville is 'Ville ou est etablie la compagnie.';
comment on column compagnie.province is 'Province ou est etablie la compagnie.';
comment on column compagnie.pays is 'Pays ou est etablie la compagnie.';

comment on table pilote is 'Table contenant les informations relatives aux pilotes.';
comment on column pilote.brevet is 'Brevet que detient le pilote.';
comment on column pilote.nom is 'Nom du pilote';
comment on column pilote.nbrhvol is 'Nombre dheure qua effectue le pilote.';
comment on column pilote.compa is 'Compagnie ou travail le pilote';

comment on table avion is 'Table contenant les informations relatives aux avions';
comment on column avion.matricule is 'Matricule identifiant lavion';
comment on column avion.typeavion is 'Modele de lavion';
comment on column avion.nbrhvol is 'Nombre dheure de vol qua effectue lavion.';
comment on column avion.proprio is 'Proprietaire de lavion.';

select ALL_COL_COMMENTS.OWNER, ALL_COL_COMMENTS.TABLE_NAME, ALL_TAB_COMMENTS.COMMENTS, ALL_COL_COMMENTS.COLUMN_NAME, ALL_COL_COMMENTS.COMMENTS from ALL_COL_COMMENTS inner join ALL_TAB_COMMENTS 
on ALL_COL_COMMENTS.TABLE_NAME = ALL_TAB_COMMENTS.TABLE_NAME where ALL_COL_COMMENTS.TABLE_NAME = 'COMPAGNIE' or ALL_COL_COMMENTS.TABLE_NAME = 'PILOTE' 
or ALL_COL_COMMENTS.TABLE_NAME = 'AVION' OR ALL_COL_COMMENTS.TABLE_NAME = 'AFFRETEMENT' order by ALL_COL_COMMENTS.TABLE_NAME;