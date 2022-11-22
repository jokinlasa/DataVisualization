source('data.r')
server <- function(input, output) {
  
  data <- reactive({Chocolate %>% filter(between (cocoa_percent,input$percentage[1], input$percentage[2]))})
  
  output$plot <- renderPlot({
    ggplot(data(), aes(x=rating)) + geom_histogram()
  })
  
}