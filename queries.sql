/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name FROM animals WHERE neutered = True AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = True;

SELECT * FROM animals WHERE name != 'Gabumon';

SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

-- Begin Transaction

BEGIN;

UPDATE animals SET species = 'unspecified';

ROLLBACK;

-- Begin another Transaction

BEGIN;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

COMMIT;

-- Begin another Transaction

BEGIN;

DELETE FROM animals;

ROLLBACK;

-- Begin another Transaction 

BEGIN;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT SP_1;

UPDATE animals SET weight_kg = weight_kg * -1;

ROLLBACK TO SP_1;

UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

COMMIT;

-- Answering questions with queries

SELECT COUNT(*) FROM animals;

SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;

SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;

SELECT neutered, MAX(weight_kg) as Max_weight, MIN(weight_kg)
  as Max_weight FROM animals GROUP BY neutered;

SELECT neutered, AVG(escape_attempts) as Average_escape_attempts FROM animals
WHERE date_of_birth <= '2000-12-31' AND date_of_birth >= '1990-01-01' GROUP BY neutered;

-- Answering questions with queries involving JOINS

SELECT full_name as Owner, name as animals FROM owners O JOIN animals A ON O.id = A.owner_id
WHERE full_name = 'Melody Pond';

SELECT A.name as animals, S.name as Type FROM species S JOIN animals A ON S.id = A.species_id
WHERE S.name = 'Pokemon';

SELECT O.full_name as Owner, A.name as Animals FROM owners O LEFT JOIN animals A ON O.id = A.owner_id;

SELECT S.name as Species, COUNT(A.name) as Total_number FROM species S JOIN animals A ON S.id = A.species_id
GROUP BY S.name;

SELECT O.full_name as owner, A.name as animal, S.name as type 
FROM owners O JOIN animals A ON O.id = A.owner_id
JOIN species S ON S.id = A.species_id
WHERE O.full_name = 'Jennifer Orwell' AND S.name = 'Digimon';

SELECT O.full_name as owner, A.name as animal 
FROM owners O JOIN animals A ON O.id = A.owner_id
WHERE O.full_name = 'Dean Winchester' AND A.escape_attempts = 0;

SELECT agg.full_name as owner, count as Total_number FROM
(SELECT full_name, count(a.owner_id) FROM owners O
JOIN animals A ON O.id = A.owner_id GROUP BY O.full_name) AS agg 
WHERE count = (SELECT MAX(count) FROM (SELECT full_name, count(a.owner_id) FROM owners O
JOIN animals A ON O.id = A.owner_id GROUP BY O.full_name) AS agg);