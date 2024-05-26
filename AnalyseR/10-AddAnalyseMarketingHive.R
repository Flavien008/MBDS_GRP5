#IMPORTANT: Il faut être connecté à la base dans R pour pouvoir faire cette étape
# hiveDB <- dbConnect(odbc::odbc(), "Hive Driver")

# Creation de la table "marketing_result"
create_table_query <- "
CREATE TABLE IF NOT EXISTS marketing_result (
    id INT,
    age INT,
    sexe STRING,
    taux INT,
    situation_familiale STRING,
    nbr_enfant INT,
    voiture_2 BOOLEAN,
    predicted_categorie STRING
);
"

dbExecute(hiveDB, create_table_query)

# Fonction pour échapper les valeurs et les formater comme des chaînes SQL
escape_values <- function(value) {
  if (is.numeric(value)) {
    return(as.character(value))
  } else {
    return(paste0("'", gsub("'", "''", as.character(value)), "'"))
  }
}

# Convertir chaque ligne du data frame en une chaîne SQL
convert_to_sql_string <- function(row) {
  values <- sapply(row, escape_values)
  return(paste0("(", paste(values, collapse = ", "), ")"))
}

# Appliquer la conversion à chaque ligne du data frame
sql_values <- apply(marketing, 1, convert_to_sql_string)

# Nom de la table et des colonnes
table_name <- "marketing_result"
columns <- names(marketing)

# Créer la requête SQL d'insertion
sql_insert <- paste0("INSERT INTO ", table_name, " (", paste(columns, collapse = ", "), ") VALUES ", paste(sql_values, collapse = ", "))

# Afficher la requête SQL générée pour vérification
cat("SQL Insert Query:\n", sql_insert, "\n")

dbExecute(hiveDB, sql_insert)


dbGetQuery(hiveDB,"select * from marketing_result")


# Fermeture de la connexion
dbDisconnect(hiveDB)
