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
  password TEXT NOT NULL CHECK (length(motDePasse) >= 8),
  role TEXT NOT NULL CHECK(rolePersonne in ('etudiant', 'prof', 'admin','superviseur')),
  last_login TEXT DEFAULT NULL,
  is_superuser BOOLEAN DEFAULT FALSE,
  is_staff BOOLEAN DEFAULT True,
  is_active BOOLEAN DEFAULT True,
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
  fichier TEXT, --  localisation du fichier de la proposition de sujet
  idPeriode INT NOT NULL,
  idProf INT NOT NULL,
  FOREIGN KEY (idPeriode) REFERENCES Periode(idPeriode),
  FOREIGN KEY (idProf) REFERENCES Professeur(idProf)

);
CREATE TABLE UE(
  idue TEXT PRIMARY KEY, -- matricule de l'UE
  nom TEXT NOT NULL,
  idProf INT NOT NULL,
  FOREIGN KEY (idProf) REFERENCES Professeur(idProf)
);
CREATE TABLE Cours( -- re
  idCours INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  idue TEXT NOT NULL,
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
  VALUES ('Doe', 'John', 'john.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=', 'etudiant'),
        ('Doe', 'Jane', 'jane.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','etudiant'),
        ('Doe', 'Rick','ricke.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','etudiant'),
        ('Doe', 'Rudolf','rudolf.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','etudiant'),
        ('Doe', 'Jack', 'jack.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','prof'),
        ('Doe', 'Jill', 'jill.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','prof'),
        ('Doe', 'James', 'james.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','admin'),
        ('Doe', 'Jenny', 'jenny.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','superviseur');
INSERT INTO Periode (annee, delaiPremierePartie, delaiDeuxiemePartie, delaiTroisiemePartie, delaiFinal)
  VALUES (EXTRACT(YEAR FROM TIMESTAMP '2024-01-01'), '2024-02-02', '2024-03-12', '2024-04-28', '2022-05-27'),
        (EXTRACT(YEAR FROM TIMESTAMP '2024-01-01'), '2024-02-02', '2024-03-12', '2024-04-28', '2022-05-27');

INSERT INTO Professeur (specialite, idPersonne, idPeriode)
  VALUES ('IA', 3, 1),
        ('ML', 4, 2);
INSERT INTO Sujet (titre, descriptif, fichier, idPeriode, idProf)
  VALUES ('La reproduction des insectes', 'Les insectes sont des animaux ovipares', NULL, 1, 1),
        ('L IA', 'L intelligence artificelle est un système informatique capable d apprendre par lui-même', NULL, 2, 2);
INSERT INTO UE (idue,nom, idProf)
  VALUES ('INFOB331','Introduction à la démarche scientifique', 1),
        ('INFOMA451','Mémoire', 2);
INSERT INTO Cours (idUE, nom)
  VALUES ('INFOB331', 'Introduction à la démarche scientifique'),
        ('INFOMA451', 'Mémoire');
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