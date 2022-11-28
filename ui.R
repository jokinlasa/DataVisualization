library(shinydashboard)
library(ggvis)
library(hpackedbubble)
source('data.r')
 
ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th")),
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
              ))
    )
  )
)