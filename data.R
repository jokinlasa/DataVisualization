library(readr)

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
