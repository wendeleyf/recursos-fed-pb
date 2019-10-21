source("R/utils.R")

processar_idepb_2017 <- function(caminho_idepb_2017){
  idepb_2017 <-fread(input = caminho_idepb_2017, stringsAsFactors = FALSE, header = FALSE) 
  idepb_2017 <- idepb_2017[-c(1:2), ]
  colunas <- idepb_2017[1, ]
  colnames(idepb_2017) <- as.character(colunas[1, ])
  idepb_2017 <- idepb_2017[-1, ]
  
  # Removendo acento das colunas
  colnames(idepb_2017) <- iconv(colnames(idepb_2017), to = "ASCII//TRANSLIT")
  colnames(idepb_2017) <- tolower(colnames(idepb_2017))
  colnames(idepb_2017) <- gsub(" ", "_", colnames(idepb_2017))
  
  idepb_2017$codigo_da_etapa_de_escolaridade <- NULL
  idepb_2017$codigo_da_escola <- NULL
  idepb_2017$codigo_de_gre <- NULL
  idepb_2017$codigo_de_municipio <- NULL
  
  # Substituindo vírgulas por ponto nos valores de números
  idepb_2017$`nota_media_padronizada_-_lp` <- gsub(",", ".", idepb_2017$`nota_media_padronizada_-_lp`)
  idepb_2017$`nota_media_padronizada_-_mt` <- gsub(",", ".", idepb_2017$`nota_media_padronizada_-_mt`)
  idepb_2017$indicador_de_desempenho <- gsub(",",".", idepb_2017$indicador_de_desempenho)
  idepb_2017$indicador_de_fluxo <- gsub(",", ".", idepb_2017$indicador_de_fluxo)
  idepb_2017$idepb <- gsub(",", ".", idepb_2017$idepb)
  
  # Convertendo os valores strings em tipo númerico
  idepb_2017$`nota_media_padronizada_-_lp` <- as.numeric(idepb_2017$`nota_media_padronizada_-_lp`)
  idepb_2017$`nota_media_padronizada_-_mt` <- as.numeric(idepb_2017$`nota_media_padronizada_-_mt`)
  idepb_2017$indicador_de_desempenho <- as.numeric(idepb_2017$indicador_de_desempenho)
  idepb_2017$indicador_de_fluxo <- as.numeric(idepb_2017$indicador_de_fluxo)
  idepb_2017$idepb <- as.numeric(idepb_2017$idepb)

  # Renomeando as colunas para um valor mais adequado ao banco de dados
  nomes_colunas <- c("etapa_escolaridade", "rede_ensino",
                      "gre","municipio","escola","nota_media_padronizada_lp",
                      "nota_media_padronizada_mt","indicador_desempenho",
                      "indicador_fluxo", "idepb")
  colnames(idepb_2017) <- nomes_colunas
  
  # Adicionando coluna de ano
  idepb_2017$ano <- 2017
  
  # Salvando RDS com dataframe tratado
  saveRDS(object = idepb_2017, "data/idepb-2017.rds")
  idepb_2017
}
processar_idepb_2018 <- function(caminho_idepb_2018){
  idepb_2018 <- fread(caminho_idepb_2018, stringsAsFactors = FALSE, header = TRUE)
  colunas <- idepb_2018[1, ]
  idepb_2018 <- idepb_2018[-1, ]
  colnames(idepb_2018) <- as.character(colunas[1, ])
  
  # Removendo acentos das colunas
  colnames(idepb_2018) <- iconv(colnames(idepb_2018), to = "ASCII//TRANSLIT")
  colnames(idepb_2018) <- tolower(colnames(idepb_2018))
  colnames(idepb_2018) <- gsub(" ", "_", colnames(idepb_2018))
  
  idepb_2018$codigo_da_escola <- NULL
  
  # Substituindo vírgulas por ponto nos valores de números
  idepb_2018$`nota_media_padronizada_-_lp` <- gsub(",", ".", idepb_2018$`nota_media_padronizada_-_lp`)
  idepb_2018$`nota_media_padronizada_-_mt` <- gsub(",", ".", idepb_2018$`nota_media_padronizada_-_mt`)
  idepb_2018$indicador_de_desempenho <- gsub(",", ".", idepb_2018$indicador_de_desempenho)
  idepb_2018$indicador_de_fluxo <- gsub(",", ".", idepb_2018$indicador_de_fluxo)
  idepb_2018$idepb <- gsub(",", ".", idepb_2018$idepb)  
  
  # Convertendo os valores strings em tipo númerico
  idepb_2018$`nota_media_padronizada_-_lp` <- as.numeric(idepb_2018$`nota_media_padronizada_-_lp`)
  idepb_2018$`nota_media_padronizada_-_mt` <- as.numeric(idepb_2018$`nota_media_padronizada_-_mt`)
  idepb_2018$indicador_de_desempenho <- as.numeric(idepb_2018$indicador_de_desempenho)  
  idepb_2018$indicador_de_fluxo <- as.numeric(idepb_2018$indicador_de_fluxo)
  idepb_2018$idepb <- as.numeric(idepb_2018$idepb)  
  
  # Renomeando as colunas para um valor mais adequado ao banco de dados
  nomes_colunas <- c("etapa_escolaridade", "rede_ensino",
                     "gre","municipio","escola","nota_media_padronizada_lp",
                     "nota_media_padronizada_mt","indicador_desempenho",
                     "indicador_fluxo", "idepb")
  
  colnames(idepb_2018) <- nomes_colunas
  
  # Adicionando coluna de ano
  idepb_2018$ano <- 2018
  
  # Salvando RDS com dataframe tratado
  saveRDS(object = idepb_2018, "data/idepb-2018.rds")
  idepb_2018
    
}
juntar_arquivos_idepb <- function(idepb_2017, idepb_2018){
  # Juntando os dois data.frames para inserção no banco de dados
  idepb <- rbind(idepb_2017, idepb_2018)
  
  # Adicionando coluna de índice
  idepb$id_idepb <- seq.int(nrow(idepb))
  
  # Reorganizando o data.frame para o índice ir para a primeira coluna
  idepb <- idepb[, c(12,1,2,3,4,5,6,7,8,9,10,11)]
  
  # Salvando um rds completo com os índices
  saveRDS(object = idepb, "data/idepb_completo.rds")
  
  idepb
}

# Buscando data.frames tratados do idepb por ano
idepb_2017 <- processar_idepb_2017("data/idepb-2017.csv")
idepb_2018 <- processar_idepb_2018("data/idepb-2018.csv")

# Juntando os arquivos em um só
idepb <- juntar_arquivos_idepb(idepb_2017, idepb_2018)


