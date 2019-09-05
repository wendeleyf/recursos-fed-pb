source("R/utils.R")
source("R/busca_recursos_no_bd.R")

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
              source(file = "pages/transferencias_gerais.R", encoding = "UTF-8")[1])
    )
  )
)


server <- function(input, output, session){
  
  output$filtro_funcao <- renderUI({
    lista_funcao <- recursos %>%
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

  output$filtro_tipo_transferencia <- renderUI({
    
  })
  
  output$tabela_transferencias_geral <- DT::renderDataTable({
    lista_funcao <- input$funcao_governo_input
    lista_programa <- input$programa_governo_input
    lista_acao <- input$acao_governo_input
    anos <- input$ano_input[1]:input$ano_input[2]
    ente <- input$ente_input
    categoria <- input$categoria_input
    tabela <- recursos %>%
      filter(
        nome_funcao %in% lista_funcao,
        nome_programa %in% lista_programa,
        nome_acao %in% lista_acao,
        ano %in% anos,
        esfera == ente,
        tipo_transferencia %in% categoria
      )
    
    DT::datatable(
      data = tabela,
      class = "compact stripe",
      extensions = "Responsive",
      rownames = FALSE,
      selection = "none",
      options = list(language = list(url = 'linguagens/Portuguese-Brasil.json'))
    )
  })
}

shinyApp(ui = ui, server = server)
