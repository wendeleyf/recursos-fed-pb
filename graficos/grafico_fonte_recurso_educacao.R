output$grafico_fonte_recurso_educacao <- renderPlotly({
  
  #categorizando empenhos
  empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "FUNDEB") == TRUE] <- "FUNDEB"
  empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "PNAE") == TRUE] <- "PNAE"
  empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "FNDE") ==  TRUE] <- "FNDE"
  empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "PDDE") == TRUE] <- "PDDE"
  empenhos$tipo_repasse [grepl(x = empenhos$fonte_recurso, pattern = "PNATE") == TRUE] <- "PNATE"
  empenhos$vl_Empenho <- as.numeric(gsub(",", ".", gsub("\\.", "", empenhos$vl_Empenho)))
  
  tabela <- empenhos%>%
    filter()%>%
    group_by(tipo_repasse,ano_emissao)%>%
    summarise(total = sum(vl_Empenho))
  
  p <- ggplot(tabela, aes(fill=tipo_repasse, y=log10(total), x=tipo_repasse)) + 
    geom_bar(position="dodge", stat="identity") +
    scale_fill_viridis(discrete = T, option = "D",direction = 1) +
    ggtitle("") +
    facet_wrap(~ano_emissao) +
    
    theme(legend.position="none") +
    xlab("") +
    
    ylab("")
  ggplotly(p)
  

})





# teste <- empenhos%>%
#   group_by(tipo_repasse,ano_emissao)%>%
#   summarise(total = sum(vl_Empenho))
# 
# p <- ggplot(teste, aes(fill=tipo_repasse, y=log10(total), x=tipo_repasse)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_viridis(discrete = T, option = "D",direction = 1) +
#   ggtitle("Programas") +
#   facet_wrap(~ano_emissao) +
# 
#   theme(legend.position=~total) +
#   xlab("") +
# 
#   ylab("")

