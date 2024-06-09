#-------------------------#
# PREPARATION DES DONNEES #
#-------------------------#

# Sélection des colonnes nécessaires pour l'analyse
clientsImmat <- clientsImmat[, c("age", "sexe", "taux", "situation_familiale", "nbr_enfant", "voiture_2", "categorie")]


clientsImmat$sexe<-as.factor(clientsImmat$sexe)
clientsImmat$situation_familiale<-as.factor(clientsImmat$situation_familiale)
clientsImmat$categorie<-as.factor(clientsImmat$categorie)


# Préparation des ensembles d'apprentissage et de test
set.seed(123)  # Fixe la graine aléatoire pour la reproductibilité
index <- sample(1:nrow(clientsImmat), 0.7 * nrow(clientsImmat))  # Création des indices aléatoires pour l'ensemble d'apprentissage
clientsImmat_EA <- clientsImmat[index, ]
clientsImmat_ET <- clientsImmat[-index, ]

# Installation/mise à jour des librairies si nécessaire
# install.packages("rpart")
# install.packages("rpart.plot")
# install.packages("C50")
# install.packages("tree")

# Activation des librairies
library(rpart)
library(rpart.plot)
library(C50)
library(tree)


#---------------------------------------------------------------------#
# APPRENTISSAGE DES CLASSIFIEURS rpart() AVEC DIFFERENTS PARAMETRAGES #
#---------------------------------------------------------------------#

# Affichage de l'aide 
? rpart()

# Sélection d'attribut par Coefficient de Gini et effectif minimal d'un nœud de 10
tree_rp1 <- rpart(categorie~., clientsImmat_EA, parms = list(split = "gini"), control = rpart.control(minbucket = 10))
rpart.plot(tree_rp1, cex = 0.5)

# Sélection d'attribut par Coefficient de Gini et effectif minimal d'un nœud de 5
tree_rp2 <- rpart(categorie~., clientsImmat_EA, parms = list(split = "gini"), control = rpart.control(minbucket = 5))
rpart.plot(tree_rp2, cex = 0.5)

# Sélection d'attribut par Information Gain et effectif minimal d'un nœud de 10
tree_rp3 <- rpart(categorie~., clientsImmat_EA, parms = list(split = "information"), control = rpart.control(minbucket = 10))
rpart.plot(tree_rp3, cex = 0.5)

# Sélection d'attribut par Information Gain et effectif minimal d'un nœud de 5
tree_rp4 <- rpart(categorie~., clientsImmat_EA, parms = list(split = "information"), control = rpart.control(minbucket = 5))
rpart.plot(tree_rp4, cex = 0.5)


#----------------------------------------------------------------#
# TEST DES DES CLASSIFIEURS rpart() ET CALCUL DES TAUX DE SUCCES #
#----------------------------------------------------------------#

# Application de tree_rp1 à l'ensemble de test
test_rp1 <- predict(tree_rp1, clientsImmat_ET, type = "class")
# Calcul du taux de succès : nombre de succès sur nombre total d'exemples de test
print(taux_rp1 <- nrow(clientsImmat_ET[clientsImmat_ET$categorie == test_rp1, ]) / nrow(clientsImmat_ET))

# Application de tree_rp2 à l'ensemble de test
test_rp2 <- predict(tree_rp2, clientsImmat_ET, type = "class")
# Calcul du taux de succès : nombre de succès sur nombre total d'exemples de test
print(taux_rp2 <- nrow(clientsImmat_ET[clientsImmat_ET$categorie == test_rp2, ]) / nrow(clientsImmat_ET))

# Application de tree_rp3 à l'ensemble de test
test_rp3 <- predict(tree_rp3, clientsImmat_ET, type = "class")
# Calcul du taux de succès : nombre de succès sur nombre total d'exemples de test
print(taux_rp3 <- nrow(clientsImmat_ET[clientsImmat_ET$categorie == test_rp3, ]) / nrow(clientsImmat_ET))

# Application de tree_rp4 à l'ensemble de test
test_rp4 <- predict(tree_rp4, clientsImmat_ET, type = "class")
# Calcul du taux de succès : nombre de succès sur nombre total d'exemples de test
print(taux_rp4 <- nrow(clientsImmat_ET[clientsImmat_ET$categorie == test_rp4, ]) / nrow(clientsImmat_ET))


