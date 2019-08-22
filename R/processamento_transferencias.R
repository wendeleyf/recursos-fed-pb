# Bibliotecas
library(dplyr)
library(tidyverse)
library(data.table)

# Lendo arquivo de transferências PB
ler_rds_transferencias_pb <- function(caminho){
  caminho_rds <- caminho
  transferencias_pb <- readRDS(caminho_rds)
  return(transferencias_pb)
}

# Tratanto o rds e removendo colunas desnecessárias para a aplicação
tratar_rds_transferencias_pb <- function(transferencias_pb){
  rds <- transferencias_pb
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
salvar_rds_transferencias_pb_enxutas <- function(arquivo, caminho){
  saveRDS(object = arquivo, file = caminho)
}

salvar_rds_transferencias_pb_enxutas(transferencias, 'data/transferencias_pb_enxuta.rds')


