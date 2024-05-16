install.packages(c("RJDBC", "DBI", "rJava", "odbc"))
library(odbc)
library(DBI)
library(rJava)
library(RJDBC)
hiveDB <- dbConnect(odbc::odbc(), "Hive Driver")
dbGetQuery(hiveDB,"select * from catalogue_ext")



