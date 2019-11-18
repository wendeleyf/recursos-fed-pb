output$fornecedores_educacao <- renderPlotly({
 
  tabela <- fornecedores%>%filter(TIPO == "Fornecedor Comum")
  
  p <- tabela[1:10,] %>%
    ggplot(aes(reorder(FORNECEDOR, MUNICIPIO),
               MUNICIPIO,
               fill = PAGO,
               text = paste("FORNECEDOR :",
                            FORNECEDOR,
                            "<br>CPF/CNPJ : ",
                            CPF_CNPJ,
                            "<br>Nº DE MUNICÍPIOS ATUANDO : ",
                            MUNICIPIO,
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





