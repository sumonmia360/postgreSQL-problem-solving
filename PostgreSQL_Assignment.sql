-- Active: 1747418356741@@127.0.0.1@5432@conservation_db@public

--Rangers Table
CREATE TABLE rangers(ranger_id SERIAL PRIMARY KEY,name VARCHAR(50),region TEXT);
INSERT INTO rangers(name,region) VALUES('Alice Green',' Northern Hills'),('Bob White',' River Delta'),('Carol King','Mountain Range');

SELECT * FROM rangers;
--Species Table
CREATE TABLE species (species_id SERIAL PRIMARY KEY,common_name VARCHAR(50),scientific_name TEXT,discovery_date DATE,conservation_status VARCHAR(50));

INSERT INTO species (common_name,scientific_name ,discovery_date ,conservation_status) VALUES('Snow Leopard','Panthera uncia','1775-01-01','Endangered'),('Bengal Tiger','Panthera tigris tigris','1758-01-01','Endangered'),('Red Panda','Ailurus fulgens','1825-01-01','Vulnerable'),('Asiatic Elephant','Elephas maximus indicus','1758-01-01','Endangered');

--Sightings Table
CREATE TABLE sightings (sighting_id SERIAL PRIMARY KEY,species_id INT REFERENCES species(species_id),ranger_id INT REFERENCES rangers(ranger_id),location TEXT,sighting_time TIMESTAMP ,notes TEXT);
INSERT INTO sightings (ranger_id,species_id,location,sighting_time,notes ) VALUES(1,1,'Peak Ridge','2024-05-10 07:45:00','Camera trap image captured'),(2,2,'Bankwood Area','2024-05-12 16:20:00','Juvenile seen'),(3,3,'Bamboo Grove East','2024-05-15 09:10:00','Feeding observed');

SELECT * FROM sightings;
---------------------------------------------------------
--problem-1

INSERT INTO rangers(name,region) VALUES('Derek Fox','Coastal Plains');

--problem-2

SELECT  count(conservation_status) as unique_species_count FROM species WHERE conservation_status = 'Endangered';

--problem-3

SELECT * FROM sightings WHERE location  ILIKE'%Pass%';

--problem-4

SELECT name,count(sighting_time) as total_sightings  FROM rangers JOIN sightings USING(ranger_id) GROUP BY name;

--problem-5

SELECT common_name FROM species WHERE species_id NOT IN (SELECT species_id  FROM species JOIN sightings USING(species_id));

--problem-6

CREATE or REPLACE VIEW with_out_main_max AS SELECT * FROM sightings WHERE not sighting_time = (SELECT max(sighting_time) FROM sightings);
CREATE or REPLACE VIEW  recent_sightings_1 as SELECT max(sighting_time) FROM with_out_main_max;
CREATE or REPLACE VIEW recent_sightings_2 as SELECT max(sighting_time) FROM sightings;
CREATE or REPLACE VIEW sighting_and_species_T as ( SELECT * FROM species JOIN  sightings USING(species_id) WHERE sighting_time = (SELECT * FROM recent_sightings_1) or  sighting_time = (SELECT * FROM recent_sightings_2))

SELECT common_name,sighting_time,name FROM rangers JOIN sighting_and_species_t USING(ranger_id);






