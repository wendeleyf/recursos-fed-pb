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
## grafico_barra_funcao
## 
## -------------------------------------------

# -
# Retorna os grafico de barras  de recursos federais por tipo salvos na base de dados 
# @return {grafico_barra_tipo} recursos - grafico_barra com informações da base de dados
# - 

grafico_barra_tipo <- function(){
  #agurpando dados
  df_ano_tipo <- recursos %>%
    group_by(ano,tipo_transferencia)%>%
    summarise(total = sum(valor_transferido))
  
  #gerando grafico
  p_total_tipo <- plot_ly(df_ano_tipo,
                          x = ~ano , 
                          y = ~total, 
                          name = ~tipo_transferencia,
                          text = ~paste("Ano :",ano,'<br>Total:R$',formatar(total)),
                          hoverinfo = 'text')%>%
    layout(title = "Recursos Tipo Por Ano",
           yaxis = list(title = ~`total`,type = "log"),
           xaxis = list(title = ~tipo_transferencia),
           barmode = 'group')
  
  #retornar grafico
  p_total_tipo 
  
  
}

# -
# Retorna os grafico de barras  de recursos federais por funçao salvos na base de dados 
# @return {grafico_barra_função} recursos - grafico_barra com informações da base de dados
# - 

grafico_barra_funcao <- function(){
  #agurpando dados
  df_ano_funcao <- recursos %>%
    group_by(ano,nome_funcao)%>%
    summarise(total = sum(valor_transferido))
  
  #gerando grafico
  p_total_nome <- plot_ly(df_ano_funcao,
                          x= ~ano,
                          y = ~total,
                          name = ~nome_funcao,
                          color= ~log10(total),
                          marker = list(colorscale='Viridis',
                                        reversescale = T),
                          text = ~paste("Funçao:",nome_funcao,
                                         '<br>Total:R$',formatar(total)),
                          hoverinfo = 'text')%>%
    layout(title = "Recursos Função Por Ano",
           #legend = list(y = 0.5),
           yaxis = list(title = ~total,type = "log",showticklabels = FALSE),
           xaxis = list(title = ~nome_funcao),
           barmode = 'group')%>%
    hide_colorbar()
    
  #retornar grafico
  p_total_nome
           
  
}

# INÍCIO
grafico_barra_tipo()
grafico_barra_funcao()


