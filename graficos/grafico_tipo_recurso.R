output$grafico_transferencias_geral <- renderPlotly({
  
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
    )%>%group_by(tipo_transferencia,ano)%>%
    summarise(total = sum(valor_transferido))
  
  toWebGL(
  p_total_funcao_linha <- plot_ly(tabela,
                                  x = ~ano , 
                                  y = ~total, 
                                  name = ~tipo_transferencia,
                                  text = ~paste("Categoria do Repasse :",tipo_transferencia,"<br>Ano :",ano,'<br>Total:R$',formatar(total)),
                                  hoverinfo = 'text')%>%
    layout(title = FALSE,
           yaxis = list(title = "",
                        showticklabels = FALSE,
                        type = "log"),
           xaxis = list(title = ~tipo_transferencia),
           barmode = 'group')
  )
})