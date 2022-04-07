library(shiny)
library(tidyverse)
library(shinythemes)

whisky <- CodeClanData::whisky
all_whiskies <- unique(whisky$Distillery)

ui <- fluidPage(
  
  theme = shinytheme("united"),
  
  titlePanel(tags$h1("🤤 Scotch Whisky Profiler 🤤")),
  
  HTML("<br><br>"),
  
  plotOutput("whisky_plot"),
  
  HTML("<br>"),
  
  fluidRow(
    
    column(3, offset = 1,
           selectInput(
             "whisky_input",
             tags$h3("Pick your Whisky!"),
             choices = all_whiskies
           )
    )
  )
)

server <- function(input, output) {
  
  output$whisky_plot <- renderPlot({
    
    whisky[c(2, 7:18)] %>% 
      pivot_longer(cols = -1, 
                   names_to = "Characteristic", 
                   values_to = "Intensity") %>% 
      arrange(Characteristic) %>% 
      filter(Distillery == input$whisky_input) %>% 
      ggplot() +
      aes(x = Intensity, y = Characteristic, fill = Characteristic) +
      geom_col() +
      xlim(0, 4) +
      scale_fill_manual(values = c("Body" = "#f2a02e", 
                                   "Floral" = "#f082ff", 
                                   "Fruity" = "#ff6e88", 
                                   "Honey" = "#ffd68a", 
                                   "Malty" = "#e8b782", 
                                   "Medicinal" = "#96e3b3", 
                                   "Nutty" = "#91642c", 
                                   "Smoky" = "#383735", 
                                   "Spicy" = "#de6d0b", 
                                   "Sweetness" = "#f5ddc9", 
                                   "Tobacco" = "#50301e", 
                                   "Winey" = "#631034")) +
      labs(x = "\nIntensity") +
      theme_minimal() +
      theme(axis.text = element_text(size = 17),
            axis.title.x = element_text(size = 16),
            axis.title.y = element_text(size = 0),
            legend.position="none")
    
  })
  
}

shinyApp(ui = ui, server = server)