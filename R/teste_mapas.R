source("R/busca_recursos_no_bd.R")

gerar_mapa <- function(){
  anos <- c(2017,2018,2019)
  total_recursos <- recursos %>%
    filter(
      ano %in% anos,
      esfera == "Municipal",
    ) %>%
    group_by(nome_municipio, ano) %>% 
    summarise(total_transferido = sum(valor_transferido)) %>%
    arrange(nome_municipio)
  # spread(ano, total_transferido)
  
  tabela <- aggregate(tabela$total, by=list(nome_municipio = tabela$nome_municipio), FUN=sum)
  glimpse(tabela)
  # print(rowSums(total_recursos[, -1]))
  # total_recursos <- cbind(total_recursos,
  #                         total_total = rowSums(total_recursos[, -1]))
  
  # total_recursos <- total_recursos[-1, ]
  
  municipios <- readRDS("data/municipios_pb.rds")
  names(municipios)[names(municipios) == "descricao_clean"] <- "nome_municipio"
  
  municipios$nome_municipio[municipios$nome_municipio == "SAO DOMINGOS"] <- "SAO DOMINGOS DE POMBAL"
  municipios$nome_municipio[municipios$nome_municipio == "SAO VICENTE DO SERIDO"] <- "SERIDO"
  
  
  municipio_total <- left_join(
    municipios,
    total_recursos,
    by = "nome_municipio"
  )
  
  shp <- st_read("data/geojs-25-mun.json")
  names(shp)[names(shp) == "id"] <- "cod_ibge"
  
  shp_total_transf <- left_join(
    shp,
    municipio_total,
    by = "cod_ibge"
  )
  
  shp_total_transf$description <- NULL
  shp_total_transf$name <- NULL
  shp_total_transf$cod_siafi <- NULL
  
  map_breaks <- c(0, 50000, 500000, 1000000, 5000000, 10000000, 50000000,100000000,500000000, Inf)
  pal_fun <- colorBin("viridis", 
                      domain = shp_total_transf$x, 
                      bins = map_breaks, 
                      pretty = TRUE, 
                      reverse = TRUE)
  mapa_popup <- paste0(shp_total_transf$descricao,":",formata_moeda(shp_total_transf$x))
  
  labels <- sprintf(
    "<strong>%s</strong><br/>%s",
    shp_total_transf$descricao, formata_moeda(shp_total_transf$x)
  ) %>% lapply(htmltools::HTML)
  
  leaflet(shp_total_transf) %>%
    setView(
      lng = -36.8561,
      lat = -7.20791,
      zoom = 8
    ) %>%
    addPolygons(
      stroke = TRUE,
      fillColor = ~pal_fun(x),
      fillOpacity = 0.8,
      weight = 1,
      opacity = 1,
      color = "white",
      dashArray = "3",
      smoothFactor = 0.5,
      popup = mapa_popup,
      highlight =  highlightOptions(
        weight = 2,
        color = "#444444",
        dashArray = "",
        fillOpacity = 0.7,
        bringToFront = TRUE
      ),
      label = labels,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto"
      ) 
    )%>%
    addLegend(
      pal = pal_fun,
      values = ~x,
      opacity = 0.7,
      title = "Total Transferido aos Municipios",
      position = "bottomright",
      labFormat = labelFormat(prefix = "R$")
    )
  
}

