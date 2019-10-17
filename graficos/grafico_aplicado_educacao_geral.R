output$grafico_aplicado_educacao_geral <- renderPlotly({
  
  df_pagamentos <- pagamentos%>%filter(!is.na(categoria))%>%
    group_by(data = year(DATA_DO_PAGAMENTO)) %>%
    summarise(total = sum(PAGO))%>%
    mutate(categoria = "Pagamentos")%>%filter(data > 2016)
  programas <- c("FUNDEB","PDDE","PNATE") 
  df_recursos <- recursos%>%filter(linguagem_cidada %in% programas)%>%
    group_by(data = ano) %>%
    summarise(total = sum(valor_transferido)) %>%
    mutate(categoria = "Repasses")
  
  
  
  df_merge <- merge(df_recursos,df_pagamentos,all=T )
  
  p1 <- plot_ly(df_merge,
                y = ~total,
                x = ~data,
                
                color = ~categoria,
                
                name = ~categoria,
                text = ~paste("",categoria,
                              "<br>Data :",data,'<br>Total:R$',formatar(total)),
                hoverinfo = 'text')%>%
    layout(title = "",
           
           
           yaxis = list(title = "",
                        showticklabels = FALSE,
                        type = "log"),
           xaxis = list(title = ~categoria)
    )%>%config(displaylogo = FALSE)
  
  p1

})


