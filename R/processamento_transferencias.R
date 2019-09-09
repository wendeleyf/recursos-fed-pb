## -------------------------------------------
## Script: processamento_transferencias.R
##
## Descrição: Script para leitura, tratamento e inserção de dos Recursos Federais na Paraíba no banco de dados
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
## ler_rds_recursos_pb
## tratar_rds_recursos_pb
## salvar_rds_recursos_pb_enxuto
## inserir_recursos_no_banco_de_dados
## 
## -------------------------------------------


# -
# Lê um arquivo RDS no computador para trabalhá-lo no R
# @param {character} caminho - Diretório onde o arquivo está no computador
# @return {data.frame} recursos_pb - Retorna um data.frame a partir do RDS lido.
# - 
ler_rds_recursos_pb <- function(caminho){
  caminho_rds <- caminho
  recursos_pb <- readRDS(caminho_rds)
  return(recursos_pb)
}

# -
# Retorna o data.frame tratado, removendo colunas desnecessárias para a aplicação
# @param {data.frame} recursos_pb - O data.frame que irá ser trabalhado, é necessário que seja o rds específico de recursos 
# @return {data.frame} rds - O data.frame tratado e sem colunas desnecessárias
# - 
tratar_rds_recursos_pb <- function(recursos_pb){
  rds <- recursos_pb
  #rds$ano_mes <- NULL
  rds$uf <- NULL
  rds$codigo_municipio_siafi <- NULL
  rds$codigo_funcao <- NULL
  rds$codigo_subfuncao <- NULL
  rds$codigo_elemento_despesa <- NULL
  rds$codigo_grupo_despesa <- NULL
  rds$codigo_modalidade_aplicacao_despesa <- NULL
  rds <- tibble::rowid_to_column(rds, "id_recurso")
  return(rds)
}


# -
# Insere o data.frame de recursos tratado no banco de dados
# @param {data.frame} recursos - O data.frame de recursos que irá ser inserido na base de dados
# - 
inserir_recursos_no_banco_de_dados <- function(recursos){
  dados <- recursos
  conexao <- conectar_postgre_sql()
  dbWriteTable(conexao, "recursos_portal_transparencia", recursos, row.names = FALSE, overwrite = TRUE)
  dbSendQuery(conexao, "ALTER TABLE recursos_portal_transparencia ADD PRIMARY KEY (id_recurso)")
  dbDisconnect(conexao)
}


# INÍCIO #
# Tratando o dataframe de recursos
recursos_clean <- ler_rds_recursos_pb("data/transf_pb.rds")
recursos <- tratar_rds_recursos_pb(recursos_clean)
inserir_recursos_no_banco_de_dados(recursos)
salvar_rds_recursos_pb_enxuto(recursos, 'data/recursos_pb_enxuto.rds')
recursos <- buscar_recursos_no_banco_de_dados()
caminho_rds_recursos <- "data/recursos_pb_enxuto.rds"
recursos_pb <- readRDS(caminho_rds_transferencias)
total <- buscar_total_recursos_por_municipio()

