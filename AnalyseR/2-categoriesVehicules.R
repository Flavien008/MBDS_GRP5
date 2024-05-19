# Fonction pour définir la catégorie en fonction des critères 

  # Nous allons catégoriser les véhicules en cinq catégories principales en fonction de certaines caractéristiques pertinentes, à savoir :
  
  #citadine #sportive #familiale #confort #longue 

# Installer et charger le package cluster
install.packages("cluster")
library(cluster)

definir_categorie_cluster <- function(data) {
  # Préparer les données
  data_prep <- data[, c("puissance", "longueur", "nbplaces", "nbportes", "malusbonus", "rejetsco2", "coutenergie","prix")]
  
  # Convertir longueur en facteur si ce n'est pas déjà fait
  if (!is.factor(data_prep$longueur)) {
    data_prep$longueur <- factor(data_prep$longueur)
  }
  
  # Normaliser les variables numériques
  data_norm <- scale(data_prep[, c("puissance", "nbplaces", "nbportes", "malusbonus", "rejetsco2", "coutenergie","prix")])
  
  # Clustering hiérarchique
  hc <- hclust(dist(data_norm), method = "ward.D")
  
  # Découper les clusters en 5 catégories
  nb_cluster <- 6
  coupes <- cutree(hc, k = nb_cluster)
  
  # Analyser les clusters pour déterminer les caractéristiques dominantes
  cluster_analysis <- function(data, clusters) {
    analysis <- data.frame(
      cluster = 1:nb_cluster,
      puissance_moyenne = tapply(data$puissance, clusters, mean),
      nbplaces_moyenne = tapply(data$nbplaces, clusters, mean),
      nbportes_moyenne = tapply(data$nbportes, clusters, mean),
      malusbonus_moyen = tapply(data$malusbonus, clusters, mean),
      rejetsco2_moyen = tapply(data$rejetsco2, clusters, mean),
      coutenergie_moyen = tapply(data$coutenergie, clusters, mean),
      prix_moyen = tapply(data$prix, clusters, mean)
    )
    return(analysis)
  }
  
  cluster_info <- cluster_analysis(data_prep, coupes)
  print(cluster_info) # Afficher les informations pour vérification
  
  sorted_puissance <- sort(cluster_info$puissance_moyenne, decreasing = TRUE)
  second_max_puissance <- sorted_puissance[2]
  
  # Mapper les clusters aux catégories en fonction des analyses
  mapping_clusters_categories <- function(cluster) {
    if (cluster_info$puissance_moyenne[cluster] == second_max_puissance) {
      return("sportive")
    }else if (cluster_info$prix_moyen[cluster] == max(cluster_info$prix_moyen )&& cluster_info$puissance_moyenne[cluster] == max(cluster_info$puissance_moyenne)) {
      return("luxe")
    } else if (cluster_info$nbplaces_moyenne[cluster] == max(cluster_info$nbplaces_moyenne)) {
      return("familiale")
    } else if (cluster_info$coutenergie_moyen[cluster] == min(cluster_info$coutenergie_moyen)) {
      return("citadine")
    } else if (cluster_info$nbportes_moyenne[cluster] > 3) {
      return("confort")
    }
    else {
      return("longue")
    }
    
    print(max(cluster_info$prix_moyen))
  }
  
  # Ajouter la colonne "categorie" sans perdre les colonnes existantes
  data$categorie <- sapply(coupes, mapping_clusters_categories)
  
  # Renvoyer les données avec la catégorie ajoutée
  return(data)
}


# Appliquer la fonction aux 
catalogue <- definir_categorie_cluster(catalogue)

View(catalogue)

# Convertir toutes les valeurs de la colonne "marque" en minuscules pour la fusion insensible à la casse
immatriculation$marque <- tolower(immatriculation$marque)
catalogue$marque <- tolower(catalogue$marque)
catalogue$couleur <- tolower(catalogue$couleur)
immatriculation$couleur <- tolower(immatriculation$couleur)

# Fusionner les données
immatrCatalog <- merge(x = immatriculation, by = c( "marque","nom","puissance", "longueur", "nbplaces", "nbportes","couleur", "prix"), y = catalogue )
immatrCatalog <- unique(immatrCatalog)
str(immatrCatalog)


clientsImmat <- merge(x = clients, by = c( "immatriculation"), y = immatrCatalog )
clientsImmat <- unique(clientsImmat)

# Vérifier le nombre d'éléments dans chaque catégorie
print(table(catalogue$categorie))
print(table(immatrCatalog$categorie))
print(table(clientsImmat$categorie))
