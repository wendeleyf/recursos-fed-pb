output$grafico_fonte_recurso_educacao <- renderPlotly({
  
  programas <- c("FUNDEB","PDDE","PNATE")
  
  pagamentos
   
  
  
  

 

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

