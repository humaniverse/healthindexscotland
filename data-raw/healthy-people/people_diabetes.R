# ---- Load packages ----
library(tidyverse)
library(geographr)

# Source: https://www.diabetesinscotland.org.uk/wp-content/uploads/2023/10/Scottish-Diabetes-Survey-2022.pdf
# pg. 36, use the crude prevelance
diabetes_hb <- tribble(
  ~hb19_name, ~diabetes_percent, ~year,
  "Orkney", 5.9, 2022,
  "Shetland", 5.4, 2022,
  "Borders", 6.4, 2022,
  "Western Isles", 6.5, 2022,
  "Highland", 6.4, 2022,
  "Grampian", 5.6, 2022,
  "Tayside", 6.1, 2022,
  "Lothian", 5.3, 2022,
  "Dumfries and Galloway", 7.2, 2022,
  "Fife", 6.6, 2022,
  "Forth Valley", 6.6, 2022,
  "Ayrshire and Arran", 7.3, 2022,
  "Greater Glasgow and Clyde", 6.0, 2022,
  "Lanarkshire", 6.9, 2022
)

hb_ltla_lookup <- lookup_dz11_ltla19_hb19 |>
  distinct(ltla19_code, hb19_code)

hb_lookup <- boundaries_hb19 |>
  sf::st_drop_geometry()

people_diabetes <-
  diabetes_hb |>
  left_join(hb_lookup) |>
  left_join(hb_ltla_lookup) |>
  select(ltla24_code = ltla19_code, diabetes_percent, year)

people_diabetes <- people_diabetes |>
  mutate(domain = "people") |>
  mutate(subdomain = "physical health conditions") |>
  mutate(is_higher_better = FALSE)


# ---- Save output to data/ folder ----
usethis::use_data(people_diabetes, overwrite = TRUE)
