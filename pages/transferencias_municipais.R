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
    title = "Mapa de recursos transferidos",
    solidHeader = TRUE,
    leafletOutput("mapa_transferencias_municipio"),
    width = 12
  )
)