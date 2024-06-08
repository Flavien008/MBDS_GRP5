# Extraction et Traitement des Données

Lors du clonage de ce projet, veuillez copier le fichier **Immatriculations.csv** disponible à l'adresse suivante : https://drive.google.com/file/d/1dZaWPH4xbJGQBjmsj6Z-MRo1A8oWwuye/view?usp=sharing dans le dossier du projet, à l'emplacement `./DATA_EXTRACTOR/dataSources`. Cette étape est nécessaire car le fichier dépasse 100 Mo, ce qui empêche de faire un commit sur GitHub en raison de la limite de taille des fichiers.

## Source Oracle NoSQL

### Importation des Données

Dans le cadre de notre projet, nous avons choisi d'utiliser le serveur Oracle NoSQL pour stocker nos données clients et marketing. Pour cela, nous avons développé deux programmes d'extraction : Clients.java et Marketing.java. Vous trouverez ces scripts dans le répertoire "programmesExtraction". Pour les utiliser, veuillez suivre les instructions ci-dessous :

- Connectez-vous à la machine Vagrant en utilisant la commande suivante :

```bash
vagrant ssh
```

- Définissez les chemins des répertoires :

```bash
export MYTPHOME=/vagrant/MBDS_GRP5/DATA_EXTRACTOR/programmesExtraction/
```

```bash
export DATAHOME=/vagrant/MBDS_GRP5/DATA_EXTRACTOR/dataSources
```

- Démarrer le serveur Oracle NOSQL (KV Store) avec la commande

```bash
nohup java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT &
```

- Importez les données marketing :

```bash
javac -g -cp "$KVHOME/lib/kvclient.jar:$MYTPHOME:." "$MYTPHOME/Marketing.java"
```

```bash
java -cp "$KVHOME/lib/kvclient.jar:$MYTPHOME:." Marketing
```

- Importez les données clients :

```bash
javac -g -cp "$KVHOME/lib/kvclient.jar:." "$MYTPHOME/Clients.java"
```

```bash
java -cp "$KVHOME/lib/kvclient.jar:$MYTPHOME" Clients
```

Nous allons à présent créer les tables externes sur HIVE pour accéder aux données.

### Création des Tables Externes sur HIVE

Pour démarrer, vous devez lancer le serveur HIVE en exécutant les commandes suivantes :

```bash
start-dfs.sh
```

```bash
start-yarn.sh
```

```bash
nohup hive --service metastore > /dev/null &
```

```bash
nohup hiveserver2 > /dev/null &
```

- Accédez ensuite à la console HIVE avec la commande suivante. Notez que cela peut prendre quelques instants pour que la commande soit opérationnelle :

```bash
beeline -u jdbc:hive2://localhost:10000 vagrant
```

```bash
USE DEFAULT;
```

- Voici le script de création de la table Marketing :

```bash
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
```

- Et voici le script de création de la table Clients :

```bash
CREATE EXTERNAL TABLE IF NOT EXISTS Clients_EXT (
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
```

## Source MongoDB

### Importation des Données

Pour notre projet nous avons décidé de placer les données de Catalogue dans le serveur Mongo DB.

Pour réaliser l'import des données on va utiliser l'utilitaire mongoimport.

On lance MongoDB :

```bash
sudo systemctl start mongod
```

On se connecte ensuite au MongoDB Client

```bash
mongo
```

On execute la serie des commandes suivante :

```bash
// Créer la BDD TPA
use TPA
// Créer les deux collections "Catalogue" :
db.createCollection("Catalogue")
// Verifier les collections
show collections
//On quitte le mongo shell
quit()
```

Ensuite, on lance la commande pour importer les données pour Catalogue :

```bash
mongoimport -d TPA -c Catalogue --type=csv --file="$DATAHOME/Catalogue.csv"  --headerline

```

On peut verifier que les donnees on ete bien importees :

```bash
mongo
use TPA
db.Catalogue.find({})
```

### Création des tables externes sur HIVE

Pour démarrer et accéder à la console HIVE il faut suivre les mêmes instructions que pour la source Oracle NOSQL.