#--------------------------------------------------------------------#
# APPRENTISSAGE DES CLASSIFIEURS C5.0() AVEC DIFFERENTS PARAMETRAGES #
#--------------------------------------------------------------------#

# Affichage de l'aide 
? C5.0


# Apprentissage avec minCases = 10 et noGlobalPruning = FALSE
tree_C51 <- C5.0(categorie ~ ., data = clientsImmat_EA, control = C5.0Control(minCases = 10, noGlobalPruning = FALSE))
plot(tree_C51, type="simple")

# Apprentissage avec minCases = 10 et noGlobalPruning = TRUE
tree_C52 <- C5.0(categorie ~ ., data = clientsImmat_EA, control = C5.0Control(minCases = 10, noGlobalPruning = TRUE))
plot(tree_C52, type="simple")

# Apprentissage avec minCases = 5 et noGlobalPruning = FALSE
tree_C53 <- C5.0(categorie ~ ., data = clientsImmat_EA, control = C5.0Control(minCases = 5, noGlobalPruning = FALSE))
plot(tree_C53, type="simple")

# Apprentissage avec minCases = 5 et noGlobalPruning = TRUE
tree_C54 <- C5.0(categorie ~ ., data = clientsImmat_EA, control = C5.0Control(minCases = 5, noGlobalPruning = TRUE))
plot(tree_C54, type="simple")

#----------------------------------------------------------------#
# TEST DES CLASSIFIEURS C5.0() ET CALCUL DES TAUX DE SUCCES #
#----------------------------------------------------------------#

# Test et taux de succès pour le 1er paramétrage pour C5.0()
test_C51 <- predict(tree_C51, clientsImmat_ET)
print(taux_C51 <- sum(clientsImmat_ET$categorie == test_C51) / nrow(clientsImmat_ET))

# Test et taux de succès pour le 2nd paramétrage pour C5.0()
test_C52 <- predict(tree_C52, clientsImmat_ET)
print(taux_C52 <- sum(clientsImmat_ET$categorie == test_C52) / nrow(clientsImmat_ET))

# Test et taux de succès pour le 3ème paramétrage pour C5.0()
test_C53 <- predict(tree_C53, clientsImmat_ET)
print(taux_C53 <- sum(clientsImmat_ET$categorie == test_C53) / nrow(clientsImmat_ET))

# Test et taux de succès pour le 4ème paramétrage pour C5.0()
test_C54 <- predict(tree_C54, clientsImmat_ET)
print(taux_C54 <- sum(clientsImmat_ET$categorie == test_C54) / nrow(clientsImmat_ET))


#--------------------------------------------------------------------#
# APPRENTISSAGE DES CLASSIFIEURS tree() AVEC DIFFERENTS PARAMETRAGES #
#--------------------------------------------------------------------#

# Affichage de l'aide 
? tree


# Apprentissage avec split = "deviance" et mincut = 10
tree_tr1 <- tree(categorie ~ ., data = clientsImmat_EA, split = "deviance", control = tree.control(nrow(clientsImmat_EA), mincut = 10))
plot(tree_tr1)
text(tree_tr1, pretty = 0)

# Apprentissage avec split = "deviance" et mincut = 5
tree_tr2 <- tree(categorie ~ ., data = clientsImmat_EA, split = "deviance", control = tree.control(nrow(clientsImmat_EA), mincut = 5))
plot(tree_tr2)
text(tree_tr2, pretty = 0)


#----------------------------------------------------------------#
# TEST DES DES CLASSIFIEURS tree() ET CALCUL DES TAUX DE SUCCES #
#----------------------------------------------------------------#

# Test et taux de succès pour le 1er paramétrage pour tree()
test_tr1 <- predict(tree_tr1, clientsImmat_ET, type = "class")
print(taux_tr1 <- sum(clientsImmat_ET$categorie == test_tr1) / nrow(clientsImmat_ET))

# Test et taux de succès pour le 2nd paramétrage pour tree()
test_tr2 <- predict(tree_tr2, clientsImmat_ET, type = "class")
print(taux_tr2 <- sum(clientsImmat_ET$categorie == test_tr2) / nrow(clientsImmat_ET))

