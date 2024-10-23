library(dplyr)
library(readr)
library(stringr)
library(sf)

# - Road safety data -
# Source: https://statistics.gov.scot/data/road-safety
road_safety_raw <- read_csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Froad-safety")

road_safety <-
  road_safety_raw |>
  filter(
    FeatureType == "Council Area",
    DateCode == max(DateCode),
    Gender == "All",
    Age == "All",
    Outcome == "Killed Or Seriously Injured"
  ) |>
  select(
    ltla21_code = FeatureCode,
    accident_count = Value
  )

# - Local Authority area -
# Source: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2021-boundaries-uk-bgc/about
# A custom query URL has been set by selecting only 'lad21cd' & 'Shape__Area' from
# 'Out Fields' in 'Query' and selecting 'Return Geometry' to 'False' in 'Output Options'
areas <-
  read_sf("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2021_UK_BGC_2022/FeatureServer/0/query?where=1%3D1&outFields=LAD21CD,Shape__Area&returnGeometry=false&outSR=4326&f=json")

areas <-
  areas |>
  st_drop_geometry() |>
  select(
    ltla21_code = LAD21CD,
    area_m_squared = Shape__Area
  ) |>
  filter(str_detect(ltla21_code, "^S")) |>
  mutate(area_km_squared = area_m_squared / 1000^2) |>
  select(-area_m_squared)

# - Normalise accident count by land area -
places_road_safety <-
  road_safety |>
  left_join(areas, by = "ltla21_code") |>
  mutate(road_accident_count_by_area = accident_count / area_km_squared) |>
  select(
    ltla24_code = ltla21_code,
    road_accident_count_by_area) |>
  mutate(year = 2022)

# ---- Save output to data/ folder ----
usethis::use_data(places_road_safety, overwrite = TRUE)
