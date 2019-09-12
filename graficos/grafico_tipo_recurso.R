output$grafico_transferencias_geral <- renderPlotly({

  tabela <- filter_data()%>%
    group_by(tipo_transferencia,ano)%>%
    summarise(total = sum(valor_transferido))
  
  
  
  
  toWebGL(
  p_total_funcao_linha <- plot_ly(tabela,
                                  x = ~ano , 
                                  y = ~total, 
                                  color = ~tipo_transferencia,
                                  name = ~tipo_transferencia,
                                  text = ~paste("Categoria do Repasse :",tipo_transferencia,
                                                "<br>Ano :",ano,'<br>Total:R$',formatar(total)),
                                  hoverinfo = 'text')%>%
    layout(title = FALSE,
           yaxis = list(title = "",
                        showticklabels = FALSE,
                        type = "log"),
           xaxis = list(title = ~tipo_transferencia),
           barmode = 'group')%>%config(displaylogo = FALSE)
  )
})