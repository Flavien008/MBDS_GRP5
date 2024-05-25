# Installation/mise à jour des librairies si nécessaire
install.packages("kknn")
install.packages("caret")

# Activation des librairies
library(kknn)
library(caret)

#--------------------------------------------------------------------#
# APPRENTISSAGE DES CLASSIFIEURS kknn() AVEC DIFFERENTS PARAMETRAGES #
#--------------------------------------------------------------------#

# Affichage de l'aide 
? kknn

# Apprentissage avec k = 5 et distance = 1 (Manhattan distance)
knn_model1 <- kknn(categorie ~ ., train = clientsImmat_EA, test = clientsImmat_ET, k = 5, distance = 1)
summary(knn_model1)

# Apprentissage avec k = 10 et distance = 1 (Manhattan distance)
knn_model2 <- kknn(categorie ~ ., train = clientsImmat_EA, test = clientsImmat_ET, k = 10, distance = 1)
summary(knn_model2)

# Apprentissage avec k = 5 et distance = 2 (Euclidean distance)
knn_model3 <- kknn(categorie ~ ., train = clientsImmat_EA, test = clientsImmat_ET, k = 5, distance = 2)
summary(knn_model3)

# Apprentissage avec k = 10 et distance = 2 (Euclidean distance)
knn_model4 <- kknn(categorie ~ ., train = clientsImmat_EA, test = clientsImmat_ET, k = 10, distance = 2)
summary(knn_model4)

#--------------------------------------------------------------------#
# TEST DES CLASSIFIEURS kknn() ET CALCUL DES TAUX DE SUCCES #
#--------------------------------------------------------------------#

# Test et taux de succès pour le 1er paramétrage pour k-NN
predictions_knn1 <- fitted(knn_model1)
print(taux_knn1 <- sum(clientsImmat_ET$categorie == predictions_knn1) / nrow(clientsImmat_ET))
#----------> 0,622230391

# Test et taux de succès pour le 2nd paramétrage pour k-NN
predictions_knn2 <- fitted(knn_model2)
print(taux_knn2 <- sum(clientsImmat_ET$categorie == predictions_knn2) / nrow(clientsImmat_ET))
#----------> 0,644554356

# Test et taux de succès pour le 3ème paramétrage pour k-NN
predictions_knn3 <- fitted(knn_model3)
print(taux_knn3 <- sum(clientsImmat_ET$categorie == predictions_knn3) / nrow(clientsImmat_ET))
#----------> 0,623099288

# Test et taux de succès pour le 4ème paramétrage pour k-NN
predictions_knn4 <- fitted(knn_model4)
print(taux_knn4 <- sum(clientsImmat_ET$categorie == predictions_knn4) / nrow(clientsImmat_ET))
#----------> 0,643885974

