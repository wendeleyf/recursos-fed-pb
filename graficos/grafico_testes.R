source("R/busca_empenhos_no_bd.R")
source("R/busca_pagamentos_no_bd.R")
library(circlepackeR)

empenhos$vl_Empenho <-
  as.numeric(gsub(",", ".", gsub("\\.", "", empenhos$vl_Empenho)))

empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "FUNDEB") == TRUE] <- "FUNDEB"
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "PNAE") == TRUE] <- "PNAE"
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "FNDE") ==  TRUE] <- "FNDE"
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "PDDE") == TRUE] <- "PDDE"
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "PNATE") == TRUE] <- "PNATE"



empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "FUNDEB") == TRUE] <-
  "FUNDEB"
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "FNDE") == TRUE] <-
  "FUNDEB"

pagamentos$tipo_repasse [grepl(x = pagamentos$`descriã§ã£o da conta`, pattern = "FUNDEB") == TRUE] <-
  "FUNDEB"

#------


# df1 <- empenhos %>%
#   filter(tipo_repasse == "FUNDEB" & nome_municipio ==  "BREJO DO CRUZ" ) %>%
#   group_by(tipo_repasse,data = ano_emissao) %>%
#   summarise(total = sum(vl_Empenho))%>%
#   mutate(categoria = "Empenhos")



recursos$ano_mes <-  ymd(paste(tabela$ano_mes,"01",sep = ""))





#sumarizando dados FUNDEB

df2 <- recursos %>%
  filter(linguagem_cidada == "FUNDEB" & nome_municipio ==  "BREJO DO CRUZ") %>%
  group_by(tipo_repasse =linguagem_cidada, data = ano) %>%
  summarise(total = sum(valor_transferido))%>%
  mutate(categoria = "Repasses",
          )


df3 <- pagamentos %>%
  filter(tipo_repasse == "FUNDEB" ) %>%
  group_by(tipo_repasse,data = year(`dt. pagamento`)) %>%
  summarise(total = sum(pago))%>%
  mutate(categoria = "Pagamentos")

#unindo dataframes

df4 <- merge(df3,df2,all=T )

#gerando plot

p1 <- plot_ly(df4,
              y = ~total,
              x = ~data,
              type = 'scatterter',
              name = ~categoria,
              text = ~paste("",categoria,
                                              "<br>Ano :",data,'<br>Total:R$',formatar(total)),
              hoverinfo = 'text')%>%
  layout(title = "FUNDEB",
         yaxis = list(title = "",
                      showticklabels = FALSE,
                      type = "log"),
         xaxis = list(title = ~categoria),
         barmode = 'group')%>%config(displaylogo = FALSE)
              



p1



#------
#gasto por sub funçao

teste <- empenhos%>%
  group_by(tipo_repasse,ano_emissao,sub_funcao)%>%
  summarise(total = sum(vl_Empenho))

p <- plot_ly(teste,
              y = ~total,
              x = ~tipo_repasse,
              type = 'bar',
              name = ~ano_emissao,
              text = ~paste("",tipo_repasse,
                            "<br>Ano :",ano_emissao,'<br>Total:R$',formatar(total),sub_funcao),
              hoverinfo = 'text')%>%
  layout(title = "Educação",
         yaxis = list(title = "",
                      showticklabels = FALSE,
                      type = "log"),
         xaxis = list(title = ~ano_emissao),
         barmode = 'group')%>%config(displaylogo = FALSE)


p
