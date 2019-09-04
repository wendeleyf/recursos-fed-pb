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
      arrange(nome_funcao)
    
    lista_funcao %>%
      split(.$nome_funcao) %>%
      map(~.$nome_funcao)
  
  pickerInput(
    inputId = "funcao_governo_input",
    label = "Função do governo: ",
    choices = lista_funcao,
    options = list(
      `actions-box` = TRUE,
      `none-selected-text` = "Nenhum selecionado.",
      `none-results-text` = "Nenhum resultado.",
      `select-all-text` = 'Todos',
      `deselect-all-text` = "Nenhum"
  )
  )
})
}

shinyApp(ui = ui, server = server)
