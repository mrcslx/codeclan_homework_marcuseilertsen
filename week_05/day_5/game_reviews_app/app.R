library(shiny)
library(tidyverse)
library(DT)

games <- CodeClanData::game_sales
all_genres <- sort(unique(games$genre))
all_years <- sort(unique(games$year_of_release))
all_platforms <- sort(unique(games$platform))

ui <- fluidPage(
  
  titlePanel(h1("💩🕹 Turd Finder 3000 🕹💩")),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("platform_input", label = h4("Platform"), 
                  choices = all_platforms),
      
      checkboxGroupInput("genre_input", label = h4("Game genre"), 
                         choices = all_genres,
                         selected = all_genres),
      
      sliderInput("year_input", label = h4("Release year range"), min = 1988, 
                  max = 2016, value = c(1988, 2016), sep = "")
      
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Worst reviewed games", 
                 HTML("<br>"),
                 plotOutput("critic_ratings_plot"), 
                 HTML("<br><br>"),
                 plotOutput("user_ratings_plot")), 
        tabPanel("Summary", verbatimTextOutput("summary")), 
        tabPanel("Table view", tableOutput("table"))
      )
    )
  )
)

server <- function(input, output) {
  
  output$critic_ratings_plot <- renderPlot({
    
    games %>% 
      filter(genre %in% input$genre_input, 
             year_of_release %in% seq(input$year_input[1], input$year_input[2], by = 1), 
             platform == input$platform_input) %>% 
      select(name, critic_score) %>% 
      arrange(desc(critic_score)) %>% 
      tail(10) %>% 
      ggplot() +
      aes(x = critic_score, y = reorder(name, critic_score)) +
      geom_col(fill = "burlywood3") +
      geom_text(aes(label = critic_score), hjust = 1.5) +
      labs(x = "Critic score",
           y = "Game title",
           title = "Worst games by critic score") +
      theme(axis.text = element_text(size = 11),
            axis.title.x = element_text(size = 14),
            axis.title.y = element_text(size = 0))
    
  })
  
  
  output$user_ratings_plot <- renderPlot({
    
    games %>% 
      filter(genre %in% input$genre_input, 
             year_of_release %in% seq(input$year_input[1], input$year_input[2], by = 1), 
             platform == input$platform_input) %>% 
      select(name, user_score) %>% 
      arrange(desc(user_score)) %>% 
      tail(10) %>% 
      ggplot() +
      aes(x = user_score, y = reorder(name, user_score)) +
      geom_col(fill = "lightgoldenrod3") +
      geom_text(aes(label = user_score), hjust = 1.5) +
      labs(x = "User score",
           y = "Game title",
           title = "Worst games by user score") +
      theme(axis.text = element_text(size = 11),
            axis.title.x = element_text(size = 14),
            axis.title.y = element_text(size = 0))
    
  })
  
}

shinyApp(ui = ui, server = server)