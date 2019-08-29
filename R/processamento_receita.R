source(file = "R/utils.R")
library(stringr)
caminho_receitas <- "data/TCE-PB-SAGRES-Receita_Orcamentaria_Esfera_Municipal.txt"

receitas_municipais <- fread(file = caminho_receitas, 
                             header = TRUE, 
                             stringsAsFactors = FALSE,
                             encoding = 'UTF-8')

receitas_municipais$dt_mesano <- as.character(receitas_municipais$dt_mesano)
receitas_municipais$dt_mesano <- substr(receitas_municipais$dt_mesano,1, nchar(receitas_municipais$dt_mesano)-4)

names(receitas_municipais) <- c("cd_ugestora", 
                                "de_ugestora", 
                                "dt_ano", 
                                "cd_receita_orcug", 
                                "de_receitaorcug",
                                "tp_atualizacao_receita",
                                "de_atualizacao_receita",
                                "vl_lancamento_orc",
                                "dt_mes")

receitas$vl_lancamento_orc <- as.numeric(receitas$vl_lancamento_orc)

receitas <- tibble::rowid_to_column(receitas, "id_receita")

conexao <- conectar_postgre_sql()
dbWriteTable(conexao, "receita_municipio_sagres", receitas, row.names = FALSE, overwrite = TRUE)
dbSendQuery(conexao, "ALTER TABLE receita_municipio_sagres ADD PRIMARY KEY(id_receita)")
dbDisconnect(conexao)

saveRDS(object = receitas, file = "data/receitas_municipio_sagres.rds")
