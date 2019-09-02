fluidRow(
  box(
    title = tags$strong("Transferências Fiscais na Paraíba"),
    solidHeader = TRUE,
    tags$p("Painel que permite visualizar a totalidade das transferências fiscais ao Estado. Deve-se escolher um tipo de ente
      recebedor para visualizar os dados (Municípios, Estado ou Entidades sem fins lucrativos)"),
    tags$p("É possível ver os dados sob vários angulos por meios das séries temporais para verificar como os recursos estão se comportando
           no tempo."),
    width = 12
  ),
  box(
    title = "Tipo de Ente",
    prettyRadioButtons(
      inputId = "tipo_ente",
      label = "Escolha",
      choices = c("Municipal", "Estado", "Entidades sem fins lucrativos")
    ),
    width = 3
    ),
  box(
    title = "Ano(s)",
    sliderTextInput(
      inputId = "ano_input",
      label = "Escolha os anos",
      choices = c(2010,2011,2012,2013,2014,2015),
      selected = c(2010, 2013)
    ),
    width = 3
    ),
  box(
    title = "Categoria Transf.",
    width = 3
    ),
  box(
    title = "Tipo Transf.",
    width = 3
    )
)
