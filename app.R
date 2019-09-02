source("R/utils.R")

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
              fluidRow(
                box(
                  h2("Recursos Federais na Paraíba", class = "text-center"),
                  img(src ='img/fundo_3.png', class = "img img-responsive"),
                  width = 12
                )
              )
      )
    )
  )
)


server <- function(input, output, session){
  
}

shinyApp(ui = ui, server = server)
