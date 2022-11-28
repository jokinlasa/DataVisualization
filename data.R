library(readr)
library(shiny)
library(rgdal)
library(leaflet)
library(readr)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(ggvis)
library(hpackedbubble)
library(reshape2)
library(DT)

Chocolate <- read_csv("chocolate_bars_2.csv")
Chocolate$company_location[Chocolate$company_location == "U.S.A."] <- "United States"
Chocolate$company_location[Chocolate$company_location == "U.K."] <- "United Kingdom"  

# Function for generating tooltip text
cocoa_tooltip <- function(x) {
  if (is.null(x)) return(NULL)
  if (is.null(x$id)) return(NULL)
  
  # Pick out the movie with this ID
  bar<- Chocolate[Chocolate$id_x == x$id_x, ]
  
  paste0("<b> Bar name: ", bar$bar_name, "</b><br> manufacturer:",
         bar$manufacturer, "<br> bean origin: ",
         bar$bean_origin
  )
}

company_countries <- unique(Chocolate$company_location)

company_manufacturers <- Chocolate %>% group_by(company_location, manufacturer) 

company_manufacturers_info <-  company_manufacturers[2:3]
manufacturers <- unique(company_manufacturers[2])
company_manufacturers_info2 <- company_manufacturers_info %>% distinct(manufacturer, .keep_all = TRUE)





w <- merge(x = company_manufacturers_info, y = manufacturers, by = "manufacturer")

company_values <- Chocolate %>% group_by(company_location) %>% summarise(count=n_distinct(manufacturer))
order_company_values <- company_values %>%
                        as.data.frame() %>%
                        arrange(desc(count))



x<-dcast(order_company_values,count~company_location[1:20])


ingredients <- Chocolate$ingredients

#filter year = 2017
choco_2017 <- Chocolate[Chocolate$year_reviewed == 2017, ]

#get the average of rating based on company and company location in 2017
best_choco_2017 <- aggregate(rating ~ manufacturer + company_location, data = choco_2017, FUN = mean)
best_choco_2017_order <- best_choco_2017[order(-best_choco_2017$rating),]

best_choco_top_20 <- best_choco_2017_order[1:20,]

ggplot(best_choco_top_20, aes(y = reorder(manufacturer, rating),x  = rating, fill = company_location)) +
  geom_col() +
  geom_text(aes(label = round(rating,2), hjust = 1.4)) +
  labs(x = "Rating", y = "Company", title = "Best Chocolate Company in 2017") +
  theme_minimal()

years <- Chocolate$year_reviewed
