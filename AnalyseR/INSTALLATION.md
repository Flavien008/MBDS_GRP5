## Installation du Driver Hive pour R

### Windows

1. Téléchargez le Driver ODBC Hive pour Windows depuis ce [lien](https://www.cloudera.com/downloads/connectors/hive/odbc/2-6-1.html).

![image](images/1-InstallationOBDCDriver.png)

2. Une fois le téléchargement terminé, allez dans [Panneau de configuration -> Système et sécurité -> Outils windows] de votre ordinateur et lancez "ODBC Data Source Administrator (XX-BITS)" (32 ou 64 bits selon votre ordinateur) :

![image](images/2-Outils%20windows.png)

3. Choisisez Hive Driver puis cliquez sur le bouton "Ajouter" (ADD) :

![image](images/3-Admin%20Source%20Données.png)

Une fenêtre s'affichera :

4. Sous l'onglet "USER DSN", sélectionnez le driver Cloudera que vous venez d'installer :

![image](images/4-Ajout%20Cloudera.png)

5. Remplissez avec les informations suivantes :

![image](images/5-Coudera%20Form%20and%20avanced%20options.png)

6. Faites la même chose dans l'onglet "SYSTEM DSN" :

![image](images/6-SDN%20OBDC.png)

### R

1. Exécutez les lignes de commande suivantes (dans le fichier `1-DriverConnection.R`) :

```r
install.packages(c("RJDBC", "DBI", "rJava", "odbc"))
library(odbc)
library(DBI)
library(rJava)
library(RJDBC)

# Connexion à Hive
hiveDB <- dbConnect(odbc::odbc(), "Hive Driver")
```

Apres cette étape, si vous utilisez RStudio vous devez voir la connexion du HIVE comme suit : 

![image](images/7-R%20connexion.png)

Pour tester que tout marche bien on execute une simple requete SQL :

```r
dbGetQuery(hiveDB,"select * from marketing_ext")
```

![image]()

