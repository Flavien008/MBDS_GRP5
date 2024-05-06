# Extraction et Traitement des Données

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
export DATAHOME=/vagrant/MBDS_GRP5/DATA_EXTRACTOR/dataSources
```	

- Démarrer le serveur Oracle NOSQL (KV Store) avec la commande 
```bash
nohup java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT &
```
- Importez les données marketing :
```bash
javac -g -cp "$KVHOME/lib/kvclient.jar:$MYTPHOME:." "$MYTPHOME/Marketing.java"
java -cp "$KVHOME/lib/kvclient.jar:$MYTPHOME:." Marketing

```
- Importez les données clients :
```bash
javac -g -cp "$KVHOME/lib/kvclient.jar:." "$MYTPHOME/Clients.java"
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

