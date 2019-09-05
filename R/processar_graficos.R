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
## grafico_linhas_tipo
## grafico_linhas_funcao
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

grafico_barra_funcao <- function(df){
  
  iconv(from = "UTF-8", to="ASCII//TRANSLIT")
  #agurpando dados
  df_ano_funcao <- df %>%
    group_by(ano,nome_funcao)%>%
    summarise(total = sum(valor_transferido))

  #gerando grafico
  p_total_nome <- plot_ly(df_ano_funcao,
                          x= ~ano,
                          y = ~log(total),
                          name = ~nome_funcao,
                          color= ~log2(total),
                          type = 'bar',
                          marker = list(colorscale='Viridis',
                                        reversescale = T),
                          text = ~paste("Funçao :",nome_funcao,
                                         '<br>Total:R$',formatar(total)),
                          hoverinfo = 'text')%>%
    layout(title = "Recursos Função Por Ano",
           #legend = list(y = 0.5),
           yaxis = list(title = ~total,showticklabels = FALSE),
           xaxis = list(title = ~ano),
           barmode = 'group')%>%
    hide_colorbar()
    

           
  
}

# -
# Retorna os grafico de linhas  de recursos federais por tipo salvos na base de dados 
# @return {grafico_linhas_tipo} recursos - grafico_linhascom informações da base de dados
# - 

grafico_linhas_tipo <- function(){
  
  #agurpando dados
  df_ano_tipo <- recursos %>%
    group_by(ano,tipo_transferencia)%>%
    summarise(total = sum(valor_transferido))
  
  p_total_tipo_linha <- plot_ly(df_ano_tipo, y = ~total,
                                x = ~`ano`,
                                name = ~tipo_transferencia,
                                type = 'scatter',
                                mode = 'lines') %>%
    layout(title = "Recursos funçao por ano",
           yaxis = list(title = 'VALOR'),
           xaxis = list(title = 'ANO'))
  
  p_total_tipo_linha
  
}

# -
# Retorna os grafico de linhas  de recursos federais por tipo salvos na base de dados 
# @return {grafico_linhas_função} recursos - grafico_linhas com informações da base de dados
# - 


grafico_linhas_funcao <- function(){
  #agurpando dados
  df_ano_funcao <- recursos %>%
    group_by(nome_funcao,ano)%>%
    summarise(total = sum(valor_transferido))
  
  p_total_funcao_linha <- plot_ly(df_ano_funcao, 
                                  y = ~total, 
                                  x = ~`ano`, 
                                  name = ~nome_funcao, 
                                  type = 'scatter',
                                  mode = 'lines+markers',
                                  line = list(shape = "spline")) %>%
    layout(title = "Função por ano",
           yaxis = list(title = ~total,type = "log" ),
           xaxis = list(title = ~`ano`))
  
  p_total_funcao_linha
}





# corrigir escalas do grafico
# grafico_dispersao_municipo <- function(){
# 
#   total_recursos <- recursos %>%
#     group_by(nome_municipio) %>%
#     summarise(total_transferido = sum(valor_transferido, na.rm = TRUE),
#               cout_transferencia = n_distinct(id_recurso)) %>%
#     arrange(desc(total_transferido))
#   total_recursos$nome_municipio[total_recursos$nome_municipio == ''] <- 'GOVERNO DA PARAÍBA'
# 
#   p <- plot_ly(total_recursos,x = ~log(total_transferido),
#                y = ~cout_transferencia,
#                #colobar
#                marker=list(colorscale='Viridis',
#                            reversescale =T),
# 
#                #legenda
# 
#                showlegend = FALSE,
#                text = ~paste("Municipio:",nome_municipio,
#                              '<br>R$:',formatar(total_transferido),
#                              "<br>Quantidade de transferencias: ", cout_transferencia),
#                hoverinfo = 'text',
#                color = ~total_transferido,
#                size = ~total_transferido)%>%
#     hide_colorbar()
#   p
# 
#   }

# INÍCIO
 # grafico_barra_tipo()
 # grafico_barra_funcao()
 #grafico_linhas_funcao()
 #grafico_linhas_tipo()
 #grafico_dispersao_municipo()

