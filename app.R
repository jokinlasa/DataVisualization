library(shiny)
library(rgdal)
library(leaflet)
library(readr)
library(dplyr)
library(ggplot2)
source('ui.R', local = TRUE)
source('server.R')
source('data.r')


shinyApp(
  ui = ui,
  server = server
)