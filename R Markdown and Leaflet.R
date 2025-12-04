library(leaflet)
library(dplyr)
cities <- data.frame(
  city = c("New York", "London", "Tokyo", "Paris", "Sydney", "Rio de Janeiro", "Cape Town", "Dubai", "Singapore", "Toronto"),
  lat = c(40.7128, 51.5074, 35.6895, 48.8566, -33.8688, -22.9068, -33.9249, 25.2048, 1.3521, 43.6532),
  lng = c(-74.0060, -0.1278, 139.6917, 2.3522, 151.2093, -43.1729, 18.4241, 55.2708, 103.8198, -79.3832),
  population = c(8.8, 9.0, 37.4, 2.1, 5.3, 6.7, 4.7, 3.6, 5.9, 6.4),
  fun_fact = c("Home to the Statue of Liberty, a gift from France in 1886.", 
               "Big Ben is actually the nickname for the Great Bell, not the tower.", 
               "Tokyo's Shibuya Crossing is the busiest pedestrian intersection in the world.", 
               "The Eiffel Tower was meant to be temporary for the 1889 World's Fair.", 
               "Sydney Opera House's roof is made of 1,056,000 tiles.", 
               "Rio's Christ the Redeemer statue overlooks the city from Corcovado Mountain.", 
               "Table Mountain is one of the oldest mountains on Earth.", 
               "The Burj Khalifa is the tallest building in the world at 828 meters.", 
               "Singapore is known as the 'Garden City' with more trees than people.", 
               "Toronto has more than 160 ethnic origins represented in its population.")
)

# Preview the data
knitr::kable(head(cities), caption = "Sample City Data")

# Add a continent column for color coding
cities$continent <- c("North America", "Europe", "Asia", "Europe", "Oceania", "South America", 
                      "Africa", "Asia", "Asia", "North America")

# Color palette
continent_colors <- c("North America" = "blue", "Europe" = "green", "Asia" = "orange", 
                      "South America" = "purple", "Africa" = "brown", "Oceania" = "pink")

enhanced_map <- leaflet(cities) %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
  addCircleMarkers(
    lat = ~lat, lng = ~lng,
    radius = ~population / 3,
    color = ~continent_colors[continent],
    fillOpacity = 0.8,
    stroke = TRUE,
    weight = 2,
    popup = ~paste(
      "<b>", city, "</b><br/>",
      "Continent: ", continent, "<br/>",
      "Population: ", population, "M<br/>",
      "<i>", fun_fact, "</i>"
    ),
    label = ~paste(city, "-", continent),
    group = ~continent  # Group by continent for layer control
  ) %>%
  addLayersControl(
    baseGroups = c("OpenStreetMap", "Satellite"),
    overlayGroups = names(continent_colors),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  addLegend(
    "bottomleft",
    colors = continent_colors,
    labels = names(continent_colors),
    title = "Continents"
  ) %>%
  setView(lng = 0, lat = 20, zoom = 2)

enhanced_map