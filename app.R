library(shiny)
library(rgdal)
library(leaflet)
library(readr)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(ggvis)
install.packages("hpackedbubble", build_vignettes = TRUE)
library(hpackedbubble)
library(reshape2)
library(DT)


source('ui.R', local = TRUE)
source('server.R')
source('data.r')


shinyApp(
  ui = ui,
  server = server
)