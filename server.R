source('data.r')


server <- function(input, output) {
  chocolateData <- read_csv("chocolate_bars_2.csv")

  output$RawData <- DT::renderDataTable(
    DT::datatable({
      chocolateData
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
  
  bubble_plot <- reactive({
    if(input$CircleGraph == "manufacturers"){
      hpackedbubble(company_values$company_location,Chocolate$manufacturer,company_values$count,
                    title = "CARBON EMISSIONS AROUND THE WORLD (2014)",
                    pointFormat = "<b>{point.company_location}:</b> {point.manufacturer}",
                    dataLabelsFilter = 100,
                    packedbubbleMinSize = "50%",
                    packedbubbleMaxSize = "150%",
                    theme = "sunset",
                    packedbubbleZMin = 0,
                    packedbubbleZmax = 1000, split = 1,
                    gravitational = 0.02,
                    parentNodeLimit = 1,
                    dragBetweenSeries = 0,
                    seriesInteraction = 0,
                    width = "100%")
    }
    if(input$CircleGraph == "bean origins"){
     hpackedbubble(company_values$company_location,Chocolate$manufacturer,company_values$count,
                    title = "CARBON EMISSIONS AROUND THE WORLD (2014)",
                    pointFormat = "<b>{point.bean_origin}:</b> {point.manufacturer}",
                    dataLabelsFilter = 100,
                    packedbubbleMinSize = "50%",
                    packedbubbleMaxSize = "150%",
                    theme = "sunset",
                    packedbubbleZMin = 0,
                    packedbubbleZmax = 1000, split = 1,
                    gravitational = 0.02,
                    parentNodeLimit = 1,
                    dragBetweenSeries = 0,
                    seriesInteraction = 0,
                    width = "100%")
    }
  })
  
  
  
  
  output$plot1 <- renderPlot({
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
  
  output$bubbleplot <- renderHpackedbubble({ hpackedbubble(company_manufacturers_info2$company_location,company_manufacturers_info2$manufacturer, order_company_values$count,
                                                           title = "TOP 20 COUNTRIES WITH MORE CHOCOLATE MANUFACTURERS",
                                                           pointFormat = "<b>{point.name}</b> {point.y}",
                                                           dataLabelsFilter = 1000,
                                                           packedbubbleMinSize = "20%",
                                                           packedbubbleMaxSize = "250%",
                                                           theme = "sunset",
                                                           packedbubbleZMin = 0,
                                                           packedbubbleZmax = 1000, split = 1,
                                                           gravitational = 0.02,
                                                           parentNodeLimit = 50,
                                                           dragBetweenSeries = 0,
                                                           seriesInteraction = 0,
                                                           width = "200%")}) 
  bean_origin_rating <- chocolateData %>% 
    group_by(bean_origin) %>% 
    summarise(Average_rating = mean(rating))%>%
    top_n(n = 10, wt = Average_rating) 
  
  output$plot3 <- renderPlot({
    ggplot(data = bean_origin_rating, aes(y = bean_origin, x = Average_rating, fill = bean_origin)) + 
      geom_col(color = "black") + 
      geom_text(aes(label = round(Average_rating, 2)), hjust = 1.4) +
      theme(legend.position = "none") +
      xlab("Average Rating") +
      ylab("Bean Origin")
  })
}