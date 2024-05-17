# Fonction pour définir la catégorie en fonction des critères 

  # Nous allons catégoriser les véhicules en cinq catégories principales en fonction de certaines caractéristiques pertinentes, à savoir :
  
  #citadine - courte et pas beaucoup de cheveaux
  
  #sportive - beaucoup de cheveaux & 3 portes
  
  #familiale - 7 places + pas puissante et très longue / longue / moyenne
  
  #confort - longue et puissante tres longue avec des cheveaux & prix & 5 portes
  
  #classic - le reste (5 portes, courte / moyenne / longue, puissance moyenne)

definir_categorie <- function(puissance, longueur, nbplaces, nbportes) {
  ifelse(puissance <= 150 & longueur %in% c("courte", "moyenne"), "citadine",
         ifelse(puissance > 200 & nbportes == 3, "sportive",
                ifelse(nbplaces > 5 | (puissance <= 200 & longueur %in% c("longue", "moyenne", "très longue")), "familiale",
                       ifelse(longueur %in% c("longue", "moyenne", "très longue") & puissance > 200 & nbportes == 5, "confort",
                              "classic"))))
}


# Appliquer la fonction aux différents datasets
catalogue$categorie <- with(catalogue, definir_categorie(puissance, longueur, nbplaces, nbportes))
immatriculation$categorie <- with(immatriculation, definir_categorie(puissance, longueur, nbplaces, nbportes))
clientImmat$categorie <- with(clientImmat, definir_categorie(puissance, longueur, nbplaces, nbportes))

# Vérifier le nombre d'éléments dans chaque catégorie
table(catalogue$categorie)
table(immatriculation$categorie)
table(clientImmat$categorie)
