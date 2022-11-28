library(ggplot2)
library(dplyr)
library(ggiraph)
theme_set(theme_bw())
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

source('data.r')
server <- function(input, output) {
  world <- ne_countries(scale = "medium", returnclass = "sf")
  class(world)
  
  df <- Chocolate
  df <- df %>% 
    rename(
      name = company_location
    )

  
  map_data <- merge(world, df, by = "name", all.x = TRUE)
  
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
  
  output$mapPlot1 <- renderPlot({
    ggplot(data = map_data) +
      geom_sf(aes( fill = num_ingredients)) +
      scale_fill_viridis_c(option = "plasma", trans = "sqrt") +
      xlab("Longitude") + ylab("Latitude") +
      ggtitle("World map", subtitle = paste0("(", length(unique(Chocolate$bean_origin)), " countries)"))
  })
  
  output$mapPlot2 <- renderPlot({
    ggplot(data = map_data) +
      geom_sf(aes( fill = cocoa_percent)) +
      scale_fill_viridis_c(option = "turbo", trans = "sqrt") +
      xlab("Longitude") + ylab("Latitude") +
      ggtitle("World map", subtitle = paste0("(", median(Chocolate$cocoa_percent), " median percentage)"))
  })
  
  output$mapPlot3 <- renderPlot({
    ggplot(data = map_data) +
      geom_sf(aes( fill = rating)) +
      scale_fill_viridis_c(option = "rocket", trans = "sqrt") +
      xlab("Longitude") + ylab("Latitude") +
      ggtitle("World map", subtitle = paste0("(", median(Chocolate$rating), " median rating)"))
  })
}