output$tabela_programas_educacao_geral <- DT::renderDataTable({
  anos <- input$ano_rastreamento_educacao_geral_input[1]:input$ano_rastreamento_educacao_geral_input[2]
  # anos <- c(2017,2018,2019)
  programas <- c("FUNDEB","PDDE","PNATE")
  
  educacao_pagamentos <-
    pagamentos %>% filter(categoria %in% programas)%>%
    group_by(data = year(DATA_DO_PAGAMENTO),programa = categoria) %>%
    summarise(total = sum(PAGO))%>%
    mutate(categoria = "Pagamentos")%>%filter(data %in% anos)
  
  educacao_repasses <-
    recursos %>% filter(linguagem_cidada %in% programas) %>%
    group_by(data = ano,programa = linguagem_cidada) %>%
    summarise(total = sum(valor_transferido)) %>%
    mutate(categoria = "Repasses")%>%filter(data %in% anos)
  
  tabela <- 
    merge(educacao_pagamentos,educacao_repasses,all=T )%>%
    spread(data, total)
  nomes <- colnames(tabela)
  DT::datatable(
    data = tabela,
    class = "compact stripe",
    extensions = "Responsive",
    rownames = FALSE,
    selection = "none",
    options = list(language = list(url = 'linguagens/Portuguese-Brasil.json'),
                   paging = FALSE,
                   searching = FALSE) 
  ) %>%
    formatCurrency(
      columns = nomes,
      currency = "R$",
      digits = 2,
      mark = ".",
      dec.mark = ","
    )
})
