library(shiny)
library(rgdal)
library(leaflet)
library(readr)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(ggvis)
library(maps)
library(reshape2)
install.packages("hpackedbubble", build_vignettes = TRUE)
library(hpackedbubble)
library(DT)


source('ui.R', local = TRUE)
source('server.R')
source('data.r')


shinyApp(
  ui = ui,
  server = server
)