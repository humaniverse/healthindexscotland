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

# England's Health Index defines 'personal crimes' as:
# - violence against the person
# - sexual offences
# - robbery
# - theft
# - criminal damage
# - arson
#
# We don't have the exact same categories for Scotland but have chosen:
# - Non-sexual crimes of violence (includes robbery)
# - Sexual crimes
# - Damage and reckless behaviour
crime <-
  crime_raw |>

  filter(
    `Local Authority` != "Scotland",
    Crime == "Total",
    `Crime group` %in% c("Non-sexual crimes of violence", "Sexual crimes", "Damage and reckless behaviour")
  ) |>

  select(
    ltla21_name = `Local Authority`,
    personal_crimes_per_10000 = `2023-24`
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
  summarise(personal_crimes_per_10000 = sum(personal_crimes_per_10000)) |>
  ungroup()

places_personal_crime <-
  crime |>
  left_join(lookup, by = "ltla21_name") |>
  relocate(ltla21_code) |>
  select(-ltla21_name) |>
  mutate(year = "2023-24") |>
  rename(ltla24_code = ltla21_code)

# ---- Save output to data/ folder ----
usethis::use_data(places_personal_crime, overwrite = TRUE)
