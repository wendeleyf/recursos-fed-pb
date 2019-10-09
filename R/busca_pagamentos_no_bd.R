source("R/utils.R")


buscar_pagamentos_sagres <- function(){
  pagamentos <- readRDS("Z:\\sagres pagamentos/pagamentos_municipios_sagres.rds")%>%
    filter(FUNCAO == "Educação")
  pagamentos$X_U_FEFF_NO_DO_EMPENHO <- NULL
  pagamentos$DATA <- NULL
  pagamentos$MES_DO_EMPENHO <- NULL
  pagamentos$HISTORICO <- NULL
  pagamentos
  

}

buscar_pagamentos_educacao_sagres <- function(){

  pagamentos_educacao <- readRDS("data/pagamentos_educacao.rds")
  #categorizando pagamentos por fonte de recurso
  #FUNDEB
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "111") == TRUE] <- "FUNDEB"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "112") == TRUE] <- "FUNDEB"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "113") == TRUE] <- "FUNDEB"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "114") == TRUE] <- "FUNDEB"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "115") == TRUE] <- "FUNDEB"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "116") == TRUE] <- "FUNDEB"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "117") == TRUE] <- "FUNDEB"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "151") == TRUE] <- "FUNDEB"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "152") == TRUE] <- "FUNDEB"
  
  #FNDE
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "120") == TRUE] <- "FNDE"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "124") == TRUE] <- "FNDE"
 
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "121") == TRUE] <- "PDDE"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$DESCRICAO, pattern = "PDDE") == TRUE] <- "PDDE"
  
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "122") == TRUE] <- "PNAE"
  pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "123") == TRUE] <- "PNATE"
  
  



  #convertendo data
  pagamentos_educacao$DATA_DO_PAGAMENTO <- as.Date(pagamentos_educacao$DATA_DO_PAGAMENTO)

  #converter valores
  pagamentos_educacao$PAGO <- as.numeric(pagamentos_educacao$PAGO)

  #limpando nome dos municipios
  pagamentos_educacao$MUNICIPIO <- rm_acento(pagamentos_educacao$MUNICIPIO)
  
  pagamentos_educacao
}

#retornar dataset
pagamentos <- buscar_pagamentos_educacao_sagres()

#salvando RDS
#saveRDS(pagamentos,"data/pagamentos_educacao.rds")










