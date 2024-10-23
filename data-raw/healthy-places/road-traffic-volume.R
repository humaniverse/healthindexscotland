library(dplyr)
library(readr)
library(stringr)
library(geographr)
library(sf)

# Lookup LAD names and LAD Codes
# lookup <-
#   boundaries_ltla21 |>
#   as_tibble() |>
#   select(-geometry) |>
#   filter(str_detect(ltla21_code, "^S"))

# Retrieve LAD area sizes KM^2
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

# Retrieve traffic data
# Source: https://roadtraffic.dft.gov.uk/downloads
traffic_raw <-
  read_csv("https://storage.googleapis.com/dft-statistics/road-traffic/downloads/data-gov-uk/local_authority_traffic.csv")

traffic <-
  traffic_raw |>
  filter(year == max(year)) |>
  filter(str_detect(local_authority_code, "^S")) |>
  select(
    ltla21_code = local_authority_code,
    vehicle_km_annual = all_motor_vehicles
  ) |>
  mutate(vehicle_km_millions = vehicle_km_annual / 1e+06) |>
  select(-vehicle_km_annual)
  # mutate(
  #   lad_name = case_when(
  #     lad_name == "Dumfries & Galloway" ~ "Dumfries and Galloway",
  #     lad_name == "" ~ "Na h-Eileanan Siar",
  #     lad_name == "Argyll & Bute" ~ "Argyll and Bute",
  #     lad_name == "Perth & Kinross" ~ "Perth and Kinross",
  #     TRUE ~ lad_name
  #   )
  # )

# Join lookup to traffic data
# traffic <-
#   lookup |>
#   left_join(traffic, by = "ltla21_code") |>
#   select(-ltla21_name)

# Impute missing data
# Source: https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/healthandwellbeing/methodologies/methodsusedtodevelopthehealthindexforengland2015to2018
# Reason for missing: not specified
# Strategy: match Na h-Eileanan Siar (S12000013) vehicle_km_billions
#           to Shetland Islands (S12000027) and Orkney Islands (S12000023)
#           as they share a similar population size (~25,000), and presumably
#           similar driving patterns
# shetland_orkney_traffic <-
#   traffic |>
#   filter(
#     ltla21_code == "S12000027" |
#       ltla21_code == "S12000023"
#   ) |>
#   pull(vehicle_km_billions) |>
#   mean()
#
# traffic <-
#   traffic |>
#   mutate(
#     vehicle_km_billions = if_else(
#       lad_code == "S12000013",
#       shetland_orkney_traffic,
#       vehicle_km_billions
#     )
#   )

# Normalise traffic volume by land area (Km^2)
places_traffic_volume <-
  traffic |>
  left_join(areas, by = "ltla21_code") |>
  mutate(traffic_volume = vehicle_km_millions / area_km_squared) |>
  select(
    ltla24_code = ltla21_code,
    traffic_volume) |>
  mutate(year = 2023 )

# ---- Save output to data/ folder ----
usethis::use_data(places_traffic_volume, overwrite = TRUE)
