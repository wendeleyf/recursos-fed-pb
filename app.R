source("R/utils.R")
source("R/busca_recursos_no_bd.R")
source("R/processamento_pagamentos.R")
#source("R/busca_empenhos_no_bd.R", encoding = "UTF-8")
source("R/busca_pagamentos_no_bd.R", encoding = "UTF-8")
source("mapas/mapa_total_transferencia_municipios.R")
source("mapas/mapa_total_educacao_geral.R")

#source("R/processar_graficos.R")

ui <- dashboardPage(
  dashboardHeader(
    title = "ASG",
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
          menuItem(
            text = "Educação",
            icon = icon("book"),
            menuSubItem(
              tabName = "rastreamento_educacao_geral",
              text = "Visão Geral",
              icon = icon("eye")
            ),
            menuSubItem(
              tabName = "rastreamento_educacao_individual",
              text = "Visão Individual",
              icon = icon("eye")
            ),
            menuSubItem(
              tabName = "rastreamento_educacao_fornecedores",
              text = "Visão Fornecedores",
              icon = icon("eye")
            )
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
              source(file = "pages/transferencias_municipais.R", encoding = "UTF-8")[1]),
      tabItem(tabName = "rastreamento_educacao_individual",
              source(file = "pages/rastreamento_educacao.R", encoding = "UTF-8")[1]),
      tabItem(tabName = "rastreamento_educacao_geral",
              source(file = "pages/rastreamento_educacao_geral.R", encoding = "UTF-8")[1])
    )
  )
)


