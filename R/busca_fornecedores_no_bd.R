source("R/utils.R")



buscar_fornecedores_educacao <- function(){
  pagamentos <- readRDS("data/pagamentos_educacao.rds")
  grupos_despesa <- c("Outras Despesas Correntes", "Investimentos", "Inversões Financeiras")
  
  pagamentos_filtrados <- pagamentos %>%
    filter(pagamentos$GRUPO_DE_NATUREZA_DE_DESPESA %in% grupos_despesa)
  
  top_10_fornecedores <- pagamentos_filtrados %>%
    select(FORNECEDOR, MUNICIPIO, PAGO, CPF_CNPJ)
  
  top_10_fornecedores$PAGO <- as.numeric(top_10_fornecedores$PAGO)
  
  top_10_fornecedores <- top_10_fornecedores %>%
    group_by(CPF_CNPJ) %>%
    summarise(TOTAL_PAGO = sum(PAGO)) %>%
    arrange(desc(TOTAL_PAGO))
  
  contados <- top_10_fornecedores %>% 
    group_by(CPF_CNPJ) %>%
    summarise(QTD = n())
  
  
  unicos_true <- fread("data/unicos_true.csv", stringsAsFactors = FALSE, header = TRUE)
  
  contados_final <- left_join(
    contados,
    unicos_true,
    by = "CPF_CNPJ"
  )
  
  contados_final <- contados_final[, c(1, 3, 2)]
}

buscar_top_20_fornecedores <- function(){
  top20 <- readRDS(file = "data/top20_fornecedores.rds")
  top20
}


