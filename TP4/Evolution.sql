-- Poly Montréal
-- INF3710 Hiver 2017
-- Solutionnaire TP 3
--------------------------------------------------------

---------- Création de la table MEMBRE 
CREATE TABLE MEMBRE(
NumM NUMBER(10) CONSTRAINT MEMBRE_PK PRIMARY KEY,
Nom VARCHAR2(50) CONSTRAINT NOM_MEMBRE_NN NOT NULL,
Prenom VARCHAR2(50) CONSTRAINT PRENOM_MEMBRE_NN NOT NULL,
photoM VARCHAR2(255),
Email VARCHAR2(50) CONSTRAINT email_NN NOT NULL,
typeProfil CHAR(1) CONSTRAINT Profil_CK check (upper(typeProfil)in ('P', 'V')),
dateInscription DATE CONSTRAINT DATEINSCRIPTION_NN NOT NULL,
nAbonne number default 0
);

---------- Création de la table ABONNE
CREATE TABLE ABONNE(
NumM NUMBER(10),
NumAbonne NUMBER(10) ,
debutAbonnement DATE CONSTRAINT debutAbonnement_NN NOT NULL,
finAbonnement DATE,
CONSTRAINT ABONNE_PK PRIMARY KEY (NumM,NumAbonne),
CONSTRAINT ABONNE_NUMA_FK FOREIGN KEY (NumAbonne) REFERENCES MEMBRE(numM),
CONSTRAINT ABONNE_NUMM_FK FOREIGN KEY (NumM) REFERENCES MEMBRE(numM)
);

---------- Création de la table AMI
CREATE TABLE AMI(
NumM NUMBER(10),
NumAmi NUMBER(10) ,
CONSTRAINT AMI_PK PRIMARY KEY (NumM,NumAmi),
CONSTRAINT AMI_NUMA_FK FOREIGN KEY (NumAmi) REFERENCES MEMBRE(numM),
CONSTRAINT AMI_NUMM_FK FOREIGN KEY (NumM) REFERENCES MEMBRE(numM)
);

---------- Création de la table Photo
CREATE TABLE PHOTO(
numPhoto NUMBER(20) CONSTRAINT Photo_PK PRIMARY KEY,
numM NUMBER(10),
urlPhoto VARCHAR2(255),
descriptionPhoto LONG,
debutPublication DATE CONSTRAINT debutPublication_NN NOT NULL,
finPublication DATE,
CONSTRAINT Photo_numM_FK FOREIGN KEY (numM) REFERENCES MEMBRE(numM)
);

---------- Création de la table COMMENTAIRE
CREATE TABLE COMMENTAIRE(
numPhoto NUMBER(20),
numM NUMBER(10),
no NUMBER(30),
contenu VARCHAR2(255) CONSTRAINT CONTENU_Commentaire_NN NOT NULL,
CONSTRAINT Commentaire_PK PRIMARY KEY(numPhoto, numM, no),
CONSTRAINT Commentaire_numPhoto_FK FOREIGN KEY (numPhoto) REFERENCES Photo(numPhoto),
CONSTRAINT Commentaire_numM_FK FOREIGN KEY (numM) REFERENCES MEMBRE(numM)
);

---------- Création de la table JAIME
CREATE TABLE JAIME(
numPhoto NUMBER(20),
numM NUMBER(10),
CONSTRAINT JAIME_PK PRIMARY KEY(numPhoto, numM),
CONSTRAINT JAIME_numMPhoto_FK FOREIGN KEY (numPhoto) REFERENCES Photo(numPhoto),
CONSTRAINT JAIME_numM_FK FOREIGN KEY (numM) REFERENCES MEMBRE(numM)
);

-------------------------------
--         Création des index         --
-------------------------------
-- sur les clés externes 

CREATE UNIQUE INDEX ABONNE_NUMM_IDX ON ABONNE(numM) ;
CREATE UNIQUE INDEX ABONNE_NUMA_IDX ON ABONNE(numAbonne) ;
CREATE UNIQUE INDEX AMI_NUMM_IDX ON AMI(numM) ;
CREATE UNIQUE INDEX AMI_NUMA_IDX ON AMI(numAmi) ;
CREATE UNIQUE INDEX Photo_numM_IDX ON PHOTO(numM) ;
CREATE UNIQUE INDEX Commentaire_numM_IDX ON COMMENTAIRE(numM) ;
CREATE UNIQUE INDEX Commentaire_numPhoto_IDX ON COMMENTAIRE(numPhoto) ;
CREATE UNIQUE INDEX JAIME_numM_IDX ON JAIME(numM) ;
CREATE UNIQUE INDEX JAIME_numMPhoto_IDX ON JAIME(numPhoto) ;

