source("R/utils.R")


buscar_pagamentos_sagres <- function(){
  pagamentos <- readRDS("Z:\\sagres pagamentos/pagamentos_municipios_sagres.rds")

}

pagamentos <- buscar_pagamentos_sagres()%>%
  filter(FUNCAO == "Educação")






