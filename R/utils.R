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
   library(shinyWidgets)
## -------------------------------------------
##
## Sumário de Funções
##
## conectar_postgre_sql
##
## -------------------------------------------

# -
# Retorna uma conexão que será 
# @return {data.frame} rds - O data.frame tratado e sem colunas desnecessárias
# - 
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
# -
# Formata valores (Função Wendeley)
# Retorna valores formatado
# @return {value}  - O valor formatado padrão 000.00,00
# - 
formatar <- function(valor){
  format(valor, digits = 10, big.mark = ".", decimal.mark = ",")
}
