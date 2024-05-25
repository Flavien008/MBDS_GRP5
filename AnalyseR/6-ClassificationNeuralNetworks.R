# Installation/mise à jour des librairies si nécessaire
 install.packages("nnet")
 install.packages("caret")

# Activation des librairies
library(nnet)
library(caret)

#--------------------------------------------------------------------#
# APPRENTISSAGE DES CLASSIFIEURS nnet() AVEC DIFFERENTS PARAMETRAGES #
#--------------------------------------------------------------------#

# Affichage de l'aide 
? nnet

# Apprentissage avec size = 5 et decay = 0.1
nn_model1 <- nnet(categorie ~ ., data = clientsImmat_EA, size = 5, decay = 0.1, maxit = 200)
print(nn_model1)

# Apprentissage avec size = 10 et decay = 0.1
nn_model2 <- nnet(categorie ~ ., data = clientsImmat_EA, size = 10, decay = 0.1, maxit = 200)
print(nn_model2)

# Apprentissage avec size = 5 et decay = 0.01
nn_model3 <- nnet(categorie ~ ., data = clientsImmat_EA, size = 5, decay = 0.01, maxit = 200)
print(nn_model3)

# Apprentissage avec size = 10 et decay = 0.01
nn_model4 <- nnet(categorie ~ ., data = clientsImmat_EA, size = 10, decay = 0.01, maxit = 200)
print(nn_model4)

#--------------------------------------------------------------------#
# TEST DES CLASSIFIEURS nnet() ET CALCUL DES TAUX DE SUCCES #
#--------------------------------------------------------------------#

# Test et taux de succès pour le 1er paramétrage pour Neural Network
test_nn1 <- predict(nn_model1, clientsImmat_ET, type = "class")
print(taux_nn1 <- sum(clientsImmat_ET$categorie == test_nn1) / nrow(clientsImmat_ET))
#----------> 0,560037429

# Test et taux de succès pour le 2nd paramétrage pour Neural Network
test_nn2 <- predict(nn_model2, clientsImmat_ET, type = "class")
print(taux_nn2 <- sum(clientsImmat_ET$categorie == test_nn2) / nrow(clientsImmat_ET))
#----------> 0,650502958

# Test et taux de succès pour le 3ème paramétrage pour Neural Network
test_nn3 <- predict(nn_model3, clientsImmat_ET, type = "class")
print(taux_nn3 <- sum(clientsImmat_ET$categorie == test_nn3) / nrow(clientsImmat_ET))
#----------> 0,631320389

# Test et taux de succès pour le 4ème paramétrage pour Neural Network
test_nn4 <- predict(nn_model4, clientsImmat_ET, type = "class")
print(taux_nn4 <- sum(clientsImmat_ET$categorie == test_nn4) / nrow(clientsImmat_ET))
#----------> 0,659258764

