output$treemap_tipo_municipio <- renderPlot({
  
  tabela <- filter_data_municipio()%>%
    filter(nome_municipio == input$nome_municipio_input)
  
  color_pal = viridis::viridis_pal(direction = -1,option = "D")(5)
  treemap::treemap(tabela, 
                   index="linguagem_cidada", 
                   vSize="valor_transferido", 
                   vColor="valor_transferido",
                   type="value",
                   title = "",
                   palette=color_pal,
                   fun.aggregate = "sum",
                   border.col ="white",
                   position.legend="bottom",
                   fontsize.labels = 16,
                   title.legend="",
                   format.legend = list(scientific = FALSE, big.mark = ".", decimal.mark = ",")
                   
                   
                   
  )
  
  
})