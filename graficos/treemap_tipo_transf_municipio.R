output$treemap_tipo_municipio <- renderD3tree2({
  tabela <- filter_data_municipio()%>%
    filter(nome_municipio == input$nome_municipio_input)
  color_pal = viridis::viridis_pal(direction = -1, option = "D")(5)
  d3tree2(
    treemap(
      tabela,
      index = c("linguagem_cidada","nome_programa"),
      vSize = "valor_transferido",
      vColor = "valor_transferido",
      type = "value",
      title = "",
      palette = color_pal,
      fun.aggregate = "sum",
      border.col = "white",
      position.legend = "none",
      fontsize.labels = 16,
      title.legend = "",
      format.legend = list(
        scientific = FALSE,
        big.mark = ".",
        decimal.mark = ","
      )
    )
    ,
    rootname = "Transferências"
  )
})