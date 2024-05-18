# Fonction pour définir la catégorie en fonction des critères 

  # Nous allons catégoriser les véhicules en cinq catégories principales en fonction de certaines caractéristiques pertinentes, à savoir :
  
  #citadine #sportive #familiale #confort #classic 

# Installer et charger le package cluster
install.packages("cluster")
library(cluster)

# Fonction de catégorisation
definir_categorie_cluster <- function(data) {
  # Préparer les données
  data_prep <- data[, c("puissance", "longueur", "nbplaces", "nbportes","malusbonus","rejetsco2","coutenergie")]
  
  # Convertir longueur en facteur si ce n'est pas déjà fait
  if (!is.factor(data_prep$longueur)) {
    data_prep$longueur <- factor(data_prep$longueur)
  }
  
  # Normaliser les variables numériques
  data_norm <- scale(data_prep[, c("puissance", "nbplaces", "nbportes","malusbonus","rejetsco2","coutenergie")])
  
  # Clustering hiérarchique
  hc <- hclust(dist(data_norm), method = "ward.D")
  
  # Découper les clusters en 5 catégories
  nb_cluster <- 5
  coupes <- cutree(hc, k = nb_cluster)
  
  # Mapper les clusters aux catégories
  mapping_clusters_categories <- function(cluster) {
    if (cluster == 1) {
      return("citadine")
    } else if (cluster == 2) {
      return("sportive")
    } else if (cluster == 3) {
      return("familiale")
    } else if (cluster == 4) {
      return("confort")
    } else if (cluster == 5) {
      return("longue")
    }
  }
  
  # Ajouter la colonne "categorie" sans perdre les colonnes existantes
  data$categorie <- sapply(coupes, mapping_clusters_categories)
  
  # Renvoyer les données avec la catégorie ajoutée
  return(data)
}


definir_categorie_Immatriculation <- function(data) {
  # Préparer les données
  data_prep <- data[, c("puissance", "longueur", "nbplaces", "nbportes")]
  
  # Convertir longueur en facteur si ce n'est pas déjà fait
  if (!is.factor(data_prep$longueur)) {
    data_prep$longueur <- factor(data_prep$longueur)
  }
  
  # Normaliser les variables numériques
  data_norm <- scale(data_prep[, c("puissance", "nbplaces", "nbportes")])
  
  # Clustering hiérarchique
  hc <- hclust(dist(data_norm), method = "ward.D")
  
  # Découper les clusters en 5 catégories
  nb_cluster <- 5
  coupes <- cutree(hc, k = nb_cluster)
  
  # Mapper les clusters aux catégories
  mapping_clusters_categories <- function(cluster) {
    if (cluster == 1) {
      return("citadine")
    } else if (cluster == 2) {
      return("sportive")
    } else if (cluster == 3) {
      return("familiale")
    } else if (cluster == 4) {
      return("confort")
    } else if (cluster == 5) {
      return("longue")
    }
  }
  
  # Ajouter la colonne "categorie" sans perdre les colonnes existantes
  data$categorie <- sapply(coupes, mapping_clusters_categories)
  
  # Renvoyer les données avec la catégorie ajoutée
  return(data)
}




# Appliquer la fonction aux datasets
catalogue <- definir_categorie_cluster(catalogue)


#eto le andramana
immatriculation <- definir_categorie_Immatriculation(immatriculation)


# Convertir toutes les valeurs de la colonne "marque" en minuscules pour la fusion insensible à la casse
immatriculation$marque <- tolower(immatriculation$marque)
catalogue$marque <- tolower(catalogue$marque)
clientImmat$marque <- tolower(clientImmat$marque)

# Fusionner en ignorant la casse
immatriculation <- merge(immatriculation, catalogue[, c("marque", "categorie")], by = "marque", all.x = TRUE)
clientImmat <- merge(clientImmat, catalogue[, c("marque", "categorie")], by = "marque", all.x = TRUE)


# Vérifier le nombre d'éléments dans chaque catégorie
print(table(catalogue$categorie))
print(table(immatriculation$categorie))
print(table(clientImmat$categorie))
