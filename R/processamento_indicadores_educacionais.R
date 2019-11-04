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