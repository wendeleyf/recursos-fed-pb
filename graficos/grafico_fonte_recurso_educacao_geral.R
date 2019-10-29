output$grafico_fonte_recurso_educacao_geral <- renderPlotly({
  
  programas <- c("FUNDEB","PDDE","PNATE")
  color_pal = viridis::viridis_pal(direction = -1,option = "D")(5)
  educacao_pagamentos <-
    pagamentos %>% filter(categoria %in% programas )%>%
    group_by(data = year(DATA_DO_PAGAMENTO),programa = categoria) %>%
    summarise(total = sum(PAGO))%>%
    mutate(categoria = "Pagamentos")%>%filter(data > 2016)
  
  educacao_repasses <-
    recursos %>% filter(linguagem_cidada %in% programas) %>%
    group_by(data = ano,programa = linguagem_cidada) %>%
    summarise(total = sum(valor_transferido)) %>%
    mutate(categoria = "Repasses")
  
  dataset <- merge(educacao_pagamentos,educacao_repasses,all=T )
  p <- ggplot(dataset,
              aes(
                fill = categoria,
                y = total,
                x = programa,
                text = paste(
                  "Programa :",
                  programa,
                  "<br>Descrição",
                  categoria,
                  "<br>Ano :",
                  data,
                  '<br>Total:R$',
                  formatar(total)
                )
              )) +
    geom_bar(position = "dodge", stat = "identity")  +
    theme(legend.title = element_blank()) +
    scale_y_continuous(labels = scales::format_format(
      big.mark = ".",
      decimal.mark = ",",
      scientific = FALSE
    )) +
    facet_wrap( ~ data) +
    xlab("") +
    ylab("")
  ggplotly(p, tooltip = "text")
  
  })