-------------------------------
--         Requêtes          --
-------------------------------

-------------------------------
-- R1 : Noms et prénoms des amis du membre dont l’identifiant est 201701.
-------------------------------

SELECT M.NOM, M.PRENOM
FROM MEMBRE M INNER JOIN AMI A ON (A.NUMM=201701 AND A.NUMAMI=M.NUMM);

-- ou 

SELECT M.NOM, M.PRENOM
FROM MEMBRE M INNER JOIN AMI A ON A.NUMAMI=M.NUMM
WHERE A.NUMM=201701;

-------------------------------
--R2 : Liste des membres, par ordre décroissant des noms et prénoms, qui ont au moins un ami en commun avec le membre dont l’identifiant est 201701.
-------------------------------

SELECT M.NOM, M.PRENOM
FROM MEMBRE M INNER JOIN AMI A1 ON A1.NUMM=M.NUMM
WHERE A1.NUMAMI in (SELECT A2.NUMAMI FROM AMI A2 WHERE A2.NUMM=201701)
ORDER BY M.NOM desc, M.PRENOM desc;

-- Ou

SELECT M.NOM, M.PRENOM
FROM MEMBRE M NATURAL JOIN AMI A1
WHERE A1.NUMAMI in (SELECT A2.NUMAMI FROM AMI A2 WHERE A2.NUMM=201701)
ORDER BY M.NOM desc, M.PRENOM desc;

-- Ou

WITH AMISDE201701 AS (SELECT A2.NUMAMI FROM AMI A2 WHERE A2.NUMM=201701) 
SELECT M.NOM, M.PRENOM
FROM (MEMBRE M NATURAL JOIN AMI A1 ) INNER JOIN AMISDE201701 A2 ON A1.NUMAMI = A2.NUMAMI
ORDER BY M.NOM desc, M.PRENOM desc;

-- Ou

SELECT M.NOM, M.PRENOM
FROM (MEMBRE M NATURAL JOIN AMI A1 ) INNER JOIN AMI A2 ON (A1.NUMAMI = A2.NUMAMI AND A2.NUMM=201701)
ORDER BY M.NOM desc, M.PRENOM desc;

-------------------------------
--R3 : Liste des membres, par ordre croissant des noms et prénoms, qui ont exactement trois (03) amis en commun avec le membre 201701.
-------------------------------

SELECT M.NOM, M.PRENOM
FROM MEMBRE M INNER JOIN AMI A1 ON A1.numM=M.numM
WHERE A1.NUMAMI in (SELECT A2.NUMAMI FROM AMI A2 WHERE A2.NUMM=201701)
GROUP BY M.NOM, M.PRENOM
HAVING COUNT(DISTINCT A1.NUMAMI)=3
ORDER BY M.NOM, M.PRENOM;

-- Ou

SELECT M.NOM, M.PRENOM
FROM MEMBRE M NATURAL JOIN AMI A1
WHERE A1.NUMAMI in (SELECT A2.NUMAMI FROM AMI A2 WHERE A2.NUMM=201701)
GROUP BY M.NOM, M.PRENOM
HAVING COUNT(DISTINCT A1.NUMAMI)=3
ORDER BY M.NOM, M.PRENOM;

-- Ou

WITH AMISDE201701 AS (SELECT A2.numAmi FROM AMI A2 WHERE A2.NumM=201701) 
SELECT M.NOM, M.PRENOM
FROM (MEMBRE M NATURAL JOIN AMI A1 ) INNER JOIN AMISDE201701 A2 ON A1.NUMAMI = A2.NUMAMI
GROUP BY M.NOM, M.PRENOM
HAVING COUNT(DISTINCT A1.NUMAMI)=3
ORDER BY M.NOM, M.PRENOM;

-- Ou

