library(tidyverse)
library(geographr)

# Source: https://www.diabetesinscotland.org.uk/wp-content/uploads/2023/10/Scottish-Diabetes-Survey-2022.pdf
# pg. 36, use the crude prevelance
diabetes_hb <- tribble(
  ~hb19_name, ~diabetes_percent,
  "Orkney", 5.9,
  "Shetland", 5.4,
  "Borders", 6.4,
  "Western Isles", 6.5,
  "Highland", 6.4,
  "Grampian", 5.6,
  "Tayside", 6.1,
  "Lothian", 5.3,
  "Dumfries and Galloway", 7.2,
  "Fife", 6.6,
  "Forth Valley", 6.6,
  "Ayrshire and Arran", 7.3,
  "Greater Glasgow and Clyde", 6.0,
  "Lanarkshire", 6.9
)

hb_ltla_lookup <- lookup_dz11_ltla19_hb19 |>
  distinct(ltla19_code, hb19_code)

hb_lookup <- boundaries_hb19 |>
  sf::st_drop_geometry()

people_diabetes <-
  diabetes_hb |>
  left_join(hb_lookup) |>
  left_join(hb_ltla_lookup) |>
  select(ltla24_code = ltla19_code, diabetes_percent)

usethis::use_data(people_diabetes, overwrite = TRUE)
