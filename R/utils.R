## -------------------------------------------
## Script: utils.R
##
## Descrição: Script com as funções e bibliotecas em comum que serão utilizadas no sistema Recursos Federais PB
##
## Autor: Wendeley Fernandes
##
## Data: 28/08/2019
##
## -------------------------------------------
## 
## Bibliotecas Padrões
   library(RPostgres)
   library(dplyr)
   library(tidyverse)
   library(data.table)
   library(shiny)
   library(shinydashboard)
   library(plotly)

## -------------------------------------------
##
## Sumário de Funções
##
## conectar_postgre_sql
##
## -------------------------------------------


conectar_postgre_sql <- function(){
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
