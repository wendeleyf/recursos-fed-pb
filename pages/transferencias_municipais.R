fluidRow(
  box(
    title = tags$strong("Transferências Fiscais aos Municípios PB"),
    solidHeader = TRUE,
    tags$p("Painel que permite vizualizar a totalidade das transferencias fiscais aos municípios da Paraíba. 
           Pode-se selecionar 1 município para análise individual."),
    tags$p("É possível ver os dados sob vários angulos por meios das séries temporais para verificar como os recursos estão se comportando
           no tempo."),
    width = 12
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
    title = "Categoria Transferência",
    pickerInput(
      inputId = "categoria_input_municipios",
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
    title = "Tipo Transferência",
    uiOutput("filtro_tipo_municipios"),
    width = 3
  ),
  box(
    title = "Funcional Programático",
    column(
      uiOutput("filtro_funcao_municipios"),
      width = 12
    ),
    column(
      uiOutput("filtro_programa_municipios"),
      width = 12
    ),
    column(
      uiOutput("filtro_tipo_transferencia_municipios"),
      width = 12
    ),
    width = 12
  ),
  box(
    title = "Mapa de recursos transferidos",
    solidHeader = TRUE,
    leafletOutput("mapa_transferencias_municipio"),
    width = 12
  )
)