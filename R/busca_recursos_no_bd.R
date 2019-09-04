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

# -
# Retorna um data.frame de recursos federais, coletados na base de dados e então tratados adicionando uma coluna de
# 'esfera', para categorizar os tipos de recursos
# @return {data.frame} recursos - O data.frame tratado por esferas 
# - 
buscar_recursos_por_tipo <- function(){
  conexao <- conectar_postgre_sql()
  recursos_tbl <- tbl(conexao, "recursos_portal_transparencia")
  recursos <- recursos_tbl %>%
    collect()
  recursos$esfera[recursos$tipo_favorecido == "Administracao Publica Estadual ou do Distrito Federal"] <- "Estado"
  recursos$esfera[recursos$tipo_favorecido == "Administracao Publica Municipal"] <- "Municipal"
  recursos$esfera[recursos$tipo_favorecido == "Entidades Sem Fins Lucrativos"] <- "Entidades Sem Fins Lucrativos"
  
  recursos$esfera[recursos$tipo_favorecido == "Fundo Publico" & grepl(x = recursos$nome_favorecido, pattern = "MUN.") == TRUE] <- "Municipal"
  recursos$esfera[recursos$tipo_favorecido == "Fundo Publico" & grepl(x = recursos$nome_favorecido, pattern = "MINICIPAL") == TRUE] <- "Municipal"
  recursos$esfera[recursos$tipo_favorecido == "Fundo Publico" & grepl(x = recursos$nome_favorecido, pattern = "FMS") == TRUE] <- "Municipal"
  recursos$esfera[recursos$tipo_favorecido == "Fundo Publico" & grepl(x = recursos$nome_favorecido, pattern = "ESTADU") == TRUE] <- "Estado"
  recursos
}

# buscar_lista_funcao_recursos <- function(){
#   conexao <- conectar_postgre_sql()
#   lista_funcao_tbl <- tbl(conexao, "recursos_portal_transparencia")
#   lista_funcao <- lista_funcao_tbl %>%
#     distinct(nome_funcao) %>%
#     collect()
#   lista_funcao
# }

# INÍCIO
recursos <- buscar_recursos_no_banco_de_dados()

