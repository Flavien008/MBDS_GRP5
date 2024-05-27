# Installation du Driver Hive pour R

### Windows

1. **Téléchargement du Driver ODBC Hive :**
   - Téléchargez le Driver ODBC Hive pour Windows depuis ce [lien](https://www.cloudera.com/downloads/connectors/hive/odbc/2-6-1.html).

   - Installez le.

   ![image](images/1-InstallationOBDCDriver.png)

2. **Accéder aux Outils d'administration Windows :**
   - Une fois le téléchargement terminé, allez dans [Panneau de configuration -> Système et sécurité -> Outils Windows] de votre ordinateur et lancez "ODBC Data Source Administrator (XX-BITS)" (32 ou 64 bits selon votre ordinateur).

   ![Outils Windows](images/2-Outils%20windows.png)

3. **Ajouter un nouveau Data Source :**
   - Choisissez "Hive Driver" puis cliquez sur le bouton "Ajouter" (ADD).

   ![Ajouter un Data Source](images/3-Admin%20Source%20Données.png)

   Une fenêtre s'affichera.

4. **Sélection du Driver Cloudera :**
   - Sous l'onglet "USER DSN", sélectionnez le driver Cloudera que vous venez d'installer.

   ![Sélection du Driver Cloudera](images/4-Ajout%20Cloudera.png)

5. **Configuration du Driver Cloudera :**
   - Remplissez le formulaire avec les informations nécessaires puis cochez les cases indiqués dans "Advanced option".

   ![Configuration du Driver Cloudera](images/5-Coudera%20Form%20and%20avanced%20options.png)

6. **Répéter l'opération pour SYSTEM DSN :**
   - Faites la même chose dans l'onglet "SYSTEM DSN".

   ![SYSTEM DSN](images/6-SDN%20OBDC.png)

### R

1. **Installation et Chargement des Packages R :**
   - Exécutez les lignes de commande suivantes (dans le fichier `1-DriverConnection.R`) :

   ```r
   install.packages(c("RJDBC", "DBI", "rJava", "odbc"))
   library(odbc)
   library(DBI)
   library(rJava)
   library(RJDBC)

   # Connexion à Hive
   hiveDB <- dbConnect(odbc::odbc(), "Hive Driver")
    ```

   - Pour tester que tout marche bien on execute une simple requete SQL :

    ```r
    dbGetQuery(hiveDB,"select * from marketing_ext")
    ```

    ![image]()

