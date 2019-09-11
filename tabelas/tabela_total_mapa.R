output$tabela_total_mapa <- DT::renderDataTable({
  lista_funcao <- input$funcao_governo_input_municipios
  lista_programa <- input$programa_governo_input_municipios
  lista_acao <- input$acao_governo_input_municipios
  anos <- input$ano_input_municipios[1]:input$ano_input_municipios[2]
  tipo <- input$tipo_input_municipios
  categoria <- input$categoria_input_municipios
  
  tabela <- recursos %>%
    filter(
      nome_funcao %in% lista_funcao,
      nome_programa %in% lista_programa,
      nome_acao %in% lista_acao,
      ano %in% anos,
      linguagem_cidada %in% tipo,
      esfera == "Municipal",
      tipo_transferencia %in% categoria
    ) %>%
    group_by(nome_municipio, ano) %>%
    summarise(total = sum(valor_transferido)) 

  
  tabela <- aggregate(tabela$total, by=list(nome_municipio = tabela$nome_municipio), FUN=sum)
  # Testes
  
  # rowSums(tabela[, -1])
  # tabela <- cbind(tabela,
  #                         total_total = rowSums(tabela[, -1]))
  
  nomes <- colnames(tabela)
  DT::datatable(
    data = tabela,
    class = "compact stripe",
    extensions = "Responsive",
    rownames = FALSE,
    selection = "none",
    options = list(language = list(url = 'linguagens/Portuguese-Brasil.json')) 
  ) %>% 
    formatCurrency(
    columns = nomes,
    currency = "R$",
    digits = 2,
    mark = ".",
    dec.mark = ","
  )
})