library(RPostgres)
library(dplyr)
library(tidyverse)
library(data.table)
library(shiny)
library(shinydashboard)


conectarPostgreSql <- function(){
  conexao <- dbConnect(
    drv = Postgres(),
    host = "10.10.15.73",
    port = 5432,
    dbname = "SEC_PB",
    user = "postgres",
    password = "root"
  )
  return(conexao)
}
