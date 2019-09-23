source("R/utils.R")


buscar_pagamentos_sagres <- function(){
  conexao <- conectar_postgre_sql()
  pagamentos_tbl <- tbl(conexao, "pagamentos_sagres")
  pagamentos <- pagamentos_tbl %>%
    collect()
  pagamentos
}

pagamentos <- buscar_pagamentos_sagres()

names(pagamentos) <- tolower(names(pagamentos))

df <- pagamentos%>%
  group_by(`fonte de recursos`)%>%
  filter(programa)%>%
  summarise(total_empenhado = sum(empenhado),
            total_pago = sum(pago))
