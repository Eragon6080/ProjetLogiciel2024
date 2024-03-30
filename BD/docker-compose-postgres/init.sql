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
-- function for checking
    CREATE OR REPLACE FUNCTION check_role_content(json_content JSON) RETURNS BOOLEAN AS $$
DECLARE
  role_value jsonb;
BEGIN
  role_value := json_content -> 'role';
  RETURN role_value ? 'superviseur' OR role_value ? 'professeur' OR role_value ? 'etudiant' OR role_value ? 'admin';
END;
$$ LANGUAGE plpgsql;
CREATE TABLE Personne(
  idPersonne INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  nom TEXT NOT NULL,
  prenom TEXT NOT NULL,
  mail TEXT NOT NULL UNIQUE CHECK (mail ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
  password TEXT NOT NULL CHECK (length(password) >= 8),
  role JSON NOT NULL CHECK (jsonb_typeof(role::jsonb -> 'role') = 'array' AND jsonb_exists(role::jsonb, 'role') and check_role_content(role)),
  last_login TEXT DEFAULT NULL,
  is_superuser BOOLEAN DEFAULT FALSE,
  is_staff BOOLEAN DEFAULT True,
  is_active BOOLEAN DEFAULT True
);
CREATE TABLE Delivrable(
  idDelivrable INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  fichier TEXT,
  typeFichier TEXT check(typeFichier IN ('pdf', 'docx', 'pptx', 'xlsx', 'zip', 'rar', '7z', 'tar', 'gz', 'bz2', 'xz', 'tgz', 'tbz2', 'txz', 'pdf', 'docx', 'pptx', 'xlsx', 'zip', 'rar', '7z', 'tar', 'gz', 'bz2', 'xz', 'tgz', 'tbz2', 'txz'))
);
CREATE TABLE Periode(
  idPeriode INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  annee int NOT NULL
  );
CREATE TABLE Etape(
  idEtape INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  delai DATE NOT NULL,
  description TEXT NOT NULL,
  idPeriode INT NOT NULL,
  idDelivrable INT,
  FOREIGN KEY (idPeriode) REFERENCES Periode(idPeriode),
  FOREIGN KEY (idDelivrable) REFERENCES Delivrable(idDelivrable)
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
  descriptif TEXT NOT NULL DEFAULT 'NULL',
  destination TEXT NOT NULL DEFAULT 'NULL',
  estPris BOOLEAN NOT NULL DEFAULT FALSE,
  fichier TEXT, --  localisation du fichier de la proposition de sujet
  idPeriode INT NOT NULL DEFAULT 1,
  idProf INT NOT NULL DEFAULT 1,
  FOREIGN KEY (idPeriode) REFERENCES Periode(idPeriode),
  FOREIGN KEY (idProf) REFERENCES Professeur(idProf)

);
CREATE TABLE UE(
  idue TEXT PRIMARY KEY, -- matricule de l'UE
  nom TEXT NOT NULL,
  idProf INT NOT NULL,
  FOREIGN KEY (idProf) REFERENCES Professeur(idProf)
);
CREATE TABLE Cours(
  idCours INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  idue TEXT NOT NULL,
  nom TEXT NOT NULL,
  FOREIGN KEY (idUE) REFERENCES UE(idUE)
);
CREATE TABLE Etudiant(
  idEtudiant INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  bloc INT NOT NULL check(bloc >= 1 and bloc <= 5),
  idPersonne INT NOT NULL,
  idSujet INT UNIQUE,
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
INSERT INTO Personne (nom, prenom, mail,password, role)
  VALUES ('Doe', 'John', 'john.doe@gmail.com', 'pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=',
          '{"role" : ["etudiant"]}'),
        ('Doe', 'Jane', 'jane.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','{"role" : ["etudiant"]}'),
        ('Doe', 'Rick','ricke.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','{"role" : ["etudiant"]}'),
        ('Doe', 'Rudolf','rudolf.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','{"role" : ["etudiant"]}'),
        ('Doe', 'Jack', 'jack.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','{"role" : ["professeur","superviseur"]}'),
        ('Doe', 'Jill', 'jill.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=', '{"role" : ["professeur"]}'),
        ('Doe', 'James', 'james.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=', '{"role" : ["admin"]}'),
        ('Doe', 'Jenny', 'jenny.doe@gmail.com','pbkdf2_sha256$720000$tjC57NAqNFX9F7XCKvDqet$ymUne1VQexTF3EB/sqF+eqJSC8ZC4F9wgrSUblI9iPw=','{"role": ["superviseur"]}');
INSERT INTO Periode (annee)
  VALUES (EXTRACT(YEAR FROM TIMESTAMP '2024-01-01')),
        (EXTRACT(YEAR FROM TIMESTAMP '2024-01-01'));
INSERT INTO Delivrable (fichier, typeFichier)
  VALUES ('/home/etudiant/devoir1.pdf', 'pdf'),
        ('/home/etudiant/devoir2', 'docx');
INSERT INTO Etape (delai, description, idPeriode, idDelivrable)
  VALUES ('2024-01-01', 'rendre le devoir 1', 1, 1),
        ('2024-02-01', 'rendre le devoir 2', 2, 2);

INSERT INTO Professeur (specialite, idPersonne, idPeriode)
  VALUES ('IA', 3, 1),
        ('ML', 4, 2);
INSERT INTO Sujet (titre, descriptif, fichier, idPeriode, idProf,estPris)
  VALUES ('La reproduction des insectes', 'Les insectes sont des animaux ovipares', NULL, 1, 1,TRUE),
        ('L IA', 'L intelligence artificelle est un système informatique capable d apprendre par lui-même', NULL, 2, 2,TRUE);
INSERT INTO UE (idue,nom, idProf)
  VALUES ('INFOB331','Introduction à la démarche scientifique', 1),
        ('INFOMA451','Mémoire', 2);
INSERT INTO Cours (idUE, nom)
  VALUES ('INFOB331', 'Introduction à la démarche scientifique'),
        ('INFOMA451', 'Mémoire');
INSERT INTO Etudiant (bloc, idPersonne, idSujet)
  VALUES (1, 1, 1),
        (2, 2, 2);
INSERT INTO Etudiant(bloc, idPersonne)
      VALUES  (3, 3),
        (4, 4);
INSERT INTO Inscription (idEtudiant, idCours)
  VALUES (1, 1),
        (2, 2),
        (3, 1),
        (4, 2);


