output$grafico_categoria_municipio <- renderPlotly({
  
  tabela <- filter_data_municipio()%>%
    filter(nome_municipio == "JOAO PESSOA")%>%
    group_by(tipo_transferencia,ano_mes)%>%
    summarise(total = sum(valor_transferido))
  
  tabela$ano_mes <-  ymd(paste(tabela$ano_mes,"01",sep = ""))
  
  #paleta de cores
  color_pal = viridis::viridis_pal(direction = -1,option = "D")(15)
  
  p_total_funcao_linha <- plot_ly(tabela, 
                                  y = ~total, 
                                  x = ~ano_mes, 
                                  name = ~tipo_transferencia, 
                                  type = 'scatter',
                                  mode = 'lines+markers',
                                  color = ~tipo_transferencia,
                                  fill = 'tozeroy',
                                  #colors = color_pal,
                                  text = ~paste("Categoria de Transferência :",tipo_transferencia,"<br>Data :",format(ymd(ano_mes),"%B-%Y"),'<br>Total:R$',formatar(total)),
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