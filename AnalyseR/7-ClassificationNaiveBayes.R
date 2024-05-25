# Installation/mise à jour des bibliothèques si nécessaire
install.packages("e1071")

# Activation des bibliothèques
library(e1071)
library(caret)

#--------------------------------------------------------------------#
# APPRENTISSAGE DES CLASSIFIEURS naiveBayes() AVEC DIFFERENTS PARAMETRAGES #
#--------------------------------------------------------------------#

# Affichage de l'aide 
?naiveBayes

# Apprentissage avec laplace = 0
nb_model1 <- naiveBayes(categorie ~ ., data = clientsImmat_EA, laplace = 0)
summary(nb_model1)

# Apprentissage avec laplace = 1
nb_model2 <- naiveBayes(categorie ~ ., data = clientsImmat_EA, laplace = 1)
summary(nb_model2)

#--------------------------------------------------------------------#
# TEST DES CLASSIFIEURS naiveBayes() ET CALCUL DES TAUX DE SUCCES #
#--------------------------------------------------------------------#

# Test et taux de succès pour le 1er paramétrage pour Naive Bayes
test_nb1 <- predict(nb_model1, clientsImmat_ET)
taux_nb1 <- sum(clientsImmat_ET$categorie == test_nb1) / nrow(clientsImmat_ET)
print(taux_nb1)
#----------> 0,592186612

# Test et taux de succès pour le 2nd paramétrage pour Naive Bayes
test_nb2 <- predict(nb_model2, clientsImmat_ET)
taux_nb2 <- sum(clientsImmat_ET$categorie == test_nb2) / nrow(clientsImmat_ET)
print(taux_nb2)
#----------> 0,592186612

