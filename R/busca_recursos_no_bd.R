## -------------------------------------------
## Script: busca_recursos_no_bd.R
##
## Descrição: Script para buscas de registros dos recursos federais na base de dados
##
## Autor: Wendeley Fernandes
##
## Data: 28/08/2019 
##
## -------------------------------------------
## 
## Bibliotecas Padrões
   source('R/utils.R')
## -------------------------------------------
##
## Sumário de Funções
##
## buscar_recursos_no_banco_de_dados
## buscar_total_recursos_por_municipio
## 
## -------------------------------------------


# -
# Retorna os registros de recursos federais salvos na base de dados como data.frame
# @return {data.frame} recursos - data.frame com registros da base de dados
# - 
buscar_recursos_no_banco_de_dados <- function(){
  conexao <- conectar_postgre_sql()
  recursos_tbl <- tbl(conexao, "recursos_portal_transparencia")
  recursos <- recursos_tbl %>%
    collect()
  dbDisconnect(conexao)
  recursos
}

# -
# Retorna o total de recursos federais como data.frame, agrupados por municipios
# @return {data.frame} total_recursos - O data.frame com o total de recursos federais
# - 
buscar_total_recursos_por_municipio <- function(){
  conexao <- conectar_postgre_sql()
  recursos_tbl <- tbl(conexao, "recursos_portal_transparencia")
  total_recursos <- recursos_tbl %>%
    group_by(nome_municipio) %>%
    summarise(total_transferido = sum(valor_transferido, na.rm = TRUE)) %>%
    arrange(desc(total_transferido)) %>%
    collect()
  dbDisconnect(conexao)
  total_recursos$nome_municipio[total_recursos$nome_municipio == ''] <- 'GOVERNO DA PARAÍBA'
  total_recursos
}


# INÍCIO
recursos <- buscar_recursos_no_banco_de_dados()
