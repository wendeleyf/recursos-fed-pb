source("R/utils.R")
source("R/busca_recursos_no_bd.R")
source("mapas/mapa_total_transferencia_municipios.R")

#source("R/processar_graficos.R")

ui <- dashboardPage(
  dashboardHeader(
    title = "RECURSOS-PB",
    titleWidth = 250
  ),
  
  dashboardSidebar(
    
    sidebarMenu(
      menuItem(
        tabName = "home",
        text = "Inicial",
        icon = icon("home")
      ),
      menuItem(
        text = "Transferências Fiscais",
        icon = icon("flag"),
        menuSubItem(
          tabName = "transferencias_gerais",
          text = "Visão Geral",
          icon = icon("eye")
        ),
        menuSubItem(
          tabName = "transferencias_municipais",
          text = "Visão Municipal",
          icon = icon("eye")
        ),
        menuSubItem(
          text = "Visão Estadual",
          icon = icon("eye")
        )
      ),
      menuItem(
        text = "Aplicações Diretas",
        icon = icon("flag")
      ),
      menuItem(
        text = "Rastreamento",
        icon = icon("search"),
        menuItem(
          text = "Municipal",
          icon = icon("eye"),
          menuSubItem(
            text = "Educação",
            icon = icon("book")
          ),
          menuSubItem(
            text = "Saúde",
            icon = icon("plus")
          )
        ),
        menuItem(
          text = "Estadual",
          icon = icon("flag")
        )
      )
    ),
    
    width = 250
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
             source(file = "pages/home.R", encoding = "UTF-8")[1]
      ),
      tabItem(tabName = "transferencias_gerais",
              source(file = "pages/transferencias_gerais.R", encoding = "UTF-8")[1]
      ),
      tabItem(tabName = "transferencias_municipais",
              source(file = "pages/transferencias_municipais.R", encoding = "UTF-8")[1])
    )
  )
)


