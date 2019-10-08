fluidRow(
  box(
    title = tags$strong("Rastreamento das Verbas da Educação - Municípios"),
    solidHeader = TRUE,
    tags$p("Neste painel é possível visualizar os recursos transferidos para um ou mais municípios da Paraíba
           relativamente à Função Educação bem como a sua aplicação dentro da mesma rúbrica"),
    tags$p("Os valores estão agrupados por tipo de transferência: FUNDEB, PDDE, PNATE, PNAE e outras.
           No grupo outras, estão todas as transferências fiscais da União ao(s) município(s) que não foram classificadas 
           na origem em nenhum dos grupos anteriores, mas que estão dentro da Função Educação"),
    width = 12
  ),
  box(
    title = "Selecione o Município",
    uiOutput("filtro_nomes_rastreamento"),
    width = 12
  ),
  box(
    title = "Valor total transferido X Aplicado no período",
    tabsetPanel(
      type = "tabs",
      tabPanel(
        title = "Gráfico"
      ),
      tabPanel(
        title = "Dados"
      )
    ),
    width = 12
  ),
  box(
    title = "Programas ",
    collapsible=TRUE,
    tabsetPanel(
      type = "tabs",
      tabPanel(
        title = "Gráfico",
        plotly::plotlyOutput("grafico_fonte_recurso_educacao")
      ),
      tabPanel(
        title = "Dados"
      )
    ),
    width = 12
  )
)