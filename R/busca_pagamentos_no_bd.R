source("R/utils.R")


buscar_pagamentos_sagres <- function(){
  pagamentos <- readRDS("Z:\\sagres pagamentos/pagamentos_municipios_sagres.rds")
  
  pagamentos <- pagamentos%>%filter(!grepl("2016",pagamentos$DATA_DO_PAGAMENTO))

}

#caminho_arquivo <- "Z:\\sagres pagamentos/pagamentos_municipios_sagres.rds"

buscar_pagamentos_educacao_sagres <- function(caminho_arquivo){

  pagamentos_educacao <- readRDS(caminho_arquivo)
  # Categorizando pagamentos por fonte de recurso
  
  # FUNDEB
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "FUNDEB") == TRUE] <-"FUNDEB"
  
  # PDDE
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "PDDE") == TRUE] <- "PDDE"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$DESCRICAO, pattern = "PDDE") == TRUE] <- "PDDE"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$DESCRICAO, pattern = "P.D.D.E") == TRUE] <- "PDDE"
 
  # PNAE
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "PNAE") == TRUE] <- "PNAE"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$DESCRICAO, pattern = "PNAE") == TRUE] <- "PNAE"
  
  # PNATE
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "PNATE") == TRUE] <- "PNATE"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$DESCRICAO, pattern = "PNATE") == TRUE] <- "PNATE"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$DESCRICAO,pattern = "PENAT")== TRUE] <- "PNATE"
  

  #convertendo data
  pagamentos_educacao$DATA_DO_PAGAMENTO <- as.Date(pagamentos_educacao$DATA_DO_PAGAMENTO)

  #converter valores
  pagamentos_educacao$PAGO <- as.numeric(pagamentos_educacao$PAGO)

  #limpando nome dos municipios
  pagamentos_educacao$MUNICIPIO <- rm_acento(pagamentos_educacao$MUNICIPIO)
  
  pagamentos_categorizado <-
    pagamentos_educacao %>% filter(!is.na(categoria))
  
  #saveRDS(pagamentos_categorizado,"pagamentos_categorizado.rds")
  
  
}


#retornar dataset
pagamentos <- readRDS("data/pagamentos_categorizado.rds")

#salvando RDS
# saveRDS(pagamentos,"data/pagamentos_educacao.rds")









