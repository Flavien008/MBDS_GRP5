beeline -u jdbc:hive2://localhost:10000 vagrant

USE DEFAULT;

CREATE EXTERNAL TABLE IF NOT EXISTS MARKETING_EXT (
MARKETINGID INTEGER,
AGE INTEGER,
SEXE STRING,
TAUX INTEGER,
SITUATION_FAMILIALE STRING,
NBR_ENFANT INTEGER,
VOITURE_2 STRING
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000",
"oracle.kv.tableName" = "Marketing"
);


CREATE EXTERNAL TABLE IF NOT EXISTS CLIENTS_EXT (
ClIENTID INTEGER,
AGE INTEGER,
SEXE STRING,
TAUX INTEGER,
SITUATION_FAMILIALE STRING,
NBR_ENFANT INTEGER,
VOITURE_2 STRING,
IMMATRICULATION STRING
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000",
"oracle.kv.tableName" = "clients"
);


CREATE EXTERNAL TABLE catalogue_ext ( 
id STRING, 
Marque STRING,
Nom STRING,
Puissance DOUBLE,
Longueur STRING,
NbPlaces INT,
NbPortes INT,
Couleur STRING,
Occasion STRING,
Prix DOUBLE )
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"id":"_id", "marque":"marque", "nom" : "nom", "puissance": "puissance", "longueur" : "longueur", "nbPlaces" : "nbPlaces", "nbPortes" : "nbPortes", "couleur" : "couleur", "occasion" : "occasion", "prix" : "prix"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/TPA.Catalogue');

CREATE EXTERNAL TABLE immatriculation_ext (
id STRING,
Immatriculation STRING,
Marque STRING,
Nom STRING,
Puissance DOUBLE,
Longueur STRING,
NbPlaces INT,
NbPortes INT,
Couleur STRING,
Occasion STRING,
Prix DOUBLE )
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/vagrant/data'
TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE EXTERNAL TABLE IF NOT EXISTS co2_ext (
    marque STRING,
    malusBonus FLOAT,
    rejetsCO2 FLOAT,
    coutEnergie FLOAT
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
STORED AS TEXTFILE 
LOCATION '/user/vagrant/output/clean_co2';

CREATE TABLE IF NOT EXISTS catalogue_co2
AS
WITH avg_co2 AS (
    SELECT 
        AVG(malusBonus) AS avgMalusBonus,
        AVG(rejetsCO2) AS avgRejetsCO2,
        AVG(coutEnergie) AS avgCoutEnergie
    FROM 
        co2_ext
)

SELECT 
    catalogue_ext.*,
    COALESCE(co2_ext.malusBonus, avg_co2.avgMalusBonus) AS malusBonus,
    COALESCE(co2_ext.rejetsCO2, avg_co2.avgRejetsCO2) AS rejetsCO2,
    COALESCE(co2_ext.coutEnergie, avg_co2.avgCoutEnergie) AS coutEnergie
FROM 
    catalogue_ext
LEFT JOIN 
    co2_ext
ON 
    LOWER(catalogue_ext.Marque) = LOWER(co2_ext.marque),
avg_co2;