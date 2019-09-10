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
      inputId = "ente_input",
      label = "Escolha",
      choices = c("Municipal", "Estado", "Entidades Sem Fins Lucrativos")
    ),
    width = 3
    ),
  box(
    title = "Ano(s)",
    sliderInput(
      inputId = "ano_input_municipio",
      label = "Escolha os anos",
      min = 2017,
      max = 2019,
      value = c(2017,2019)
    ),
    width = 3
    ),
  box(
    title = "Categoria Transf.",
    pickerInput(
      inputId = "categoria_input",
      label = "Escolha uma categoria",
      choices = c("Constitucionais e Royalties", "Legais, Voluntárias e Específicas"),
      selected = c("Constitucionais e Royalties", "Legais, Voluntárias e Específicas"),
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    ),
    width = 3
    
    ),
  box(
    title = "Tipo Transf.",
    uiOutput("filtro_tipo"),
    width = 3
    ),
  box(
    title = "Funcional Programático",
    column(
     uiOutput("filtro_funcao"),
     width = 12
    ),
    column(
      uiOutput("filtro_programa"),
      width = 12
    ),
    column(
      uiOutput("filtro_tipo_transferencia"),
      width = 12
    ),
    width = 12
  ),
  
  box(
    title = "Recursos Transferidos por Categoria",
    tabsetPanel(
      type = "tabs",
      tabPanel(title = "Gráfico",
              plotly::plotlyOutput("grafico_transferencias_geral")),
      tabPanel(
        title = "Dados",
        tags$br(),
        DT::dataTableOutput("tabela_transferencias_geral")
      )
      ),
    width = 12
  ),
  box(
    title = "Recursos Transferidos por Função",
    tabsetPanel(
      type = "tabs",
      tabPanel(title = "Gráfico",
               plotly::plotlyOutput("grafico_transferencias_funcao")),
      tabPanel(
        title = "Dados",
        tags$br(),
        DT::dataTableOutput("tabela_transferencias_funcao")
      )
    ),
    width = 12
  )
)
