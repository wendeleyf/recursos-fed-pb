library(data.table)

file_path = "data/pagamentos.rds"
pianco_path = "data/pianco.csv"

rm(pagamentos)
pagamentos <- readRDS(file = file_path)

nomes <- colnames(pagamentos)
nomes <- as.character(nomes)
nomes <- nomes_1

pianco <- fread(file_path, drop = "HISTÓRICO", stringsAsFactors = FALSE, header = TRUE)
