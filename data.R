Chocolate <- read_csv("chocolate_bars_2.csv")

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

company_values <- Chocolate %>% group_by(company_location) %>% summarise(count=n_distinct(manufacturer))
order_company_values <- company_values %>%
                        as.data.frame() %>%
                        arrange(desc(count))
