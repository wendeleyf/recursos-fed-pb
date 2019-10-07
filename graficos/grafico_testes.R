source("R/busca_recursos_no_bd.R")
source("R/busca_pagamentos_no_bd.R")


transferencias_educacao <-
  recursos %>% filter(nome_funcao == "Educação",nome_municipio == "JOAO PESSOA")




pagamentos_educacao <- 
  pagamentos %>% filter(MUNICIPIO == "João Pessoa")

#categorizando transferencias por fonte de recurso
pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "FUNDEB") == TRUE] <- "FUNDEB"
pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "PNAE") == TRUE] <- "PNAE"
pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "FNDE") ==  TRUE] <- "FNDE"
pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "PDDE") == TRUE] <- "PDDE"
pagamentos_educacao$categoria [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "PNATE") == TRUE] <- "PNATE"

pagamentos_educacao$DATA_DO_PAGAMENTO <- as.Date(pagamentos_educacao$DATA_DO_PAGAMENTO)
pagamentos_educacao$DATA_DO_PAGAMENTO <- ymd(pagamentos_educacao$DATA_DO_PAGAMENTO)
pagamentos_educacao$DATA_DO_PAGAMENTO <- as.Date(format(ymd(pagamentos_educacao$DATA_DO_PAGAMENTO),"%m-%Y"))


pagamentos_educacao$PAGO <- as.numeric(gsub(",", ".", gsub("\\.", "", pagamentos_educacao$PAGO)))

categorias <- unique(pagamentos_educacao$categoria)

pagamentos_educacao <- pagamentos_educacao%>%
  filter(categoria %in% categorias)%>%
  group_by(categoria,DATA_DO_PAGAMENTO)%>%
  summarise(total = sum(PAGO))

p1 <- plot_ly(pagamentos_educacao,
              y = ~,
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
empenhos$vl_Empenho <- formatar(empenhos$vl_Empenho)
 # as.numeric(gsub(",", ".", gsub("\\.", "", empenhos$vl_Empenho)))

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
#-----
teste <- empenhos%>%
  group_by(tipo_repasse,ano_emissao)%>%
  summarise(total = sum(vl_Empenho))

p <- ggplot(teste, aes(fill=tipo_repasse, y=log10(total), x=tipo_repasse)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_viridis(discrete = T, option = "D",direction = 1) +
  ggtitle("Programas") +
  facet_wrap(~ano_emissao) +
  
  theme(legend.position=~total) +
  xlab("") +
  
  ylab("") 

  

p%>%style( hoverinfo = "none")%>%ggplotly()

