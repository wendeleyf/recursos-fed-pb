output$tabela_categoria_municipo <- DT::renderDataTable({
  
  tabela <- filter_data_municipio()%>%
    filter(nome_municipio == input$nome_municipio_input)%>%
    group_by(tipo_transferencia,ano_mes)%>%
    summarise(total = sum(valor_transferido))
  
  tabela$ano_mes <-  ymd(paste(tabela$ano_mes,"01",sep = ""))
  tabela$ano_mes <- format(ymd(ano_mes),"%B-%Y") 

})