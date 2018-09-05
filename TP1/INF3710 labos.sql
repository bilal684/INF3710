-- Création des tables

-- Table numéro 1 : Departement 

CREATE TABLE Departement (
CodeDept CHAR(5) PRIMARY KEY,
NomDept CHAR(30)
);

-- Table numéro 2 : Employe 

CREATE TABLE Employe (
CodeEmp CHAR(5) PRIMARY KEY,
NomEmp CHAR(30) UNIQUE,
PrenomEmp CHAR(30) UNIQUE,
Surnom CHAR(5),
DeptEmp CHAR(5)
);

insert into departement values ('1', 'test');
insert into employe values ('1','test','test','tes','1');
insert into employe values ('2','test','test','tes','1');

drop table departement cascade constraints;

-- Table numéro 3 : Formation 

CREATE TABLE Formation (
CodeForm CHAR(8) PRIMARY KEY,
NomForm CHAR(30) NOT NULL,
NbreHeures INTEGER,
Prix DECIMAL(5, 2) NOT NULL
);

-- Table numéro 4 : Inscription

CREATE TABLE Inscription (
CodeEmp CHAR(8),-- REFERENCES Employe,
CodeForm CHAR(5),-- REFERENCES Formation,
PRIMARY KEY (CodeEmp, CodeForm)
);

--1 a 3
DROP TABLE employe;
DROP TABLE employe cascade constraints;
DROP TABLE departement cascade constraints;
drop table formation cascade constraints;
drop table inscription cascade constraints;

-- 4
alter table employe modify( NomEmp default 'monNomParDefaut' );
alter table employe modify (NomEmp not null);

INSERT INTO Formation VALUES ( 'INFO2811', 'Systèmes d''exploitation');
INSERT INTO Departement VALUES ('d0031', 'Exportation');
INSERT INTO Departement VALUES ('d0010', 'R.H.');
INSERT INTO Departement VALUES ('d0200', 'Commercial');
INSERT INTO Departement VALUES ('d0201', 'pep');

INSERT INTO Employe VALUES( 'e2998', 'Lapointe', 'Stephane', NULL, 'd0200');
INSERT INTO Employe VALUES( 'e2999', '', 'Stephane', 'test', 'd0010');

INSERT INTO Employe VALUES( 'e3004', 'mehdi', 'kadi', 'test', 'd0202');
--6
INSERT INTO Employe VALUES( 'e3005', NULL, 'kadi', 'test', 'd0203');
INSERT INTO Employe VALUES( 'e3006', NULL, 'kadi', 'test', 'd0204');
--7
drop table employe cascade constraints;
CREATE TABLE Employe (
CodeEmp CHAR(5) PRIMARY KEY,
NomEmp CHAR(30) UNIQUE,
PrenomEmp CHAR(30) UNIQUE,
Surnom CHAR(5),
DeptEmp CHAR(5)
);

--cas 1
INSERT INTO Employe VALUES( 'e3005', 'mehdi', 'kadi', 'test', 'd0203');
INSERT INTO Employe VALUES( 'e3006', 'mehdi', 'kadi', 'test', 'd0204');
drop table employe cascade constraints;
--cas 2
INSERT INTO Employe VALUES( 'e3005', 'mehdi', 'kadi', 'test', 'd0203');
INSERT INTO Employe VALUES( 'e3006', 'bilal', 'kadi', 'test', 'd0204');
drop table employe cascade constraints;
--cas 3
INSERT INTO Employe VALUES( 'e3005', NUll, NULL, 'test', 'd0203');
INSERT INTO Employe VALUES( 'e3006', NULL, NULL, 'test', 'd0204');
drop table employe cascade constraints;
--cas 4
INSERT INTO Employe VALUES( 'e3005', NUll, NULL, 'test', 'd0203');
INSERT INTO Employe VALUES( 'e3006', NULL, 'kadi', 'test', 'd0204');
drop table employe cascade constraints;

--8
drop table employe cascade constraints;
CREATE TABLE Departement (
CodeDept CHAR(5) PRIMARY KEY,
NomDept CHAR(30)
);
insert into departement values('inf', 'informatique');
insert into departement values('inf', 'infographie');
insert into departement values (null, 'informatique');
--9
drop table departement cascade constraints;
CREATE TABLE Inscription (
CodeEmp CHAR(8),-- REFERENCES Employe,
CodeForm CHAR(5),-- REFERENCES Formation,
PRIMARY KEY (CodeEmp, CodeForm)
);
-- cas1
insert into inscription values ('test', 'test');
--cas2
insert into inscription values ('test', 'test');
insert into inscription values ('test', 'test');
--cas 3
insert into inscription values (NULL, NULL);

--10
CREATE TABLE Departement (
CodeDept CHAR(5) PRIMARY KEY,
NomDept CHAR(30) UNIQUE
);
drop table employe cascade constraints;
drop table departement cascade constraints;
insert into departement values('1', 'informatique');
insert into departement values('2', 'logiciel');
insert into departement values('3', 'mathematique');
CREATE TABLE Employe (
CodeEmp CHAR(5) PRIMARY KEY,
NomEmp CHAR(30),
PrenomEmp CHAR(30),
Surnom CHAR(5),
DeptEmp CHAR(5) REFERENCES Departement on delete set null--,
--UNIQUE (DeptEmp, Surnom)
);
--cas 1
INSERT INTO Employe VALUES( '1', 'Lapointe', 'Stephane', 'test', '4');
--cas 2
INSERT INTO Employe VALUES( '1', 'Lapointe', 'Stephane', 'test', '2');
DELETE FROM departement WHERE CodeDept = '2';
--cas 3
INSERT INTO Employe VALUES( '1', 'Lapointe', 'Stephane', 'test', '2');
DELETE FROM departement WHERE CodeDept = '2';
--cas 4
INSERT INTO Employe VALUES( '1', 'Lapointe', 'Stephane', 'test', '2');
DELETE FROM departement WHERE CodeDept = '2';
--cas 4
INSERT INTO Employe VALUES( '2', 'Lapointe', 'Stephane', 'test', null);