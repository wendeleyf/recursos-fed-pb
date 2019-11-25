output$grafico_fonte_recurso_educacao_geral <- renderPlotly({
  anos <- input$ano_rastreamento_educacao_geral_input[1]:input$ano_rastreamento_educacao_geral_input[2]
  
  programas <- c("FUNDEB","PDDE","PNATE")
  color_pal = viridis::viridis_pal(direction = -1,option = "D")(5)
  educacao_pagamentos <-
    pagamentos %>% filter(categoria %in% programas )%>%
    group_by(data = year(DATA_DO_PAGAMENTO),programa = categoria) %>%
    summarise(total = sum(PAGO))%>%
    mutate(categoria = "Pagamentos")%>%filter(data %in% anos)
  
  educacao_repasses <-
    recursos %>% filter(linguagem_cidada %in% programas) %>%
    group_by(data = ano,programa = linguagem_cidada) %>%
    summarise(total = sum(valor_transferido)) %>%
    mutate(categoria = "Repasses")%>%filter(data %in% anos)
  
  dataset <- merge(educacao_pagamentos,educacao_repasses,all=T )
 

  ggplotly(
    ggplot(dataset,
           aes(y = total,
               x = programa,
               fill = categoria,
               text = paste("Programa :",programa,
                            "<br>Descrição",categoria,
                            "<br>Ano :",data,
                            "<br>Total:R$",
                            formatar(total)))) +
      geom_bar(position = "dodge", stat = "identity") +
      scale_fill_viridis_d(direction = 1,
                           begin = 0,
                           end = .79) +
      scale_y_continuous(labels = scales::format_format(
        big.mark = ".",
        decimal.mark = ",",
        scientific = FALSE
      )) +
      theme(legend.title = element_blank()) +
       
      facet_wrap( ~ data) +
      xlab("") +
      ylab("")
    , tooltip = "text")
  
  })