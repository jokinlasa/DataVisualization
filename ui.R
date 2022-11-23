
source('data.r')
 
ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
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
                              value =  c(45, 50)),
           
                ),
                 box(title = "Barplot", width=9, status="primary",plotOutput(outputId = "plot1"))
            ),
             fluidRow(
                box(
                  
                  ggvisOutput("plot2")
                )
             )
      ),
  
      #second tab content
      tabItem(tabName="widgets",
              h2("second tab"))
   
    )
  )
)