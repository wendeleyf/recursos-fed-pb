## -------------------------------------------
## Script: processar_graficos.R
##
## Descrição: Script para graficos dos recursos federais na base de dados
##
## Autor: João Calixto
##
## Data: 29/08/2019 
##
## -------------------------------------------
## 
## Bibliotecas Padrões
source('R/utils.R')
source('R/busca_recursos_no_bd.R')
## -------------------------------------------
##
## Sumário de Funções
##
## grafico_barra_tipo
## buscar_total_recursos_por_municipio
## 
## -------------------------------------------

# -
# Retorna os grafico de barras tipo de recursos federais salvos na base de dados 
# @return {grafico_barra_tipo} recursos - grafico_barra com informações da base de dados
# - 

grafico_barra_tipo <- function(){
  #agurpando dados
  df_ano_tipo <- recursos %>%
    group_by(ano,tipo_transferencia)%>%
    summarise(total = sum(valor_transferido))
  
  #gerando grafico
  
  p_total_tipo <- plot_ly(df_ano_tipo,x = ~ano , y = ~total, name = ~tipo_transferencia )%>%
    layout(title = "Recursos Tipo Por Ano",
           yaxis = list(title = ~`total`,type = "log"),
           xaxis = list(title = ~tipo_transferencia),
           barmode = 'group')
  
  p_total_tipo 
  
  
}

# INÍCIO
grafico_barra_tipo()
