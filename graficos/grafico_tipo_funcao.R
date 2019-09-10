output$grafico_transferencias_funcao <- renderPlotly({
  
  lista_funcao <- input$funcao_governo_input
  lista_programa <- input$programa_governo_input
  lista_acao <- input$acao_governo_input
  anos <- input$ano_input[1]:input$ano_input[2]
  tipo <- input$tipo_input
  ente <- input$ente_input
  categoria <- input$categoria_input
  tabela <- recursos %>%
    filter(
      nome_funcao %in% lista_funcao,
      nome_programa %in% lista_programa,
      nome_acao %in% lista_acao,
      ano %in% anos,
      linguagem_cidada %in% tipo,
      esfera == ente,
      tipo_transferencia %in% categoria
    )%>%group_by(nome_funcao,ano_mes)%>%
    summarise(total = sum(valor_transferido))
  
 
  p_total_funcao_linha <- plot_ly(tabela, 
                                  y = ~total, 
                                  x = ~`ano_mes`, 
                                  name = ~nome_funcao, 
                                  type = 'scatter',
                                  mode = 'lines+markers'
                                  #line = list(shape = "spline")
                                  ) %>%
    layout(title = "Função por ano",
           yaxis = list(title = ~total,
                        type = "log",
                        showticklabels = FALSE ),
           xaxis = list(title = ~`ano_mes`))%>%
    hide_colorbar()
  
})