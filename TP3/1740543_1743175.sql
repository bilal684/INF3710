--Table cleaning section
drop table MEMBRE cascade constraints;
drop table ABONNE cascade constraints;
drop table AMI cascade constraints;
drop table PHOTO cascade constraints;
drop table COMMENTAIRE cascade constraints;
drop table JAIME cascade constraints;

--******************************QUESTION 1 - CREATION DE TABLE******************************
/*
* Instruction pour la creation de la table MEMBRE.
*/
create table MEMBRE (
numM integer constraint MEMBRE_PK primary key,
nom varchar(50) not null,
prenom varchar(50) not null,
photoM varchar(14),
Email varchar(50) not null,
typeProfil char(1) not null constraint CHECK_PROFIL_TYPE check(typeProfil in ('P','V')),
dateInscription date not null,
nAbonne integer default 0 not null
);

/*
* Instruction pour la creation de la table ABONNE.
*/
create table ABONNE(
numM integer constraint ABONNE_MEMBRE_NUMM_REF references MEMBRE(numM),
numAbonne integer constraint ABONNE_MEMBRE_NUMABONNE_REF references MEMBRE(numM),
debutAbonnement date not null,
finAbonnement date,
constraint ABONNE_COMPOSITE_PK primary key (numM, numAbonne)
);
/*
* Instruction pour la creation de la table ABONNE.
*
* NOUS VOYONS LA RELATION D'AMITIER COMME ETANT BIDIRECTIONNELLE! Donc si A est ami avec B, alors B est ami avec A. 
* Donc deux entrer dans la table AMI pour 1 relation d'amitier.
*/
create table AMI (
numM integer constraint AMI_MEMBRE_NUMM_REF references MEMBRE(numM),
numAmi integer constraint AMI_MEMBRE_NUMAMI_REF references MEMBRE(numM),
constraint AMI_COMPOSITE_PK primary key (numM, numAmi)
);

/*
* Instruction pour la creation de la table PHOTO.
*/
create table PHOTO (
numPhoto integer constraint PHOTO_PK primary key,
urlPhoto varchar(255),
descriptionPhoto VARCHAR(500),
debutPublication date not null,
finPublication date,
numM integer not null constraint PHOTO_MEMBRE_NUMM_REF references MEMBRE(numM)
);

/*
* Instruction pour la creation de la table COMMENTAIRE.
*/
create table COMMENTAIRE (
numPhoto integer constraint COMMENTAIRE_PHOTO_NUMPHOTO_REF references PHOTO(numPhoto),
numM integer constraint COMMENTAIRE_PHOTO_NUMM_REF references MEMBRE(numM),
noComm integer,
contenu varchar(255) not null,
constraint COMMENTAIRE_COMPOSITE_PK primary key (numPhoto, numM, noComm)
);

/*
* Instruction pour la creation de la table JAIME.
*/
create table JAIME (
numPhoto integer constraint JAIME_PHOTO_NUMPHOTO_REF references PHOTO(numPhoto),
numM integer constraint JAIME_MEMBRE_NUMM_REF references MEMBRE(numM),
constraint JAIME_COMPOSITE_PK primary key (numPhoto, numM)
);

--******************************QUESTION 2 - REQUETES******************************

--**********R1**********

--Test case
/*insert into MEMBRE values (201701, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201702, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201703, 'test ', 'test2',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into AMI values (201701, 201702);
insert into AMI values (201701, 201703);*/
/*
* **********R1 Query**********
* Ici, il s'agit de trouver l'ensemble des amis du membre dont numM = 201701 
* Pour chaque element de l'ensemble ci-haut, on prend son nom et prenom dans
* la table MEMBRE.
*/
select MEMBRE.nom, MEMBRE.prenom from MEMBRE where MEMBRE.numM in (select AMI.numAmi from AMI where AMI.numM = 201701);

