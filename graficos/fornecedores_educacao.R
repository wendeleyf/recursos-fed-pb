output$fornecedores_educacao <- renderPlotly({
  # Recebendo lista com os anos selecionados
  anos <-
    input$ano_rastreamento_educacao_geral_input[1]:input$ano_rastreamento_educacao_geral_input[2]
  
  # Convertendo gráfico do ggplot2 em plot interativos com o plotly.js
  ggplotly(
    # Filtrando e agregando dados
    fornecedores %>% filter(TIPO == "Fornecedor Comum") %>% # Filtrando por tipo de fornecedor 
      filter(DATA_DO_PAGAMENTO %in% anos) %>%  # Filtrando por ano de atuação
      group_by(FORNECEDOR, CPF_CNPJ) %>% # Agrupando pelas variáveis  FONRNECEDOR E CPF_CNPJ
      summarise(PAGO = sum(PAGO), # Sumarizando total pago ao fornecedor
                Nº_DE_MUNICÍPIOS = n_distinct(MUNICIPIO)) %>% # Contabilizando a quantidade de atuação do fornecedor
      arrange(desc(Nº_DE_MUNICÍPIOS)) %>% # Ordenando pelo numero de municipios de atuação do fornecedor
      head(10) %>% # selecionando os 10 primeiros registros
      # Gerando gráfico ggplot2 
      ggplot(aes(reorder(FORNECEDOR, Nº_DE_MUNICÍPIOS),# Alterando a ordem dos níveis dos fatores
                 Nº_DE_MUNICÍPIOS,
                 fill = PAGO,
                 # Mapeando legendas e rótulos do gráfico
                 text = paste("FORNECEDOR :",
                              FORNECEDOR,"<br>",
                              "CPF/CNPJ : ",
                              CPF_CNPJ,"<br>",
                              "Nº DE MUNICÍPIOS ATUANDO : ",
                              Nº_DE_MUNICÍPIOS,"<br>",
                              'VALOR PAGO: R$',
                              formatar(PAGO)))) +
      # Definindo o layout do gráfico
      geom_bar(position = "dodge", stat = "identity") +
      # definindo scala de cores e valores
      scale_fill_viridis(direction = -1,
                         begin = 0,
                         end = .79,
                         labels = scales::format_format(big.mark = ".",
                                                        decimal.mark = ",",
                                                        scientific = FALSE))  +
      # Invertendo as coordenadas cartesianas para deixar o grafico na horizontal
      coord_flip() +
      # Definindo legendas e rótulos do gráfico
      labs(x = "",
           y = "Nº DE MUNICÍPIOS ATUANDO",
           fill = "VALOR PAGO EM R$"),
    
    tooltip = "text") 

})