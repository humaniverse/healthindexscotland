# ---- Load packages ----
library(tidyverse)
library(httr)
library(readxl)

# ---- Get data ----
# Source: https://www.scotlandscensus.gov.uk/documents/scotland-s-census-2022-housing-chart-data/
GET(
  "https://www.scotlandscensus.gov.uk/media/ylnofgux/scotland-s-census-2022-chart-data-for-publication-housing.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

household_overcrowding_raw <- read_excel(tf, sheet = 7, skip = 4)

places_household_overcrowding <- household_overcrowding_raw |>
  mutate(year = "2022") |>
  select(
    ltla24_code = `Area code`,
    household_overcrowding_percentage = `Percentage`,
    year
  )

# ---- Save output to data/ folder ----
usethis::use_data(places_household_overcrowding, overwrite = TRUE)
