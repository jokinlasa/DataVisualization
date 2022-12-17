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
theme_set(theme_bw())

Chocolate <- read_csv("chocolate_bars_2.csv")

shinyApp(
  ui = ui,
  server = server
)