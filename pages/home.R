fluidRow(
  box(
    img(src ='img/fundo_3.png', class = "img img-responsive"),
    h2("Sobre o Sistema"),
    tags$p("Permitir a visualização, acompanhamento e análise dos recursos federais que chegam ao estado
           da Paraíba e seus municípios com vistas a obter insights sobre a execução das Políticas Públicas
           alvo desses recursos subsidiando tomada de decisão e ações de controle que contribuam para melhoria
           do desempenho operacional dessas políticas e uma melhor alocação de recursos."),
    h2("Fontes de dados e Datasets utilizados"),
    tags$p("Transferências da União"),
    tags$p("Objetivo:"),
    tags$ul(tags$li("Visualizar as transferências Fiscais da União para o estado da PB e seus municípios")),
    tags$p("Formas de visualização:"),
    tags$ul(tags$li("Ver o montante transferido por município e para o estado como um todo"),
            tags$li("Ver os montantes transferidos no tempo"),
            tags$li("Ver os montantes:",
                    tags$ul(tags$li("por categoria (Obrigatórias e Discricionárias) - Maior nível de agregação"),
                            tags$li("por tipo (Fundeb, PNATE, Royalties etc.)")))),
    tags$p("Fonte: Portal da Transparência"),
    h2("Filtros aplicados aos dados"),
    tags$p("Dataset: ", tags$strong("Transferências fiscais")),
    tags$ol(
      tags$li("Excluídos os valores negativos"),
      tags$li("Excluído FPE e FPM")
    ),
    tags$p("Dataset: ", tags$strong("Transferências voluntárias")),
    tags$ol(
      tags$li('Filtro inicial: "Em execução"')
    ),
    width = 12
    )
  )