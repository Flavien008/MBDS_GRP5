# Créer une table temporaire pour stocker les résultats
dbWriteTable(hiveDB, "marketing_temp", marketing, overwrite = TRUE, row.names = FALSE)

# Mise à jour de la table marketing_ext avec les nouvelles prédictions
query <- "
INSERT OVERWRITE TABLE marketing_ext
SELECT m.*, t.predicted_categorie
FROM marketing m
JOIN marketing_temp t
ON m.client_id = t.client_id
"
dbExecute(hiveDB, query)

# Nettoyage: suppression de la table temporaire
dbRemoveTable(hiveDB, "marketing_temp")

# Fermeture de la connexion
dbDisconnect(hiveDB)