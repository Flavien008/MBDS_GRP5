# Installation/mise à jour des librairies si nécessaire
install.packages("randomForest")

# Activation des librairies
library(randomForest)

#--------------------------------------------------------------------#
# APPRENTISSAGE DES CLASSIFIEURS randomForest() AVEC DIFFERENTS PARAMETRAGES #
#--------------------------------------------------------------------#

# Affichage de l'aide 
? randomForest

# Apprentissage avec ntree = 500 et mtry = 2
rf_model1 <- randomForest(categorie ~ ., data = clientsImmat_EA, ntree = 500, mtry = 2)
print(rf_model1)
varImpPlot(rf_model1)

# Apprentissage avec ntree = 1000 et mtry = 2
rf_model2 <- randomForest(categorie ~ ., data = clientsImmat_EA, ntree = 1000, mtry = 2)
print(rf_model2)
varImpPlot(rf_model2)

# Apprentissage avec ntree = 500 et mtry = 3
rf_model3 <- randomForest(categorie ~ ., data = clientsImmat_EA, ntree = 500, mtry = 3)
 print(rf_model3)
varImpPlot(rf_model3)

# Apprentissage avec ntree = 1000 et mtry = 3
rf_model4 <- randomForest(categorie ~ ., data = clientsImmat_EA, ntree = 1000, mtry = 3)
print(rf_model4)
varImpPlot(rf_model4)

#--------------------------------------------------------------------#
# TEST DES CLASSIFIEURS randomForest() ET CALCUL DES TAUX DE SUCCES #
#--------------------------------------------------------------------#

# Test et taux de succès pour le 1er paramétrage pour Random Forest
test_rf1 <- predict(rf_model1, clientsImmat_ET)
print(taux_rf1 <- sum(clientsImmat_ET$categorie == test_rf1) / nrow(clientsImmat_ET))
#----------> 0,682718979

# Test et taux de succès pour le 2nd paramétrage pour Random Forest
test_rf2 <- predict(rf_model2, clientsImmat_ET)
print(taux_rf2 <- sum(clientsImmat_ET$categorie == test_rf2) / nrow(clientsImmat_ET))
#----------> 0,682952912

# Test et taux de succès pour le 3ème paramétrage pour Random Forest
test_rf3 <- predict(rf_model3, clientsImmat_ET)
print(taux_rf3 <- sum(clientsImmat_ET$categorie == test_rf3) / nrow(clientsImmat_ET))
#----------> 0,67329479

# Test et taux de succès pour le 4ème paramétrage pour Random Forest
test_rf4 <- predict(rf_model4, clientsImmat_ET)
print(taux_rf4 <- sum(clientsImmat_ET$categorie == test_rf4) / nrow(clientsImmat_ET))
#----------> 0,672592989

