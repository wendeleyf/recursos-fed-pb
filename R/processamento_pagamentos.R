library(data.table)
library(dplyr)

buscar_fornecedores <- function(){
  
  caminho_pagamentos_rds <- "data/pagamentos_educacao.rds"
  pagamentos_educacao <- readRDS(caminho_pagamentos_rds)
  grupos_despesa <- c("Outras Despesas Correntes", "Investimentos", "Inversões Financeiras")
  
  pagamentos_filtrados_despesa <- pagamentos_educacao %>%
    filter(GRUPO_DE_NATUREZA_DE_DESPESA %in% grupos_despesa)
  
  pagamentos_filtrados_despesa <- pagamentos_filtrados_despesa %>%
    select(CPF_CNPJ,FORNECEDOR, MUNICIPIO, PAGO)
  
  fornecedores <- pagamentos_filtrados_despesa %>%
    distinct(CPF_CNPJ, FORNECEDOR)
  
  fornecedores <- fornecedores[!duplicated(fornecedores$CPF_CNPJ), ]
  
  AGREGADO_PAGO <- aggregate(PAGO ~ CPF_CNPJ, pagamentos_filtrados_despesa, sum)
  AGRREGADO_COUNT_MUNICIPIO <- aggregate(MUNICIPIO ~ CPF_CNPJ, pagamentos_filtrados_despesa, function(x) length(unique(x)))
  
  
  AGREGADO <- left_join(
    AGREGADO_PAGO,
    AGRREGADO_COUNT_MUNICIPIO,
    by = "CPF_CNPJ"
  )
  
  AGREGADO <- left_join(
    fornecedores,
    AGREGADO    ,
    by = "CPF_CNPJ"
  )
  
  AGREGADO <- AGREGADO %>%
    arrange(desc(MUNICIPIO))
  
}

categorizar_fornecedores <- function(fornecedores){
  fornecedores <- buscar_fornecedores()
  fornecedores$FORNECEDOR <- toupper(fornecedores$FORNECEDOR)
  fornecedores$TIPO <- "Fornecedor Comum"
  prestadores_publicos <-
    "BANCO|DETRAN|FUNDO|INSS|TESOURO|UNDIME|CAGEPA|ENERGISA|TELEMAR|MINISTÉRIO|SECRETARIA|SENAT|INSTITUTO"
  fornecedores$TIPO[grepl(paste(prestadores_publicos, collapse = "|"),
                          fornecedores$FORNECEDOR) == TRUE] <- "Prestador Público"
  fornecedores
}

fornecedores <- categorizar_fornecedores(buscar_fornecedores())