SELECT M.NOM, M.PRENOM
FROM (MEMBRE M NATURAL join AMI A1 ) INNER JOIN AMI A2 ON (A1.NUMAMI = A2.NUMAMI AND A2.NUMM=201701)
GROUP BY M.NOM, M.PRENOM
HAVING COUNT(DISTINCT A1.NUMAMI)=3
ORDER BY M.NOM, M.PRENOM;

-------------------------------
-- R4 : Noms et prénoms des membres qui ont commenté plus de trois fois une même photo.
-------------------------------

WITH COMMENTATEUR AS 
(SELECT C.NUMM
FROM COMMENTAIRE C 
GROUP BY C.NUMPHOTO,C.NUMM
HAVING COUNT(DISTINCT C.NO)>=3)
SELECT M.NOM, M.PRENOM
FROM MEMBRE M NATURAL JOIN COMMENTATEUR;

-------------------------------
--R5 : Pour chaque membre, le nombre moyen de « j’aime » récolté pour toutes les photos qu’il a publiées.
-------------------------------

WITH MEMBREPHOTO AS
(SELECT P.NUMM, J.NUMPHOTO, COUNT(DISTINCT J.NUMM) NJP
FROM JAIME J INNER JOIN PHOTO P ON J.NUMPHOTO=P.NUMPHOTO
GROUP BY P.NUMM, J.NUMPHOTO
) 
SELECT DISTINCT M2.NOM, M2.PRENOM, AVG(M1.NJP) N
FROM MEMBREPHOTO M1 INNER JOIN MEMBRE M2 ON M1.NUMM=M2.NUMM
GROUP BY M2.NOM, M2.PRENOM;

-------------------------------
-- R6 : Noms et prénoms des membres qui sont des amis ou des abonnés du membre 201701 et qui n’ont jamais aimé une de ses photos.
-------------------------------

WITH NOCOMMENT AS
((SELECT DISTINCT A1.NUMABONNE NUM FROM ABONNE A1 WHERE A1.NUMM=201701
UNION
SELECT DISTINCT A2.NUMAMI FROM AMI A2 WHERE A2.NUMM=201701)
MINUS
SELECT DISTINCT J.NUMM FROM PHOTO P INNER JOIN JAIME J ON P.NUMPHOTO=J.NUMPHOTO AND P.NUMM=201701)
SELECT DISTINCT M.NOM, M.PRENOM
FROM MEMBRE M INNER JOIN NOCOMMENT NC ON M.NUMM=NC.NUM;

-- Ou

SELECT DISTINCT M.NOM, M.PRENOM
FROM MEMBRE M 
WHERE M.NUMM in ((SELECT DISTINCT A1.NUMABONNE NUM FROM ABONNE A1 WHERE A1.NUMM=201701
UNION
SELECT DISTINCT A2.NUMAMI FROM AMI A2 WHERE A2.NUMM=201701)
MINUS
SELECT DISTINCT J.NUMM FROM PHOTO P INNER JOIN JAIME J ON P.NUMPHOTO=J.NUMPHOTO AND P.NUMM=201701);

---------------------------------------------------------------------------------------------------------------------

--Cleaning part
drop table abonne cascade constraints;
drop table ami cascade constraints;
drop table commentaire cascade constraints;
drop table jaime cascade constraints;
drop table membre cascade constraints;
drop table photo cascade constraints;
--Premiere partie : Evolution

--Tache 1
Alter table MEMBRE add nAmis integer default 0;
--Tache 2
Alter table COMMENTAIRE modify contenu varchar2(140);
--Tache 3
Alter table membre modify typeprofil default 'P';
--Tache 4
Alter table ami add (dateAmitier DATE not null);

--Tache 5
/*
* ATTENTION, nous voyons la relation d'amitier comme etant bidirectionnelle. Ainsi, si A est ami avec B, alors B est ami avec A. Il faut donc
* deux entrees dans la table AMI pour representer une relation d'amitie.
*/
--TEST CASE

/*insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into AMI values (201701, 201702, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201702, 201701, to_date('03/05/2008','DD/MM/YYYY'));
*/

