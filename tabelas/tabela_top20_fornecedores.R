output$tabela_top20_fornecedores <- DT::renderDataTable({
  anos <- input$ano_rastreamento_educacao_geral_input[1]:input$ano_rastreamento_educacao_geral_input[2]
  tabela <- 
    fornecedores %>% filter(TIPO == "Fornecedor Comum") %>%
    filter(DATA_DO_PAGAMENTO %in% anos) %>%
    group_by(FORNECEDOR, CPF_CNPJ) %>%
    summarise(PAGO = sum(PAGO),
              Nº_DE_MUNICÍPIOS = n_distinct(MUNICIPIO)) %>%
    arrange(desc(Nº_DE_MUNICÍPIOS)) %>%
    head(20)
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
      columns = "PAGO",
      currency = "R$",
      digits = 2,
      mark = ".",
      dec.mark = ","
    )
})