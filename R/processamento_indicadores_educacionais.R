source("R/utils.R")
# Processamento de indicadores educacionais
processar_rend_escolas <- function(caminho_indicadores_2014){
  # Caminho dos arquivos
  caminho_rend_escolas_2014 <- "Y:/TI/Arquivos Educação/e. TX_REND_ESCOLAS_2014.xlsx"
  caminho_rend_escolas_2015 <- "Y:/TI/Arquivos Educação/e. TX_REND_ESCOLAS_2015.xlsx"
  caminho_rend_escolas_2016 <- "Y:/TI/Arquivos Educação/e. TX_REND_ESCOLAS_2016.xlsx"
  caminho_rend_escolas_2017 <- "Y:/TI/Arquivos Educação/e. TX_REND_ESCOLAS_2017.xlsx"
  caminho_rend_escolas_2018 <- "Y:/TI/Arquivos Educação/e. TX_REND_ESCOLAS_2018.xlsx"
  
  # Arquivo 2014
  processar_rend_escolas_2014 <- function(caminho_rend_escolas_2014){
    rend_escolas_2014 <- read_excel(caminho_rend_escolas_2014, sheet=1, col_names = FALSE)
    colunas <- cbind(rend_escolas_2014[4,1:9 ], rend_escolas_2014[7,10:63])
    rend_escolas_2014 <- rbind(colunas,rend_escolas_2014[-c(1:9), ])
    rm(colunas)
    rend_escolas_2014 <- rend_escolas_2014[-c(747:752), ]
    colnames(rend_escolas_2014) <- as.character(rend_escolas_2014[1, ])
    rend_escolas_2014 <- rend_escolas_2014[-1, ]
    
    # Removendo acento das colunas
    colnames(rend_escolas_2014) <- iconv(colnames(rend_escolas_2014),from = "UTF-8" ,to = "ASCII//TRANSLIT")
    colnames(rend_escolas_2014) <- tolower(colnames(rend_escolas_2014))
    colnames(rend_escolas_2014) <- gsub(" ", "_", colnames(rend_escolas_2014))
    
    # Retornando dataframe tratado
    rend_escolas_2014
  }
  # Arquivo 2015
  processar_rend_escolas_2015 <- function(caminho_rend_escolas_2015){
    rend_escolas_2015 <- read_excel(caminho_rend_escolas_2015, sheet=1, col_names = FALSE)
    rend_escolas_2015 <- rend_escolas_2015[,-(34:45)]
    colunas <- cbind(rend_escolas_2015[4,1:9 ], rend_escolas_2015[7,10:63])
    rend_escolas_2015 <- rbind(colunas,rend_escolas_2015[-c(1:9), ])
    rm(colunas)
    rend_escolas_2015 <- rend_escolas_2015[-c(742:746), ]
    colnames(rend_escolas_2015) <- as.character(rend_escolas_2015[1, ])
    rend_escolas_2015 <- rend_escolas_2015[-1, ]
    
    # Removendo acento das colunas
    colnames(rend_escolas_2015) <- iconv(colnames(rend_escolas_2015),from = "UTF-8" ,to = "ASCII//TRANSLIT")
    colnames(rend_escolas_2015) <- tolower(colnames(rend_escolas_2015))
    colnames(rend_escolas_2015) <- gsub(" ", "_", colnames(rend_escolas_2015))
    
    # Retornando dataframe tratado
    rend_escolas_2015
    
  }
  # Arquivo 2016
  processar_rend_escolas_2016 <- function(caminho_rend_escolas_2016){
    rend_escolas_2016 <- read_excel(caminho_rend_escolas_2016, sheet=1, col_names = FALSE)
    colunas <- cbind(rend_escolas_2016[5,1:9 ], rend_escolas_2016[7,10:63])
    rend_escolas_2016 <- rbind(colunas,rend_escolas_2016[-c(1:8), ])
    rm(colunas)
    rend_escolas_2016 <- rend_escolas_2016[-c(724:725), ]
    colnames(rend_escolas_2016) <- as.character(rend_escolas_2016[1, ])
    rend_escolas_2016 <- rend_escolas_2016[-1, ]
    
    # Removendo acento das colunas
    colnames(rend_escolas_2016) <- iconv(colnames(rend_escolas_2016),from = "UTF-8" ,to = "ASCII//TRANSLIT")
    colnames(rend_escolas_2016) <- tolower(colnames(rend_escolas_2016))
    colnames(rend_escolas_2016) <- gsub(" ", "_", colnames(rend_escolas_2016))
    
    # Retornando dataframe tratado
    rend_escolas_2016
    
  }
  # Arquivo 2017
  processar_rend_escolas_2017 <- function(caminho_rend_escolas_2017){
    rend_escolas_2017 <- read_excel(caminho_rend_escolas_2017, sheet=1, col_names = FALSE)
    colunas <- cbind(rend_escolas_2017[5,1:9 ], rend_escolas_2017[7,10:63])
    rend_escolas_2017 <- rbind(colunas,rend_escolas_2017[-c(1:8), ])
    rm(colunas)
    rend_escolas_2017 <- rend_escolas_2017[-c(646:647), ]
    colnames(rend_escolas_2017) <- as.character(rend_escolas_2017[1, ])
    rend_escolas_2017 <- rend_escolas_2017[-1, ]
    
    # Removendo acento das colunas
    colnames(rend_escolas_2017) <- iconv(colnames(rend_escolas_2017),from = "UTF-8" ,to = "ASCII//TRANSLIT")
    colnames(rend_escolas_2017) <- tolower(colnames(rend_escolas_2017))
    colnames(rend_escolas_2017) <- gsub(" ", "_", colnames(rend_escolas_2017))
    
    # Retornando dataframe tratado
    rend_escolas_2017
    
  }
  # Arquivo 2018
  processar_rend_escolas_2018 <- function(caminho_rend_escolas_2018){
    rend_escolas_2018 <- read_excel(caminho_rend_escolas_2018, sheet=1, col_names = FALSE)
    colunas <- cbind(rend_escolas_2018[5,1:9 ], rend_escolas_2018[7,10:63])
    rend_escolas_2018 <- rbind(colunas,rend_escolas_2018[-c(1:8), ])
    rm(colunas)
    rend_escolas_2018 <- rend_escolas_2018[-c(649:650), ]
    colnames(rend_escolas_2018) <- as.character(rend_escolas_2018[1, ])
    rend_escolas_2018 <- rend_escolas_2018[-1, ]
    
    # Removendo acento das colunas
    colnames(rend_escolas_2018) <- iconv(colnames(rend_escolas_2018),from = "UTF-8" ,to = "ASCII//TRANSLIT")
    colnames(rend_escolas_2018) <- tolower(colnames(rend_escolas_2018))
    colnames(rend_escolas_2018) <- gsub(" ", "_", colnames(rend_escolas_2018))
    
    # Retornando dataframe tratado
    rend_escolas_2018
  }
  
  # Executando 
  rend_escolas_2014 <- processar_rend_escolas_2014(caminho_rend_escolas_2014)
  rend_escolas_2015 <- processar_rend_escolas_2015(caminho_rend_escolas_2015)
  rend_escolas_2016 <- processar_rend_escolas_2016(caminho_rend_escolas_2016)
  rend_escolas_2017 <- processar_rend_escolas_2017(caminho_rend_escolas_2017)
  rend_escolas_2018 <- processar_rend_escolas_2018(caminho_rend_escolas_2018)
  
  colnames(rend_escolas_2018) = colnames(rend_escolas_2017) = colnames(rend_escolas_2016) =
    colnames(rend_escolas_2015)
  
  rendimento_escolar <- rbind(rend_escolas_2014,rend_escolas_2015,rend_escolas_2016,rend_escolas_2017,rend_escolas_2018)
  

  
}