- script de création de la table Catalogue

```bash
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
```

## Source Hadoop Distributed File System (HDFS)

### Importation des Données

Pour notre projet, nous avons décidé de stocker le fichier CO2.csv et immatriculation dans HDFS. Pour l'importer, veuillez suivre les étapes ci-dessous :

- Si HDFS n'est pas déjà lancé, démarrez-le :

```bash
start-dfs.sh
```

- Définissez le chemin du répertoire HDFS :

```bash
export HDFSHOME=/vagrant/MBDS_GRP5/DATA_EXTRACTOR/hdfs
```

- Créez un répertoire "input" sur HDFS et transférez le fichier CO2.csv depuis le répertoire local vers HDFS :

```bash
hadoop fs -mkdir -p /user/vagrant/input
hadoop fs -put $DATAHOME/CO2.csv /user/vagrant/input/CO2.csv
```

- Créez un répertoire "data" sur HDFS et transférez le fichier immatriculations.csv depuis le répertoire local vers HDFS :

```bash
hadoop fs -mkdir -p /user/vagrant/data
hadoop fs -put $DATAHOME/immatriculations.csv /user/vagrant/data/immatriculations.csv
```

- Lancez le script Spark pour nettoyer et transformer les données (Map Reduce) :

```bash
spark-submit $HDFSHOME/clean_map_reduce_co2.py
```

### Création des Tables Externes sur Hive

Pour démarrer et accéder à la console HIVE il faut suivre les mêmes instructions que pour la source Oracle NOSQL.

- Script de création de la table `co2_ext` :

```bash
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
```

- Script pour créer la table `catalogue_co2` en intégrant les données de `co2_ext` avec celles de catalogue_ext. Tout d'abord, nettoyer certaines données de `catalogue_ext` afin d'obtenir `cleaned_catalogue_ext`, puis effectuer la jointure entre `cleaned_catalogue_ext` et `co2_ext`.
- Lors de la jointure, pour les marques de voitures qui ne sont pas présentes dans `co2_ext`, on insert la moyenne des colonnes `malusBonus`, `rejetsCO2` et `coutEnergie` de toutes les marques de véhicules qui sont présentes des deux côtés (`cleaned_catalogue_ext` et `co2_ext`).

```bash
CREATE TABLE cleaned_catalogue_ext AS
SELECT
    id,
    CASE
        WHEN marque LIKE '%Hyunda%' THEN 'Hyundai'
        ELSE marque
    END AS marque,
    nom,
    puissance,
    longueur,
    nbplaces,
    nbportes,
    couleur,
    occasion,
    prix
FROM catalogue_ext;
```

```bash
CREATE TABLE IF NOT EXISTS catalogue_co2
AS
WITH marques_communs AS (
    SELECT DISTINCT co2.marque, co2.malusBonus, co2.rejetsCO2, co2.coutEnergie
    FROM co2_ext co2
    JOIN cleaned_catalogue_ext cat
    ON LOWER(co2.marque) = LOWER(cat.Marque)
),
moyennes_co2 AS (
    SELECT
        AVG(co2.malusBonus) AS avg_malusBonus,
        AVG(co2.rejetsCO2) AS avg_rejetsCO2,
        AVG(co2.coutEnergie) AS avg_coutEnergie
    FROM co2_ext co2
    JOIN marques_communs communs
    ON LOWER(co2.marque) = LOWER(communs.marque)
)
SELECT
    cat.*,
    COALESCE(co2.malusBonus, moyennes_co2.avg_malusBonus) AS malusBonus,
    COALESCE(co2.rejetsCO2, moyennes_co2.avg_rejetsCO2) AS rejetsCO2,
    COALESCE(co2.coutEnergie, moyennes_co2.avg_coutEnergie) AS coutEnergie
FROM cleaned_catalogue_ext cat
LEFT JOIN co2_ext co2
ON LOWER(co2.marque) = LOWER(cat.Marque)
CROSS JOIN moyennes_co2;
```

- script de création de la table Immatriculation

```bash
CREATE EXTERNAL TABLE immatriculation_ext (
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
```