--**********R2**********
--Test case 
/*insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201703, 'test ', 'test2',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201704, 'test1 ', 'test3',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201705, 'test2 ', 'test4',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into AMI values (201701, 201702);
insert into AMI values (201702, 201701);
insert into AMI values (201703, 201702);
insert into AMI values (201702, 201703);
insert into AMI values (201701, 201704);
insert into AMI values (201704, 201701);
insert into AMI values (201704, 201705);
insert into AMI values (201705, 201704);*/
--**********R2 Query**********
/*
* **********R2 Query**********
* Ici, il s'agit de trouver l'ensemble des amis du membre dont numM = 201701.
* Ensuite, il faut trouver l'ensemble des amis des amis du membre dont numM = 201701.
* Or, comme nous voyons la relation AMI comme etant bidirectionnelle (voir commentaire de la creation table AMI),
* il faut enlever le membre 201701 de cette ensemble, car dans le resultat, il va etre present et c'est 
* incorrect de dire que 201701 est ami en commun avec lui meme (d'ou le minus dans amisDesAmisDe201701).
* L'ensemble resultant correspond a l'ensemble membres ayant un ou plusieurs ami en commun avec avec 201701.
* De cet ensemble, on se refere a la table MEMBRE pour obtenir les informations propre membres ayant des amis en commun avec 201701. 
* Finalement, on ordonne le resultat par ordre decroissant de nom et de prenom (order by, 
* il est necessaire de specifier desc, car par defaut, order by ordonne de facon ascendante).
*/
with 
mbre201701 as (select MEMBRE.numM from MEMBRE where MEMBRE.numM = 201701),
amiDe201701 as (select AMI.numAmi from AMI where AMI.numM = (select mbre201701.numM from mbre201701)),
amisDesAmisDe201701 as (select AMI.numAmi from AMI, amiDe201701 where AMI.numM = amiDe201701.numAmi minus select mbre201701.numM from mbre201701)
select MEMBRE.* from MEMBRE where MEMBRE.numM in (select amisDesAmisDe201701.numAmi from amisDesAmisDe201701) 
order by MEMBRE.nom desc , MEMBRE.prenom desc;

--**********R3**********
--Test case
/*insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201703, 'shisha', 'pommeVerte',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201704, 'shisha', 'fraise',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201705, 'shisha', 'citron',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201706, 'shisha', 'banane',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201707, 'shisha', 'raisin',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
--201701 ami avec 5 personne
insert into AMI values (201701, 201702);
insert into AMI values (201701, 201703);
insert into AMI values (201701, 201704);
insert into AMI values (201701, 201705);
insert into AMI values (201701, 201706);
insert into AMI values (201702, 201701);
insert into AMI values (201703, 201701);
insert into AMI values (201704, 201701);
insert into AMI values (201705, 201701);
insert into AMI values (201706, 201701);
--201707 ami avec 3 ami de 201701
insert into AMI values (201707, 201702);
insert into AMI values (201702, 201707);
insert into AMI values (201707, 201703);
insert into AMI values (201703, 201707);
insert into AMI values (201707, 201704);
insert into AMI values (201704, 201707);
insert into AMI values (201703, 201704);
insert into AMI values (201704, 201703);

insert into AMI values (201703, 201705);
insert into AMI values (201705, 201703);
insert into AMI values (201703, 201702);
insert into AMI values (201702, 201703);
insert into AMI values (201704, 201705);
insert into AMI values (201705, 201704);*/

--tester que si il a 4 ami, son nom sort pas
/*insert into AMI values (201707, 201705);
insert into AMI values (201705, 201707);*/
--doit donner shisha pomme verte & shisha raisin

