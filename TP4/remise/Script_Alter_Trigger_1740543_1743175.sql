/*
--Cleaning part
drop table abonne cascade constraints;
drop table ami cascade constraints;
drop table commentaire cascade constraints;
drop table jaime cascade constraints;
drop table membre cascade constraints;
drop table photo cascade constraints;
*/

--Tache 1
/*
* ***** Methodologie adoptee *****
* Ici, il suffit de modifier la table et d'utiliser la close ''default'' pour indiquer que la
* valeur par defaut de nAmis est 0.
*/
Alter table MEMBRE add nAmis integer default 0;
--Tache 2
/*
* ***** Methodologie adoptee *****
* Ici, il suffie de modifier la table commentaire et d'utiliser la close ''modify'' sur l'attribut ''contenu''
* et de specifier la nouvelle taille du varchar2.
*/
Alter table COMMENTAIRE modify contenu varchar2(140);
--Tache 3
/*
* ***** Methodologie adoptee *****
* Ici, il suffie de modifier la table membre et d'utiliser la close ''modify'' sur l'attribut ''typeprofil''
* et de specifier que la valeur par defaut est 'V'.
*/
Alter table membre modify typeprofil default 'V';
--Tache 4
/*
* ***** Methodologie adoptee *****
* Ici, il suffie de modifier la table membre et d'utiliser la close ''add'' pour ajouter
* une nouvelle colonne, soit dateAmitier de type date. Nous jugeons necessaire ici de specifier la contrainte
* de non nulliter sur ce nouvelle attribue.
*/
Alter table ami add (dateAmitier DATE not null);

--Tache 5
/*
* ATTENTION, nous voyons la relation d'amitier comme etant bidirectionnelle. Ainsi, si A est ami avec B, alors B est ami avec A. Il faut donc
* deux entrees dans la table AMI pour representer une relation d'amitie.
*/
--TEST CASE

/*
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into AMI values (201701, 201702, to_date('03/05/2008','DD/MM/YYYY'));
insert into AMI values (201702, 201701, to_date('03/05/2008','DD/MM/YYYY'));
*/
/*
* ***** Methodologie adopte *****
* L'idee ici est d'incrementer le champs namis de la table membre. Donc
* initialement, on stock dans une variable le nombre d'ami initiale et apres
* l'insertion, on incremente cette valeur et on la remet dans nAmis.
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

/*
* ***** Methodologie adopte *****
* L'idee ici est d'incrementer ou de decrementer le nombre d'abonne qu'un membre a. Donc
* apres une insertion ou une mise a jour de la table abonne, on verifie si le champ
* fin abonnement est null ou non. S'il est null, on incremente le nombre d'abonner
* courant que l'on aura prealablement stocker dans une variable. Sinon, il est imperatif
* de verifier que le nombre d'abonne courant est > 0, car on veux eviter le cas ou 
* quelqun insere une ligne abonne avec debutabonnement et finabonnement non null alors
* que le dit abonne avais aucun abonne. On risquerai de se retrouver avec -1 comme nombreAbonne
* et on ne veux pas ca. Si le nombre d'abonne est plus grand que 0, alors on decremente.
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
	if(currentNAbonne > 0) then
        update membre set membre.nabonne = currentNAbonne - 1 where membre.numM = :new.numM;
	end if;
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
/*
* ***** Methodologie adopte *****
* L'idee ici est d'empecher les membres d'obtenir la reputation de narcisique. Ainsi, avant l'insertion
* ou la mise a jour de la table JAIME, on verifie si l'id du membre qui vien d'aimer une
* photo est egale au proprietaire de la photo. Si c'est le cas, alors on lance une erreur.
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
/*
* ***** Methodologie adopte *****
* Ici, l'idee est de toujours stocker le type de profil en lettre majuscule. Ainsi,
* avant l'insertion ou la mise a jour de la table membre, on applique 
* la fonction ''upper'' sur le champ ''typeProfil''.
*/
create or replace trigger toUpperProfilType
before insert or update on MEMBRE
for each row
begin
:NEW.typeProfil := upper(:NEW.typeProfil);
end;

--Tache 9
--Test case

/*
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into ABONNE values (201701, 201702, to_date('03/05/2008','DD/MM/YYYY'), to_date('03/05/2007','DD/MM/YYYY'));
*/

/*
* ***** Methodologie adopte *****
* L'idee ici est de verifier qu'il y ait une certaine logique au niveau de la table ABONNE
* au niveau des dates. Il faut evidemment que la date de debutAbonnement soit inferieur a 
* la date de fin d'abonnement. Donc avant l'insertion ou la mise a jour de la table ABONNE,
* on verifie si finAbonnement est null ou non, s'il est pas null, alors une verification s'impose,
* on verifie si finAbonnement est plus petite que debutAbonnement. Si c'est le cas, alors
* nous levons une erreur qui indique cette incoherence.
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

/*
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
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

/*
* ***** Methodologie adopte *****
* Ici, l'idee est d'empecher toute personne qui n'est pas l'ami d'un certain membre d'aimer les photo du dit membre.
* Ainsi, avant l'insertion ou la modification d'un champ dans la table JAIME, on verifie stock dans une variable
* l'identifiant du proprietaire de la photo. Ensuite, on cree une variable de type integer qui va prendre uniquement
* une valeur 0 ou 1. 0 indique que la personne qui essaie d'aimer la photo n'est pas l'ami du membre. 1 inversement.
* On choisi donc de compter combien de fois la personne qui vien d'aimer la photo est ami avec le proprietaire de la photo.
* Si le count est 1, alors la personne est bien ami, sinon il ne l'ai pas. On verifie finalement la valeur de cette
* variable. Si cette derniere est inferieur a 1 (donc = 0), alors la personne qui essaie d'aimer la photo n'est pas
* l'ami du proprietaire de la photo. Le trigger vaa donc lancer une erreur.
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

--Tache 11 (voir code java pour querry)

--Test case

/*
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
insert into MEMBRE values (201702, 'kadi', 'mehdi',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
*/

--Tache 12 (voir code java pour querry)

--Test case
/*
insert into MEMBRE values (201703, 'Chicha', 'raison',null, 'testt2','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
*/

--Tache 13 (voir code java pour querry)

--Test case

/*
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
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

--Tache 14 (voir code java pour querry)

--Test case

/*
insert into MEMBRE values (201701, 'itani', 'bilal',null, 'testt','P', to_date('03/05/2008','DD/MM/YYYY'), default, default);
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