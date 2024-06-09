# Installation et chargement des bibliothèques nécessaires
install.packages("skimr")
library(skimr)


#------------------------#
# CHARGEMENT DES DONNEES #
#------------------------#

# Chargement des donnees
catalogue <- dbGetQuery(hiveDB, "select 
                        catalogue_co2.id as id,
                        catalogue_co2.marque as marque,
                        catalogue_co2.nom as nom,
                        catalogue_co2.puissance as puissance,
                        catalogue_co2.longueur as longueur,
                        catalogue_co2.nbplaces as nbplaces,
                        catalogue_co2.nbportes as nbportes,
                        catalogue_co2.couleur as couleur,
                        catalogue_co2.occasion as occasion,
                        catalogue_co2.prix as prix,
                        catalogue_co2.malusbonus as malusbonus,
                        catalogue_co2.rejetsco2 as rejetsco2,
                        catalogue_co2.coutenergie as coutenergie
                        from catalogue_co2")

immatriculation <- dbGetQuery(hiveDB,"select 
                        immatriculation_ext.immatriculation as immatriculation,
                        immatriculation_ext.marque as marque,
                        immatriculation_ext.nom as nom,
                        immatriculation_ext.puissance as puissance,
                        immatriculation_ext.longueur as longueur,
                        immatriculation_ext.nbplaces as nbplaces,
                        immatriculation_ext.nbportes as nbportes,
                        immatriculation_ext.couleur as couleur,
                        immatriculation_ext.occasion as occasion,
                        immatriculation_ext.prix as prix
                        from immatriculation_ext")


co2table <- dbGetQuery(hiveDB, "select 
                  co2_ext.marque as marque,
                  co2_ext.malusbonus as malusbonus,
                  co2_ext.rejetsco2 as rejet,
                  co2_ext.coutenergie as coutenergie
                  from co2_ext")

marketing <- dbGetQuery(hiveDB, "select 
                  marketing_ext.marketingid as id,
                  marketing_ext.age as age,
                  marketing_ext.sexe as sexe,
                  marketing_ext.taux as taux,
                  marketing_ext.situation_familiale as situation_familiale,
                  marketing_ext.nbr_enfant as nbr_enfant,
                  marketing_ext.voiture_2 as voiture_2
                  from marketing_ext")

clients <- dbGetQuery(hiveDB, "select 
                  clients_ext.clientid as id,
                  clients_ext.age as age,
                  clients_ext.sexe as sexe,
                  clients_ext.taux as taux,
                  clients_ext.situation_familiale as situation_familiale,
                  clients_ext.nbr_enfant as nbr_enfant,
                  clients_ext.voiture_2 as voiture_2,
                  clients_ext.immatriculation as immatriculation
                  from clients_ext")


# Inspection initiale des datasets
str(catalogue)
names(catalogue)
summary(catalogue)

str(immatriculation)
names(immatriculation)
summary(immatriculation)

str(co2table)
names(co2table)
summary(co2table)

str(marketing)
names(marketing)
summary(marketing)

str(clients)
names(clients)
summary(clients)


#-------------------------------------#
# NETOYAGE ET PREPARATION DES DONNEES #
#-------------------------------------#


# Nettoyage et Préparation des Données
# Mettre à jour la colonne 'marketing.situation familiale'
marketing$situation_familiale <- tolower(marketing$situation_familiale)
marketing$situation_familiale <- with(marketing, ifelse(situation_familiale =="c�libataire", "celibataire",situation_familiale))
marketing$situation_familiale <- with(marketing, ifelse(situation_familiale =="célibataire", "celibataire",situation_familiale))

# Mettre à jour la colonne 'catalogue.longueur'
catalogue$longueur <- with(catalogue, ifelse(longueur == 'tr�s longue', "tres longue", longueur))
catalogue$longueur <- with(catalogue, ifelse(longueur == 'très longue', "tres longue", longueur))

# Mettre à jour la colonne 'immatriculation_ext.longueur'
immatriculation$longueur <- with(immatriculation, ifelse(longueur == 'tr�s longue', "tres longue", longueur))
immatriculation$longueur <- with(immatriculation, ifelse(longueur == 'très longue', "tres longue", longueur))

# concernant l'age nous avons des anomalies avec des ages negatifs. Pour corriger cette anomalie nous allons remplacer les ages negatifs par la mediane : 41
clients$age <- with(clients, ifelse(age < 0, 41 ,age))
# de meme pour le taux avec une mediane à 521
clients$taux <- with(clients, ifelse(taux < 0, 521 ,taux))

#pour le sexe du client
# Supprimer les caracteres speciaux
clients$sexe <- gsub("[^A-Za-z]", "", clients$sexe)

# Mettre en majuscules
clients$sexe <- toupper(clients$sexe)

# Supprimer les espaces vides
clients$sexe <- gsub("\\s+", "", clients$sexe)

# Remplacer les valeurs
clients$sexe <- ifelse(clients$sexe %in% c("MASCULIN", "HOMME"), "M", clients$sexe)
clients$sexe <- ifelse(clients$sexe %in% c("FEMININ", "FEMME"), "F", clients$sexe)
clients$sexe <- ifelse(clients$sexe %in% c("FEMININ", "FEMME"), "F", clients$sexe)

summary(clients)


#situation familiale
# Convertir les valeurs à comparer en minuscules
clients$situation_familiale <- tolower(clients$situation_familiale)
# Remplacer les valeurs
clients$situation_familiale <- ifelse(clients$situation_familiale %in% c("c�libataire"), "celibataire", clients$situation_familiale)
clients$situation_familiale <- ifelse(clients$situation_familiale %in% c("mari�(e)"), "marie(e)", clients$situation_familiale)
clients$situation_familiale <- ifelse(clients$situation_familiale %in% c("divorc�e"), "divorce(e)", clients$situation_familiale)
clients$situation_familiale <- ifelse(clients$situation_familiale %in% c("seule", "seul"), "seule", clients$situation_familiale)

clients$situation_familiale <- ifelse(clients$situation_familiale %in% c("célibataire"), "celibataire", clients$situation_familiale)
clients$situation_familiale <- ifelse(clients$situation_familiale %in% c("marié(e)"), "marie(e)", clients$situation_familiale)
clients$situation_familiale <- ifelse(clients$situation_familiale %in% c("divorcé(e)"), "divorce(e)", clients$situation_familiale)


clients$sexe[clients$sexe == ""] <- "ND"
clients$sexe[clients$sexe == "FMININ"] <- "F"
clients$situation_familiale[clients$situation_familiale=="?"] <-"ND"
clients$situation_familiale[clients$situation_familiale==" "] <-"ND"
clients$situation_familiale[clients$situation_familiale=="n/d"] <-"ND"
clients$nbr_enfant[clients$nbr_enfant == -1] <- 0
clients$voiture_2[clients$voiture_2==" "] <- "ND"
clients$voiture_2[clients$voiture_2=="?"] <- "ND"

print(summary(catalogue))
print(skim(catalogue))
print(skim(clients))


#-------------------------------------#
# VISUALISATION DES DONNEES #
#-------------------------------------#

#Visualisation des donnees
install.packages("ggplot2")
library("ggplot2")

# Histogramme des âges des clients
ggplot(clients, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  labs(title = "Histogramme des âges des clients", x = "Âge", y = "Frequence")

# Barplot des marques de voitures
ggplot(immatriculation,aes(x = marque)) +
  geom_bar(fill = "lightblue", color = "black") +
  labs(title = "Nombre de voitures par marque", x = "Marque", y = "Nombre de voitures") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Puissance en fonction de la longueur
ggplot(catalogue, aes(x = longueur, y = puissance)) +
  geom_boxplot() +
  labs(title = "Puissance en fonction de la longueur", x = "Longueur", y = "Puissance")

#Relation entre puissance et prix
ggplot(catalogue, aes(x = puissance, y = prix, color = longueur)) +
  geom_point(alpha = 0.6) +
  labs(title = "Relation entre puissance et prix", x = "Puissance", y = "Prix")

# Diagramme de Corrélation: Heatmap des corrélations entre les variables numériques
library(reshape2)

# Extraction des variables numériques
numeric_data <- catalogue[, sapply(catalogue, is.numeric)]

# Calcule de la matrice de corrélation
cor_matrix <- cor(numeric_data, use = "complete.obs")

# Transformation de la matrice en format long
melt_cor_matrix <- melt(cor_matrix)

# Création du heatmap de corrélation
ggplot(melt_cor_matrix, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white", midpoint = 0, limit = c(-1, 1), space = "Lab", name="Correlation") +
  labs(title = "Heatmap des corrélations entre les variables numériques") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