--**********R3 Query**********
/*
* **********R3 Query**********
* L'idee ici est semblable a R2, a quelques difference pret. On commence par trouver
* l'ensemble des amis de 201701. Ensuite, on va trouver l'ensemble des amis des amis de 201701.
* Ici, a l'inverse de R2, nous avons decider de travailler avec les numM et les numAmi contrairement a R2. 
* Donc, comme la relation AMI est bidirectionnelle (voir commentaire lors de la creation de la table AMI),
* nous devons soustraire les elements ou un ami est ami avec 201701 et vise versa. (D'ou le minus de l'union
* dans la table virtuelle amisDesAmisDe201701). Finalement, il faut trouver les amis des amis qui ont exactement
* trois amis en commun avec 201701, d'ou l'usage du ''group by ... having'' et du ''count'' dans troisAmisEnComm201701.
* Ainsi, l'ensemble troisAmisEnComm201701 ne contiendra que les membres ayant exactement trois amis en commun
* avec 201701. Finalement, on recupere les informations aux membres dans troisAmisEnComm201701 dans la table
* MEMBRE et on les ordonne par ordre croissant de nom et de prenom (order by,
* ici il n'est pas necessaire de specifier asc, car order by le fait par defaut. Or, pour une question de
* rigueur et de clarete, nous le faisons.)
*/
with
amiDe201701 as (select AMI.numAmi from AMI where AMI.numM = 201701),
amisDesAmisDe201701 as (select AMI.numM, AMI.numAmi from AMI inner join amiDe201701 on AMI.numM = amiDe201701.numAmi where AMI.numM = amiDe201701.numAmi minus 
(select AMI.numM, AMI.numAmi from MEMBRE inner join AMI on MEMBRE.numM = AMI.numM where MEMBRE.numM = 201701 union 
select AMI.numM, AMI.numAmi from MEMBRE inner join AMI on MEMBRE.numM = AMI.numM where AMI.numAmi = 201701 )),
troisAmisEnComm201701 as (select amisDesAmisDe201701.numAmi, count(amisDesAmisDe201701.numM) from amisDesAmisDe201701 group by amisDesAmisDe201701.numAmi having count(amisDesAmisDe201701.numM) = 3)
select MEMBRE.* from MEMBRE inner join troisAmisEnComm201701 on MEMBRE.numM = troisAmisEnComm201701.numAmi
order by MEMBRE.nom asc, MEMBRE.prenom asc;

