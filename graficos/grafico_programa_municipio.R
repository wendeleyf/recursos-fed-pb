output$grafico_programa_municipio <- renderPlotly({
  
  tabela <- filter_data_municipio()%>%
    filter(nome_municipio == input$nome_municipio_input)%>%
    group_by(nome_programa,ano_mes)%>%
    summarise(total = sum(valor_transferido))
  
  tabela$ano_mes <-  ymd(paste(tabela$ano_mes,"01",sep = ""))
  
  #paleta de cores
  color_pal = viridis::viridis_pal(direction = -1,option = "D")(15)
  
  p_total_funcao_linha <- plot_ly(tabela, 
                                  y = ~total, 
                                  x = ~ano_mes, 
                                  name = ~nome_programa, 
                                  type = 'scatter',
                                  mode = 'lines+markers',
                                  color = ~nome_programa,
                                  #fill = 'tozeroy',
                                  #colors = color_pal,
                                  text = ~paste("Programa :",nome_programa,"<br>Data :",format(ymd(ano_mes),"%B-%Y"),'<br>Total:R$',formatar(total)),
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