processar_relacao_alunos <- function(){
  
  nomes_colunas <- c("ano", "gre", "municipio", "cod_inep", "entidade", "id_aluno", "nome_aluno")
  
  caminho_2014 <- "data/relacao_alunos_2014_2015_2016.xlsx"
  caminho_2017 <- "data/d. Relação de alunos - Rede Estadual - 2017.xlsx"
  caminho_2018 <- "data/d. Relação de alunos - Rede Estadual - 2018.xlsx"
  
  # Lendo os arquivos do Excel
  relacao_2014_15_16 <- read_excel(path = caminho_2014, sheet = 1)
  relacao_2017 <- read_excel(path = caminho_2017, sheet = 1)
  relacao_2018 <- read_excel(path = caminho_2018, sheet = 1)
  
  # Reordenando o dataset para padronização
  relacao_2014_15_16 <- relacao_2014_15_16[, c(1,3,4,2,5,6)]
  relacao_2017 <- relacao_2017[, c(1,2,3,5,4,6,7)]
  # Criando coluna nova para padronização
  relacao_2014_15_16$novo <- ""
  
  # Removendo registros desnecessários dos datasets
  relacao_2014_15_16 <- relacao_2014_15_16[-c(1:3), ]
  relacao_2017 <- relacao_2017[-c(1:3), ]
  relacao_2018 <- relacao_2018[-c(1:3), ]
  
  # Renomeando todas as colunas seguindo um padrão
  colnames(relacao_2014_15_16) <- nomes_colunas
  colnames(relacao_2017) <- nomes_colunas
  colnames(relacao_2018) <- nomes_colunas
  
  # Relação completa
  relacao_completa <- rbind(relacao_2014_15_16, relacao_2017, relacao_2018)
  
  # Adicionando index de relação e reordenando o data.frame
  relacao_completa$id_relacao <- seq.int(nrow(relacao_completa))
  relacao_completa <- relacao_completa[,c (8,1,2,3,4,5,6,7)]
  
  relacao_completa
}

salvar_relacao_completa_no_bd(relacao_completa){
  conexao <- conectar_postgre_sql()
  dbWriteTable(conexao, "ie_relacao_alunos", relacao_completa, row.names = FALSE, overwrite = TRUE)
  dbSendQuery(conexao, "ALTER TABLE ie_relacao_alunos ADD PRIMARY KEY(id_relacao)")
  dbDisconnect(conexao)
}



rendimento_escolar <- processar_rend_escolas()



