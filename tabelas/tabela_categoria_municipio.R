output$tabela_categoria_municipio <- DT::renderDataTable({
  tabela <- filter_data_municipio() %>%
    filter(nome_municipio == input$nome_municipio_input) %>%
    group_by(tipo_transferencia, ano_mes) %>%
    summarise(total = sum(valor_transferido)) %>%
    spread(tipo_transferencia, total)
  tabela$ano_mes <- ymd(paste(tabela$ano_mes, "01", sep = ""))
  tabela$ano_mes <- format(ymd(tabela$ano_mes), "%B-%Y")
  
  tabela
  
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