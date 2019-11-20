output$fornecedores_educacao <- renderPlotly({
  
  anos <- input$ano_rastreamento_educacao_geral_input[1]:input$ano_rastreamento_educacao_geral_input[2]
  tabela <- fornecedores%>%filter(TIPO == "Fornecedor Comum")%>%
    filter(DATA_DO_PAGAMENTO %in% anos)
  
  p <- tabela%>%
    group_by(FORNECEDOR,CPF_CNPJ)%>%
    summarise(PAGO = sum(PAGO),
              QTD = n_distinct(MUNICIPIO))%>%
    arrange(desc(QTD))%>%
    head(10)%>%
  
    ggplot(aes(reorder(FORNECEDOR, QTD),
               QTD,
               fill = PAGO,
               text = paste("FORNECEDOR :",
                            FORNECEDOR,
                            "<br>CPF/CNPJ : ",
                            CPF_CNPJ,
                            "<br>Nº DE MUNICÍPIOS ATUANDO : ",
                            QTD,
                            '<br>VALOR PAGO: R$',
                            formatar(PAGO)))) +
    geom_bar(position = "dodge", stat = "identity") +
    scale_fill_viridis(direction = -1,
                       begin = 0,
                       end = .79,
                       labels = scales::format_format(
                         big.mark = ".",
                         decimal.mark = ",",
                         scientific = FALSE))  +
    coord_flip() +
    labs(x= "",
         y = "Nº DE MUNICÍPIOS ATUANDO",
         fill = "VALOR PAGO EM R$"
         ) 
  
  
  
  
  # Adicionando as legendas 
  ggplotly(p,tooltip = "text")%>%
  style(hoverlabel = list(bgcolor = "white",
                            bordercolor = "#77777",
                            font = list(color  = '#77777'),
                            align = "forget",  
                            orientation = "v"  ))
  
})