create or replace trigger incrementeNAmis
after insert on AMI
for each row
declare
currentNAmis MEMBRE.namis%type;
begin
select membre.namis into currentNAmis from membre where membre.numm = :NEW.numM;
update MEMBRE set membre.nAmis = currentNAmis + 1 where membre.numM = :NEW.numM;
end;

--Tache 6

--TEST CASE
/*
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201703, 'chicha', 'framboise',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into ABONNE values (201701, 201702, to_date('03/05/2008','DD/MM/YYYY'), null);
insert into ABONNE values (201701, 201703, to_date('03/05/2008','DD/MM/YYYY'), null);
update abonne set abonne.finabonnement = to_date('03/05/2008','DD/MM/YYYY') where abonne.numAbonne = 201702;
update abonne set abonne.finabonnement = to_date('03/05/2008','DD/MM/YYYY') where abonne.numAbonne = 201703;
*/

create or replace trigger mettreAjourAbonnes
after insert or update on ABONNE
for each row
declare
currentNAbonne MEMBRE.nabonne%type;
begin
select MEMBRE.nabonne into currentNAbonne from MEMBRE where membre.numm = :NEW.numM;
if(:new.finabonnement is null) then
    update membre set membre.nabonne = currentNAbonne + 1 where membre.numM = :NEW.numM;
else 
    update membre set membre.nabonne = currentNAbonne - 1 where membre.numM = :new.numM;
end if;
end;

--Tache 7

--TEST CASE
/*
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into PHOTO values (1, 201701, 'test', 'uneDesc', to_date('03/05/2008','DD/MM/YYYY'), null);
insert into JAIME values (1, 201701);
insert into JAIME values (1, 201702);
*/

create or replace trigger SayNoToNarcisism
before insert or update on JAIME
for each row
declare
proprioPhoto photo.numM%type;
begin
select photo.numM into proprioPhoto from photo where photo.numPhoto = :NEW.numPhoto;
if (proprioPhoto = :NEW.Numm) then
    raise_application_error(-20991, 'Erreur : un utilisateur ne peut pas aimer sa propre photo.');
end if;
end;

--Tache 8

--Test case

/*
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','p', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'itni', 'bial',null, 'testt','v', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201703, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
*/

create or replace trigger toUpperProfilType
before insert or update on MEMBRE
for each row
begin
:NEW.typeProfil := upper(:NEW.typeProfil);
end;

--Tache 9
--Test case

/*insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into ABONNE values (201701, 201702, to_date('03/05/2008','DD/MM/YYYY'), to_date('03/05/2007','DD/MM/YYYY'));
*/
create or replace trigger verifierFinAbonnementRealiste
before insert or update on ABONNE
for each row
begin
if (:NEW.finAbonnement is not null) then
    if(:NEW.debutAbonnement > :NEW.finAbonnement) then
        raise_application_error(-20992, 'Erreur : la date de fin dabonnement doit etre posterieure a la date debut dabonnement ');
    end if;
end if;
end;

--Tache 10


--Test case

/*insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201703, 'chicha', 'pomme',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into ABONNE values (201701, 201703, to_date('03/05/2008','DD/MM/YYYY'), null);
insert into AMI values (201701, 201702, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201702, 201701, to_date('03/05/2008','DD/MM/YYYY'));
insert into PHOTO values (1, 201701, 'test', 'uneDesc', to_date('03/05/2008','DD/MM/YYYY'), null);
--Lui devrais marcher
insert into JAIME values (1, 201702);
--Eux nope
insert into JAIME values (1, 201703);
update JAIME set jaime.numM = 201703 where jaime.numM = 201702;
*/
create or replace trigger doitEtreAmiPourAimer
before insert or update on JAIME
for each row
declare
proprioPhoto photo.numM%type;
isFriendWith integer;
begin
select photo.numM into proprioPhoto from photo where photo.numPhoto = :NEW.numPhoto;
select count(AMI.numM) into isFriendWith from AMI where AMI.numAmi = :NEW.numM and AMI.numM = proprioPhoto;
if(isFriendWith < 1) then
    raise_application_error(-20993, 'Erreur : seuls les amis de la peronne qui a publie la photo peuvent laimer ');
end if;
end;


--TEST CASE TACHE 11

/*insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
*/

--TEST CASE TACHE 12

/*insert into MEMBRE values (201703, 'Chicha', 'raison',null, 'testt2','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);*/

