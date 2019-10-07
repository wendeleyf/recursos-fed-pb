output$grafico_transferencias_geral <- renderPlotly({
  
  color_pal = viridis::viridis_pal(direction = 1,option = "D")(3)
  
  tabela <- filter_data()%>%
    group_by(tipo_transferencia)%>%
    summarise(total = sum(valor_transferido))%>%
    plot_ly(labels =~tipo_transferencia, values = ~total)%>%
    add_pie(hole = 0.6)%>%
    layout(title = "",  showlegend = T,
           colorway = color_pal,
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
  
  
  
  
  # toWebGL(
  # p_total_funcao_linha <- plot_ly(tabela,
  #                                 labels = ~tipo_transferencia,
  #                                 value = ~total,
  #                                 color = ~tipo_transferencia,
  #                                 name = ~tipo_transferencia,
  #                                 text = ~paste("Categoria do Repasse :",tipo_transferencia,
  #                                               "<br>Ano :",ano,'<br>Total:R$',formatar(total)),
  #                                 hoverinfo = 'text')%>%
  #   layout(title = FALSE,
  #          yaxis = list(title = "",
  #                       showticklabels = FALSE,
  #                       type = "log"),
  #          xaxis = list(title = ~tipo_transferencia))%>%
  #   config(displaylogo = FALSE)
  # )
})