library(data.table)
library(dplyr)
source("R/utils.R")

buscar_fornecedores <- function(){
  
  caminho_pagamentos_rds <- "data/pagamentos_educacao.rds"
  pagamentos_educacao <- readRDS(caminho_pagamentos_rds)
  grupos_despesa <- c("Outras Despesas Correntes", "Investimentos", "Inversões Financeiras")
  
  pagamentos_educacao <- pagamentos_educacao %>%
    filter(GRUPO_DE_NATUREZA_DE_DESPESA %in% grupos_despesa)
  
  pagamentos_educacao <- pagamentos_educacao %>%
    select(CPF_CNPJ,FORNECEDOR, MUNICIPIO, PAGO,DATA_DO_PAGAMENTO)
  pagamentos_educacao$DATA_DO_PAGAMENTO <- year(pagamentos_educacao$DATA_DO_PAGAMENTO)
  
  fornecedores <- pagamentos_educacao %>%
    distinct(CPF_CNPJ, FORNECEDOR)
  
  pagamentos_educacao <- pagamentos_educacao %>%
    select(CPF_CNPJ, MUNICIPIO, PAGO,DATA_DO_PAGAMENTO)
  
  fornecedores <- fornecedores[!duplicated(fornecedores$CPF_CNPJ), ]
  
  fornecedores <- left_join(
    pagamentos_educacao,
    fornecedores    ,
    by = "CPF_CNPJ"
  )
  
  # AGREGADO_PAGO <- aggregate(PAGO ~ CPF_CNPJ+ DATA_DO_PAGAMENTO, pagamentos_educacao, sum)
  # AGRREGADO_COUNT_MUNICIPIO <- aggregate(MUNICIPIO ~ CPF_CNPJ + DATA_DO_PAGAMENTO , pagamentos_educacao, function(x) length(unique(x)))
  # 
  # 
  # AGREGADO <- left_join(
  #   AGREGADO_PAGO,
  #   AGRREGADO_COUNT_MUNICIPIO,
  #   by = c("CPF_CNPJ","DATA_DO_PAGAMENTO")
  # )
  # 
  # AGREGADO <- left_join(
  #   fornecedores,
  #   AGREGADO    ,
  #   by = "CPF_CNPJ"
  # )
  # 
  # AGREGADO <- AGREGADO %>%
  #   arrange(desc(MUNICIPIO))
  
}

categorizar_fornecedores <- function(fornecedores){
  fornecedores$FORNECEDOR <- str_trim(toupper(fornecedores$FORNECEDOR))
  
  fornecedores$TIPO <- "Fornecedor Comum"
  prestadores_publicos <-
    "BANCO|CONSELHO|DETRAN|FUNDO|INSS|TESOURO|UNDIME|CAGEPA|ENERGISA|TELEMAR|MINISTÉRIO|SECRETARIA|SENAT|INSTITUTO"
  fornecedores$TIPO[grepl(paste(prestadores_publicos, collapse = "|"),
                          fornecedores$FORNECEDOR) == TRUE] <- "Prestador Público"
  fornecedores
}

fornecedores <- categorizar_fornecedores(buscar_fornecedores())


