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

dbExecute(hiveDB, sql_insert)


dbGetQuery(hiveDB,"select * from marketing_result")


# Fermeture de la connexion
dbDisconnect(hiveDB)