server <- function(input, output, session){
  
  # Transferências Gerais
  
  # Reactive: data.frame reativo que atualiza sempre que os inputs da aplicação são selecionados,
  # necessário para todas as operações que envolvem a atualização dos no painel
  filter_data <- reactive({
    lista_funcao <- input$funcao_governo_input
    lista_programa <- input$programa_governo_input
    lista_acao <- input$acao_governo_input
    anos <- input$ano_input[1]:input$ano_input[2]
    tipo <- input$tipo_input
    ente <- input$ente_input
    categoria <- input$categoria_input
    recursos %>%
      filter(
        nome_funcao %in% lista_funcao,
        nome_programa %in% lista_programa,
        nome_acao %in% lista_acao,
        ano %in% anos,
        linguagem_cidada %in% tipo,
        esfera == ente,
        tipo_transferencia %in% categoria
      )
  })
  
  # Output: Filtro de Picker Input dinâmico com os tipos de transferências ---
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
  
  # Output: Filtro de Picker Input dinâmico com as funções do governo ---
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
  
  # Output: Filtro de Picker Input dinâmico com os programas do governo ---
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
  
  # Output: Filtro de Picker Input dinâmico com as ações do governo ---
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
  
  # Output: data.frame para construção de tabela com os valores das transferências gerais ao município da Paraiba
  output$tabela_transferencias_geral <- DT::renderDataTable({
    source("tabelas/tabela_tipo_recurso.R",local = TRUE, encoding = "UTF-8")

  })

  # Output: gráfico com os valores de transferência gerais ao município da Paraíba
  output$grafico_transferencias_geral <- renderPlotly({
    source("graficos/grafico_tipo_recurso.R", local = TRUE, encoding = "UTF-8")

    })
  
 # Output: data.frame com os valores das transferências gerais categorizadas por função
  output$tabela_transferencias_funcao <- DT::renderDataTable({
    source("tabelas/tabela_tipo_funcao.R",local = TRUE, encoding = "UTF-8")
    
  })
  
  # Output: gráfico com os valores de transferência gerais categorizadas por função
  output$grafico_transferencias_funcao <- renderPlotly({
    source("graficos/grafico_tipo_funcao.R", local = TRUE, encoding = "UTF-8")
    
  })
  
# ============================================================================
  
  # Transferências Municipais
  
  # Reactive: data.frame reativo que atualiza sempre que os inputs da aplicação são selecionados,
  # necessário para todas as operações que envolvem a atualização dos dados referentes à visão municipal nos painéis.
  filter_data_municipio <- reactive({
    lista_funcao <- input$funcao_governo_input_municipios
    lista_programa <- input$programa_governo_input_municipios
    lista_acao <- input$acao_governo_input_municipios
    anos <- input$ano_input_municipios[1]:input$ano_input_municipios[2]
    tipo <- input$tipo_input_municipios
    categoria <- input$categoria_input_municipios
    
    tabela <- recursos %>%
      filter(
        nome_funcao %in% lista_funcao,
        nome_programa %in% lista_programa,
        nome_acao %in% lista_acao,
        ano %in% anos,
        linguagem_cidada %in% tipo,
        esfera == "Municipal",
        tipo_transferencia %in% categoria
      )  
  })
  
  # Output: Filtro de Picker Input dinâmico com os tipos de transferências municipais ---
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
  
  # Output: Filtro de Picker Input dinâmico as funções do governo municipais---
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
  
  # Output: Filtro de Picker Input dinâmico com os programas do governo municipais ---
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
  
  # Output: Filtro de Picker Input dinâmico com as ações do governo municipais ---
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
  
  # Output: Mapa Leaflet com o total das transferências aos municípios da Paraíba---
  output$mapa_transferencias_municipio <- renderLeaflet({
    input_anos <- input$ano_input_municipios
    input_funcao <- input$funcao_governo_input_municipios
    input_programa <- input$programa_governo_input_municipios
    input_acao <- input$acao_governo_input_municipios
    input_tipo <- input$tipo_input_municipios
    input_categoria <- input$categoria_input_municipios
    gerar_mapa(
      input_anos,
      input_funcao,
      input_programa,
      input_acao,
      input_tipo,
      input_categoria
    )
  }
  )
  
  # Output: data.frame com os valores dos 10 municípios que menos receberam transferências na Paraíba ---
  output$tabela_bottom_total_transferido <- DT::renderDataTable({
    tabela <- filter_data_municipio()%>%
      group_by(nome_municipio, ano) %>%
      summarise(total = sum(valor_transferido))%>%
      spread(ano, total)
    tabela[is.na(tabela)] <- 0
    tabela <- cbind(tabela,
                    total_total = rowSums(tabela[, -1]))
    tabela <- tabela %>%
      arrange(total_total)
    
    tabela <- head(tabela, 10)
    
    nomes <- colnames(tabela)
    DT::datatable(
      data = tabela,
      class = "compact stripe",
      extensions = "Responsive",
      rownames = FALSE,
      selection = "none",
      options = list(language = list(url = 'linguagens/Portuguese-Brasil.json'),
                     paging = FALSE,
                     searching = FALSE) 
    ) %>% 
      formatCurrency(
        columns = nomes,
        currency = "R$",
        digits = 2,
        mark = ".",
        dec.mark = ","
      )
  })
  
  # Output: Filtro de Picker Input dinâmico com os municípios da Paraíba ---
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
  
  # Output: data.frame com os valores de total dos municípios utilizados no mapa Leaflet---
  output$tabela_total_mapa <- DT::renderDataTable({
    source("tabelas/tabela_total_mapa.R", local = TRUE, encoding = "UTF-8")
  })
  # Output: Grafico com os valores de transferencias por municipio selecionado
  output$grafico_categoria_municipio <- renderPlotly({
    municipio <- input$nome_municipio_input
    source("graficos/grafico_categoria_municipio.R",local = TRUE, encoding = "UTF-8")
    
  })
  
  # Output: data.frame com os valores de total dos municípios utilizados no grafico categoria municipio---
  output$tabela_categoria_municipio <- DT::renderDataTable({
    
    source("tabelas/tabela_categoria_municipio.R",local = TRUE,encoding = "UTF-8")
   
  })
  
  # Output: treemap com os valores de total por tipo municipio
  output$treemap_tipo_municipio <- renderD3tree2({
    
    source("graficos/treemap_tipo_transf_municipio.R",local = TRUE,encoding = "UTF-8")
    })
  
  # Output: grafico com os valores de total por programa
  output$grafico_programa_municipio <- renderPlot({

    source("graficos/grafico_programa_municipio.R",local = TRUE,encoding = "UTF-8")
  })
  
  
  # ============================================================================
  
  # Rastreamento Município - Educação Geral
  
  
  
  
  output$mapa_total_educacao_geral <- renderLeaflet({
    funcao <- "Educação"
    gerar_mapa_total_educacao(funcao)
  })
  
  output$tabela_top20_fornecedores <- DT::renderDataTable({
    source("tabelas/tabela_top20_fornecedores.R", local = TRUE, encoding = "UTF-8")
    
  })
  
  output$tabela_programas_educacao_geral <- DT::renderDataTable({
    source("tabelas/tabela_programas_educacao_geral.R", local = TRUE, encoding = "UTF-8")
    
  })
  
  # Output: 
  output$grafico_aplicado_educacao_geral <- renderPlotly({
    source("graficos/grafico_aplicado_educacao_geral.R", local = TRUE, encoding = "UTF-8")
    
  })
  
  # Output: treemap com os maiores fornecedores da educação
  output$fornecedores_educacao <- renderPlotly({
    
    source("graficos/fornecedores_educacao.R",local = TRUE,encoding = "UTF-8")
  })
  
  # Output: 
  output$grafico_fonte_recurso_educacao_geral <- renderPlotly({
    source("graficos/grafico_fonte_recurso_educacao_geral.R", local = TRUE, encoding = "UTF-8")
    
  })
  
  # ============================================================================
  
  # Rastremanto Munícipio - Educação Individual
  # Output: Filtro de Picker Input dinâmico com os municípios da Paraíba ---
  output$filtro_nomes_rastreamento <- renderUI({
    lista_municipios <- recursos %>%
      distinct(nome_municipio) %>%
      arrange(nome_municipio)
    
    # Função necessária para remover os valores "" da lista de municipios
    lista_municipios <- lista_municipios[!apply(lista_municipios == "", 1, all),]
    
    lista_municipios <- lista_municipios %>%
      split(.$nome_municipio) %>%
      map(~.$nome_municipio)
    
    pickerInput(
      inputId = "nome_municipio_rastreamento",
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
  
  # Output: 
  output$grafico_aplicado_educacao <- renderPlotly({
    source("graficos/grafico_aplicado_educacao.R", local = TRUE, encoding = "UTF-8")
    
  })
  
  # Output: 
  output$grafico_fonte_recurso_educacao <- renderPlotly({
    source("graficos/grafico_fonte_recurso_educacao.R", local = TRUE, encoding = "UTF-8")
    
  })
  
  
  
  
  

  
}

shinyApp(ui = ui, server = server)
