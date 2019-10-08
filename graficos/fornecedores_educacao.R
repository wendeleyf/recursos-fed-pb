output$fornecedores_educacao <- renderPlot({
  
  tabela <- buscar_top_20_fornecedores()
  
  color_pal = viridis::viridis_pal(direction = -1,option = "D")(20)
  p <- treemap::treemap(tabela, 
                        index=c("FORNECEDOR"),
                        vSize="TOTAL_PAGO", 
                        vColor="TOTAL_PAGO",
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