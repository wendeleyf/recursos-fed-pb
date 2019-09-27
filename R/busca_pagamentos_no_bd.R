source("R/utils.R")



buscar_pagamentos_sagres <- function(){
  conexao <- conectar_postgre_sql()
  pagamentos_tbl <- tbl(conexao, "pagamentos_municipio_sagres")
  pagamentos <- pagamentos_tbl %>%
    
    collect()
  pagamentos
}

pagamentos <- buscar_pagamentos_sagres()



