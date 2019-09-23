output$treemap_tipo_municipio <- renderPlot({
  
  tabela <- filter_data()
  
  color_pal = viridis::viridis_pal(direction = -1,option = "D")(5)
  p <- treemap::treemap(recursos, 
                   index=c("linguagem_cidada"),
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