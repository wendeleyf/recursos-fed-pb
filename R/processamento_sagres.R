source(file = "R/utils.R")

caminho_sagres_2017_2018 <- "data/TCE-PB-Empenhos_2017-2018.csv"
caminho_sagres_2019 <- "data/TCE-PB-Empenhos_2019.csv"

# CSVS
empenhos <- read.csv(file = caminho_sagres_2017_2018, 
                     stringsAsFactors = FALSE,
                     sep = ';',
                     header = TRUE)

empenhos_2019 <- read.csv(file = caminho_sagres_2019,
                          stringsAsFactors = FALSE,
                          sep = ';',
                          header = TRUE)


empenhos$data_emissao <- as.Date(empenhos$data_emissao, "%Y-%m-%d")
saveRDS(object = empenhos, file = "data/empenhos_sagres.rds")
saveRDS(object = empenhos_2019, file = "data/empenhos_sagres_2019.rds")


# RDS
empenhos_2017_2018 <- readRDS(file = "data/empenhos_sagres_2017_2018.rds")
empenhos_2019 <- readRDS(file = "data/empenhos_sagres_2019.rds")

empenhos_sagres <- rbind(empenhos_2017_2018, empenhos_2019)

empenhos_sagres <- tibble::rowid_to_column(empenhos_sagres, "id_empenho")
saveRDS(object = empenhos_sagres, file = "data/empenhos_sagres.rds")
conexao <- conectar_postgre_sql()
dbWriteTable(conexao, "empenhos_sagres_atualizado", empenhos_sagres, row.names = FALSE, overwrite = TRUE)
dbSendQuery(conexao, "ALTER TABLE empenhos_sagres_atualizado ADD PRIMARY KEY (id_empenho)")
dbDisconnect(conexao)
