library(shinydashboard)
library(ggvis)
library(hpackedbubble)
source('data.r')
 
ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Dataset", tabName = "dataset", icon = icon("database")),
      menuItem("Group members", tabName = "group", icon = icon("people-group")),
      menuItem("Animated", tabName = "widgets", icon = icon("chart-area")),
      menuItem("Bar charts", tabName = "barchart", icon = icon("chart-bar")),
      menuItem("Maps", tabName = "maps", icon = icon("earth-americas"))
    )
  ),
  
  dashboardBody(
    tabItems(
      #first tab content
      tabItem(tabName = "dashboard",
              # Boxes need to be put in a row (or column)
              fluidRow( 
                box(
                  title = "Controls",width=3,
                  sliderInput(inputId = "percentage",
                              label = "cocoa percentage:",
                              min = min(Chocolate$cocoa_percent),
                              max = max(Chocolate$cocoa_percent),
                              value =  c(50, 60)),
           
                ),
                 box(title = "Barplot", width=12, status="primary",plotOutput(outputId = "plot1", width="100%"))
            ),
             fluidRow(
                box(width=12,
                  ggvisOutput("plot2")
                )

             )
      ),
      tabItem(tabName ="barchart",
              fluidRow(
                box(
                  title=strong("Which bean origin has the highest average rating?"), 
                  width=12, status="primary", 
                  p("In the following diagram, you can see the average ratings for the different bean origin countries.
                     Only the top 10 countries are shown, and all of them has an average rating above 3. 
                    Tobago has the highest average rating with 3.62, then it follows China and Sao Tome & Principe with 3.5."),
                  plotOutput(outputId = "plot3")
                )
              )
        
      ),
      #second tab content
      tabItem(tabName="maps",
                  fluidRow(
                      box(title = "Cocoa percentage per country", width=12, status="primary",plotOutput(outputId = "mapPlot2", width="100%"))
                    ),
                    fluidRow(
                      box(title = "Ratings per country", width=12, status="primary",plotOutput(outputId = "mapPlot3", width="100%"))
                      ),
              fluidRow(
                box(title = "Average number of ingredients used by country", width=12, status="primary",plotOutput(outputId = "mapPlot1", width="100%"))
              )
              ),
      
      tabItem(tabName="widgets",
              h2("widgets tab"),
              fluidRow(
                selectInput("CircleGraph", "Choose what you want to visualize:",
                            choices=  list("manufacturers"=1, "bean origins"=2),
                            selected=1
                ),
                hpackedbubbleOutput("bubbleplot", width = "100%", height = "800px")
              )),
      tabItem(tabName="group",
              fluidRow(
                h2("Group 9"),
                p("Gábor Gulácsi - gagul21@student.sdu.dk"),
                p("Jokin Lasa Escobales - jolas21@student.sdu.dk"),
                p("Zsófia Bardócz - zsbar21@student.sdu.dk"),
              )
      ),
      tabItem(tabName="dataset",
              fluidRow( 
                h2("Data"),
                p("We found our dataset on Kaggle, which is a really popular platform for data
                  scientists and people who are interested in machine learning. It is a great source
                  of datasets, and all of them are open-sourced."),
                p("It contains more than 2500 chocolate bars from all around the world."),
                p("Each chocolate bar is evaluated from different qualities, which can be objective
                  or subjective."),
                actionButton(inputId='ab1', label="Learn more", icon=icon("link"),
                             onclick ="window.open('https://www.kaggle.com/datasets/evangower/chocolate-bar-ratings', '_blank')"),
                h3("Properties:"),
                p("In the dataset you can see the following properties:"),
                tags$li("Manufacturer: The name of the manufacturer."),
                tags$li("Company location: The location of the manufacturer.Company location: The location of the manufacturer."),
                tags$li("Year reviewed: The year of the review."),
                tags$li("Bean origin: The country where the cocoa beans originated from."),
                tags$li("Bar name: The name of the chocolate bar."),
                tags$li("Cocoa percent: How much cocoa is in the chocolate bar."),
                tags$li("Num ingredients: The number of ingredients in the chocolate bar."),
                tags$li("Ingredients: The list of ingredients used in the chocolate bar. 
                        The ingredient can be beans (B), sugar (S), sweetener (S*), cocoa butter (C), vanilla (V), 
                        lecithin (L), and salt (Sa)."),
                tags$li("Review: A subjective opinion or summary about the chocolate bar."),
                tags$li("Rating: The rating of the chocolate bar, the value is between 1 and 5. 
                Between 4 and 5 the chocolate bar considered outstanding, between 3.5 and 3.9 it is highly recommended,
                 between 3.0 and 3.49 it is recommended, between 2.0 and 2.9 it is disappointing, 
                        under 2 it is unpleasant."),
                br(),br(),
                h3("Dataset"),
                p("In the following table you can see all the entries."),
                fluidRow(column(DT::dataTableOutput("RawData"),
                                width = 12))
              ))
    )
  )
)