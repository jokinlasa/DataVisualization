library(ggplot2)
library(dplyr)
library(ggiraph)
theme_set(theme_bw())
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

server <- function(input, output) {
  world <- ne_countries(scale = "medium", returnclass = "sf")
  class(world)
  
  df <- Chocolate
  df <- df %>% 
    rename(
      name = company_location
    )

  map_data <- merge(world, df, by = "name", all.x = TRUE)

  output$RawData <- DT::renderDataTable(
    DT::datatable({
      Chocolate
    },
    options = list(lengthMenu=list(c(5,15,20),c('5','15','20')),pageLength=10,
                   initComplete = JS(
                     "function(settings, json) {",
                     "$(this.api().table().header()).css({'background-color': 'moccasin', 'color': '1c1b1b'});",
                     "}"),
                   columnDefs=list(list(className='dt-center',targets="_all"))
    ),
    filter = "top",
    selection = 'multiple',
    style = 'bootstrap',
    class = 'cell-border stripe',
    rownames = FALSE,
    colnames = c("Id","Manufacturer","Company location","Year reviewed","Bean origin","Bar name","Cocoa percent","Number of ingredients","Ingredients","Review", "Rating", 'Id x')
    ))
  
  data <- reactive({Chocolate %>% filter(between (cocoa_percent,input$percentage[1], input$percentage[2]))})
  
  output$histogramOfRating <- renderPlot({
    ggplot(data(), aes(x=rating)) + geom_histogram()
  })
  
  vis <- (
    {
      Chocolate %>% ggvis(~cocoa_percent, ~rating, key:=~id_x ) %>%
        set_options(height = 480, width = 1000) %>%
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

  bean_origin_rating <- Chocolate %>% 
    group_by(bean_origin) %>% 
    summarise(Average_rating = mean(rating))%>%
    top_n(n = 10, wt = Average_rating)
  
  output$bestPerBeanOrigin <- renderPlot({
    ggplot(data = bean_origin_rating, aes(y = reorder(bean_origin, Average_rating), x = Average_rating, fill = bean_origin)) + 
      geom_col(color = "black") + 
      geom_text(aes(label = round(Average_rating, 2)), hjust = 1.4) +
      theme(legend.position = "none") +
      xlab("Average Rating") +
      ylab("Bean Origin")
  })

  top5_chocolate <- reactive({Chocolate %>% 
    filter(between (Chocolate$cocoa_percent, input$from, input$to))%>%
    summarise(rating = rating, bar_name = bar_name, cocoa_percent = cocoa_percent)%>%
    top_n(n = 10, wt = rating)})
  
  output$bestPerPercentage <- renderPlot({
    ggplot(data = subset(head(top5_chocolate(), 5)), aes(x=rating, y=reorder(bar_name,rating) , fill = bar_name)) +
      geom_col(color = "black") +
      geom_text(aes(label = rating), hjust = 1.4) +
      theme(legend.position = "none") +
      xlab("Rating") +
      ylab("Chocolate bar name") 
  })
  
  miscompanas_top10 <- Chocolate %>%
    group_by(year_reviewed) %>%
    mutate(rank=order(-rating)*1) %>%
    filter(rank <=10) %>%
    ungroup()
  
  
  output$animation<- renderImage({
    
    outfile <- tempfile(fileext='.gif')
    
    myplotanim <- ggplot(miscompanas_top10, aes(rank, group=manufacturer,
                                                fill=as.factor(manufacturer), color=as.factor(manufacturer)))+
      geom_tile(aes(y=rating/2,
                    height=rating,
                    width=0.9), alpha=0.8, color=NA) +
      geom_text(aes(y=0, label=paste(manufacturer," ")), vjust=0.2, hjust=1) +
      coord_flip(clip="off", expand=FALSE) +
      scale_y_continuous(labels=scales::comma)+
      scale_x_reverse()+
      guides(color=FALSE, fill=FALSE)+
      
      labs(title='{closest_state}', x="manufacturer", y="rating")+
      theme(plot.title = element_text(hjust = 0, size = 10),
            axis.ticks.y = element_blank(),  # These relate to the axes post-flip
            axis.text.y  = element_blank(),  # These relate to the axes post-flip
            plot.margin = margin(1,1,1,1, "cm"))+
      
      transition_states(year_reviewed, transition_length = 4, state_length = 1)+
      exit_fly(x_loc = 0, y_loc = 0) +         # chart exit animation params
      enter_fly(x_loc = 0, y_loc = 0)
    
    anim_save("mygif.gif", animate(myplotanim, fps=10, duration=40, width=650, height=500))
    
    list(src = "mygif.gif",
         contentType = 'image/gif'
    )
  })
}