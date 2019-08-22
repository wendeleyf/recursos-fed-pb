library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(
    title = "RECURSOS-PB",
    titleWidth = 250
  ),
  
  dashboardSidebar(
    width = 250
  ),
  dashboardBody()
)


server <- function(input, output, session){
  
}

shinyApp(ui = ui, server = server)
