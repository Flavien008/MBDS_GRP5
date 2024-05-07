from pyspark import SparkContext

sc = SparkContext("local[*]", "NettoyageMapReduceCO2")

# Charger les données depuis le fichier CSV
co2_rdd = sc.textFile('/user/vagrant/input/CO2.csv')

# Fonction pour nettoyer les caractères spéciaux et corriger les marques mal orthographiées
def nettoyer_caracteres(line):
    # Remplacer les caractères spéciaux et les fautes typographiques
    cleaned = line.replace('Ã\xa0 aimant permanent,', 'à aimant permanent')
    cleaned = cleaned.replace('\xa0', '')  # Enlever les espaces non conventionnels
    cleaned = cleaned.replace('Ã©', 'é')  # Corriger les caractères accentués
    cleaned = cleaned.replace('€1', '€')  # Corriger le symbole de l'euro
    cleaned = cleaned.replace('€', '')  # Retirer le symbole de l'euro
    cleaned = cleaned.replace('Ã¨', 'è')  # Corriger les caractères accentués
    return cleaned

# Nettoyer les lignes du CSV et les diviser en colonnes
lignes_propres_rdd = co2_rdd.map(nettoyer_caracteres).map(lambda line: line.split(","))

# Fonction pour corriger les marques spécifiques et retirer les lignes vides
def corriger_marque(ligne):
    marque = ligne[1].split(' ')[0]  # Utiliser le premier mot de la marque
    if marque == 'LAND':
        marque = 'LAND ROVER'
    elif marque in ['"KIA"', '"VOLKSWAGEN', '"KIA']:
        marque = marque.replace('"', '')  # Enlever les guillemets
    return [ligne[0], marque, ligne[2], ligne[3], ligne[4]]

# Corriger les marques
marques_corrigees_rdd = lignes_propres_rdd.map(corriger_marque).filter(lambda x: x[0] != '')

# Fonction pour convertir une chaîne en entier ou renvoyer '-' s'il y a un problème
def convertir_en_entier(value):
    return int(value) if value != '-' else '-'

# Convertir les valeurs appropriées en entiers
entiers_rdd = marques_corrigees_rdd.map(lambda x: (x[1], convertir_en_entier(x[2]), convertir_en_entier(x[3]), int(x[4])))

# Calculer la moyenne pour les colonnes contenant des valeurs manquantes
valeurs_valides_rdd = entiers_rdd.map(lambda x: x[1]).filter(lambda x: x != '-')
moyenne_valeur = valeurs_valides_rdd.mean()

# Fonction pour remplacer les valeurs manquantes par une moyenne donnée
def remplacer_par_moyenne(value, moyenne):
    return moyenne if value == '-' else value

# Remplacer les valeurs manquantes par la moyenne calculée
valeurs_corrigees_rdd = entiers_rdd.map(lambda x: (x[0], remplacer_par_moyenne(x[1], moyenne_valeur), x[2], x[3]))

# Réduire par clé (marque) pour obtenir les sommes des colonnes
aggregated_rdd = valeurs_corrigees_rdd.map(lambda x: (x[0], (x[1], x[2], x[3], 1)))
reduced_rdd = aggregated_rdd.reduceByKey(lambda x, y: (x[0] + y[0], x[1] + y[1], x[2] + y[2], x[3] + y[3]))

# Calculer les moyennes finales pour chaque marque
moyennes_rdd = reduced_rdd.map(lambda x: (x[0], x[1][0] / x[1][3], x[1][1] / x[1][3], x[1][2] / x[1][3]))

# Convertir les résultats en string pour l'enregistrement
resultats_string = moyennes_rdd.map(lambda x: f"{x[0]},{x[1]},{x[2]},{x[3]}")

# Enregistrer les résultats dans des fichiers texte
resultats_string.saveAsTextFile('/user/vagrant/output/clean_co2')