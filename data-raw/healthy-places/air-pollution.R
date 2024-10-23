library(readr)
library(dplyr)
library(stringr)
library(geographr)

# Population-weighted annual mean PM2.5 data (by local authority)
# Source: https://uk-air.defra.gov.uk/data/pcm-data
air_pollution_raw <-
  read_csv(
    "https://uk-air.defra.gov.uk/datastore/pcm/popwmpm252023byUKlocalauthority.csv",
    skip = 2
  )

# Use the anthropogenic component for health burden calculations
air_pollution <-
  air_pollution_raw |>
  select(
    ltla24_code = `LA code`,
    air_pollution_weighted = `PM2.5 2023 (anthropogenic)`
  )

places_air_pollution <-
  air_pollution |>
  filter(str_detect(ltla24_code, "^S")) |>
  mutate(year = 2023)


# ---- Save output to data/ folder ----
usethis::use_data(places_air_pollution, overwrite = TRUE)
