source('data.r')
server <- function(input, output) {
  
  data <- reactive({Chocolate %>% filter(between (cocoa_percent,input$percentage[1], input$percentage[2]))})
  
  output$plot1 <- renderPlot({
    ggplot(data(), aes(x=rating)) + geom_histogram()
  })
  
  vis <- (
    {
      Chocolate %>% ggvis(~cocoa_percent, ~rating, key:=~id_x ) %>%
        layer_points() %>%
        add_tooltip(cocoa_tooltip, "hover") %>%
        add_axis("x", title = "percentage") %>%
        add_axis("y", title = "rating")
      
    }
  )
  vis %>% bind_shiny("plot2")
  
}