--**********R4**********
--Test case
/*insert into MEMBRE values (201700, 'haboub', 'shisha',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201703, 'shisha', 'citron',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201704, 'shisha', 'carotte',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into PHOTO values (1, 'test', 'uneDesc',to_date('03/05/2008','DD/MM/YYYY'), null, 201700);
insert into PHOTO values (2, 'test2', 'uneDesc2',to_date('03/05/2008','DD/MM/YYYY'), null, 201700);
insert into COMMENTAIRE values (1, 201701, 1, 'test');
insert into COMMENTAIRE values (1, 201701, 2, 'test2');
insert into COMMENTAIRE values (1, 201701, 3, 'test3');
insert into COMMENTAIRE values (1, 201702, 4, 'test4');
insert into COMMENTAIRE values (1, 201701, 5, 'test3');
insert into COMMENTAIRE values (1, 201702, 5, 'test5');
insert into COMMENTAIRE values (2, 201702, 1, 'test6');
insert into COMMENTAIRE values (2, 201702, 2, 'test7');
insert into COMMENTAIRE values (2, 201702, 3, 'test8');
insert into COMMENTAIRE values (2, 201702, 4, 'test8');
insert into COMMENTAIRE values (2, 201703, 5, 'test9');*/
/*
* **********R4 Query**********
* Ici, il s'agit de trouver l'ensemble des membres ayant commenter une photo. Nous avons donc
* creer l'ensemble mbresCommPhoto qui contient cette information. Ensuite, il faut trouver les
* commentaires associer aux photo. Ici, il est necessaire d'utiliser ''DISTINCT'' lors de la recherche
* pour eliminer les ranger qui se repete. Cette ensemble est represente par commentairePhoto.
* Ensuite, il faut trouver l'ensemble representant les membres ayant commenter plus de trois fois une meme photo,
* Il est donc necessaire d'utiliser un ''group by ... having'' et ''count''. Finalement, on se refere a la table
* MEMBRE pour obtenir les informations propre aux membres ayant commenter plus de trois fois une meme photo.
*/
with
mbresCommPhoto as (select MEMBRE.* from MEMBRE inner join COMMENTAIRE on MEMBRE.numM = COMMENTAIRE.numM),
commentairePhoto as (select DISTINCT COMMENTAIRE.* from COMMENTAIRE inner join mbresCommPhoto on COMMENTAIRE.numM = mbresCommPhoto.numM),
commPlus3fois as (select commentairePhoto.numPhoto, commentairePhoto.numM, count(commentairePhoto.numM) from commentairePhoto 
group by commentairePhoto.numPhoto, commentairePhoto.numM having count(commentairePhoto.noComm) > 3)
select MEMBRE.nom, MEMBRE.prenom from MEMBRE where MEMBRE.numM in (select commPlus3fois.numM from commPlus3fois);
--**********R5**********
--Test case
/*insert into MEMBRE values (201700, 'haboub', 'shisha',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);

insert into MEMBRE values (201702, 'allo', 'shisha',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201703, 'mehdi', 'kadi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201704, 'shisha', 'menthe',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);

insert into PHOTO values (1, 'test', 'uneDesc',to_date('03/05/2008','DD/MM/YYYY'), null, 201700);
insert into PHOTO values (2, 'test2', 'uneDesc2',to_date('03/05/2008','DD/MM/YYYY'), null, 201701);
insert into PHOTO values (3, 'test3', 'uneDesc',to_date('03/05/2008','DD/MM/YYYY'), null, 201700);
insert into JAIME values (1, 201702);
insert into JAIME values (2, 201704);
insert into JAIME values (3, 201703);
insert into JAIME values (1, 201704);
insert into JAIME values (1, 201703);*/
/*
* **********R5 Query**********
* Ici, nous avons recupere l'ensemble des membres ayant publie des photos (membreAyantPubliePhoto). Pour ce faire,
* il est necessaire d'utiliser ''DISTINCT'', car il est possible qu'un membre ai publie plus d'une photo. Ensuite, 
* nous avons recuperer l'ensemble des photo ayant ete publie par ces memes membres (photoDesMembreAyantPublie).
* Ensuite, nous avons recuperer l'ensemble des ''jaime'' associes a chacune des photos publies (jaimeAssocieAuPhotos).
* Ensuite, nous avons recuperer le nombre de jaime par photo pour chaque membre ayant publie des photos, d'ou l'usage du 'group by' dans nombreJaimeParPhoto.
* Ensuite, nous avons recuperer le nombre moyen de jaime par photo pour chaque membre ayant publie des photos,
* d'ou l'usage de 'AVG' et du 'group by' (nombreMoyenJaimeParPhoto).
* Finalement, nous avons recuperer les informations propres de ces membres et le nombre moyen de jaime qu'ils
* ont obtenus pour tout les photos qu'ils ont publies. Attention, ici il est necessaire de faire un left join
* dans la mesure ou on nous demande la moyenne des jaime de toute les photos publie pour CHAQUE membre et non uniquement la moyenne
* pour les membres ayant publie uniquement des photos. Le left join va indiquer ''null'' dans la colonne MOYENNEJAIMEPOURPHOTOPUBLIE,
* car ces membres on publie aucune photo. La valeur ''null'' ici est equivalante a la valeur '0', donc une moyenne de 0 'jaime'.
*/
with
membreAyantPubliePhoto as (select DISTINCT MEMBRE.* from MEMBRE inner join PHOTO on MEMBRE.numM = PHOTO.numM),
photoDesMembreAyantPublie as (select PHOTO.* from PHOTO inner join membreAyantPubliePhoto on PHOTO.numM = membreAyantPubliePhoto.numM),
jaimeAssocieAuPhotos as (select JAIME.numPhoto, JAIME.numM personneAimer, photoDesMembreAyantPublie.numM proprioPhoto from JAIME inner join photoDesMembreAyantPublie on JAIME.numPhoto = photoDesMembreAyantPublie.numPhoto),
nombreJaimeParPhoto as (select jaimeAssocieAuPhotos.numPhoto, jaimeAssocieAuPhotos.proprioPhoto, count(jaimeAssocieAuPhotos.personneAimer) as nbreJaime from jaimeAssocieAuPhotos group by jaimeAssocieAuPhotos.numPhoto, jaimeAssocieAuPhotos.proprioPhoto),
nombreMoyenJaimeParPhoto as (select nombreJaimeParPhoto.proprioPhoto, AVG(nombreJaimeParPhoto.nbreJaime) as moyenneJaimePourPhotoPubliee from nombreJaimeParPhoto group by nombreJaimeParPhoto.proprioPhoto)
select MEMBRE.*, nombreMoyenJaimeParPhoto.moyenneJaimePourPhotoPubliee from MEMBRE left join nombreMoyenJaimeParPhoto on MEMBRE.numM = nombreMoyenJaimeParPhoto.proprioPhoto;

