library(shiny)
library(tidyverse)

games <- CodeClanData::game_sales
all_genres <- sort(unique(games$genre))
all_years <- sort(unique(games$year_of_release))
all_platforms <- sort(unique(games$platform))

ui <- fluidPage(
  
  titlePanel("Game Reviews"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      checkboxGroupInput("genre_input", label = h4("Game genre"), 
                         choices = all_genres,
                         selected = 1),
      
      sliderInput("year_input", label = h4("Release year range"), min = 1988, 
                  max = 2016, value = c(1988, 2016), sep = ""),
      
      checkboxGroupInput("platform_input", label = h4("Platform"), 
                         choices = all_platforms,
                         selected = 1),
      
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Highest reviewed games", plotOutput("plot")), 
        tabPanel("Summary", verbatimTextOutput("summary")), 
        tabPanel("Table view", tableOutput("table"))
      )
    )
  )
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)