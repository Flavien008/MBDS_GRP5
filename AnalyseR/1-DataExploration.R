#------------------------#
# CHARGEMENT DES DONNÉES #
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

# etant donné le volume de donnée import d'immatriculation, j'ai fait le choix d'importer les tâbles jointes avec HIVE :
#on réalise une fusion entre clients et immatriculations
clientImmat <- dbGetQuery(hiveDB, "select 
                  clients_ext.clientid as id,
                  clients_ext.age as age,
                  clients_ext.sexe as sexe,
                  clients_ext.taux as taux,
                  clients_ext.situation_familiale as situation_familiale,
                  clients_ext.nbr_enfant as nbr_enfant,
                  clients_ext.voiture_2 as voiture_2,
                  clients_ext.immatriculation as immatriculation,
                  immatriculation_ext.marque as marque,
                  immatriculation_ext.nom as nom,
                  immatriculation_ext.puissance as puissance,
                  immatriculation_ext.longueur as longueur,
                  immatriculation_ext.nbplaces as nbplaces,
                  immatriculation_ext.nbportes as nbportes,
                  immatriculation_ext.couleur as couleur,
                  immatriculation_ext.occasion as occasion,
                  immatriculation_ext.prix as prix
                  from clients_ext inner join immatriculation_ext
                  on clients_ext.immatriculation = immatriculation_ext.immatriculation")

# # Inspection initiale des datasets
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

str(clientImmat)
names(clientImmat)
summary(clientImmat)



#Visualisation des données

# Histogramme des âges des clients
ggplot(clientImmat, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  labs(title = "Histogramme des âges des clients", x = "Âge", y = "Fréquence")

# Barplot des marques de voitures
ggplot(clientImmat, aes(x = marque)) +
  geom_bar(fill = "lightblue", color = "black") +
  labs(title = "Nombre de voitures par marque", x = "Marque", y = "Nombre de voitures") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# dans notre dataset 'très longue' correspond à 'tr'
# Mettre à jour la colonne 'immatriculation_ext.longueur'
immatriculation$longueur <- with(immatriculation, ifelse(longueur == 'tr', "très longue", longueur))

clientImmat$longueur <- with(clientImmat, ifelse(longueur == 'tr', "très longue", longueur))

# concernant l'age nous avons des anomalies avec des ages negatifs. Pour corriger cette anomalie nous allons remplacer les ages negatifs par la mediane : 41
clientImmat$age <- with(clientImmat, ifelse(age < 0, 41 ,age))
clients$age <- with(clients, ifelse(age < 0, 41 ,age))

# de meme pour le taux avec une mediane à 521
clientImmat$taux <- with(clientImmat, ifelse(taux < 0, 521 ,taux))
clients$taux <- with(clients, ifelse(taux < 0, 521 ,taux))
