output$grafico_fonte_recurso_educacao <- renderPlotly({
  
  programas <- c("FUNDEB","PDDE","PNATE")
  
  educacao_pagamentos <-
    pagamentos %>% filter(categoria %in% programas,MUNICIPIO == input$nome_municipio_rastreamento)%>%
    group_by(data = year(DATA_DO_PAGAMENTO),programa = categoria) %>%
    summarise(total = sum(PAGO))%>%
    mutate(categoria = "Pagamentos")%>%filter(data > 2016)
  
  educacao_repasses <-
    recursos %>% filter(linguagem_cidada %in% programas,nome_municipio == input$nome_municipio_rastreamento) %>%
    group_by(data = ano,programa = linguagem_cidada) %>%
    summarise(total = sum(valor_transferido)) %>%
    mutate(categoria = "Repasses")
  
  dataset <- merge(educacao_pagamentos,educacao_repasses,all=T )
    p <- ggplot(dataset,
                aes(fill = categoria,
                    y = log2(total),
                    x = programa,
                    text =paste("Programa :",programa,
                                "<br>Descrição",categoria,
                                "<br>Ano :",data,
                                '<br>Total:R$',formatar(total)))) +
    geom_bar(position = "dodge", stat = "identity")  +
    # ggtitle("Programas") +
    facet_wrap( ~ data) +  
    xlab("") +
    ylab("")
  ggplotly(p,tooltip = "text" )

 

})



