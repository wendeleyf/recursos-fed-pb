source("R/utils.R")

# Pegando nomes de arquivos
file_list <-
  list.files("Z:/sagres pagamentos/",
             pattern = "*.csv",
             full.names = TRUE)

# Tratando os nomes das colunas, removendo sinais e adicionando _ onde tem 'espaços'
tabnames <- read.delim(file_list[1],sep = ",", header = TRUE, nrows = 1,encoding = "UTF-8")
names(tabnames) <- iconv(names(tabnames), to="ASCII//TRANSLIT")  
names(tabnames) <- gsub("[^A-Z0-9]+","_", toupper(names(tabnames)) )
names(tabnames) = make.names(names(tabnames), unique=TRUE, allow_=TRUE)
names(tabnames) = gsub('.','_',names(tabnames), fixed=TRUE) 
colunas <- colnames(tabnames)

# # Tratando a exeção do arquivo Pianco
# temp_csv <-
#   read.csv2(
#     "Z:/Piancó.csv",
#     header = FALSE,
#     skip = 1,
#     quote = '"',
#     sep = ",",
#     encoding = "UTF-8",
#     colClasses = rep('character', 31),
#     stringsAsFactors = FALSE
#     
#   )
# 
# pianco <- fread("../Piancó2.csv", 
#                 stringsAsFactors = FALSE, 
#                 header = TRUE, 
#                 encoding = "UTF-8",
#                 sep = ',')
# 
# write.csv(temp_csv[1:31],
#           "Z:/sagres pagamentos/Piancó.csv",
#           sep = ",",
#           row.names = FALSE)

# Modificando funçao para ler arquivos
my.read.delim <-
  function(fnam) {
    print(fnam)
    read.delim(
      fnam,
      header = FALSE,
      skip = 1,
      sep = ',',
      encoding = "UTF-8",
      col.names = colunas,
      colClasses = rep('character', 31),
      stringsAsFactors = FALSE
    )
  }

dataset <- do.call("rbind.fill", lapply(file_list, my.read.delim))
# Gerando o RDS
saveRDS(dataset,"pagamentos_municipios_sagres.rds")