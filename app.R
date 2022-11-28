library(shiny)
library(rgdal)
library(leaflet)
library(readr)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(ggvis)
library(maps)
library(magrittr)
library(rvest)
library(reshape2)
library(ggiraph)
library(RColorBrewer)


source('ui.R', local = TRUE)
source('server.R')
source('data.r')


shinyApp(
  ui = ui,
  server = server
)