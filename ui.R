library(readr)
library(shiny)
library(rgdal)
library(leaflet)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(ggvis)
library(maps)
library(reshape2)
library(hpackedbubble)
library(DT)
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(ggiraph)
library(gganimate)
 
ui <- dashboardPage(
  dashboardHeader(title = "CHOCOLATE"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Information", tabName = "information", icon = icon("info")),
      menuItem("Percentage vs Rating", tabName = "percentageVsRating", icon = icon("dashboard")),
      menuItem("Best per year", tabName = "bestPerYear", icon = icon("chart-area")),
      menuItem("Best per Bean origin", tabName = "bestPerBeanOrigin", icon = icon("chart-bar")),
      menuItem("Best per percentage", tabName = "bestPerPercentage", icon = icon("percent")),
      menuItem("Around the world", tabName = "maps", icon = icon("earth-americas")),
      menuItem("Group members", tabName = "group", icon = icon("people-group"))
      
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName="information",
              fluidRow( 
                h2("Report"),
                p("Clicking here you can access the report."),
                p("You have to be logged in with your Google account to access it."),
                actionButton(inputId='ab2', label="Report", icon=icon("link"),
                             onclick ="window.open('https://drive.google.com/file/d/1wnrqjpHOExLj27HVdlXb4cWrkHc-Q4PP/view?usp=share_link', '_blank')"),
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
              )
      ),
      tabItem(tabName = "percentageVsRating",
              fluidRow( 
                box(
                  title = "Select the percentage range",width=3,
                  sliderInput(inputId = "percentage",
                              label = "cocoa percentage:",
                              min = min(Chocolate$cocoa_percent),
                              max = max(Chocolate$cocoa_percent),
                              value =  c(50, 60)),
                  
                ),
                box(title = "Is there a correlation between a chocolate bar's rating and cocoa percentage?", width=12, status="primary",plotOutput(outputId = "histogramOfRating", width="100%"))
              ),
              fluidRow(
                box(width=12,
                    ggvisOutput("plot2")
                )
              )
      ),
      tabItem(tabName="bestPerYear",
              fluidRow(
                
                box(
                  title=strong("top 10 chocolate bars by manufacturers over the year", 
                               plotOutput(outputId="animation"), width="100%"),
                )
              )
      ),
      tabItem(tabName ="bestPerBeanOrigin",
              fluidRow(
                box(
                  title=strong("Which bean origin has the highest average rating?"), 
                  width=12, status="primary",
                  plotOutput(outputId = "bestPerBeanOrigin")
                )
              )
      ),
      tabItem(tabName = "bestPerPercentage",
              fluidRow( 
                box(
                  title = "Choose the range of cocoa percentage that you prefer",width=3,
                  selectInput("from", 
                              label = "from",
                              choices = c("40", "50","60", "70", "80", "90", "100"),
                              selected = "40"),
                  selectInput("to", 
                              label = "to",
                              choices = c("40", "50","60", "70", "80", "90", "100"),
                              selected = "60"),
                ),
                box(title = "Best chocolate bars in the selected range", width=12, status="primary",plotOutput(outputId = "bestPerPercentage", width="100%"))
              )
      ),
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
      tabItem(tabName="group",
              fluidRow(
                h2("Group 9"),
                p("Gábor Gulácsi - gagul21@student.sdu.dk"),
                p("Jokin Lasa Escobales - jolas21@student.sdu.dk"),
                p("Zsófia Bardócz - zsbar21@student.sdu.dk"),
              )
      )
    )
  )
)