--TEST CASE TACHE 13

/*insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201703, 'chicha', 'peche',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201704, 'chicha', 'pomme',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201705, 'chicha', 'orange',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201706, 'chicha', 'citron',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);


insert into AMI values (201701, 201702, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201702, 201701, to_date('03/05/2008','DD/MM/YYYY'));

insert into AMI values (201702, 201703, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201703, 201702, to_date('03/05/2008','DD/MM/YYYY'));

insert into AMI values (201702, 201705, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201705, 201702, to_date('03/05/2008','DD/MM/YYYY'));

insert into AMI values (201701, 201703, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201703, 201701, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201701, 201704, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201704, 201701, to_date('03/05/2008','DD/MM/YYYY'));

insert into AMI values (201701, 201705, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201705, 201701, to_date('03/05/2008','DD/MM/YYYY'));

insert into ABONNE values (201701, 201705, to_date('03/05/2008','DD/MM/YYYY'), null);
insert into ABONNE values (201701, 201706, to_date('03/05/2008','DD/MM/YYYY'), null);

insert into PHOTO values (1, 201701, 'test', 'uneDesc', to_date('03/05/2008','DD/MM/YYYY'), null);
insert into PHOTO values (2, 201701, 'test', 'uneDesc', to_date('03/05/2008','DD/MM/YYYY'), null);
insert into PHOTO values (3, 201703, 'test2', 'uneDesc2', to_date('03/05/2008','DD/MM/YYYY'), null);
insert into PHOTO values (4, 201705, 'test4', 'uneDesc4', to_date('03/05/2008','DD/MM/YYYY'), null);
insert into PHOTO values (5, 201705, 'test5', 'uneDesc5', to_date('03/05/2008','DD/MM/YYYY'), null);
insert into PHOTO values (6, 201706, 'test5', 'uneDesc5', to_date('03/05/2008','DD/MM/YYYY'), null);

insert into COMMENTAIRE values (1, 201702, 1, 'test');
insert into COMMENTAIRE values (2, 201702, 1, 'test2');
insert into COMMENTAIRE values (3, 201702, 2, 'test3');
insert into COMMENTAIRE values (4, 201701, 1, 'test3');
insert into COMMENTAIRE values (5, 201701, 1, 'test3');
*/

--Querry T13 (a mettre dans le programme java)
with
lesHyperActifs as (
select distinct membre.numM from Membre inner join ami on membre.numM = ami.numM inner join photo on photo.numM = ami.numAmi 
group by membre.numM having count(photo.numM) = (select count(distinct commentaire.numPhoto) from commentaire where commentaire.numM = membre.numM group by commentaire.numM)
union
select distinct membre.numM from Membre inner join abonne on membre.numM = abonne.numM inner join photo on photo.numM = abonne.numAbonne where abonne.finAbonnement is null
group by membre.numM having count(photo.numM) = (select count(distinct commentaire.numPhoto) from commentaire where commentaire.numM = membre.numM group by commentaire.numM)
)
select membre.nom, membre.prenom from membre where membre.numM in (select lesHyperActifs.* from lesHyperActifs);


--TEST CASE TACHE 14


/*insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201703, 'chicha', 'peche',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201704, 'chicha', 'pomme',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201705, 'chicha', 'orange',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201706, 'chicha', 'citron',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);


insert into AMI values (201701, 201702, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201702, 201701, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201701, 201703, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201703, 201701, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201701, 201704, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201704, 201701, to_date('03/05/2008','DD/MM/YYYY'));

insert into AMI values (201702, 201703, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201702, 201704, to_date('03/05/2008','DD/MM/YYYY'));
*/
--querry a mettre dans le programme java :
with
mbreEtNmbreAmi as (select AMI.numM, count(AMI.numAmi) as nombreAmi from AMI group by AMI.numM),
lesPlusPopulaires as (select mbreEtNmbreAmi.numM from mbreEtNmbreAmi where mbreEtNmbreAmi.nombreAmi = (select max(mbreEtNmbreAmi.nombreAmi) from mbreEtNmbreAmi))
select MEMBRE.nom, MEMBRE.prenom from MEMBRE where MEMBRE.numM in (select lesPlusPopulaires.* from lesPlusPopulaires);


