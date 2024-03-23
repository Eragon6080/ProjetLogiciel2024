-- create a table
/*CREATE TABLE test(
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name TEXT NOT NULL,
  archived BOOLEAN NOT NULL DEFAULT FALSE
);

-- add test data
INSERT INTO test (name, archived)
  VALUES ('test row 1', true),
  ('test row 2', false);
*/
CREATE TABLE Personne(
  idPersonne INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  nom TEXT NOT NULL,
  prenom TEXT NOT NULL,
  mail TEXT NOT NULL UNIQUE CHECK (mail ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
  motDePasse TEXT NOT NULL CHECK (length(motDePasse) >= 8),
  rolePersonne TEXT NOT NULL CHECK(rolePersonne in ('etudiant', 'prof', 'admin','superviseur'))
);
CREATE TABLE Periode(
  idPeriode INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  annee int NOT NULL,
  delaiPremierePartie DATE NOT NULL,
  delaiDeuxiemePartie DATE NOT NULL,
  delaiTroisiemePartie DATE NOT NULL,
  delaiFinal DATE NOT NULL

);
CREATE TABLE Professeur(
  idProf INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  specialite TEXT NOT NULL,
  idPersonne INT NOT NULL,
  idPeriode INT NOT NULL,
  FOREIGN KEY (idPersonne) REFERENCES Personne(idPersonne),
  FOREIGN KEY (idPeriode) REFERENCES Periode(idPeriode)
);
CREATE TABLE Sujet(
  idSujet INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  titre TEXT NOT NULL,
  descriptif TEXT NOT NULL,
  fichier BYTEA,
  idPeriode INT NOT NULL,
  idProf INT NOT NULL,
  FOREIGN KEY (idPeriode) REFERENCES Periode(idPeriode),
  FOREIGN KEY (idProf) REFERENCES Professeur(idProf)

);
CREATE TABLE UE(
  idUE INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- matricule de l'UE
  nom TEXT NOT NULL,
  idProf INT NOT NULL,
  FOREIGN KEY (idProf) REFERENCES Professeur(idProf)
);
CREATE TABLE Cours( -- re
  idCours INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  idUE INT NOT NULL,
  nom TEXT NOT NULL,
  FOREIGN KEY (idUE) REFERENCES UE(idUE)
);
CREATE TABLE ETUDIANT(
  idEtudiant INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  bloc INT NOT NULL check(bloc >= 1 and bloc <= 5),
  idPersonne INT NOT NULL,
  idSujet INT NOT NULL,
  FOREIGN KEY (idPersonne) REFERENCES Personne(idPersonne),
  FOREIGN KEY (idSujet) REFERENCES Sujet(idSujet)
);
CREATE TABLE Inscription(
  idInscription INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  idEtudiant INT NOT NULL,
  idCours INT NOT NULL,
  FOREIGN KEY (idEtudiant) REFERENCES Etudiant(idEtudiant),
  FOREIGN KEY (idCours) REFERENCES Cours(idCours)
);



-- add insertion data
INSERT INTO Personne (nom, prenom, mail,motDePasse, rolePersonne)
  VALUES ('Doe', 'John', 'john.doe@gmail.com','Valmeinier23.', 'etudiant'),
        ('Doe', 'Jane', 'jane.doe@gmail.com','Valmeinier23.','etudiant'),
        ('Doe', 'Rick','ricke.doe@gmail.com','Valmeinier23.','etudiant'),
        ('Doe', 'Rudolf','rudolf.doe@gmail.com','Valmeinier23.','etudiant'),
        ('Doe', 'Jack', 'jack.doe@gmail.com','Valmeinier23.','prof'),
        ('Doe', 'Jill', 'jill.doe@gmail.com','Valmeinier23.','prof'),
        ('Doe', 'James', 'james.doe@gmail.com','Valmeinier23.','admin'),
        ('Doe', 'Jenny', 'jenny.doe@gmail.com','Valmeinier23.','superviseur');
INSERT INTO Periode (annee, delaiPremierePartie, delaiDeuxiemePartie, delaiTroisiemePartie, delaiFinal)
  VALUES (EXTRACT(YEAR FROM TIMESTAMP '2024-01-01'), '2024-02-02', '2024-03-12', '2024-04-28', '2022-05-27'),
        (EXTRACT(YEAR FROM TIMESTAMP '2024-01-01'), '2024-02-02', '2024-03-12', '2024-04-28', '2022-05-27');

INSERT INTO Professeur (specialite, idPersonne, idPeriode)
  VALUES ('IA', 3, 1),
        ('ML', 4, 2);
INSERT INTO Sujet (titre, descriptif, fichier, idPeriode, idProf)
  VALUES ('La reproduction des insectes', 'Les insectes sont des animaux ovipares', NULL, 1, 1),
        ('L IA', 'L intelligence artificelle est un système informatique capable d apprendre par lui-même', NULL, 2, 2);
INSERT INTO UE (nom, idProf)
  VALUES ('Introduction à la démarche scientifique', 1),
        ('Mémoire', 2);
INSERT INTO Cours (idUE, nom)
  VALUES (1, 'Introduction à la démarche scientifique'),
        (2, 'Mémoire');
INSERT INTO ETUDIANT (bloc, idPersonne, idSujet)
  VALUES (1, 1, 1),
        (2, 2, 2),
        (3, 3, 1),
        (4, 4, 2);
INSERT INTO Inscription (idEtudiant, idCours)
  VALUES (1, 1),
        (2, 2),
        (3, 1),
        (4, 2);