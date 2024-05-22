
#----------------------------------------------------------------#
# APPLICATION DU MODELE SUR LES DONNEES MARKETING #
#----------------------------------------------------------------#

# Prétraitement des données marketing
marketing$sexe <- as.factor(marketing$sexe)
marketing$situation_familiale <- as.factor(marketing$situation_familiale)

# Utilisation du modèle C5.0 avec le meilleur taux de succès pour prédire les catégories des données marketing
marketing_predictions <- predict(tree_C54, marketing)

# Ajout des prédictions aux données marketing
marketing$predicted_categorie <- marketing_predictions

# Affichage des résultats
print(head(marketing))