--**********R6**********
--Test case
/*insert into MEMBRE values (201701, 'mehdi', 'kadi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201702, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201703, 'allo', 'shisha',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201704, 'shisha', 'menthe',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201705, 'shisha', 'citron',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201706, 'shisha', 'raison',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
insert into MEMBRE values (201707, 'shisha', 'banane',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default);
--Les photos de 201701
insert into PHOTO values (1, 'test', 'uneDesc',to_date('03/05/2008','DD/MM/YYYY'), null, 201701);
insert into PHOTO values (2, 'test2', 'uneDesc2',to_date('03/05/2008','DD/MM/YYYY'), null, 201701);

--Amis ayant aimer une des photos:
insert into JAIME values (1, 201702);
insert into JAIME values (1, 201706);
insert into JAIME values (1, 201707);


--Les amis de 201701 (nous voyons la relation d'amitier comme etant bidirectionnelle).
--AMI : 201702, 201703, 201707
insert into AMI values (201701, 201702);
insert into AMI values (201702, 201701);
insert into AMI values (201701, 201703);
insert into AMI values (201703, 201701);
insert into AMI values (201701, 201707);
insert into AMI values (201707, 201701);
--Les abonne de 201701
--201704, 201705, 201706 et 201707
insert into ABONNE values (201701, 201704, to_date('03/05/2008','DD/MM/YYYY'), null);
insert into ABONNE values (201701, 201705, to_date('03/05/2008','DD/MM/YYYY'), null);
insert into ABONNE values (201701, 201706, to_date('03/05/2008','DD/MM/YYYY'), null);
insert into ABONNE values (201701, 201707, to_date('03/05/2008','DD/MM/YYYY'), null);*/
--**********R6 Query**********
/*
* Nous avons tout d'abord recupere les amis et les abonnes du membre 201701. 
* Ensuite nous avons cree l'ensemble qui contient les amis ou les abonnés du membre 201701 grace a une union.   
* Apres nous trouve les photos du membre 201701.  
* Apres nous avons trouve tous les membres qui ont aime les photos du membre 201701. 
* Apres nous avons trouve les amis ou abonnes du membre qui ne figurent pas dans l'ensemble des membres qui ont aime les
* photos du membre 201701 grace a la fonctionnalite 'not in'.
* Finalement, on trouve les informations propres (nom et prenom) aux elements de ce dernier ensemble dans la table MEMBRE.   
*/
with 
amiAvec201701 as (select AMI.numM from AMI where AMI.numAmi = 201701),
abonneDe201701 as (select ABONNE.numAbonne from ABONNE where ABONNE.numM = 201701),
amiOuAbonneDe201701 as (select amiAvec201701.numM from amiAvec201701 union select abonneDe201701.numAbonne from abonneDe201701),
photosDe201701 as (select PHOTO.numPhoto from PHOTO where PHOTO.numM = 201701),
mbreAimePhotoDe201701 as (select JAIME.numM from JAIME where JAIME.numPhoto in (select photosDe201701.numPhoto from photosDe201701)),
amiEtAbonneJamaisAime as (select amiOuAbonneDe201701.numM from amiOuAbonneDe201701 where amiOuAbonneDe201701.numM not in (select mbreAimePhotoDe201701.numM from mbreAimePhotoDe201701))
select MEMBRE.nom, MEMBRE.prenom from MEMBRE where MEMBRE.numM in (select amiEtAbonneJamaisAime.numM from amiEtAbonneJamaisAime);
