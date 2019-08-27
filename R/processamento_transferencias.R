# Bibliotecas
library(dplyr)
library(tidyverse)
library(data.table)

# Lendo arquivo de transferências PB
ler_rds_recursos_pb <- function(caminho){
  caminho_rds <- caminho
  recursos_pb <- readRDS(caminho_rds)
  return(recursos_pb)
}

# Tratanto o rds e removendo colunas desnecessárias para a aplicação
tratar_rds_recursos_pb <- function(recursos_pb){
  rds <- recursos_pb
  rds$ano_mes <- NULL
  rds$uf <- NULL
  rds$codigo_municipio_siafi <- NULL
  rds$codigo_funcao <- NULL
  rds$codigo_subfuncao <- NULL
  rds$codigo_elemento_despesa <- NULL
  rds$codigo_grupo_despesa <- NULL
  rds$codigo_modalidade_aplicacao_despesa <- NULL
  return(rds)
}

# Salvar o rds na pasta data
salvar_rds_recursos_pb_enxuto <- function(arquivo, caminho){
  saveRDS(object = arquivo, file = caminho)
}


# INÍCIO #
# Tratando o dataframe de recursos
recursos_clean <- ler_rds_recursos_pb("data/transf_pb.rds")
recursos <- tratar_rds_recursos_pb(recursos_clean)
salvar_rds_recursos_pb_enxuto(recursos, 'data/recursos_pb_enxuto.rds')


caminho_rds_recursos <- "data/recursos_pb_enxuto.rds"
recursos_pb <- readRDS(caminho_rds_transferencias)
