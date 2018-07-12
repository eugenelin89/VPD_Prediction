library(shiny)
library(leaflet)
#library(sp)
#library(rgdal)
library(caret)

shinyServer(function(input, output) {
  ##############################
  model <- readRDS("/Users/eugenelin/RStudio/DP_Proj/DDP/model_forest.rds")
  df <- read.csv("/Users/eugenelin/RStudio/DP_Proj/DDP/crime2017.csv")
  # Vancouver City Hall
  latitude = 49.2609
  longitude = -123.1139
  YEAR <- as.numeric(format(Sys.time(), "%Y"))
  MONTH <- as.numeric(format(Sys.time(), "%m"))
  DAY <- as.numeric(format(Sys.time(), "%d"))
  HOUR <- as.numeric(format(Sys.time(), "%H"))
  WEEKDAY <- weekdays(as.Date(paste(DAY, MONTH, YEAR, sep="-"),'%d-%m-%Y'))
  my_df <- data.frame(YEAR, MONTH, DAY, HOUR, longitude, latitude, WEEKDAY)
  result <- predict(model, newdata=my_df)

  rv <- reactiveValues()
  rv$latitude = 49.2609
  rv$longitude = -123.1139

  my_pred <- reactive({
    YEAR <- as.numeric(format(input$date_input, "%Y"))
    MONTH <- as.numeric(format(input$date_input, "%m"))
    DAY <- as.numeric(format(input$date_input, "%d"))
    HOUR <- input$time_input$hour
    WEEKDAY <- weekdays(as.Date(paste(DAY, MONTH, YEAR, sep="-"),'%d-%m-%Y'))
    longitude = rv$longitude
    latitude = rv$latitude
    my_df <- data.frame(YEAR, MONTH, DAY, HOUR, longitude, latitude, WEEKDAY)
    
    #YEAR <- 2017
    #MONTH <- 7
    #DAY <- 12
    #HOUR <- 13
    #WEEKDAY <- "Thursday"
    #longitude = 49.2609
    #latitude = -123.1139
    #my_df <- data.frame(YEAR, MONTH, DAY, HOUR, longitude, latitude, WEEKDAY)

    predict(model, newdata=my_df)
  })

  output$lat <- renderText({as.character(rv$latitude)})
  output$lng <- renderText({as.character(rv$longitude)})
  output$crime <- renderText({as.character(my_pred())})

  
  output$mymap <- renderLeaflet({leaflet(df) %>% 
      addTiles() %>% 
      addCircleMarkers(clusterOptions = markerClusterOptions(), popup=paste(df$TYPE), weight=1, radius = 10 ) %>%
      addMarkers(lat = 49.2609, lng = -123.1139, layerId = "foo")
  })
      
  points <- eventReactive(input$mymap_click, {
    cbind(as.numeric(input$mymap_click$lng), as.numeric(input$mymap_click$lat))
  }, ignoreNULL = FALSE)
  
  observeEvent(input$mymap_click,{
    YEAR <- as.numeric(format(input$date_input, "%Y"))
    MONTH <- as.numeric(format(input$date_input, "%m"))
    DAY <- as.numeric(format(input$date_input, "%d"))
    HOUR <- input$time_input$hour
    
    longitude <- as.numeric(input$mymap_click$lng)
    latitude <- as.numeric(input$mymap_click$lat)
    WEEKDAY <- weekdays(as.Date(paste(DAY, MONTH, YEAR, sep="-"),'%d-%m-%Y'))
    my_df <- data.frame(YEAR, MONTH, DAY, HOUR, longitude, latitude, WEEKDAY)
    result <- predict(model, newdata=my_df)

    leafletProxy("mymap")  %>% addMarkers(lat = latitude, lng = longitude, layerId = "foo")
    rv$latitude = latitude
    rv$longitude = longitude
  })
  
})

