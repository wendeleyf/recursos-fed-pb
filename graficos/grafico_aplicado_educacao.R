source("R/busca_empenhos_no_bd.R")
source("R/busca_recursos_no_bd.R")


#Ajustando granularidade das datas para mes/ano
recursos$ano_mes <-  ymd(paste(recursos$ano_mes,"01",sep = ""))
recursos$ano_mes <- format(ymd(recursos$ano_mes),"%m-%Y")
#---
empenhos$data_emissao <- ymd(empenhos$data_emissao)
empenhos$data_emissao <- format(ymd(empenhos$data_emissao),"%m-%Y")
#categorizando empenhos
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "FUNDEB") == TRUE] <- "FUNDEB"
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "PNAE") == TRUE] <- "PNAE"
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "FNDE") ==  TRUE] <- "FNDE"
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "PDDE") == TRUE] <- "PDDE"
empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "PNATE") == TRUE] <- "PNATE"

# transformando valores
empenhos$vl_Empenho <- as.numeric(gsub(",", ".", gsub("\\.", "", empenhos$vl_Empenho)))

df_recursos <- recursos %>%
  filter(linguagem_cidada == "FUNDEB" & nome_municipio ==  "BREJO DO CRUZ") %>%
  arrange(ano_mes)%>%
  group_by(tipo_repasse =linguagem_cidada, data = ano_mes) %>%
  summarise(total = sum(valor_transferido))%>%
  mutate(categoria = "Repasse Federal",
  )

df_empenhos <- empenhos %>%
  filter(tipo_repasse == "FUNDEB" ) %>%
  arrange(data_emissao)%>%
  group_by(tipo_repasse,data = data_emissao) %>%
  summarise(total = sum(vl_Empenho))%>%
  mutate(categoria = "Pagamentos")


df_merge <- merge(df_recursos,df_empenhos,all=T )

p1 <- plot_ly(df_merge,
              y = ~total,
              x = ~data,
              type = 'scatter',
              mode = 'lines+markers',
              name = ~categoria,
              text = ~paste("",categoria,
                            "<br>Data :",data,'<br>Total:R$',formatar(total)),
              hoverinfo = 'text')%>%
  layout(title = "FUNDEB",
         yaxis = list(title = "",
                      showticklabels = FALSE,
                      type = "log"),
         xaxis = list(title = ~categoria)
         )%>%config(displaylogo = FALSE)
p1
