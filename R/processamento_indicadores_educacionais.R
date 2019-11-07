source("R/utils.R")

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


## Infraestrutura
processar_infraestrutura_escolar <- function(){
  caminho_arquivo <- "data/b. INFRAESTRUTURA DAS ESCOLAS ESTADUAIS - 2018.xlsx"
  infraestrutura_escolar <- read_excel(path = caminho_arquivo, sheet = 1)
  
  nomes_colunas <- as.character(infraestrutura_escolar[4, ])
  nomes_colunas
  
  infraestrutura_escolar <- infraestrutura_escolar[-c(1:4), ]
  
  nomes_
  nomes_colunas[50] <- "ENERGIA_REDE PÚBLICA"
  nomes_colunas[51] <- "ENERGIA_GERADOR"
  nomes_colunas[52] <- "ENERGIA_OUTROS"
  nomes_colunas[53] <- "ENERGIA_INEXISTENTE"
  nomes_colunas[54] <- "ÁGUA_REDE PÚBLICA"
  nomes_colunas[55] <- "ÁGUA_CACIMBA"
  nomes_colunas[56] <- "ÁGUA_FONTE_OU_RIO"
  nomes_colunas[57] <- "ÁGUA_POÇO_ARTESIANO"
  nomes_colunas[58] <- "ÁGUA_FORNECIMENTO_INEXISTENTE"
  nomes_colunas[60] <- "BANHEIRO DENTRO DO PRÉDIO"
  nomes_colunas[64] <- "ESGOTO_REDE_PÚBLICA"
  nomes_colunas[65] <- "ESGOTO_FOSSA"
  nomes_colunas[66] <- "ESGOTO_INEXISTENTE"
  nomes_colunas[67] <- "LIXO_COLETA_PERIÓDICA"
  nomes_colunas[68] <- "LIXO_ENTERRA"
  nomes_colunas[69] <- "LIXO_QUEIMA"
  nomes_colunas[70] <- "LIXO_RECICLA"
  nomes_colunas[71] <- "LIXO_JOGA_EM_OUTRA_ÁREA"
  nomes_colunas[72] <- "LIXO_OUTROS"
  
}
