library(httr)
library(readxl)
library(dplyr)
library(stringr)
library(geographr)
library(sf)

# Lookup
lookup <-
  boundaries_ltla21 |>
  st_drop_geometry() |>
  as_tibble() |>
  filter(str_detect(ltla21_code, "^S"))

# - Recorded crime in Scotland: https://www.gov.scot/collections/recorded-crime-in-scotland/ -
# Source: https://www.gov.scot/publications/recorded-crime-scotland-2023-24/
GET(
  "https://www.gov.scot/binaries/content/documents/govscot/publications/statistics/2024/06/recorded-crime-scotland-2023-24/documents/recorded-crime-2023-24-bulletin-tables/recorded-crime-2023-24-bulletin-tables/govscot%3Adocument/recorded-crime-2023-24-bulletin-tables.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

# Table 4: Crimes and offences recorded in Scotland per 10,000 population, 2014-15 to 2023-24
crime_raw <-
  read_excel(
    tf,
    sheet = "Table_4",
    skip = 4
  )

# England's Health Index defines 'low-level crimes' as bicycle theft and shoplifting
# We only have shoplifting in Scotland. There are other crimes listed that could potentially count
# as 'low-level crimes' but we will avoid making a potentially arbitrary judgement here.
crime <-
  crime_raw |>

  filter(
    `Local Authority` != "Scotland",
    `Crime group` == "Crimes of dishonesty",
    Crime == "Shoplifting"
  ) |>

  select(
    ltla21_name = `Local Authority`,
    low_level_crimes_per_10000 = `2023-24`
  ) |>

  mutate(
    ltla21_name = case_when(
      ltla21_name == "Argyll & Bute" ~ "Argyll and Bute",
      ltla21_name == "Dumfries & Galloway" ~ "Dumfries and Galloway",
      ltla21_name == "Edinburgh, City of" ~ "City of Edinburgh",
      ltla21_name == "Perth & Kinross" ~ "Perth and Kinross",
      .default = ltla21_name
    )
  ) |>

  group_by(ltla21_name) |>
  summarise(low_level_crimes_per_10000 = sum(low_level_crimes_per_10000)) |>
  ungroup()

places_low_level_crime <-
  crime |>
  left_join(lookup, by = "ltla21_name") |>
  relocate(ltla21_code) |>
  select(-ltla21_name) |>
  mutate(year = "2023-24") |>
  rename(ltla24_code = ltla21_code)

# ---- Save output to data/ folder ----
usethis::use_data(places_low_level_crime, overwrite = TRUE)
