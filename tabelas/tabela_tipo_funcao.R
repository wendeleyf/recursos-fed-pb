output$tabela_transferencias_funcao <- DT::renderDataTable({

  tabela <- filter_data()%>%
    group_by(nome_funcao,ano)%>%
    summarise(total = sum(valor_transferido))%>%
    spread(ano, total)
  tabela[is.na(tabela)] <- 0
  tabela <- cbind(tabela,
                  total_total = rowSums(tabela[, -1]))
  tabela <- tabela %>%
    arrange(total_total)
  
  nomes <- colnames(tabela)
  DT::datatable(
    data = tabela,
    class = "compact stripe",
    extensions = "Responsive",
    rownames = FALSE,
    selection = "none",
    options = list(language = list(url = 'linguagens/Portuguese-Brasil.json')) 
  ) %>% formatCurrency(
    columns = nomes,
    currency = "R$",
    digits = 2,
    mark = ".",
    dec.mark = ","
  )
})