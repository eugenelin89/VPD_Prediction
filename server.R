library(shiny)
library(leaflet)
#library(sp)
#library(rgdal)
library(caret)
shinyServer(function(input, output) {
  ##############################
  model <- readRDS("/Users/eugenelin/RStudio/DP_Proj/DDP/model_forest.rds")
  df <- read.csv("/Users/eugenelin/RStudio/DP_Proj/DDP/crime2017.csv")
  output$mymap <- renderLeaflet({leaflet(df) %>% 
      addTiles() %>%
      addCircleMarkers(clusterOptions = markerClusterOptions(), popup=paste(df$TYPE), weight=1, radius = 10 ) 
  })
      

  
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
    output$lat <- renderText(as.character(input$mymap_click$lat))
    output$lng <- renderText(as.character(input$mymap_click$lng))
    output$crime <- renderText(as.character(result))
    #addMarkers(output$mymap, lng = longitude, lat = latitude)
  })
  
})
  
  
