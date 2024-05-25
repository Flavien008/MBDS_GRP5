# Analyse de Données de Véhicules

Ce projet d'analyse de données de véhicules a pour objectif de prédire la catégorie de véhicules pour les clients en utilisant diverses méthodes de classification. 

## Introduction

Le projet se compose de plusieurs étapes allant de la connexion à la base de données, l'exploration des données, le clustering pour définir des catégories de véhicules, jusqu'à l'application de différents modèles de classification pour prédire la catégorie de véhicules pour les données marketing.

Nous avons utilisé R pour ce projet en raison de sa puissance et de sa flexibilité pour l'analyse de données, la modélisation statistique et la visualisation. 


### Contexte

Cette analyse de données est une étape suivant la partie extraction de données, où toutes les données nécessaires ont été extraites et stockées dans Hive. Cette partie du projet consiste à récupérer ces données à partir de Hive pour effectuer l'analyse et les prédictions.


## Installation

Pour installer les packages nécessaires pour ce projet, veuillez vous référer au fichier [INSTALLATION.md](INSTALLATION.md).


## Ordre d'Exécution des Fichiers

1. **1-DriverConnection.R**
   - **Description**: Ce script établit la connexion à la base de données contenant les informations sur les véhicules et les clients.
   - **Exécution**: Exécutez ce script en premier pour vous assurer que la connexion à la base de données est correctement établie. **Note**: Si vous avez déjà chargé le fichier `.RData`, cette étape n'est plus nécessaire.

2. **2-DataExploration.R**
   - **Description**: Ce script effectue une analyse exploratoire des données pour comprendre les distributions, les relations entre les variables et identifier les éventuelles valeurs aberrantes et les corriger.
   - **Exécution**: Exécutez ce script après avoir établi la connexion à la base de données pour explorer et comprendre les données avant de procéder à l'analyse.
   **Note**: Si vous avez déjà chargé le fichier `.RData`, l'étape de chargement des données n'est plus nécessaire.

3. **3-categoriesVehicules.R**
   - **Description**: Ce script utilise le clustering pour définir des catégories de véhicules basées sur les caractéristiques des données. Les catégories sont ensuite attribuées aux véhicules.
   - **Exécution**: Exécutez ce script après l'analyse exploratoire pour effectuer le clustering et définir les catégories de véhicules.

4. **4-ClassificationTree.R**
   - **Description**: Ce script applique l'algorithme de classification par arbre de décision pour prédire la catégorie de véhicules.
   - **Exécution**: Exécutez ce script pour construire et évaluer un modèle de classification par arbre de décision.

5. **5-ClassificationRandomForest.R**
   - **Description**: Ce script utilise l'algorithme Random Forest pour prédire la catégorie de véhicules.
   - **Exécution**: Exécutez ce script pour construire et évaluer un modèle Random Forest.

6. **6-ClassificationNeuralNetworks.R**
   - **Description**: Ce script applique l'algorithme des réseaux de neurones pour prédire la catégorie de véhicules.
   - **Exécution**: Exécutez ce script pour construire et évaluer un modèle de réseaux de neurones.

7. **7-ClassificationNaiveBayes.R**
   - **Description**: Ce script utilise l'algorithme de classification Naive Bayes pour prédire la catégorie de véhicules.
   - **Exécution**: Exécutez ce script pour construire et évaluer un modèle Naive Bayes.

8. **8-ClassificationKNN.R**
   - **Description**: Ce script applique l'algorithme k-Nearest Neighbors (k-NN) pour prédire la catégorie de véhicules.
   - **Exécution**: Exécutez ce script pour construire et évaluer un modèle k-NN.

9. **9-ApplicationModèle.R**
   - **Description**: Ce script utilise le modèle de classification ayant obtenu le meilleur taux de succès pour prédire la catégorie de véhicules pour les données marketing.
   - **Exécution**: Exécutez ce script en dernier pour appliquer le modèle de prédiction aux données marketing et obtenir les prédictions finales.

## Informations Supplémentaires

- **Comparaison des Modèles**: Nous avons utilisé cinq types de classification pour identifier celui qui offre la meilleure précision. Les modèles testés incluent l'arbre de décision, la forêt aléatoire, les réseaux de neurones, Naive Bayes et k-NN. Le modèle C5.0 avec le paramétrage `tree_C54` a donné le taux de succès le plus élevé et a été utilisé pour les prédictions finales.
- **.Rproj.user, .RData, .Rhistory, AnalyseR.Rproj**: Ces fichiers sont utilisés par RStudio pour gérer le projet et l'environnement de travail.
- **Données**: Assurez-vous que toutes les données nécessaires sont disponibles et correctement formatées avant d'exécuter les scripts.
- **Prétraitement**: Certaines étapes de prétraitement des données, comme la standardisation, sont essentielles pour garantir des performances optimales des modèles.
