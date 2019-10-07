output$grafico_fonte_recurso_educacao <- renderPlotly({
  
  #categorizando pagamentos por fonte de recurso
  pagamentos_educacao$tipo_repasse [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "FUNDEB") == TRUE] <- "FUNDEB"
  pagamentos_educacao$tipo_repasse [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "PNAE") == TRUE] <- "PNAE"
  pagamentos_educacao$tipo_repasse [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "FNDE") ==  TRUE] <- "FNDE"
  pagamentos_educacao$tipo_repasse [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "PDDE") == TRUE] <- "PDDE"
  pagamentos_educacao$tipo_repasse [grepl(x = pagamentos_educacao$FONTE_DO_RECURSO, pattern = "PNATE") == TRUE] <- "PNATE"
  #convertendo data
  pagamentos_educacao$DATA_DO_PAGAMENTO <- as.Date(pagamentos_educacao$DATA_DO_PAGAMENTO)
  pagamentos_educacao$DATA_DO_PAGAMENTO <- ymd(pagamentos_educacao$DATA_DO_PAGAMENTO)
  pagamentos_educacao$DATA_DO_PAGAMENTO <- as.Date(format(ymd(pagamentos_educacao$DATA_DO_PAGAMENTO),"%m-%Y"))
  #convertendo valor
  pagamentos_educacao$PAGO <- as.numeric(gsub(",", ".", gsub("\\.", "", pagamentos_educacao$PAGO)))
  #separando categorias
  categorias <- unique(pagamentos_educacao$categoria)
  
  tabela <- pagamentos%>%
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

