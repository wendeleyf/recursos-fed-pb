output$grafico_transferencias_funcao <- renderPlotly({
  
  tabela <- filter_data()%>%
    group_by(nome_funcao,ano_mes)%>%
    summarise(total = sum(valor_transferido))
  
  tabela$ano_mes <-  ymd(paste(tabela$ano_mes,"01",sep = ""))
  
  #paleta de cores
  color_pal = viridis::viridis_pal(direction = -1,option = "D")(15)
 
  p_total_funcao_linha <- plot_ly(tabela, 
                                  y = ~total, 
                                  x = ~ano_mes, 
                                  name = ~nome_funcao, 
                                  type = 'scatter',
                                  mode = 'lines+markers',
                                  color = ~nome_funcao,
                                  #fill = 'tozeroy',
                                  colors = color_pal,
                                  text = ~paste("Função de governo :",nome_funcao,"<br>Data :",format(ymd(ano_mes),"%B-%Y"),'<br>Total:R$',formatar(total)),
                                  hoverinfo = 'text'
                                  ) %>%
    layout(title = "",
           yaxis = list(title = ~total,
                        type = "log",
                        showticklabels = FALSE ),
           xaxis = list(title =~`ano_mes`
                        #,showticklabels = FALSE
                        ))
  
})