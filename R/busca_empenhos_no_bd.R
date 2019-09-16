source("R/utils.R")
source("R/busca_recursos_no_bd.R")

buscar_empenhos_municipais_sagres <- function(){
  conexao <- conectar_postgre_sql()
  
  empenhos_tbl <- tbl(conexao, "empenhos_sagres_atualizado")
  
  f_recursos <- empenhos_tbl %>%
    distinct(fonte_recurso) %>%
    collect

  fundeb <- f_recursos$fonte_recurso[grepl(x = f_recursos$fonte_recurso, pattern = "FUNDEB") == TRUE]
  pnae <- f_recursos$fonte_recurso[grepl(x = f_recursos$fonte_recurso, pattern = "PNAE") == TRUE]
  fnde <- f_recursos$fonte_recurso[grepl(x = f_recursos$fonte_recurso, pattern = "FNDE") ==  TRUE]
  pdde <- f_recursos$fonte_recurso[grepl(x = f_recursos$fonte_recurso, pattern = "PDDE") == TRUE]
  pnate <- f_recursos$fonte_recurso[grepl(x = f_recursos$fonte_recurso, pattern = "PNATE") == TRUE]
  educacao <- f_recursos$fonte_recurso[grepl(x = f_recursos$fonte_recurso, pattern = "Educação") == TRUE]
  
  
  fonte <- c(fundeb, pnae, fnde, pdde, pnate, educacao)
  fonte <- unique(fonte)
  rm(fundeb, pnae, fnde, pdde, pnate, educacao)
  
  empenhos_educacao <- empenhos_tbl %>%
    filter(fonte_recurso %in% fonte) %>%  
    collect()
  
  registro_estranho <- empenhos_educacao %>%
    filter(unidade_gestora == "Fundo Municipal de Saúde de Alagoa Grande")
  colnames(empenhos_educacao)
  
  saveRDS(object = registro_estranho, file = "data/registro_estranho.rds")
  
  empenhos_educacao$id_empenho <- NULL
  empenhos_educacao$tipo_credor <- NULL
  empenhos_educacao$unidade_gestora <- NULL
  empenhos_educacao$cod_modalidade_licitacao <- NULL
  empenhos_educacao$unidade_orcamentaria <- NULL
  empenhos_educacao$numero_licitacao <- NULL
  empenhos_educacao$descricao_unid_orcamentaria <- NULL
  empenhos_educacao$codigo_elemento_despesa <- NULL
  empenhos_educacao$codigo_subelemento_despesa <- NULL
  empenhos_educacao$cod_fonte_recurso <- NULL
  empenhos_educacao$codigo_categoria_economica <- NULL
  empenhos_educacao$codigo_modalidade <- NULL
  empenhos_educacao$modalidade <- NULL
  empenhos_educacao$codigo_funcao <- NULL
  empenhos_educacao$funcao <- NULL
  empenhos_educacao$codigo_sub_funcao <- NULL
  empenhos_educacao$codigo_classificacao <- NULL
  
  empenhos_educacao
}

empenhos <- buscar_empenhos_municipais_sagres()
