source("R/utils.R")

#=
arquivo = "z:/pagamentos.csv"

pagamentos <- read.csv(file = arquivo, 
                       stringsAsFactors = FALSE,
                       sep = ',',
                       encoding = "UTF-8",
                       header = TRUE)






buscar_pagamentos_sagres <- function(){
  conexao <- conectar_postgre_sql()
  pagamentos_tbl <- tbl(conexao, "pagamentosunicipio_sagres")
  pagamentos <- pagamentos_tbl %>%
    
    collect()
  pagamentos
}

pagamentos <- buscar_pagamentos_sagres()



