# Installation et chargement des bibliothèques nécessaires
install.packages(c("RJDBC", "DBI", "rJava", "odbc"))
library(odbc)
library(DBI)
library(rJava)
library(RJDBC)

# Connexion à la base de données Hive
hiveDB <- dbConnect(odbc::odbc(), "Hive Driver")

# Test de la connexion
dbGetQuery(hiveDB,"select * from marketing_ext")