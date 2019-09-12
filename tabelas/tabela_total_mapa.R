output$tabela_total_mapa <- DT::renderDataTable({

  tabela <- filter_data_municipio()%>%
    group_by(nome_municipio, ano) %>%
    summarise(total = sum(valor_transferido))%>%
    spread(ano, total)
  tabela[is.na(tabela)] <- 0
  tabela <- cbind(tabela,
                  total_total = rowSums(tabela[, -1]))
  tabela <- tabela %>%
    arrange(desc(total_total))


  nomes <- colnames(tabela)
  DT::datatable(
    data = tabela,
    class = "compact stripe",
    extensions = "Responsive",
    rownames = FALSE,
    selection = "none",
    options = list(language = list(url = 'linguagens/Portuguese-Brasil.json'),
                   info = TRUE) 
  ) %>% 
    formatCurrency(
    columns = nomes,
    currency = "R$",
    digits = 2,
    mark = ".",
    dec.mark = ","
  )
})