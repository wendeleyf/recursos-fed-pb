library(data.table)
library(dplyr)

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

top10 <- left_join(
  contados_final,
  top_10_fornecedores,
  by = "CPF_CNPJ"
)

top10 <- top10 %>%
  arrange(desc(QTD))

top20 <- top10[-c(1,2,3,4,5,6,7,8), ]

top20 <- top20[-c(6,10,12,13), ]
top20 <- top20[-c(9),]
top20 <- head(top20, 20)
saveRDS(top20, "data/top20_fornecedores.rds")

buscar_fornecedores_unicos_educacao <- function(){
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
  
  pagamentos_filtrados_despesa <- pagamentos_filtrados_despesa %>%
    group_by(CPF_CNPJ) %>%
    summarise(TOTAL_PAGO = sum(PAGO), Contagem = length(unique(MUNICIPIO)))
  
  pagamentos_fornecedores <- left_join(
    fornecedores,
    pagamentos_filtrados_despesa,
    by = "CPF_CNPJ"
  )
}
