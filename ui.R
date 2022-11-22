library(shiny)
library(rgdal)
library(leaflet)
library(readr)
library(dplyr)
library(ggplot2)
source('data.r')
 
ui <- fluidPage(navbarPage(
  "Chocolate",
  tabPanel("Rating",
           sidebarPanel(
             sliderInput(inputId = "percentage",
                         label = "cocoa percentage:",
                         min = min(Chocolate$cocoa_percent),
                         max = max(Chocolate$cocoa_percent),
                         value =  c(45, 50))
           ), # sidebarPanel
           mainPanel(
             plotOutput(outputId = "plot")
             
           ) # mainPanel
           
  ), # Navbar 1, tabPanel
  tabPanel("Location"),
  tabPanel("ingredients", "This panel is intentionally left blank")
  
)
) # fluidPage