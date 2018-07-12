library(shiny)
library(shinyTime)
library(leaflet)

shinyUI(fluidPage(
  titlePanel("Predict what crime will you experinece in City of Vancouver"),
  sidebarLayout(
    sidebarPanel(
      dateInput("date_input", "Enter Date", value = NULL, min = NULL, max = NULL,
                format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                language = "en", width = NULL, autoclose = TRUE),
      timeInput("time_input", "Enter time", value = Sys.time())
    ),
    mainPanel(

      
      
      leafletOutput("mymap"),
      p(),
      textOutput("lat"),
      p(),
      textOutput("lng"),
      p(),
      textOutput("crime"),
      p(),
      textOutput("debug")

    )
  )
))