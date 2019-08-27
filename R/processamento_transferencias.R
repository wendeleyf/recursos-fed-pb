# Bibliotecas
source('R/utils.R')

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
  rds <- tibble::rowid_to_column(rds, "id_recurso")
  return(rds)
}

# Salvar o rds na pasta data
salvar_rds_recursos_pb_enxuto <- function(arquivo, caminho){
  saveRDS(object = arquivo, file = caminho)
}


# Inserindo o dataframe de recursos no banco de dados
inserir_recursos_no_banco_de_dados <- function(recursos){
  dados <- recursos
  conexao <- conectarPostgreSql()
  dbWriteTable(conexao, "recursos_portal_transparencia", recursos, row.names = FALSE, overwrite = TRUE)
  dbSendQuery(conexao, "ALTER TABLE recursos_portal_transparencia ADD PRIMARY KEY (id_recurso)")
  dbDisconnect(conexao)
}

# Buscando o dataframe de recursos no banco de dados
buscar_recursos_no_banco_de_dados <- function(){
  conexao <- conectarPostgreSql()
  recursos_tbl <- tbl(conexao, "recursos_portal_transparencia")
  recursos <- recursos_tbl %>%
    collect()
  dbDisconnect(conexao)
  recursos
}

buscar_total_recursos_por_municipio <- function(){
  conexao <- conectarPostgreSql()
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
