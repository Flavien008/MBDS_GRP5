# Projet de Ciblage de Véhicules pour un Concessionnaire Automobile

## Objectif du Projet

Nous avons été sollicités par un concessionnaire automobile pour l'aider à mieux cibler les véhicules qui pourraient intéresser ses clients. Pour cela, nous avons à notre disposition les éléments suivants :

- Un catalogue de véhicules
- Les fichiers clients concernant les achats de l'année en cours
- Un accès aux informations sur les immatriculations effectuées cette année
- Une brève documentation des données
- Une interview d'un vendeur

Notre solution doit permettre :

- À un vendeur d'identifier rapidement le type de véhicule le plus susceptible d'intéresser un client se présentant à la concession
- D'envoyer une documentation détaillée sur le véhicule le plus approprié aux clients sélectionnés par le service marketing

## Solution Proposée

Pour réaliser ce projet, nous avons divisé le problème en trois parties distinctes :

1. **Importation et Transformation des Données** - Cette étape est détaillée dans la section [Extraction des Données](https://github.com/Flavien008/MBDS_GRP5/tree/main/DATA_EXTRACTOR), où nous expliquons les différentes étapes d'importation et de transformation des données.
2. **Analyse des Données** - L'analyse est effectuée avec R et documentée dans la section [Analyse avec R](https://github.com/Flavien008/MBDS_GRP5/tree/main/AnalyseR), où nous examinons en détail l'ensemble des données.

## Architecture du Projet

Notre projet repose sur une machine Vagrant configurée par notre professeur [SergioSim](https://github.com/SergioSim). Vous pouvez consulter le dépôt correspondant à l'adresse suivante : [SergioSim/vagrant-projects](https://github.com/SergioSim/vagrant-projects/tree/staging/OracleDatabase/21.3.0).

- **Catalogue de Véhicules** : Stocké sur un serveur MongoDB.
- **Données O2 et Immatriculations** : Placées dans le système de fichiers distribué Hadoop (HDFS).
- **Données Clients et Marketing** : Hébergées sur un serveur Oracle NoSQL.

Toutes les données sont accessibles via Hive à l'aide de tables externes.

![Architecture Globale du Projet](https://github.com/Flavien008/MBDS_GRP5/blob/main/architecture.jpg)

## Répertoires Principaux

1. **[Extraction des Données](https://github.com/Flavien008/MBDS_GRP5/tree/main/DATA_EXTRACTOR)** : Processus d'importation et de mise en forme des données.
2. **[Analyse avec R](https://github.com/Flavien008/MBDS_GRP5/tree/main/AnalyseR)** : Analyse approfondie des données.

## Documents

- **[Hadoop Map Reduce](https://github.com/Flavien008/MBDS_GRP5/blob/main/HadoopMapReduce-Groupe5.pdf)** : Rapport de la démarche pour l'adaptation et l'intégration du fichier CO2.csv dans la table catalogue.
- **[Analyse R](https://github.com/Flavien008/MBDS_GRP5/blob/main/AnalyseR-Groupe5.pdf)** : Rapport de l'analyse dans R.

## Vidéo de présentation

**[Lien de la vidéo de présentation](https://drive.google.com/file/d/1gbPjelBLLrzj_ZK0fE58_MR2ZlnhHpDc/view?usp=sharing)**

## Conclusion

Grâce à cette architecture et à notre approche méthodique, nous visons à offrir une solution efficace pour aider le concessionnaire à cibler les véhicules susceptibles d'intéresser ses clients et à fournir des informations détaillées aux clients sélectionnés par le service marketing.

Pour plus de détails, veuillez consulter les répertoires individuels de notre projet.
