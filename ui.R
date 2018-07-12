library(shiny)
library(shinyTime)
library(leaflet)

shinyUI(fluidPage(
  titlePanel("What crime will you experinece in City of Vancouver"),
  
  tags$ul(
    tags$li("Click on the map somewhere in the City of Vancouver, specify a date and a time, the app will predict what crime you are likely to encounter at the specified location at the time of the day."), 
    tags$li("The map also displays location of all reported crimes in the City of Vancouver in 2017. Click on the circle on the map to explore."), 
    tags$li("The app builds on data provided by the Vancouver Police Department thru ",tags$a(href="https://data.vancouver.ca/datacatalogue/crime-data.htm", "City of Vancouver's Open Data portal"),"."),
    tags$li("We partitioned the data into 75% training and 25% validation set. Training is peformed on the training set using Random Forest, with k-fold cross-validation where k=5."),
    tags$li("Due to privacy concern, certain types of crime are not included in the data."),
    tags$li("Source code can be found on",tags$a(href="https://github.com/eugenelin89/VPD_Prediction", "Github"),".")
  ),
  
  sidebarLayout(
    sidebarPanel(
      

      
      dateInput("date_input", "Enter Date", value = NULL, min = NULL, max = NULL,
                format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                language = "en", width = NULL, autoclose = TRUE),
      timeInput("time_input", "Enter time", value = Sys.time())
    ),
    mainPanel(

      h4("Map may take a moment to load. Thank you for your patience!"),
      p(),
      leafletOutput("mymap"),
      p(),
      h4(textOutput("lat")),
      h4(textOutput("lng")),
      h3(textOutput("crime")),
      p(),
      textOutput("debug")

    )
  )
))