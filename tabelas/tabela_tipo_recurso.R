output$tabela_transferencias_geral <- DT::renderDataTable({
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
    summarise(total = sum(valor_transferido))%>%
    spread(ano, total)
  
  DT::datatable(
    data = tabela,
    class = "compact stripe",
    extensions = "Responsive",
    rownames = FALSE,
    selection = "none",
    options = list(language = list(url = 'linguagens/Portuguese-Brasil.json'))
  )
})