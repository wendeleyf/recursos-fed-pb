source("R/utils.R")

buscar_top_20_fornecedores <- function(){
  top20 <- readRDS(file = "data/top20_fornecedores.rds")
  top20
}