server <- function(input, output, session){
  
  # Transferências Gerais
  output$filtro_tipo <- renderUI({
    lista_categoria <- input$categoria_input
    lista_tipo_transferencia <- recursos %>%
      filter(tipo_transferencia %in% lista_categoria) %>%
      distinct(linguagem_cidada) %>%
      arrange(linguagem_cidada) %>%
      split(.$linguagem_cidada) %>%
      map(~.$linguagem_cidada)
    
    pickerInput(
      inputId = "tipo_input",
      label = "Tipo Transferência",
      choices = lista_tipo_transferencia,
      selected = lista_tipo_transferencia,
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    )
  })
  
  output$filtro_funcao <- renderUI({
    lista_tipo_transferencia <- input$tipo_input
    lista_funcao <- recursos %>%
      filter(linguagem_cidada %in% lista_tipo_transferencia) %>%
      distinct(nome_funcao) %>%
      arrange(nome_funcao) %>%
      split(.$nome_funcao) %>%
      map(~.$nome_funcao)
    
    pickerInput(
      inputId = "funcao_governo_input",
      label = "Função do governo:",
      choices = lista_funcao,
      selected = lista_funcao,
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    )
  })
  
  output$filtro_programa <- renderUI({
    lista_funcao <- input$funcao_governo_input
    lista_programa <- recursos %>%
      filter(nome_funcao %in% lista_funcao) %>%
      distinct(nome_programa) %>%
      arrange(nome_programa) %>%
      split(.$nome_programa) %>%
      map(~.$nome_programa)
    
    pickerInput(
      inputId = "programa_governo_input",
      label = "Programa:",
      choices = lista_programa,
      selected = lista_programa,
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    )
  })
  
  output$filtro_tipo_transferencia <- renderUI({
    lista_programa <- input$programa_governo_input
    lista_tipo_transf <- recursos %>%
      filter(nome_programa %in% lista_programa) %>%
      distinct(nome_acao) %>%
      arrange(nome_acao) %>%
      split(.$nome_acao) %>%
      map(~.$nome_acao)
    
    pickerInput(
      inputId = "acao_governo_input",
      label = "Ação:",
      choices = lista_tipo_transf,
      selected = lista_tipo_transf,
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    )
  })

  
  
  #total de recursos por categoria
  output$tabela_transferencias_geral <- DT::renderDataTable({
    source("tabelas/tabela_tipo_recurso.R",local = TRUE, encoding = "UTF-8")

  })

  
  output$grafico_transferencias_geral <- renderPlotly({
    source("graficos/grafico_tipo_recurso.R", local = TRUE, encoding = "UTF-8")

    })
  
  #total de recursos por função
  output$tabela_transferencias_funcao <- DT::renderDataTable({
    source("tabelas/tabela_tipo_funcao.R",local = TRUE, encoding = "UTF-8")
    
  })

  output$grafico_transferencias_funcao <- renderPlotly({
    source("graficos/grafico_tipo_funcao.R", local = TRUE, encoding = "UTF-8")
    
  })
  
# ============================================================================
  
  # Transferências Municipais
  
  output$filtro_tipo_municipios <- renderUI({
    lista_categoria <- input$categoria_input_municipios
    lista_tipo_transferencia <- recursos %>%
      filter(tipo_transferencia %in% lista_categoria) %>%
      distinct(linguagem_cidada) %>%
      arrange(linguagem_cidada) %>%
      split(.$linguagem_cidada) %>%
      map(~.$linguagem_cidada)
    
    pickerInput(
      inputId = "tipo_input_municipios",
      label = "Escolha um tipo",
      choices = lista_tipo_transferencia,
      selected = lista_tipo_transferencia,
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    )
  })
  
  output$filtro_funcao_municipios <- renderUI({
    lista_tipo_transferencia <- input$tipo_input_municipios
    lista_funcao <- recursos %>%
      filter(linguagem_cidada %in% lista_tipo_transferencia) %>%
      distinct(nome_funcao) %>%
      arrange(nome_funcao) %>%
      split(.$nome_funcao) %>%
      map(~.$nome_funcao)
    
    pickerInput(
      inputId = "funcao_governo_input_municipios",
      label = "Função do governo:",
      choices = lista_funcao,
      selected = lista_funcao,
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    )
  })
  
  output$filtro_programa_municipios <- renderUI({
    lista_funcao <- input$funcao_governo_input_municipios
    lista_programa <- recursos %>%
      filter(nome_funcao %in% lista_funcao) %>%
      distinct(nome_programa) %>%
      arrange(nome_programa) %>%
      split(.$nome_programa) %>%
      map(~.$nome_programa)
    
    pickerInput(
      inputId = "programa_governo_input_municipios",
      label = "Programa:",
      choices = lista_programa,
      selected = lista_programa,
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    )
  })
  
  output$filtro_tipo_transferencia_municipios <- renderUI({
    lista_programa <- input$programa_governo_input_municipios
    lista_tipo_transf <- recursos %>%
      filter(nome_programa %in% lista_programa) %>%
      distinct(nome_acao) %>%
      arrange(nome_acao) %>%
      split(.$nome_acao) %>%
      map(~.$nome_acao)
    
    pickerInput(
      inputId = "acao_governo_input_municipios",
      label = "Ação:",
      choices = lista_tipo_transf,
      selected = lista_tipo_transf,
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    )
  })
  
  output$filtro_nomes_municipios <- renderUI({
    lista_municipios <- recursos %>%
      distinct(nome_municipio) %>%
      arrange(nome_municipio)
    
    # Função necessária para remover os valores "" da lista de municipios
    lista_municipios <- lista_municipios[!apply(lista_municipios == "", 1, all),]
    
    lista_municipios <- lista_municipios %>%
      split(.$nome_municipio) %>%
      map(~.$nome_municipio)
    
    pickerInput(
      inputId = "nome_municipio_input",
      label = "Selecione o Município",
      choices = lista_municipios,
      options = list(
        `none-selected-text` = "Nenhum selecionado.",
        `none-results-text` = "Nenhum resultado.",
        `select-all-text` = 'Todos',
        `deselect-all-text` = "Nenhum"
      )
    )
  })
  
  output$mapa_transferencias_municipio <- renderLeaflet(
    gerar_mapa()
  )
  
}

shinyApp(ui = ui, server = server)
